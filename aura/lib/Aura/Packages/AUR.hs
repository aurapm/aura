{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts, TypeApplications, MonoLocalBinds, DataKinds #-}
{-# LANGUAGE DuplicateRecordFields #-}

-- |
-- Module    : Aura.Packages.AUR
-- Copyright : (c) Colin Woodbury, 2012 - 2018
-- License   : GPL3
-- Maintainer: Colin Woodbury <colin@fosskers.ca>
--
-- Module for connecting to the AUR servers, downloading PKGBUILDs and package sources.

module Aura.Packages.AUR
  ( -- * Batch Querying
    aurLookup
  , aurRepo
    -- * Single Querying
  , aurInfo
  , aurSearch
    -- * Source Retrieval
  , clone
  , pkgUrl
  ) where

import           Aura.Core
import           Aura.Pkgbuild.Base
import           Aura.Pkgbuild.Fetch
import           Aura.Settings
import           Aura.Types
import           BasePrelude hiding (head)
import           Control.Compactable (traverseEither)
import           Control.Error.Util (hush)
import           Control.Monad.Freer
import           Control.Monad.Freer.Reader
import           Data.Generics.Product (field)
import           Data.List.NonEmpty (head)
import qualified Data.Set as S
import           Data.Set.NonEmpty (NonEmptySet)
import qualified Data.Set.NonEmpty as NES
import qualified Data.Text as T
import           Data.Versions (versioning)
import           Lens.Micro ((^.), (^..), each, to)
import           Linux.Arch.Aur
import           Network.HTTP.Client (Manager)
import           System.Path
import           System.Path.IO (getCurrentDirectory)
import           System.Process.Typed (proc, runProcess)

---

-- TODO Make the call to `buildable` concurrent, since it makes web calls.
-- | Attempt to retrieve info about a given `S.Set` of packages from the AUR.
-- This is a signature expected by `InstallOptions`.
aurLookup :: Settings -> NonEmptySet PkgName -> IO (S.Set PkgName, S.Set Buildable)
aurLookup ss names = do
  (bads, goods) <- info m (foldMap (\(PkgName pn) -> [pn]) names) >>= traverseEither (buildable m)
  let goodNames = S.fromList $ goods ^.. each . field @"name"
  pure (S.fromList bads <> NES.toSet names S.\\ goodNames, S.fromList goods)
    where m = managerOf ss

-- | Yield fully realized `Package`s from the AUR. This is the other signature
-- expected by `InstallOptions`.
aurRepo :: Repository
aurRepo = Repository $ \ss ps -> do
  (bads, goods) <- aurLookup ss ps
  pkgs <- traverse (packageBuildable ss) $ toList goods
  pure (bads, S.fromList pkgs)

buildable :: Manager -> AurInfo -> IO (Either PkgName Buildable)
buildable m ai = do
  let !bse = PkgName $ pkgBaseOf ai
      mver = hush . versioning $ aurVersionOf ai
  mpb <- getPkgbuild m bse  -- Using the package base ensures split packages work correctly.
  case (,) <$> mpb <*> mver of
    Nothing        -> pure . Left . PkgName $ aurNameOf ai
    Just (pb, ver) -> pure $ Right Buildable
      { name     = PkgName $ aurNameOf ai
      , version  = ver
      , base     = bse
      , provides = list (Provides $ aurNameOf ai) (Provides . head) $ providesOf ai
      -- TODO This is a potentially naughty mapMaybe, since deps that fail to parse
      -- will be silently dropped. Unfortunately there isn't much to be done - `aurLookup`
      -- and `aurRepo` which call this function only report existence errors
      -- (i.e. "this package couldn't be found at all").
      , deps       = mapMaybe parseDep $ dependsOf ai ++ makeDepsOf ai
      , pkgbuild   = pb
      , isExplicit = False }

----------------
-- AUR PKGBUILDS
----------------
aurLink :: Path Unrooted
aurLink = fromUnrootedFilePath "https://aur.archlinux.org"

-- | A package's home URL on the AUR.
pkgUrl :: PkgName -> T.Text
pkgUrl (PkgName pkg) = T.pack . toUnrootedFilePath $ aurLink </> fromUnrootedFilePath "packages" </> fromUnrootedFilePath (T.unpack pkg)

-------------------
-- SOURCES FROM GIT
-------------------
-- TODO Make silent?
-- | Attempt to clone a package source from the AUR.
clone :: Buildable -> IO (Maybe (Path Absolute))
clone b = do
  ec <- runProcess $ proc "git" [ "clone", "--depth", "1", toUnrootedFilePath url ]
  case ec of
    (ExitFailure _) -> pure Nothing
    ExitSuccess     -> do
      pwd <- getCurrentDirectory
      pure . Just $ pwd </> (b ^. field @"base" . field @"name" . to (fromUnrootedFilePath . T.unpack))
  where url = aurLink </> (b ^. field @"base" . field @"name" . to (fromUnrootedFilePath . T.unpack)) <.> FileExt "git"

------------
-- RPC CALLS
------------
sortAurInfo :: Maybe BuildSwitch -> [AurInfo] -> [AurInfo]
sortAurInfo bs ai = sortBy compare' ai
  where compare' = case bs of
                     Just SortAlphabetically -> compare `on` aurNameOf
                     _ -> \x y -> compare (aurVotesOf y) (aurVotesOf x)

-- | Frontend to the `aur` library. For @-As@.
aurSearch :: (Member (Reader Settings) r, Member IO r) => T.Text -> Eff r [AurInfo]
aurSearch regex = do
  ss  <- ask
  res <- send $ search @IO (managerOf ss) regex
  pure $ sortAurInfo (bool Nothing (Just SortAlphabetically) $ switch ss SortAlphabetically) res

-- | Frontend to the `aur` library. For @-Ai@.
aurInfo :: (Member (Reader Settings) r, Member IO r) => NonEmpty PkgName -> Eff r [AurInfo]
aurInfo pkgs = do
  m <- asks managerOf
  sortAurInfo (Just SortAlphabetically) <$> send (info @IO m . map (^. field @"name") $ toList pkgs)

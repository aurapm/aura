-- Module for connecting to the AUR servers,
-- downloading PKGBUILDs and source tarballs, and handling them.

{-

Copyright 2012, 2013 Colin Woodbury <colingw@gmail.com>

This file is part of Aura.

Aura is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Aura is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Aura.  If not, see <http://www.gnu.org/licenses/>.

-}

module Aura.Packages.AUR
    ( aurLookup
    , aurRepo
    , isAurPackage
    , downloadPkgbuild
    , sourceTarball
    , PkgInfo(..)
    , aurInfoLookup
    , aurSearchLookup
    ) where

import           Control.Applicative
import           System.FilePath     ((</>))
import           Data.Maybe
import           Data.List           (intercalate, sortBy)
import qualified Data.Traversable    as Traversable (mapM)
import           Text.JSON

import           Aura.Utils          (scoldAndFail)
import           Aura.Bash           (namespace)
import           Aura.Monad.Aura
import           Aura.Languages
import           Aura.Pkgbuild.Base
import           Aura.Core

import           Utilities           (decompress)
import           Internet

---

aurLookup :: String -> Aura (Maybe Buildable)
aurLookup name = do
    pkgbuild <- downloadPkgbuild name
    Traversable.mapM (makeBuildable name) pkgbuild

aurRepo :: Repository
aurRepo = buildableRepository aurLookup

makeBuildable :: String -> Pkgbuild -> Aura Buildable
makeBuildable name pkgbuild = do
    ns <- namespace name pkgbuild
    return Buildable
        { buildName   = name
        , pkgbuildOf  = pkgbuild
        , namespaceOf = ns
        , explicit    = False
        , source      = \fp -> sourceTarball fp name >>= decompress
        }

isAurPackage :: String -> Aura Bool
isAurPackage name = isJust <$> downloadPkgbuild name

----------------
-- AUR PKGBUILDS
----------------
aurLink :: String
aurLink = "https://aur.archlinux.org/packages/"

pkgBaseUrl :: String -> String
pkgBaseUrl pkg = aurLink </> take 2 pkg </> pkg

pkgbuildUrl :: String -> String
pkgbuildUrl pkg = pkgBaseUrl pkg </> "PKGBUILD"

downloadPkgbuild :: String -> Aura (Maybe Pkgbuild)
downloadPkgbuild name = do
    out <- liftIO . urlContents $ pkgbuildUrl name
    return $ case out of
        "" -> Nothing
        _  -> Just out

------------------
-- SOURCE TARBALLS
------------------
tarballUrl :: String -> String
tarballUrl pkg = pkgBaseUrl pkg </> pkg ++ ".tar.gz"

sourceTarball :: FilePath    -- ^ Where to save the tarball.
              -> String      -- ^ Package name.
              -> IO FilePath -- ^ Saved tarball location.
sourceTarball path = saveUrlContents path . tarballUrl

-----------------------
-- AUR API URL CREATION
-----------------------
data RPCType = PkgSearch | MultiInfo | MSearch deriving (Eq)

aurPkgUrl :: Int -> String
aurPkgUrl n = "https://aur.archlinux.org/packages.php?ID=" ++ show n

rpcBaseUrl :: String
rpcBaseUrl = "https://aur.archlinux.org/rpc.php?"

-- Had to do a bit off a hack, since `urlEncodeVars` wasn't encoding
-- things in the necessary way.
rpcUrl :: RPCType -> [String] -> String
rpcUrl t ps = rpcBaseUrl ++ ps'
    where ps' = intercalate "&" (t' : encodedPs t)
          encodedPs MultiInfo = map (\p -> urlEncodeVars [("arg[]",p)]) ps
          encodedPs _         = [urlEncodeVars [("arg",unwords ps)]]
          t' = urlEncodeVars [rpcType t]

rpcType :: RPCType -> (String,String)
rpcType t = ("type",tname)
    where tname = case t of
                    PkgSearch -> "search"
                    MultiInfo -> "multiinfo"
                    MSearch   -> "msearch"

-------
-- JSON
-------
-- Extend this later as needed.
data PkgInfo = PkgInfo { nameOf        :: String
                       , latestVerOf   :: String
                       , projectURLOf  :: String
                       , aurURLOf      :: String
                       , licenseOf     :: String
                       , descriptionOf :: String
                       , maintainerOf  :: Maybe String
                       , isOutOfDate   :: Bool
                       , votesOf       :: Int } deriving (Eq,Show)

aurSearchLookup :: [String] -> Aura [PkgInfo]
aurSearchLookup regex = getAURPkgInfo regex PkgSearch

aurInfoLookup :: [String] -> Aura [PkgInfo]
aurInfoLookup pkgs = getAURPkgInfo pkgs MultiInfo

getAURPkgInfo :: [String] -> RPCType -> Aura [PkgInfo]
getAURPkgInfo [] _    = return []
getAURPkgInfo items t = do
  infoJSON <- liftIO . urlContents . rpcUrl t $ items
  case resultToEither $ parseInfoJSON infoJSON of
    Left _     -> scoldAndFail getAURPkgInfo_1
    Right info -> return info'
      where info' = sortBy (\x y -> compare (nameOf x) (nameOf y)) info

parseInfoJSON :: String -> Result [PkgInfo]
parseInfoJSON json = decode json >>= apiFailCheck >>= forgePkgInfo
    where forgePkgInfo j = valFromObj "results" j >>= mapM pkgInfo

apiFailCheck :: JSObject JSValue -> Result (JSObject JSValue)
apiFailCheck json = do
  isError <- (== "error") `fmap` valFromObj "type" json
  if isError then Error "AUR API lookup failed." else Ok json

-- For some reason, if I forego the `maintainer` variable with:
--   pure (resultToMaybe $ valFromObj "Maintainer" pkgJSON)
-- it refuses to compile.
pkgInfo :: JSObject JSValue -> Result PkgInfo
pkgInfo pkgJSON = PkgInfo
                  <$> valFromObj "Name" pkgJSON
                  <*> valFromObj "Version" pkgJSON
                  <*> valFromObj "URL" pkgJSON
                  <*> (aurPkgUrl . fromJSRat) `fmap` valFromObj "ID" pkgJSON
                  <*> valFromObj "License" pkgJSON
                  <*> valFromObj "Description" pkgJSON
                  <*> pure maintainer
                  <*> ((/= 0) . fromJSRat) `fmap` valFromObj "OutOfDate" pkgJSON
                  <*> fromJSRat `fmap` valFromObj "NumVotes" pkgJSON
    where maintainer = resultToMaybe $ valFromObj "Maintainer" pkgJSON

fromJSRat :: JSValue -> Int
fromJSRat (JSRational _ r) = round (fromRational r :: Float)
fromJSRat _                = error "JSValue given was not a JSRational!"

-- | A companion to the provided `resultToEither` function.
resultToMaybe :: Result a -> Maybe a
resultToMaybe (Ok a) = Just a
resultToMaybe _      = Nothing

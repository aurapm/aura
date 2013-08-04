-- Handles all `-A` operations

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

module Aura.Commands.A
    ( install
    , upgradeAURPkgs
    , aurPkgInfo
    , aurSearch
    , displayPkgDeps
    , downloadTarballs
    , displayPkgbuild ) where

import Control.Monad
import Data.Monoid
import Text.Regex.PCRE ((=~))

import           Aura.Install (InstallOptions(..))
import qualified Aura.Install as I

import Aura.Packages.Repository
import Aura.Settings.Base
import Aura.Packages.AUR
import Aura.Colour.Text
import Aura.Monad.Aura
import Aura.Languages
import Aura.Utils
import Aura.Core

import Shell
import Utilities (whenM)

---

installOptions :: I.InstallOptions
installOptions = I.InstallOptions
    { label         = "AUR"
    , installLookup = aurLookup
    , repository    = pacmanRepo <> aurRepo
    }

install :: [String] -> [String] -> Aura ()
install = I.install installOptions

upgradeAURPkgs :: [String] -> [String] -> Aura ()
upgradeAURPkgs pacOpts pkgs = ask >>= \ss -> do
  let notIgnored p = splitName p `notElem` ignoredPkgsOf ss
  notify upgradeAURPkgs_1
  foreignPkgs <- filter (\(n,_) -> notIgnored n) `fmap` getForeignPackages
  pkgInfo     <- aurInfoLookup $ map fst foreignPkgs
  let aurPkgs   = filter (\(n,_) -> n `elem` map nameOf pkgInfo) foreignPkgs
      toUpgrade = filter isntMostRecent $ zip pkgInfo (map snd aurPkgs)
  auraFirst <- auraCheck $ map (nameOf . fst) toUpgrade
  if auraFirst
     then auraUpgrade pacOpts
     else do
       devel <- develPkgCheck
       notify upgradeAURPkgs_2
       if null toUpgrade && null devel
          then warn upgradeAURPkgs_3
          else reportPkgsToUpgrade $ map prettify toUpgrade ++ devel
       install pacOpts $ map (nameOf . fst) toUpgrade ++ pkgs ++ devel
           where prettify (p,v) = nameOf p ++ " : " ++ v ++ " => " ++ latestVerOf p

auraCheck :: [String] -> Aura Bool
auraCheck toUpgrade = do
  if "aura" `elem` toUpgrade
     then optionalPrompt auraCheck_1
     else return False

auraUpgrade :: [String] -> Aura ()
auraUpgrade pacOpts = install pacOpts ["aura"]

develPkgCheck :: Aura [String]
develPkgCheck = ask >>= \ss ->
  if rebuildDevel ss then getDevelPkgs else return []

aurPkgInfo :: [String] -> Aura ()
aurPkgInfo pkgs = aurInfoLookup pkgs >>= mapM_ displayAurPkgInfo

displayAurPkgInfo :: PkgInfo -> Aura ()
displayAurPkgInfo info = ask >>= \ss ->
    liftIO $ putStrLn $ renderAurPkgInfo ss info ++ "\n"

renderAurPkgInfo :: Settings -> PkgInfo -> String
renderAurPkgInfo ss info = entrify ss fields entries
    where fields  = map bForeground . infoFields . langOf $ ss
          entries = [ magenta "aur"
                    , bForeground $ nameOf info
                    , latestVerOf info
                    , outOfDateMsg (isOutOfDate info) $ langOf ss
                    , orphanedMsg (maintainerOf info) $ langOf ss
                    , cyan $ projectURLOf info
                    , aurURLOf info
                    , licenseOf info
                    , yellow . show . votesOf $ info
                    , descriptionOf info ]

aurSearch :: [String] -> Aura ()
aurSearch []    = return ()
aurSearch regex = ask >>= \ss -> do
    results <- aurSearchLookup regex
    mapM_ (liftIO . putStrLn . renderSearch ss (unwords regex)) results

renderSearch :: Settings -> String -> PkgInfo -> String
renderSearch ss r i = searchResult
    where searchResult = if beQuiet ss then sparseInfo else verboseInfo
          sparseInfo  = nameOf i
          verboseInfo = repo ++ n ++ " " ++ v ++ " (" ++ l ++ ")\n    " ++ d
          c cl cs = case cs =~ ("(?i)" ++ r) of
                      (b,m,a) -> cl b ++ bCyan m ++ cl a
          repo = magenta "aur/"
          n = c bForeground $ nameOf i
          d = c noColour $ descriptionOf i
          l = yellow . show . votesOf $ i  -- `l` for likes?
          v | isOutOfDate i = red $ latestVerOf i
            | otherwise     = green $ latestVerOf i

displayPkgDeps :: [String] -> Aura ()
displayPkgDeps = I.displayPkgDeps installOptions

downloadTarballs :: [String] -> Aura ()
downloadTarballs pkgs = do
  currDir <- liftIO pwd
  mapM_ (downloadTBall currDir) pkgs
    where downloadTBall path pkg = whenM (isAurPackage pkg) $ do
              notify $ downloadTarballs_1 pkg
              void . liftIO $ sourceTarball path pkg

displayPkgbuild :: [String] -> Aura ()
displayPkgbuild = mapM_ $ \p ->
    downloadPkgbuild p >>= maybe (return ()) (liftIO . putStrLn)

isntMostRecent :: (PkgInfo,String) -> Bool
isntMostRecent (info,v) = trueVer > currVer
  where trueVer = comparableVer $ latestVerOf info
        currVer = comparableVer v

------------
-- REPORTING
------------

reportPkgsToUpgrade :: [String] -> Aura ()
reportPkgsToUpgrade pkgs = do
  lang <- langOf `fmap` ask
  printList green cyan (reportPkgsToUpgrade_1 lang) pkgs

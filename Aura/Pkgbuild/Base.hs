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

module Aura.Pkgbuild.Base where

import Aura.Bash
import Aura.Core
import Aura.Monad.Aura

---

pkgbuildCache :: FilePath
pkgbuildCache = "/var/cache/aura/pkgbuilds/"

customizepkgPath :: FilePath
customizepkgPath = "/etc/customizepkg.d/"

toFilename :: String -> FilePath
toFilename = (++ ".pb")

pkgbuildPath :: String -> FilePath
pkgbuildPath p = pkgbuildCache ++ toFilename p

trueVersion :: Namespace -> String
trueVersion ns = pkgver ++ "-" ++ pkgrel
    where pkgver = head $ value ns "pkgver"
          pkgrel = head $ value ns "pkgrel"

-- XXX these functions need a new home
packageBuildable :: Buildable -> Package
packageBuildable b = Package
    { pkgName        = buildName b
    , pkgVersion     = trueVersion ns
    , pkgDeps        = concatMap (map parseDep . value ns)
                       ["depends", "makedepends", "checkdepends"]
    , pkgInstallType = Build b
    }
  where
    ns = namespaceOf b

buildableRepository :: (String -> Aura (Maybe Buildable)) -> Repository
buildableRepository f = Repository $ \name ->
    fmap packageBuildable <$> f name

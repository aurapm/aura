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

module Aura.Settings.BadPackages where

import Aura.Languages

type Reason = String

-- These packages fail to build for various reasons.
getBadPackages :: Language -> [(String,Reason)]
getBadPackages _ = []

circDep :: String -> Language -> Reason
circDep = circDep_1

bashisms :: Language -> Reason
bashisms = bashisms_1

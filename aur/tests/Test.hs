{-# LANGUAGE OverloadedStrings #-}

module Main where

import Linux.Arch.Aur
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import Test.Tasty
import Test.Tasty.HUnit

---

suite :: Manager -> TestTree
suite m = testGroup "RPC Calls"
  [ testCase "info on existing package" $ infoTest m
  , testCase "info on nonexistant package" $ infoTest' m
  , testCase "search" $ searchTest m
  ]

infoTest :: Manager -> Assertion
infoTest m = info m ["aura"] >>= assert . not . null

infoTest' :: Manager -> Assertion
infoTest' m = info m ["aura1234567"] >>= assert . null

searchTest :: Manager -> Assertion
searchTest m = search m "aura" >>= assert . not . null

main :: IO ()
main = do
  m <- newManager tlsManagerSettings
  defaultMain $ suite m

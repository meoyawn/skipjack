module Main where

import SkipJackTest
import HashTest
import CBCTest

main :: IO ()
main = do
    SkipJackTest.test
    HashTest.test
    CBCTest.test
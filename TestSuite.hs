module Main where

import SkipJackTest
import HashTest
import CBCTest
import SignatureTest

main :: IO ()
main = do
    SkipJackTest.test
    HashTest.test
    CBCTest.test
    SignatureTest.test
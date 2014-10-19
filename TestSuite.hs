module Main where

import SkipJackTest
import DaviesMeyerTest
import CBCTest

main :: IO ()
main = do
    SkipJackTest.test
    DaviesMeyerTest.test
    CBCTest.test
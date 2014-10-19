module Main where

import SkipJackTest
import DaviesMeyerTest

main :: IO ()
main = do
    SkipJackTest.test
    DaviesMeyerTest.test
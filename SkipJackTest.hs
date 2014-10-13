module Main where

import SkipJack
import Data.Word

import Test.QuickCheck (quickCheck)

wordSplitting :: Word16 -> Bool
wordSplitting w = w == combineTwoWord8 (splitWord16 w)

main :: IO ()
main = quickCheck wordSplitting
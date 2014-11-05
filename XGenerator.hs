module Main where

import Signature
import System.IO
import Text.Printf

main :: IO ()
main = do
    hSetEncoding stdout utf8
    x <- generateX
    printf "%d" x
module Main where

import CBC
import Hash
import System.Environment
import System.IO
import Text.Printf

main :: IO ()
main = do
    hSetEncoding stdout utf8
    [key, msg] <- getArgs
    printf "%s" $ encrypt (stringToByteString key) msg
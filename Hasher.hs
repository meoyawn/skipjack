module Main where

import Hash
import System.Environment
import System.IO
import Text.Printf

main = do
    hSetEncoding stdout utf8
    [msg] <- getArgs
    printf "%d" $ hash msg
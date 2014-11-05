module Main where

import Signature
import Hash
import System.Environment
import System.IO
import Text.Printf

main :: IO ()
main = do
    hSetEncoding stdout utf8
    [x, msg, r, s] <- getArgs
    print $ verify (hash msg) (calculateY $ read x) (read r, read s)
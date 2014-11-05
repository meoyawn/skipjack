module Main where

import Signature
import Hash
import System.Environment
import System.IO
import Text.Printf

main :: IO ()
main = do
    hSetEncoding stdout utf8
    [x, msg] <- getArgs
    k <- generateK
    (r, s) <- return $ signature (hash msg) k (read x)
    printf "%d\n%d" r s
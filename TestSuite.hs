module Main where

import SkipJackTest
import HashTest
import CBCTest
import SignatureTest

import Signature
import Hash
import CBC
import Data.ByteString hiding (length, reverse, take, drop, last, head, init)

test :: IO ()
test = do
    k <- generateK
    x <- generateX
    y <- return $ calculateY x
    h <- return $ hash str
    (r, s) <- return $ signature h k x
    rStr <- return $ show r
    sStr <- return $ show s
    enc <- return $ encrypt key $ str ++ "\n" ++ rStr ++ "\n" ++ sStr
    dec <- return $ decrypt key enc
    decSStr <- return $ last . lines $ dec
    decRStr <- return $ head . drop 1 . reverse . lines $ dec
    print $ length decRStr
    decR <- return $ read decRStr
    print $ decR == r
    decS <- return $ read decSStr
    print $ decS == s
    decMsg <- return $ init . unlines . reverse . drop 2 . reverse . lines $ dec
    print decMsg
    decHash <- return $ hash decMsg
    print $ verify decHash y (decR, decS)
    kuda <- return $ encrypt key "Куда идем мы с пяточком"
    print $ decrypt key kuda
    where str = "HAHAHAHA"
          key = pack [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]


main :: IO ()
main = do
    SkipJackTest.test
    HashTest.test
    CBCTest.test
    SignatureTest.test
    Main.test


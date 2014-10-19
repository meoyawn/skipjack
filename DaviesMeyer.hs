module DaviesMeyer where

import SkipJack
import Data.Bits (xor)
import Data.ByteString (ByteString, pack)

stringToByteString :: String -> ByteString
stringToByteString = pack . stringToBytes

prepareForKeys :: String -> String
prepareForKeys s
    | m == 0 = s
    | otherwise = s ++ replicate (10 - m) '0'
    where m = length s `mod` 10

keysImpl :: String -> [ByteString]
keysImpl [] = []
keysImpl s  = stringToByteString (take 10 s) : keysImpl (drop 10 s)

keys :: String -> [ByteString]
keys = keysImpl . prepareForKeys

encryptFold :: Word16x4 -> ByteString -> Word16x4
encryptFold h@(h1, h2, h3, h4) mi = (e1 `xor` h1, e2 `xor` h2, e3 `xor` h3, e4 `xor` h4)
    where (e1, e2, e3, e4) = encryptBlock mi h

h0 :: Word16x4
h0 = (3123, 6778, 5679, 6788)

daviesMeyer :: String -> Word16x4
daviesMeyer s = foldl encryptFold h0 (keys s)
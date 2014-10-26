module Hash where

import CBC
import SkipJack
import Data.ByteString (ByteString, pack, unpack, length)

stringToByteString :: String -> ByteString
stringToByteString = pack . stringToBytes

prepareForKeys :: String -> String
prepareForKeys s
    | m == 0 = s
    | otherwise = s ++ replicate (5 - m) '\0'
    where m = l `mod` 5
          l = Prelude.length s

keysImpl :: String -> [ByteString]
keysImpl [] = []
keysImpl s  = stringToByteString (take 5 s) : keysImpl (drop 5 s)

keys :: String -> [ByteString]
keys = keysImpl . prepareForKeys

toByteString :: Word16x4 -> ByteString
toByteString w = pack $ words16To8 $ blocksToWords16 [w]

toWord16x4 :: ByteString -> Word16x4
toWord16x4 bs = head $ words16ToBlocks $ words8To16 $ drop m $ unpack bs
    where m = Data.ByteString.length bs `mod` 8

xorBsWithWord16x4 :: ByteString -> Word16x4 -> Word16x4
xorBsWithWord16x4 bs ws = xorW16x4 (toWord16x4 bs) ws

encryptFold :: Word16x4 -> ByteString -> Word16x4
encryptFold h mi = xorW16x4 e h
    where e = encryptBlock mi $ xorBsWithWord16x4 mi h

h0 :: Word16x4
h0 = (3123, 6778, 5679, 6788)

asInteger :: Word16x4 -> Integer
asInteger (w1, w2, w3, w4) = (fromIntegral w1) * 1000000000000000 + (fromIntegral w2) * 10000000000 + (fromIntegral w3) * 100000 + (fromIntegral w4)

hash64 :: String -> Integer
hash64 s = asInteger $ foldl encryptFold h0 (keys s)

hash :: String -> Integer
hash s = read (show h1 ++ show h2)
    where h1 = hash64 s
          h2 = hash64 (show h1 ++ s)


module CBC where

import SkipJack
import Data.ByteString (ByteString)
import Data.Word
import Data.Char
import Data.Bits

c0 :: Word16x4
c0 = (1231, 3123, 6788, 5673)

xorW16x4 :: Word16x4 -> Word16x4 -> Word16x4
xorW16x4 (w1, w2, w3, w4) (v1, v2, v3, v4) = (w1 `xor` v1, w2 `xor` v2, w3 `xor` v3, w4 `xor` v4)

withPrev :: a -> [a] -> [(a, a)]
withPrev z list = snd $ foldl f (z, []) list
  where f (prev, result) next = (next, result ++ [(prev, next)])

encryptCBC :: ByteString -> [Word16x4] -> [Word16x4]
encryptCBC key ps = tail $ foldl f [c0] ps
    where f cs p = cs ++ [encryptBlock key $ xorW16x4 p $ last cs]
          
decryptCBC :: ByteString -> [Word16x4] -> [Word16x4]
decryptCBC key cs = foldl f [] $ withPrev c0 cs
  where f ps (prev, next) = ps ++ [xorW16x4 (decryptBlock key next) prev]

encrypt :: ByteString -> String -> String
encrypt _   [] = []
encrypt key s  = blocksToStringRaw $ map (encryptBlock key) (stringToBlocks s) 

decrypt :: ByteString -> String -> String
decrypt _   [] = []
decrypt key s  = blocksToString $ map (decryptBlock key) (stringToBlocksRaw s)

-- hash! 8 22 2

charToByte :: Char -> Word8
charToByte = fromIntegral . ord

byteToChar :: Word8 -> Char
byteToChar = chr . fromIntegral

stringToBytes :: String -> [Word8]
stringToBytes = map charToByte

bytesToString :: [Word8] -> String
bytesToString = map byteToChar

prepare :: String -> String
prepare s
  | m == 0 = s ++ "1" ++ replicate 7 '0'
  | m == 7 = s ++ "1" ++ replicate 8 '0'
  | otherwise = s ++ "1" ++ replicate (7 - m) '0'
  where m = length s `mod` 8

unprepare :: String -> String
unprepare [] = error "prepare your string first"
unprepare s
  | l == '0' = unprepare i
  | l == '1' = i
  | otherwise = error "not properly prepared"
  where l = last s
        i = init s

words8To16 :: [Word8] -> [Word16]
words8To16 (w1:w2:rest) = combineTwoWord8 [w1, w2] : words8To16 rest
words8To16 [] = []
words8To16 _ = error "uneven number of word8s"

words16ToBlocks :: [Word16] -> [Word16x4]
words16ToBlocks (w1:w2:w3:w4:rest) = (w1,w2,w3,w4) : words16ToBlocks rest
words16ToBlocks [] = []
words16ToBlocks _ = error "uneven number of word16s"

blocksToWords16 :: [Word16x4] -> [Word16]
blocksToWords16 = foldl f []
  where f ws (w1,w2,w3,w4) = ws ++ [w1,w2,w3,w4]

words16To8 :: [Word16] -> [Word8]
words16To8 ws = ws >>= splitWord16

stringToBlocks :: String -> [Word16x4]
stringToBlocks = stringToBlocksRaw . prepare

stringToBlocksRaw :: String -> [Word16x4]
stringToBlocksRaw = words16ToBlocks . words8To16 . stringToBytes

blocksToString :: [Word16x4] -> String
blocksToString = unprepare . blocksToStringRaw

blocksToStringRaw :: [Word16x4] -> String
blocksToStringRaw = bytesToString . words16To8 . blocksToWords16
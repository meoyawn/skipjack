{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import SkipJack
import Control.Applicative
import Data.ByteString hiding (length)
import Data.Word
import Test.QuickCheck

prop_wordSplitting :: Word16 -> Bool
prop_wordSplitting w = w == combineTwoWord8 (splitWord16 w)

instance Arbitrary ByteString where
    arbitrary = pack <$> vector 10

prop_blockDecryption :: ByteString -> Word16x4 -> Bool
prop_blockDecryption key w = w == decryptBlock key (encryptBlock key w)

prop_byteToChar :: Char -> Bool
prop_byteToChar c = c == byteToChar (charToByte c)

prop_preparing :: String -> Bool
prop_preparing s = length (prepare s) `mod` 8 == 0

prop_unpreparing :: String -> Bool
prop_unpreparing s = s == unprepare (prepare s)

prop_preparedDecoding :: String -> Bool
prop_preparedDecoding s = s == blocksToString (stringToBlocks s)

prop_decryption :: ByteString -> String -> Bool
prop_decryption key s = s == decrypt key (encrypt key s)

return []

runTests :: IO Bool
runTests = $quickCheckAll

main :: IO ()
main = do
    _ <- runTests
    return ()
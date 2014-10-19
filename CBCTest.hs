{-# OPTIONS_GHC -fno-warn-orphans #-}

module CBCTest where

import CBC
import SkipJack
import Control.Applicative
import Data.ByteString hiding (length)
import Test.QuickCheck

instance Arbitrary ByteString where
    arbitrary = pack <$> vector 10

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

prop_CBCDecryption :: ByteString -> [Word16x4] -> Bool
prop_CBCDecryption key ws = ws == decryptCBC key (encryptCBC key ws)

return []

runTests :: IO Bool
runTests = $quickCheckAll

test :: IO ()
test = do
    _ <- runTests
    return ()    
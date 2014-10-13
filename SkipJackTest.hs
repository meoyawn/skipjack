module Main where

import SkipJack
import Control.Applicative
import Data.ByteString
import Data.Word
import Test.QuickCheck

wordSplitting :: Word16 -> Bool
wordSplitting w = w == combineTwoWord8 (splitWord16 w)

instance Arbitrary ByteString where
    arbitrary = pack <$> vector 10

decrypting :: ByteString -> Word16x4 -> Bool
decrypting key w = w == decrypt key (encrypt key w)

main :: IO ()
main = do
    quickCheck wordSplitting
    quickCheck decrypting

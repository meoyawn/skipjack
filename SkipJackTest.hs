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

prop_stringFinishing :: String -> Bool
prop_stringFinishing s = (length $ finishString s) `mod` 8 == 0

prop_flattening :: Word16x4 -> Bool
prop_flattening w = 4 == (length $ flatten w)

data Words = Words [Word16] deriving (Show)

instance Arbitrary Words where
    arbitrary = Words <$> vector 4

prop_nesting :: Words -> Bool
prop_nesting (Words ws) = ws == (flatten $ nest ws)

prop_decryption :: ByteString -> String -> Bool
prop_decryption key s = s == decrypt key (encrypt key s)

return []
runTests = $quickCheckAll

main = do
    runTests
    return ()
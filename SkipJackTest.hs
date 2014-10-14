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

return []
runTests = $quickCheckAll

main = do
    runTests
    return ()
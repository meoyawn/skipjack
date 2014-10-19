{-# OPTIONS_GHC -fno-warn-orphans #-}

module SkipJackTest where

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

return []

runTests :: IO Bool
runTests = $quickCheckAll

test :: IO ()
test = do
    _ <- runTests
    return ()
module HashTest where

import SkipJack
import Hash
import Data.ByteString (length)
import Test.QuickCheck

prop_keyPreparing :: String -> Bool
prop_keyPreparing s = Prelude.length (prepareForKeys s) `mod` 5 == 0

prop_keys :: String -> Bool
prop_keys s = all f (keys s)
    where f key = Data.ByteString.length key == 10

prop_Word16x4ToByteString :: Word16x4 -> Bool
prop_Word16x4ToByteString w = w == toWord16x4 (toByteString w)

return []

runTests :: IO Bool
runTests = $quickCheckAll

test :: IO ()
test = do
    _ <- runTests
    return ()    
module DaviesMeyerTest where

import DaviesMeyer
import Data.ByteString (length)
import Test.QuickCheck

prop_keyPreparing :: String -> Bool
prop_keyPreparing s = Prelude.length (prepareForKeys s) `mod` 10 == 0

prop_keys :: String -> Bool
prop_keys s = all f (keys s)
    where f key = Data.ByteString.length key == 10

return []

runTests :: IO Bool
runTests = $quickCheckAll

test :: IO ()
test = do
    _ <- runTests
    return ()    
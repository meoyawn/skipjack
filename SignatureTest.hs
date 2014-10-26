{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE TemplateHaskell #-}

module SignatureTest where

import Signature
import Hash
import Test.QuickCheck

data Sig = Sig Integer Integer deriving (Show, Eq)

instance Arbitrary Sig where
    arbitrary = do 
        k <- choose (1, q - 1)
        x <- choose (2, q - 1)
        return $ Sig k x

prop_verify :: String -> Sig -> Bool
prop_verify str (Sig k x) = verify h y $ signature h k x
    where h = hash str
          y = calculateY x

return []

runTests :: IO Bool
runTests = $quickCheckAll

test :: IO ()
test = do
    _ <- runTests
    return ()
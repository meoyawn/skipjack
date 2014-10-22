{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE TemplateHaskell #-}

module SignatureTest where

import Signature
import Hash
import CBC
import Control.Applicative
import Data.ByteString hiding (length, reverse, take, drop, last, head, init)
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

instance Arbitrary ByteString where
    arbitrary = pack <$> vector 10

prop_total :: ByteString -> String -> Sig -> Bool
prop_total key str (Sig k x) = verify decHash y (decR, decS)
    where enc = encrypt key $ str ++ "\n" ++ rStr ++ "\n" ++ sStr
          h = hash str
          (r, s) = signature h k x
          rStr = show r
          sStr = show s
          dec = decrypt key enc
          decR = read . head . drop 1 . reverse . lines $ dec
          decS = read . last . lines $ dec
          decMsg = init . unlines . reverse . drop 2 . reverse . lines $ dec
          decHash = hash decMsg
          y = calculateY x

return []

runTests :: IO Bool
runTests = $quickCheckAll

test :: IO ()
test = do
    _ <- runTests
    return ()
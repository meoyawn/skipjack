module Signature where

import System.Random

p :: Integer
p = 100171957116027409589353405993935820347426201265179460517658228929832800232041

q :: Integer
q = 294378924251756658506775180343451703611

gamma :: Integer
gamma = 31386163582287930555526549190665019552068439786161706594508575036593710785145

modPow :: Integral a => a -> a -> a -> a
modPow 0 _ _ = 0
modPow 1 _ _ = 1
modPow _ 0 _ = 1
modPow _ _ 0 = 0
modPow _ _ 1 = 0
modPow b e m =
  case e `mod` 2 of
    0 -> modPow (b*b `mod` m) (e `div` 2) m
    1 -> (b * modPow (b*b `mod` m) (e `div` 2) m) `mod` m
    _ -> error "What the fuck?"

modMinus1 :: Integral a => a -> a -> a
modMinus1 x modulo = modPow x (modulo - 2) modulo

g :: Integer
g = modPow gamma ((p - 1) `div` q) p

calculateY :: Integer -> Integer
calculateY x = modPow g x p

generateX :: IO Integer
generateX = randomRIO (2, q - 1)

generateK :: IO Integer
generateK = randomRIO (1, q - 1)

calculateR :: Integer -> Integer
calculateR k = modPow g k p

calculateRo :: Integer -> Integer
calculateRo r = r `mod` q

modQ :: Integer -> Integer
modQ x = x `mod` q

calculateS :: Integer -> Integer -> Integer -> Integer -> Integer
calculateS k h x r = modQ (modQ ((modMinus1 ro q) + modQ (h * x)) * modMinus1 k q)
    where ro = calculateRo r

modP :: Integer -> Integer
modP x = x `mod` p

verify :: Integer -> Integer -> (Integer, Integer) -> Bool
verify h y (r, s) = modPow r (ro * s) p == modP ((modP g) * modPow y (ro * h) p)
    where ro = calculateRo r

signature :: Integer -> Integer -> Integer -> (Integer, Integer)
signature h k x = (r, calculateS k h x r)
    where r = calculateR k

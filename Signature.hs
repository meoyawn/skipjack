module Signature where

import System.Random

p :: Integer
p = 13232376895198612407547930718267435757728527029623408872245156039757713029036368719146452186041204237350521785240337048752071462798273003935646236777459223

q :: Integer
q = 857393771208094202104259627990318636601332086981

gamma :: Integer
gamma = 7521483903782060346617399017671409232618347905458279916384743575270644052774952605706862089884256074095039537064180858502511421752637985122233359298954651

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

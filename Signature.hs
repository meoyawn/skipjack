module Main where

import SkipJack (Word16x4)
import Hash
import System.Random

p :: Integer
p = 199679

q :: Integer
q = 99839

gamma :: Integer
gamma = 56787

g :: Integer
g = (gamma ^ ((p - 1) `div` q)) `mod` p

generateX :: IO Integer
generateX = randomRIO (2, q - 1)

y :: Integer -> Integer
y x = g ^ x `mod` p

generateK :: IO Integer
generateK = randomRIO (1, q - 1)

calculateR :: Integer -> Integer
calculateR k = g ^ k `mod` p

calculateRo :: Integer -> Integer
calculateRo r = r `mod` q

calculateS :: Integer -> Integer -> Integer -> Integer -> Double
calculateS k h x r = fromIntegral (1 + ro * h * x `mod` q) / fromIntegral (ro * k)
    where ro = calculateRo r

verify :: Integer -> Integer -> (Integer, Double) -> Bool
verify h y (r, s) = fromIntegral r ** (fromIntegral ro * s) == fromIntegral (g * y ^ (ro * h))
    where ro = calculateRo r

signature :: Integer -> Integer -> Integer -> (Integer, Double)
signature h k x = (r, calculateS k h x r)
    where r = calculateR k

main = do
    k <- generateK
    x <- generateX
    h <- return $ hash "FUCK"
    (r, s) <- return $ signature h k x 
    print (r, s)
    print h



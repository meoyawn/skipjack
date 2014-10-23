module Main where

import CBC
import Haste

main :: IO ()
main = putStrLn "fuck!"

encryptClick = withElem "encrypt" $ \btn -> do
    onEvent encryptBtn OnClick $ do
        
fuck = withElems ["encryption_key", "initial", "encrypt", "encrypted"] f
    where f [keyText, initialText, encryptBtn, encryptedText] = do
        onEvent encryptBtn OnClick $ doEncrypt
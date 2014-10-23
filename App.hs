module Main where

import CBC
import Haste

doEncrypt _ _ = undefined

doDecrypt _ _ = undefined

calcHash _ _ = do
    withElem "hash_message" $ \msg -> do
        mm <- getValue msg
        case mm of
            (Just str) -> putStrLn str
            _          -> return ()

genSigKey _ _ = undefined

calcSig _ _ = undefined

events [encryptBtn, decryptBtn, hashBtn, signatureKey, signatureCalc] = do
    onEvent encryptBtn OnClick doEncrypt
    onEvent decryptBtn OnClick $ doDecrypt
    onEvent hashBtn OnClick $ calcHash
    onEvent signatureKey OnClick $ genSigKey
    onEvent signatureCalc OnClick $ calcSig

main :: IO Bool
main = withElems ["encrypt",
                  "decrypt",
                  "calculate_hash",
                  "generate_signature_key",
                  "calculate_signature"] events
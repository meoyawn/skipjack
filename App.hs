module Main where

import CBC
import Hash
import Haste
import Haste.Foreign
import Haste.Prim
import Signature

import Control.Applicative
import Control.Exception

clearError err = setProp err "innerHTML" ""

encryption :: Elem -> Elem -> Elem -> Maybe String -> IO ()
encryption msg enc err (Just key@[_,_,_,_,_]) = do
  clearError err
  Just m <- getValue msg
  setProp enc "value" $ encrypt (stringToByteString key) m
encryption _ _ err _ = showKeyError err

handleBadEncription :: Elem -> SomeException -> IO ()
handleBadEncription dErr ex = do
  showError "Сообщение было закодировано другим алгоритмом либо с другим ключом" dErr

decryption :: Elem -> Elem -> Elem -> Maybe String -> Elem -> IO ()
decryption enc dec err (Just key@[_,_,_,_,_]) dErr = do
  clearError dErr
  clearError err
  Just e <- getValue enc
  catch (setProp dec "value" $ decrypt (stringToByteString key) e) (handleBadEncription dErr)
decryption _ _ err _ _ = showKeyError err

showKeyError = showError "Ключ должен состоять из 5 знаков!"

showError str err = setProp err "innerHTML" str

doEncrypt _ _ = withElems ["encryption-key",
                           "no-key-error",
                           "initial",
                           "encrypted"] $ \[key, err, msg, enc] -> do
  mk <- getValue key
  encryption msg enc err mk

doDecrypt _ _ = withElems ["encryption-key",
                           "no-key-error",
                           "decrypted",
                           "encrypted",
                           "decryption-error"] $ \[key, err, dec, enc, dErr] -> do
  mk <- getValue key
  decryption enc dec err mk dErr

calcHash _ _ = withElems ["hash-message", "hash-result"] $ \[msg, rst] -> do
  Just str <- getValue msg
  setProp rst "value" $ show $ hash str

genSigKey _ _ = withElems ["signature-key"] $ \[key] -> do
  x <- show <$> generateX
  setProp key "value" x

calcSig _ _ = withElems ["signature-key", "signature-message", "r", "s"] $ \[key, msg, rElem, sElem] -> do
  Just m <- getValue msg
  k <- generateK
  Just x <- getValue key
  (r, s) <- return $ signature (hash m) k (read x)
  setProp rElem "value" $ show r
  setProp sElem "value" $ show s

events [encryptBtn, decryptBtn, hashBtn, signatureKey, signatureCalc] = do
    onEvent encryptBtn OnClick doEncrypt
    onEvent decryptBtn OnClick doDecrypt
    onEvent hashBtn OnClick calcHash
    onEvent signatureKey OnClick genSigKey
    onEvent signatureCalc OnClick calcSig

main :: IO Bool
main = withElems ["encrypt",
                  "decrypt",
                  "calculate-hash",
                  "generate-signature-key",
                  "calculate-signature"] events


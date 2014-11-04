module Main where

import CBC
import Hash
import Signature

import Control.Applicative
import Control.Exception

import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core

main :: IO ()
main = do
    startGUI defaultConfig setup

withNothing :: SomeException -> IO (Maybe a)
withNothing e = do
  putStrLn "handling!"
  return Nothing

maybeEncrypt :: String -> String -> IO (Maybe String)
maybeEncrypt key msg = catch (return $ Just $ encrypt (stringToByteString key) msg) withNothing

maybeDecrypt :: String -> String -> IO (Maybe String)
maybeDecrypt key msg = catch (return $ Just $ decrypt (stringToByteString key) msg) withNothing

mkCipher :: UI Element
mkCipher = do
  keyInp <- UI.input # set UI.maxlength 5
  keyErr <- UI.span #. "error"
  initialText <- UI.textarea
  encryptBtn <- UI.button #+ [string "Зашифровать"]
  encryptedText <- UI.textarea

  on UI.click encryptBtn $ \_ -> do
    element keyErr # set text ""

    key <- get value keyInp
    initial <- get value initialText
    res <- liftIO $ maybeEncrypt key initial
    case res of
      (Just x) -> element encryptedText # set text x
      Nothing -> element keyErr # set text "Ключ должен быть ровно 10 байтов"

  decryptBtn <- UI.button #+ [string "Расшифровать"]
  decryptionErr <- UI.span #. "error"
  decryptedText <- UI.textarea

  on UI.click decryptBtn $ \_ -> do
    key <- get value keyInp
    encrypted <- get value encryptedText
    res <- liftIO $ maybeDecrypt key encrypted
    case res of
      (Just x) -> element decryptedText # set text x
      Nothing -> element decryptionErr # set text "Сообщение было закодировано другим алгоритмом либо с другим ключом"

  UI.div #+ [ UI.h1  #+ [string "Skipjack"]
            , UI.h2  #+ [string "Cipher block chaining"]
            , UI.div #+ [ UI.span #+ [string "Ключ:"]
                        , return keyInp
                        , return keyErr
                        ]
            , UI.div #+ [ UI.div #+ [string "Исходное:"]
                        , return initialText
                        , return encryptBtn
                        ]
            , UI.div #+ [ UI.div #+ [string "Зашифрованное:"]
                        , return encryptedText
                        , return decryptBtn
                        , return decryptionErr
                        ]
            , UI.div #+ [ UI.div #+ [string "Расшифрованное"]
                        , return decryptedText
                        ]
            ]

setup :: Window -> UI ()
setup w = do
  return w # set title "Skipjack"
  UI.addStyleSheet w "app.css"
  getBody w #+ [mkCipher]
  return ()

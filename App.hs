module Main where

import CBC
import Hash
import Signature

import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core

main :: IO ()
main = do
    startGUI defaultConfig setup

mkCipher :: UI Element
mkCipher = do
  keyInp <- UI.input
  keyErr <- UI.span
  UI.div #+ [ UI.h1  #+ [string "Skipjack"]
            , UI.h2  #+ [string "Cipher block chaining"]
            , UI.div #+ [ UI.span #+ [string "Ключ:"]
                        , return $ keyInp
                        , return $ keyErr
                        ]
            ]

setup :: Window -> UI ()
setup w = do
  return w # set title "Skipjack"
  UI.addStyleSheet w "app.css"
  getBody w #+ [mkCipher]
  return ()


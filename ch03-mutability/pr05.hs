#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO
import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types
import Prelude (putStrLn, getLine)

app :: Application
app _req send = send $ responseBuilder status200 [] "Hello World"

main :: IO ()
main = do
    baton <- newEmptyMVar
    race_ (warp baton) (prompt baton)
  where
    warp baton = runSettings
      (setBeforeMainLoop (putMVar baton ()) defaultSettings)
      app
    prompt baton = do
      putStrLn "Waiting for warp to be ready ... "
      takeMVar baton
      putStrLn "Warp is now ready, type 'quit' to exit"
      fix $ \loop -> do
        line <- getLine
        if line == "quit"
        then putStrLn "Goodbye!"
        else putStrLn "I didn't get that, try again" >> loop

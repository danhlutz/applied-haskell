#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
import RIO
import System.IO (hPutStrLn, stderr)

data App = App
  { appName   :: !String
  , appHandle :: !Handle }

main :: IO ()
main = do
  let app = App
        { appName = "Alice"
        , appHandle = stderr
        }
  runRIO app $ do
    sayHello
    sayGoodbye

sayHello :: RIO App ()
sayHello = sayWhat "Hello, "

sayGoodbye :: RIO App ()
sayGoodbye = sayWhat "GOODBYE! "

sayWhat :: String -> RIO App ()
sayWhat str = do
  App name h <- ask
  liftIO $ hPutStrLn h $ str ++ name

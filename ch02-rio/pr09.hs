#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO
import RIO.Process
import System.Environment
import System.Exit as E

data App = App
  { appLogFunc :: !LogFunc
  , appProcessContext :: !ProcessContext }
instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x { appLogFunc = y} )
instance HasProcessContext App where
  processContextL = lens appProcessContext (\x y -> x { appProcessContext = y})

main :: IO ()
main = do
  lo <- logOptionsHandle stderr True
  pc <- mkDefaultProcessContext
  withLogFunc lo $ \lf ->
    let app = App
          { appLogFunc = lf
          , appProcessContext = pc}
    in runRIO app run

run :: RIO App ()
run = do
  args <- liftIO getArgs
  case args of
    [] -> do
      logError "You need to provide a command"
      liftIO E.exitFailure
    x:xs -> do
      results <- proc "git" ["ls-files",".."] runProcess_
      _ results

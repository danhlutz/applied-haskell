#!/usr/bin/env stack
-- stack --resolver lts-16.27 script
{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed
import System.IO (hClose)
import UnliftIO.Temporary (withSystemTempFile)
import Control.Monad (replicateM_)

main :: IO ()
main = withSystemTempFile "date" $ \fp h -> do
    let dateConfig = setStdin closed
                   $ setStdout (useHandleOpen h)
                   $ setStderr closed
                   "date"

    replicateM_ 10 $ runProcess_ dateConfig
    hClose h
    readFile fp >>= print

#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

main :: IO ()
main = pure ()

withLoggedBinaryFileRIO :: HasLogFunc env
                        => FilePath
                        -> IOMode
                        -> (Handle -> RIO env a)
                        -> RIO env a
withLoggedBinaryFileRIO fp iomode inner = do
  logDebug $ "About to open " <> fromString fp
  withBinaryFile fp iomode $ \h ->
    inner h `finally` logDebug ("Finished using: " <> fromString fp)

withLoggedBinaryFile :: (MonadUnliftIO m, MonadReader env m, HasLogFunc env)
                     => FilePath
                     -> IOMode
                     -> (Handle -> m a)
                     -> m a
withLoggedBinaryFile fp iomode inner =
  withRunInIO $ \run ->
  run $ liftRIO $ withLoggedBinaryFileRIO fp iomode $ \h ->
  liftIO $ run (inner h)

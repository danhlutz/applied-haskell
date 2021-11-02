module Practice where
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

myCatch :: (MonadUnliftIO m, Exception e) => m a -> (e -> m a) -> m a
myCatch ma fema = do
  res <- try ma
  case res of
    Left e -> fema e
    Right x -> return x

myHandle :: (MonadUnliftIO m, Exception e) => (e -> m a) -> m a -> m a
myHandle = flip myCatch

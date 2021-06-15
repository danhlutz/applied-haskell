{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module Practice where

import RIO

myCatch :: (MonadUnliftIO m, Exception e)
        => m a -> (e -> m a) -> m a
myCatch action fallback = do
  res <- try action
  case res of
    Left e -> fallback e
    Right r -> return r


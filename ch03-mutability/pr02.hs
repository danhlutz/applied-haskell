#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
import Data.IORef
import UnliftIO (MonadUnliftIO, SomeException, tryAny)
import Control.Monad.Reader
import Control.Monad.State.Class
import System.Random (randomRIO)

newtype StateRefT s m a = StateRefT (ReaderT (IORef s) m a)
  deriving (Functor, Applicative, Monad, MonadIO, MonadTrans)

instance MonadIO m => MonadState s (StateRefT s m) where
  get = StateRefT $ ReaderT $ liftIO . readIORef
  put x = StateRefT $ ReaderT $ \ref -> liftIO $ writeIORef ref $! x

runStateRefT :: MonadUnliftIO m
              => StateRefT s m a -> s -> m (s, Either SomeException a)
runStateRefT (StateRefT (ReaderT f)) s = do
  ref <- liftIO $ newIORef s
  ea <- tryAny $ f ref
  s' <- liftIO $ readIORef ref
  return (s', ea)

main :: IO ()
main = runStateRefT inner 0 >>= print

inner :: StateRefT Int IO ()
inner =
  replicateM_ 10000 go
  where
    go = do
      res <- liftIO $ randomRIO (1, 100)
      if res == (100 :: Int)
        then error "Got 100"
        else modify (+ 1)

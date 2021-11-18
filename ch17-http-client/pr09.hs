#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE OverloadedStrings #-}
import           Control.Monad.IO.Class (liftIO)
import qualified Data.ByteString as S
import qualified Data.Conduit.List as CL
import           Network.HTTP.Simple
import           System.IO (stdout)

main :: IO ()
main = httpSink "http://httpbin.org/get" $ \response -> do
  liftIO $ putStrLn $ "status code: " ++ show (getResponseStatusCode response)

  CL.mapM_ (S.hPut stdout)

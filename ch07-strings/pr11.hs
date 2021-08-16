#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ForeignFunctionInterface #-}
import Data.Monoid ((<>))
import qualified Data.Text.Encoding as TE
import qualified Data.Text.IO as TIO
import Foreign.Ptr (Ptr)
import Foreign.C.Types (CChar)
import Data.ByteString.Unsafe (unsafeUseAsCStringLen)

foreign import ccall "write"
    c_write :: Int -> Ptr CChar -> Int -> IO ()

main :: IO ()
main = do
  TIO.putStrLn "what is your name?"
  name <- TIO.getLine
  let msg = "Hello " <> name <> "\n"
      bs = TE.encodeUtf8 msg
  unsafeUseAsCStringLen bs $ \(ptr, len) ->
    c_write stdoutFD ptr len
  where
    stdoutFD = 1

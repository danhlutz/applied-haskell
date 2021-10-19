#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import qualified Data.ByteString.Lazy as B
import           Data.Vector.Unboxed ((!), freeze)
import qualified Data.Vector.Unboxed.Mutable as M

main :: IO ()
main = do
  v <- M.replicate 256 (0 :: Int)
  contents <- B.getContents
  mapM_ (addByte v) (fromIntegral <$> B.unpack contents)

  iv <- freeze v
  printFreq iv 0 256
  where
    addByte vec b = do
      c <- M.read vec b
      M.write vec b (c+1)

    printFreq vec x y
      | x == y = return ()
      | otherwise = do
          let val = vec ! x
          if val == 0 then printFreq vec (x+1) y
            else do
              putStrLn $ show x ++ ": " ++ show val
              printFreq vec (x+1) y

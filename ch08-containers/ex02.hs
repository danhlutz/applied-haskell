#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Data.Word (Word8)
import qualified Data.ByteString.Lazy as BL
import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as M

byteCount :: BL.ByteString -> Map Word8 Int
byteCount = BL.foldr binsert M.empty
  where binsert w vals =
          case M.lookup w vals of
            Nothing -> M.insert w 1 vals
            Just x -> M.insert  w (x+1) vals

pMap :: (Show k, Show v) => Map k v -> IO ()
pMap = mapM_ print . M.toList

main :: IO ()
main = do
  contents <- BL.getContents
  pMap $ byteCount contents

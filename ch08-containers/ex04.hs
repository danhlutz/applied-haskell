#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as M
import           Data.Maybe (fromMaybe)

printScore :: Map String Int -> String -> IO ()
printScore vals k = do
  let score = case M.lookup k vals of
        Nothing -> "NO SCORE"
        Just x -> show x
  putStrLn $ k ++ ": " ++ score

main :: IO ()
main = mapM_ (printScore scores) ["Alice", "Bob", "David", "Lizzie"]
  where
    scores :: Map String Int
    scores = M.fromList
      [ ("Alice", 95)
      , ("Bob", 90)
      , ("Charles", 85)]

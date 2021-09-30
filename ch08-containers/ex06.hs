#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as M
import           Control.Monad.State

addMoney :: (String, Int) -> State (Map String Int) ()
addMoney (name, val) = do
  vals <- get
  let currentVal = case M.lookup name vals of
        Nothing -> 0
        Just x -> x
      newVal = if val + currentVal < 0 then currentVal else val + currentVal
  put $ M.insert name newVal vals

main :: IO ()
main = print $ execState (mapM_ addMoney transactions) M.empty
  where
    transactions :: [(String, Int)]
    transactions =
      [ ("Alice", 5)
      , ("Bob", 12)
      , ("Alice", 20)
      , ("Charles", 3)
      , ("Bob", -7)
      , ("Alice", -24)]

#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Data.List (intersperse)
import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as M
import           Control.Monad.State

data Accounts = Accounts (Map String Int)

instance Show Accounts where
  show (Accounts vals) =
    mconcat $ intersperse "\n" $ printKeyPair <$> M.toAscList vals

printKeyPair :: (String, Int) -> String
printKeyPair (k,v) = k ++ ": " ++ show v

addMoney :: (String, Int) -> State Accounts ()
addMoney (name, val) = do
  Accounts vals <- get
  let currentVal = case M.lookup name vals of
        Nothing -> 0
        Just x -> x
      newVal = if val + currentVal < 0 then currentVal else val + currentVal
  put $ Accounts (M.insert name newVal vals)

main :: IO ()
main = print $ execState (mapM_ addMoney transactions) (Accounts M.empty)
  where
    transactions :: [(String, Int)]
    transactions =
      [ ("Alice", 5)
      , ("Bob", 12)
      , ("Alice", 20)
      , ("Charles", 3)
      , ("Bob", -7)
      , ("Alice", -24)]

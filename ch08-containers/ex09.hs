#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Data.Set (Set)
import qualified Data.Set as S

scores :: Set Int
scores = S.fromList [1..100]

dropBottom20Percent :: Ord a => Set a -> Set a
dropBottom20Percent s =
  let perc = 20 * S.size s `div` 100
      bot  = S.fromList $ take perc $ S.toAscList s
  in S.difference s bot

main :: IO ()
main = print $ dropBottom20Percent scores

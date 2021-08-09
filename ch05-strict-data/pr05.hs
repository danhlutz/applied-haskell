#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE MagicHash #-}
import GHC.Prim
import GHC.Types

main :: IO ()
main = print $ I# (loop 0# 1#)
  where loop total i
          | isTrue# (i ># 100#) = total
          | otherwise = loop (total +# i) (i +# 1#)

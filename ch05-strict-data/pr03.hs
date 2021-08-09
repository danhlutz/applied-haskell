#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE MagicHash #-}
import GHC.Prim
import GHC.Types

main :: IO ()
main = print $ I# (5# +# 6#)

#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
import Data.Text (Text)
import qualified Data.Text as T
import Data.Text.Read (signed, decimal)
import Data.Maybe (mapMaybe)

input :: Text
input = "Alice 165cm 30y 15\n\
        \Bob 170cm 35y -20\n\
        \Charlie 175cm 40y 0\n"

data Person = Person
  { name    :: !Text
  , height  :: !Int
  , age     :: !Int
  , balance :: !Int }
  deriving Show

parseLine :: Text -> Maybe Person
parseLine t0 = do
  let (name, t1) = T.break (== ' ') t0
  t2 <- T.stripPrefix " " t1
  Right (height, t3) <- Just $ decimal t2
  t4 <- T.stripPrefix "cm " t3
  Right (age, t5) <- Just $ decimal t4
  t6 <- T.stripPrefix "y " t5
  Right (balance, "") <- Just $ signed decimal t6
  Just Person {..}


main :: IO ()
main = mapM_ print $ mapMaybe parseLine $ T.lines input

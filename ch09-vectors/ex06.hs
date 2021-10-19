#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Data.Vector.Unboxed ((!), freeze)
import qualified Data.Vector.Unboxed.Mutable as M
import           System.Random (randomRIO)

data Rank =
  Ace | Jack | Queen | King | R Int
  deriving Eq

instance Show Rank where
  show Ace = "Ace"
  show Jack = "Jack"
  show Queen = "Queen"
  show King = "King"
  show (R x) = show x

data Suit =
  Clubs Rank | Hearts Rank | Diamonds Rank | Spades Rank
  deriving Eq

instance Show Suit where
  show (Clubs r) = show r ++ " of Clubs"
  show (Hearts r) = show r ++ " of Hearts"
  show (Diamonds r) = show r ++ " of Diamonds"
  show (Spades r) = show r ++ " of Spades"

toRank :: Int -> Rank
toRank x
  | x == 0 = Ace
  | x > 0 && x < 10 = R (x+1)
  | x == 10 = Jack
  | x == 11 = Queen
  | otherwise = King

toSuit :: Int -> Suit
toSuit x =
  let rank = toRank $ x `mod` 13
      suit   = x `div` 13
  in case suit of
    0 -> Clubs rank
    1 -> Hearts rank
    2 -> Diamonds rank
    _ -> Spades rank

main :: IO ()
main = do
  deck <- M.replicate 52 (1 :: Int)
  hand <- M.replicate 5 (0 :: Int)

  mapM_ (addCard deck hand) [0..4]

  fHand <- freeze hand
  mapM_ (printCard fHand) [0..4]
  where
    addCard d h i = do
      draw <- randomRIO (0, 51)
      inDeck <- M.read d draw
      case inDeck of
        0 -> addCard d h i
        _ -> do
          M.write d draw 0
          M.write h i draw

    printCard h i = print $ toSuit $ h ! i

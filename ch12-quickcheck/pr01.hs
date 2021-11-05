{-# LANGUAGE FlexibleInstances#-}
module Practice where

import Data.List (isPrefixOf, isSuffixOf)
import Data.Numbers.Primes
import Test.QuickCheck

prop_RevRev :: Eq a => [a] -> Bool
prop_RevRev xs = reverse (reverse xs) == xs

prop_RevApp :: [Int] -> [Int] -> Bool
prop_RevApp xs ys = reverse (xs ++ ys) == reverse ys ++ reverse xs

prop_PrefixSuffix :: [Int] -> Int -> Bool
prop_PrefixSuffix xs n = isPrefixOf prefix xs &&
                         isSuffixOf (reverse prefix) (reverse xs)
  where prefix = take n xs

prop_Sqrt :: Double -> Bool
prop_Sqrt x
  | x < 0            = isNaN sqrtX
  | x == 0 || x == 1 = sqrtX == x
  | x < 1            = sqrtX > x
  | x > 1            = sqrtX > 0 && sqrtX < x
  where sqrtX = sqrt x

prop_Index_v1 :: [Integer] -> Int -> Bool
prop_Index_v1 xs n = xs !! n == head (drop n xs)

prop_Index_v2 :: NonEmptyList Integer -> NonNegative Int -> Bool
prop_Index_v2 (NonEmpty xs) (NonNegative n) = xs !! n == head (drop n xs)

prop_Index_v3 :: NonEmptyList Integer -> NonNegative Int -> Property
prop_Index_v3 (NonEmpty xs) (NonNegative n) =
  n < length xs ==> xs !! n == head (drop n xs)

prop_Index_v4 :: NonEmptyList Integer -> Property
prop_Index_v4 (NonEmpty xs) =
  forAll (choose (0, length xs-1)) $ \n -> xs !! n == head (drop n xs)

prop_PrimeFactors :: Positive Int -> Bool
prop_PrimeFactors (Positive n) = isPrime n || all isPrime (primeFactors n)

prop_PrimeSum_v1 :: Int -> Int -> Property
prop_PrimeSum_v1 p q =
  p > 2 && q > 2 && isPrime p && isPrime q ==> even (p+q)

prop_PrimeSum_v1' :: Int -> Int -> Property
prop_PrimeSum_v1' p q =
  p > 2 && q > 2 && isPrime p && isPrime q ==>
  classify (p < 20 && q < 20) "trivial" $ even (p + q)

prop_PrimeSum_v2 :: Positive (Large Int) -> Positive (Large Int) -> Property
prop_PrimeSum_v2 (Positive (Large p)) (Positive (Large q)) =
  p > 2 && q > 2 && isPrime p && isPrime 1 ==>
  collect (if p < q then (p,q) else (q,p)) $ even (p + q)

prop_PrimeSum_v3 :: Property
prop_PrimeSum_v3 =
  forAll (choose (1, 1000)) $ \i ->
    forAll (choose (1, 1000)) $ \j ->
      let (p, q) = (primes !! i, primes !! j) in
        collect (if p < q then (p,q) else (q,p)) $ even (p + q)

newtype Prime a = Prime a deriving Show

instance (Integral a, Arbitrary a) => Arbitrary (Prime a) where
  arbitrary = do
    x <- frequency [ (10, choose (0,1000))
                   , (5, choose (1001, 10000))
                   , (1, choose (10001, 50000))]
    return $ Prime (primes !! x)

prop_PrimeSum_v4 :: Prime Int -> Prime Int -> Property
prop_PrimeSum_v4 (Prime p) (Prime q) =
  p > 2 && q > 2 ==> classify (p < 1000 || q < 1000) "has small prime" $
  even (p + q)

instance Show (Int -> Char) where
  show _ = "Function (Int -> Char)"

instance Show (Char -> Maybe Double) where
  show _ = "Function (Char -> Maybe Double)"

prop_MapMap :: (Int -> Char) -> (Char -> Maybe Double) -> [Int] -> Bool
prop_MapMap f g xs = map g (map f xs) == map (g . f) xs

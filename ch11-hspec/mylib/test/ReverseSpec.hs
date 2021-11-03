module ReverseSpec where

import Test.Hspec
import Test.Hspec.QuickCheck
import Reverse

spec :: Spec
spec = do
  describe "myReverse" $ do
    it "handles empty lists" $ myReverse [] `shouldBe` ([] :: [Int])
    it "reverses hello" $ myReverse "hello" `shouldBe` "olleh"
    prop "double reverse is id" $ \list ->
      myReverse (myReverse list) `shouldBe` (list :: [Int])
  describe "betterReverse" $ do
    prop "behaves the same as myReverse" $ \list ->
      betterReverse list `shouldBe` myReverse (list :: [Int])
  describe "compare with Data.List reverse" $ do
    prop "vectorReverse" $ \list ->
      vectorReverse list `shouldBe` reverse (list :: [Int])
    prop "svectorReverse" $ \list ->
      svectorReverse list `shouldBe` reverse (list :: [Int])
    prop "uvectorReverse" $ \list ->
      uvectorReverse list `shouldBe` reverse (list :: [Int])

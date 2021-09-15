#!/usr/bin/env stack
-- stack --resolver lts-12.21 script

import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as M
import           Data.Maybe (fromMaybe)
import           Data.Semigroup
import           Data.Set (Set)
import qualified Data.Set as S

newtype MultiMap k v = MultiMap
  { toMap :: Map k (Set v)
  } deriving (Show, Eq)

instance (Ord k, Ord v) => Semigroup (MultiMap k v) where
  -- MultiMap m <> MultiMap n = MultiMap $ M.unionWith S.union m n
  m <> n =
    let nKeys = M.keys (toMap n)
    in MultiMap $ foldr merge (toMap m) nKeys
    where
      merge k =
        let mVals = getSet k m
            nVals = getSet k n
        in M.insert k (S.union mVals nVals)

      getSet k v = fromMaybe mempty (M.lookup k (toMap v))

instance (Ord k, Ord v) => Monoid (MultiMap k v) where
  mempty = MultiMap M.empty
  mappend = (<>)

instance Foldable (MultiMap k) where
  foldr f b (MultiMap m) =
    let vals = mconcat $ S.toList . snd <$> M.toList m
    in foldr f b vals

insert :: (Ord k, Ord v) => k -> v -> MultiMap k v -> MultiMap k v
insert key val vals =
  let newVal = S.insert val $ mmlookup key vals
  in MultiMap $ M.insert key newVal (toMap vals)

delete :: (Ord k, Ord v) => k -> v -> MultiMap k v -> MultiMap k v
delete key val vals =
  let newVal = S.delete val $ mmlookup key vals
  in MultiMap $ M.insert key newVal (toMap vals)

deleteAll :: Ord k => k -> MultiMap k v -> MultiMap k v
deleteAll key (MultiMap vals) = MultiMap $ M.delete key vals

mmlookup :: Ord k => k -> MultiMap k v -> Set v
mmlookup key (MultiMap m) =
  case M.lookup key m of
    Nothing -> S.empty
    Just s -> s

member :: (Ord k, Ord v) => k -> v -> MultiMap k v -> Bool
member key val vals = S.member val $ mmlookup key vals

module Practice where

import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List as List
import Data.Monoid
import Text.Printf

data SSN = SSN {
    ssnPrefix :: Int
  , ssnInfix  :: Int
  , ssnSuffix :: Int
               } deriving (Eq, Ord)

instance Show SSN where
  show (SSN p i s) = printf "%03d-%02d-%04d" p i s

mkSSN :: Int -> Int -> Int -> SSN
mkSSN p i s
  | p <= 0 || p == 666 || p >= 900 = error $ "Invalid prefix: " ++ show p
  | i <= 0 || i > 99               = error $ "Invalid infix: " ++ show i
  | s <= 0 || s > 9999             = error $ "Invalid suffix: " ++ show s
  | otherwise = SSN p i s

data Gender = Male | Female | Other String deriving (Eq, Show)

data Person = Person
  { firstName :: String
  , lastName  :: String
  , gener     :: Gender
  } deriving (Eq)

instance Show Person where
  show (Person f l g) = f ++ ' ':l ++ " (" ++ show g ++ ")"

type Employees = Map.Map SSN Person

employees :: Employees
employees =
  Map.fromList
    [ (mkSSN 525 21 5423, Person "John" "Doe" Male)
    , (mkSSN 521 01 8756, Person "Mary" "Jones" Female)
    , (mkSSN 585 11 1234, Person "William" "Smith" Male)
    , (mkSSN 525 15 5673, Person "Maria" "Gonzalez" Female)
    , (mkSSN 524 34 1234, Person "Bob" "Jones" Male)
    , (mkSSN 522 43 9862, Person "John" "Doe" Male)
    , (mkSSN 527 75 1035, Person "Julia" "Bloom" Female)
    ]

lookupEmployee :: SSN -> Employees -> Maybe Person
lookupEmployee = Map.lookup

showMap :: (Show k, Show v) => Map.Map k v -> String
showMap = List.intercalate "\n" . map show . Map.toList

showEmployee :: (SSN, Person) -> String
showEmployee (social, person) =
  concat [show social, ": ", show person]

showEmployees :: Employees -> String
showEmployees es
  | Map.null es = ""
  | otherwise = showE ssn0 person0 ++ Map.foldrWithKey prepender "" rest
  where
    showE = curry showEmployee
    ((ssn0, person0), rest) = Map.deleteFindMin es
    prepender key person acc = '\n' : showE key person ++ acc

printEmployees :: Employees -> IO ()
printEmployees = putStrLn . showEmployees

withinPrefixRangeNaive :: Int -> Int -> Employees -> Employees
withinPrefixRangeNaive lo hi = Map.filterWithKey ssnInRange
  where
    ssnInRange (SSN p _ _) _ = p >= lo && p <= hi

withinPrefixRange :: Int -> Int -> Employees -> Employees
withinPrefixRange lo hi =
  fst . Map.split (SSN (hi + 1) 0 0) . snd . Map.split (SSN lo 0 0)

colorado :: Employees -> Employees
colorado = withinPrefixRange 521 524

newMexico :: Employees -> Employees
newMexico es =
  withinPrefixRange 525 525 es `Map.union` withinPrefixRange 585 585 es

--
data State =
  Arizona | California | Colorado | NewMexico | Nevada | Oklahoma |
  Texas | Utah
  deriving (Show, Eq, Ord, Enum)

statePrefixRangeMap :: Map.Map State [(Int, Int)]
statePrefixRangeMap =
  Map.fromList
    [ (Arizona, [(526, 527)])
    , (California, [(545, 573)])
    , (Colorado, [(521, 524)])
    , (NewMexico, [(525, 525), (585, 585)])
    , (Nevada, [(530, 530), (680, 680)])
    , (Oklahoma, [(440, 448)])
    , (Texas, [(449, 467)])
    , (Utah, [(528, 529)])
    ]

allStates :: Set.Set State
allStates = Set.fromDistinctAscList [toEnum 0 ..]

statePrefixMap :: Map.Map State (Set.Set Int)
statePrefixMap =
  Map.fromSet
    (Set.fromList . concatMap (uncurry enumFromTo) . (statePrefixRangeMap Map.!))
    allStates

prefixStateMap :: Map.Map Int State
prefixStateMap = Map.foldlWithKey addPrefixes Map.empty statePrefixMap
  where
    addPrefixes spm state = Map.union spm . Map.fromSet (const state)

statePersonsMap :: Employees -> Map.Map State [Person]
statePersonsMap = Map.foldlWithKey updateState Map.empty
  where updateState sm ssn p =
          case Map.lookup (ssnPrefix ssn) prefixStateMap of
            Nothing -> sm
            Just state -> Map.alter (consPerson p) state sm
        consPerson p Nothing = Just [p]
        consPerson p (Just ps) = Just (p:ps)

stateSocialsMap :: Employees -> Map.Map State (Set.Set SSN)
stateSocialsMap = Set.foldl updateState Map.empty . Map.keysSet
  where
    updateState sm ssn =
      case Map.lookup (ssnPrefix ssn) prefixStateMap of
        Nothing -> sm
        Just state -> Map.alter (addSSN ssn) state sm

    addSSN ssn Nothing = Just $ Set.singleton ssn
    addSSN ssn (Just ssnSet) = Just $ Set.insert ssn ssnSet

employeesFrom :: State -> Employees -> Employees
employeesFrom state es =
  Map.unions $ map fromRange (statePrefixRangeMap Map.! state)
  where
    fromRange (low, high) = withinPrefixRange low high es

allStateEmployeesMap :: Employees -> Map.Map State Employees
allStateEmployeesMap es = Map.fromSet (`employeesFrom` es) allStates

statePersonsMap' :: Employees -> Map.Map State [Person]
statePersonsMap' = Map.map Map.elems . Map.filter (not . Map.null)
  . allStateEmployeesMap

stateSocialsMap' :: Employees -> Map.Map State (Set.Set SSN)
stateSocialsMap' = Map.mapMaybe nonEmptyElems . allStateEmployeesMap
  where
    nonEmptyElems sem
      | Map.null sem = Nothing
      | otherwise    = Just $ Map.keysSet sem 

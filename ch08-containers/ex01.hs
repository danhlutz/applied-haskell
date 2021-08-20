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
  , gender     :: Gender
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

showEmployee :: SSN -> Person -> String
showEmployee social person =
  concat [show social, ": ", show person]

showEmployees :: Employees -> String
showEmployees es
  | Map.null es = ""
  | otherwise = Map.foldMapWithKey showE es
  where
    showE k v = showEmployee k v <> "\n"

showEmployeesRev :: Employees -> String
showEmployeesRev es
  | Map.null es = ""
  | otherwise = showE lk lv <> Map.foldlWithKey' prep "" rest
  where
    showE k v = showEmployee k v <> "\n"
    ((lk,lv), rest) = Map.deleteFindMax es
    prep acc key person = showE key person <> acc

printEmployees :: Employees -> IO ()
printEmployees = putStrLn . showEmployees

printEmployeesRev :: Employees -> IO ()
printEmployeesRev = putStrLn . showEmployeesRev


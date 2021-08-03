#!/usr/bin/env stack
-- stack script --resolver lts-12.21
import Control.Concurrent.Async
import Data.Foldable (traverse_)

type Score = Int
data Person = Person FilePath Score

people :: [Person]
people =
  [ Person "alice.txt" 50
  , Person "bob.txt" 60
  , Person "charlie.txt" 70
  ]

writePerson :: Person -> IO ()
writePerson (Person fp score) = writeFile fp (show score)

writePeople :: [Person] -> IO ()
writePeople = runConcurrently . traverse_ (Concurrently . writePerson)

main :: IO ()
main = writePeople people

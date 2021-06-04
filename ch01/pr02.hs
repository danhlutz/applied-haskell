#!/usr/bin/env stack
-- stack script --resolver lts-12.21
import Conduit
import UnliftIO

main :: IO ()
main = do
  write2Files
  runConduitRes $
    (sourceFile "file1.txt" *> sourceFile "file2.txt") .|
    sink

write2Files = runConcurrently $
     Concurrently (writeFile "file1.txt" "this is file1")
  *> Concurrently (writeFile "file2.txt" "this is file2")

sink = getZipSink $
     ZipSink (sinkFile "output1.txt")
  *> ZipSink (sinkFile "output2.txt")

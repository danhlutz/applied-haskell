module Practice where

import RIO
import System.IO (openBinaryFile)

withBinaryFile' :: FilePath -> IOMode -> (Handle -> IO r) -> IO r
withBinaryFile' fp mode f = bracket (openBinaryFile fp mode) hClose f

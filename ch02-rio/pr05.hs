#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
import RIO
import RIO.Time (getCurrentTime)
import System.IO (hPutStrLn, stderr, stdout)

data App = App
  { appName   :: !String
  , appHandle :: !Handle }

class HasHandle env where
  handleL :: Lens' env Handle
instance HasHandle Handle where
  handleL = id
instance HasHandle App where
  handleL = lens appHandle (\x y -> x { appHandle = y})

main :: IO ()
main = do
  let app = App
        { appName = "Alice"
        , appHandle = stderr
        }
  runRIO app $ do
    switchHandle stdout sayHello
    sayTime

switchHandle :: HasHandle env => Handle -> RIO env a -> RIO env a
switchHandle h = local (set handleL h)

say :: HasHandle env => String -> RIO env ()
say msg = do
  h <- view handleL
  liftIO $ hPutStrLn h msg

sayHello :: RIO App ()
sayHello = do
  App name _h <- ask
  say $ "Hello, " ++ name

sayTime :: HasHandle env => RIO env ()
sayTime = do
  now <- getCurrentTime
  say $ "The time is: " ++ show now

sayGoodbye :: RIO App ()
sayGoodbye = do
  App name _h <- ask
  say $ "GOOD BYE BYE " ++ name

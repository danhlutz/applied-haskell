#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

data App = App
  { appLogFunc :: !LogFunc
  , appName    :: !Utf8Builder
  }

instance HasLogFunc App where
  logFuncL = lens appLogFunc (\x y -> x { appLogFunc = y})

class HasAppName env where
  nameL :: Lens' env Utf8Builder
instance HasAppName App where
  nameL = lens appName (\x y -> x {appName = y})

main :: IO ()
main = runApp sayHello


runApp :: RIO App a -> IO a
runApp inner = do
  logOptions' <- logOptionsHandle stderr False
  let logOptions = setLogUseLoc True logOptions'
        -- setLogUseTime True $ setLogUseLoc True logOptions'
  withLogFunc logOptions $ \logFunc -> do
    let app = App {
            appLogFunc = logFunc
          , appName = "Alice" }
    runRIO app inner

sayHello :: (HasLogFunc env, HasAppName env) => RIO env ()
sayHello = do
  name <- view nameL
  logInfo $ "Hello, " <> name

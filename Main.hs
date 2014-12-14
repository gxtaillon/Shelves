{-# LANGUAGE OverloadedStrings #-}
module Main where

import Model
import Control.Monad.IO.Class  (liftIO)
import Database.Persist.Sqlite hiding (master, Connection)



main :: IO ()
main = runSqlite ":memory:" $ do
    runMigration migrateAll

    myShelfId <- insert $ Shelf "ABCD.123" 10.0 1.5 2.0
    thatBoxId <- insert $ Box "ZXY.098" 1.0 1.0 1.0
    thisBoxId <- insert $ Box "ZXY.099" 2.0 1.0 1.0
    
    _ <- insert $ Storage myShelfId thatBoxId
    _ <- insert $ Storage myShelfId thisBoxId

    myStorage <- selectList [StorageShelfId ==. myShelfId] []
    liftIO $ print (myStorage :: [Entity Storage])
    
    update myShelfId [ShelfWidth +=. 0.5]

    thatBox <- get thatBoxId
    liftIO $ print (thatBox :: Maybe Box)
    myShelf <- get myShelfId
    liftIO $ print (myShelf :: Maybe Shelf)

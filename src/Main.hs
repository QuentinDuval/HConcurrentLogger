module Main where

import ChanLogger (ChanLogger)
import qualified ChanLogger
import System.Directory
import Format
import SyncLogger (SyncLogger)
import qualified SyncLogger
import TestCase



main::IO()
main = do
   let spamTest :: (Logger l) => l -> IO ()
       spamTest = serialSpammer inputs 5000 TimedMsg
       inputs = words "Let us hope it will not dead lock"
          
   spamTest =<< ChanLogger.create "chan.txt"
   spamTest =<< SyncLogger.create "sync.txt"
   mapM_ removeFile ["chan.txt", "sync.txt"]


instance Logger ChanLogger where
   logMsg = ChanLogger.logMsg
   shut   = ChanLogger.shut

instance Logger SyncLogger where
   logMsg = SyncLogger.logMsg
   shut   = SyncLogger.shut

module SyncLogger (
   SyncLogger (SyncLogger),
   create, logMsg, shut
) where

import Control.Concurrent.RLock as RLock
import Format
import System.IO


-- | A simple logger object, linked to a file
data SyncLogger = SyncLogger {
   _lock :: RLock,
   _file :: Handle
};


-- | Create a new logger
create :: String -> IO SyncLogger
create fileName = do
   file <- openFile fileName AppendMode
   lock <- RLock.new
   return $ SyncLogger lock file


-- | Log a new message
logMsg :: SyncLogger -> Format -> String -> IO()
logMsg logger fmt str =
   RLock.with(_lock logger) $
      hPutStrLn (_file logger) =<< formatMsg fmt str


-- | Shut the logger
shut :: SyncLogger -> IO()
shut logger = hClose (_file logger)

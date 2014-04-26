module ChanLogger (
   ChanLogger,
   create, logMsg, shut
) where

import Control.Concurrent
import Control.Concurrent.Chan
import Format
import System.IO


-- | A simple logger object, linked to a file
newtype ChanLogger = ChanLogger { send :: LogCommand -> IO () };
data    LogCommand = LogCommand Format String | Shut (MVar ())


-- | Create a new logger
create :: String -> IO ChanLogger
create fileName = do
   ch <- newChan
   _ <- forkIO $ withFile fileName AppendMode (worker ch)
   return $ ChanLogger (writeChan ch) 


worker :: Chan LogCommand -> Handle -> IO()
worker ch out = loop where
   loop = do
      m <- readChan ch
      case m of
         Shut syncflag -> putMVar syncflag ()
         LogCommand fmt str ->
            formatMsg fmt str >>= hPutStrLn out >> loop


-- | Log a new message
logMsg :: ChanLogger -> Format -> String -> IO()
logMsg logger fmt str = send logger $ LogCommand fmt str


-- | Shut the logger
shut :: ChanLogger -> IO()
shut logger = do
   syncflag <- newEmptyMVar
   send logger (Shut syncflag)
   takeMVar syncflag


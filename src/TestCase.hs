module TestCase where

import Control.Concurrent.Async
import Control.Monad
import Data.Time
import Format


-- | Test subject
class Logger a where
   logMsg :: a -> Format -> String -> IO ()
   shut   :: a -> IO ()


{- ^
Test case:
   - Log each input iter times
   - Wait for the completion of the spammer and mark time
   - Wait for the completion of the logger and mark time
-}

serialSpammer :: (Logger l) => [String] -> Int -> Format -> l -> IO ()
serialSpammer inputs iter fmt logger =
   do t1 <- getCurrentTime
      spamers <- forM inputs
         (async . replicateM_ iter . logMsg logger fmt)
      mapM_ wait spamers
      t2 <- getCurrentTime
      shut logger
      t3 <- getCurrentTime
      timeReport t1 t2 t3


-- | Utils
timeReport :: UTCTime -> UTCTime -> UTCTime -> IO()
timeReport start mid stop =
   do let timeStr t1 t2 = show $ diffUTCTime t2 t1
      putStr $ "Elapsed: " ++ timeStr start stop
      putStrLn $ " (Delay: " ++ timeStr start mid ++ ")"

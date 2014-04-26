module Format where
import Data.Time


-- | The formating of the message
data Format = TimedMsg | NoFormat 

-- | Formatting method
formatMsg :: Format -> String -> IO String
formatMsg NoFormat str = return str
formatMsg TimedMsg str = do
   time <- getCurrentTime
   return $ "[" ++ show time ++ "]: " ++ str

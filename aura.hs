-- AURA package manager for Arch Linux

-- System libraries
import System.Environment (getArgs)
import System.Console.GetOpt

-- Custom libraries
import Pacman

data Flag = AURInstall | Help deriving (Eq)

options :: [OptDescr Flag]
options = [ Option ['A'] ["aursync"] (NoArg AURInstall) aDesc
          , Option ['h'] ["help"]    (NoArg Help)       hDesc
          ]
    where aDesc = "Install from the AUR."
          hDesc = "Displays this help message."

auraUsageMsg :: String
auraUsageMsg = usageInfo "AURA only operations:" options

{-
argError :: String -> a
argError msg = error $ usageInfo (msg ++ "\n" ++ usageMsg) options
-}

main = do
  args <- getArgs
  opts <- parseOpts args
  executeOpts opts

parseOpts :: [String] -> IO ([Flag],[String],[String])
parseOpts args = case getOpt' Permute options args of
                   (opts,nonOpts,pacOpts,_) -> return (opts,nonOpts,pacOpts) 

executeOpts :: ([Flag],[String],[String]) -> IO ()
executeOpts (flags,input,pacOpts) =
    case flags of
      [Help]       -> getPacmanHelpMsg >>= putStrLn . getHelpMsg
      [AURInstall] -> putStrLn "This option isn't ready yet."
      _            -> (pacman $ pacOpts ++ input) >> return ()

-- Crappy temp version.
-- Do this with regexes!
getHelpMsg :: [String] -> String
getHelpMsg pacmanHelpMsg = replacedLines ++ "\n" ++ auraUsageMsg
    where replacedLines = unlines . map replaceWord $ pacmanHelpMsg
          replaceWord   = unwords . map replace . words
          replace "pacman"      = "aura"
          replace "operations:" = "Inherited Pacman Operations:"
          replace otherWord     = otherWord

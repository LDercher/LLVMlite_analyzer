module Main where

import Data.List
import System.Environment

import LL.Language
import LL.Parser
import LL.Lexer

import Lab6


main = mapM_ doFile =<< getArgs

doFile fn = do s <- readFile fn
               let prog  = parse (alexScanTokens s)
               mapM_ doFun (functions prog)

doFun (funName, (_, _, cfg@(_, blocks))) =
    do putStrLn ("=== " ++ funName ++ " ===")
       mapM_ doBlock ("^" : map fst blocks)
    where preds             = predecessors cfg
          uds               = useDefs cfg
          doBlock blockName = putStr (unlines ["--- " ++ blockName ++ " ---", blockPreds, blockUseDefs])
              where blockPreds = case lookup blockName preds of
                                   Nothing -> "    Something's wrong! No predecessors for " ++ blockName
                                   Just bs -> "    Predecessors: " ++ intercalate ", " bs
                    blockUseDefs = case lookup blockName uds of
                                     Nothing           -> "    Something's wrong! No uses for " ++ blockName
                                     Just (used, defs) -> "    Used:" ++ intercalate ", " used ++
                                                          "\n    Defined: " ++  intercalate ", " defs

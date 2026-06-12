module Persistence where

import Types
import qualified Data.Map as Map
import Control.Exception (catch, IOException)
import Text.Read (readMaybe)

inventarioArquivo :: FilePath
inventarioArquivo = "Inventario.dat"

logArquivo :: FilePath
logArquivo = "Auditoria.log"

carregarInventario :: IO Inventario
carregarInventario = catch carregar tratarErro
  where
    carregar = do
      conteudo <- readFile inventarioArquivo
      case readMaybe conteudo of
        Just inventario -> return inventario
        Nothing -> return Map.empty

    tratarErro :: IOException -> IO Inventario
    tratarErro _ = return Map.empty

salvarInventario :: Inventario -> IO ()
salvarInventario inventario =
  writeFile inventarioArquivo (show inventario)

carregarLogs :: IO [LogEntry]
carregarLogs = catch carregar tratarErro
  where
    carregar = do
      conteudo <- readFile logArquivo
      return [logEntry | linha <- lines conteudo, Just logEntry <- [readMaybe linha]]

    tratarErro :: IOException -> IO [LogEntry]
    tratarErro _ = return []

adicionarLog :: LogEntry -> IO ()
adicionarLog logEntry =
  appendFile logArquivo (show logEntry ++ "\n")
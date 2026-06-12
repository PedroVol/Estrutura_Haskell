module Reports where

import Types
import qualified Data.Map as Map
import Data.List (sortOn)
import Data.Ord (Down(..))

logsDeErro :: [LogEntry] -> [LogEntry]
logsDeErro logs =
  filter ehErro logs
  where
    ehErro logEntry =
      case status logEntry of
        Falha _ -> True
        Sucesso -> False

historicoPorItem :: [LogEntry] -> [(String, Int)]
historicoPorItem logs =
  Map.toList (foldl contar Map.empty logs)
  where
    contar mapa logEntry
      | itemAfetado logEntry == "" = mapa
      | itemAfetado logEntry == "SISTEMA" = mapa
      | itemAfetado logEntry == "TODOS" = mapa
      | otherwise = Map.insertWith (+) (itemAfetado logEntry) 1 mapa

itensMaisMovimentados :: [LogEntry] -> [(String, Int)]
itensMaisMovimentados logs =
  sortOn (Down . snd) (historicoPorItem logs)

formatarLog :: LogEntry -> String
formatarLog logEntry =
  show (timestamp logEntry)
  ++ " | " ++ show (acao logEntry)
  ++ " | Item: " ++ itemAfetado logEntry
  ++ " | " ++ detalhes logEntry
  ++ " | " ++ show (status logEntry)

formatarRelatorio :: [LogEntry] -> String
formatarRelatorio logs =
  unlines
    [ "===== RELATÓRIO DE AUDITORIA ====="
    , "Total de registros no log: " ++ show (length logs)
    , "Total de falhas: " ++ show (length erros)
    , ""
    , "----- ITENS MAIS MOVIMENTADOS -----"
    , textoMovimentacao
    , ""
    , "----- LOGS DE ERRO -----"
    , textoErros
    ]
  where
    erros = logsDeErro logs
    movimentados = take 10 (itensMaisMovimentados logs)

    textoMovimentacao =
      if null movimentados
        then "Nenhuma movimentação registrada."
        else unlines [idItem ++ ": " ++ show total ++ " operação(ões)" | (idItem, total) <- movimentados]

    textoErros =
      if null erros
        then "Nenhum erro registrado."
        else unlines (map formatarLog erros)
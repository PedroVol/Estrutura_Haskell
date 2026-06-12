module InventoryLogic where

import Types
import Data.Time (UTCTime)
import qualified Data.Map as Map

criarLog :: UTCTime -> AcaoLog -> String -> String -> StatusLog -> LogEntry
criarLog tempo acaoLog idItem desc statusLog =
  LogEntry tempo acaoLog idItem desc statusLog

addItem :: UTCTime -> Item -> Inventario -> Either String ResultadoOperacao
addItem tempo item inventario
  | itemID item == "" =
      Left "O ID do item não pode ficar vazio."

  | nome item == "" =
      Left "O nome do item não pode ficar vazio."

  | quantidade item <= 0 =
      Left "A quantidade deve ser maior que zero."

  | Map.member (itemID item) inventario =
      Left "Já existe um item com esse ID."

  | otherwise =
      let novoInv = Map.insert (itemID item) item inventario
          logEntry = criarLog tempo Add (itemID item)
                      ("Item adicionado: " ++ show item)
                      Sucesso
      in Right (ResultadoOperacao novoInv logEntry "Item adicionado com sucesso.")

removeItem :: UTCTime -> String -> Int -> Inventario -> Either String ResultadoOperacao
removeItem tempo idItem qtdRemover inventario =
  case Map.lookup idItem inventario of
    Nothing ->
      Left "Item não encontrado."

    Just item ->
      if qtdRemover <= 0 then
        Left "A quantidade a remover deve ser maior que zero."
      else if qtdRemover > quantidade item then
        Left "Estoque insuficiente."
      else
        let novaQtd = quantidade item - qtdRemover
            itemAtualizado = item { quantidade = novaQtd }

            novoInv =
              if novaQtd == 0
                then Map.delete idItem inventario
                else Map.insert idItem itemAtualizado inventario

            logEntry = criarLog tempo Remove idItem
                        ("Removidas " ++ show qtdRemover ++ " unidades.")
                        Sucesso
        in Right (ResultadoOperacao novoInv logEntry "Item removido com sucesso.")

updateItem :: UTCTime -> String -> String -> Int -> String -> Inventario -> Either String ResultadoOperacao
updateItem tempo idItem novoNome novaQtd novaCategoria inventario =
  case Map.lookup idItem inventario of
    Nothing ->
      Left "Item não encontrado."

    Just _ ->
      if novoNome == "" then
        Left "O nome do item não pode ficar vazio."
      else if novaQtd < 0 then
        Left "A quantidade não pode ser negativa."
      else
        let itemAtualizado = Item idItem novoNome novaQtd novaCategoria
            novoInv = Map.insert idItem itemAtualizado inventario
            logEntry = criarLog tempo Update idItem
                        ("Item atualizado: " ++ show itemAtualizado)
                        Sucesso
        in Right (ResultadoOperacao novoInv logEntry "Item atualizado com sucesso.")

queryItem :: UTCTime -> String -> Inventario -> Either String ResultadoOperacao
queryItem tempo idItem inventario =
  case Map.lookup idItem inventario of
    Nothing ->
      Left "Item não encontrado."

    Just item ->
      let logEntry = criarLog tempo Query idItem
                      ("Consulta realizada: " ++ show item)
                      Sucesso
      in Right (ResultadoOperacao inventario logEntry ("Item encontrado: " ++ show item))
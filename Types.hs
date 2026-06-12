module Types where

import Data.Time (UTCTime)
import qualified Data.Map as Map

data Item = Item
  { itemID :: String
  , nome :: String
  , quantidade :: Int
  , categoria :: String
  } deriving (Show, Read, Eq)

type Inventario = Map.Map String Item

data AcaoLog
  = Add
  | Remove
  | Update
  | Query
  | Report
  deriving (Show, Read, Eq)

data StatusLog
  = Sucesso
  | Falha String
  deriving (Show, Read, Eq)

data LogEntry = LogEntry
  { timestamp :: UTCTime
  , acao :: AcaoLog
  , itemAfetado :: String
  , detalhes :: String
  , status :: StatusLog
  } deriving (Show, Read, Eq)

data ResultadoOperacao = ResultadoOperacao
  { novoInventario :: Inventario
  , logGerado :: LogEntry
  , mensagem :: String
  } deriving (Show, Read, Eq)
module Main where

import Types
import InventoryLogic
import Persistence
import Reports

import Data.Time (getCurrentTime)
import qualified Data.Map as Map
import Text.Read (readMaybe)
import System.IO (hFlush, stdout)
import Control.Monad (foldM, when)

main :: IO ()
main = do
  putStrLn "===================================="
  putStrLn " Sistema de Inventário em Haskell"
  putStrLn "===================================="

  inventario <- carregarInventario
  logsAntigos <- carregarLogs

  putStrLn ("Inventário carregado com " ++ show (Map.size inventario) ++ " item(ns).")
  putStrLn ("Auditoria carregada com " ++ show (length logsAntigos) ++ " registro(s).")

  loop inventario

loop :: Inventario -> IO ()
loop inventario = do
  mostrarMenu
  opcao <- prompt "Escolha uma opção: "

  case opcao of
    "1" -> telaAdicionar inventario >>= loop
    "2" -> telaRemover inventario >>= loop
    "3" -> telaAtualizar inventario >>= loop
    "4" -> telaConsultar inventario >>= loop
    "5" -> telaListar inventario >>= loop
    "6" -> telaReport inventario >>= loop
    "7" -> telaPopularExemplo inventario >>= loop
    "0" -> putStrLn "Programa encerrado."
    _ -> do
      tempo <- getCurrentTime
      adicionarLog (criarLog tempo Query "SISTEMA" ("Comando inválido: " ++ opcao) (Falha "Opção inválida no menu."))
      putStrLn "Opção inválida. Tente novamente."
      loop inventario

mostrarMenu :: IO ()
mostrarMenu = do
  putStrLn ""
  putStrLn "========== MENU =========="
  putStrLn "1 - Adicionar item"
  putStrLn "2 - Remover quantidade de item"
  putStrLn "3 - Atualizar item"
  putStrLn "4 - Consultar item"
  putStrLn "5 - Listar inventário"
  putStrLn "6 - Gerar relatório"
  putStrLn "7 - Popular com 10 itens de exemplo"
  putStrLn "0 - Sair"

prompt :: String -> IO String
prompt texto = do
  putStr texto
  hFlush stdout
  getLine

executarOperacao :: Bool -> Inventario -> Either String ResultadoOperacao -> AcaoLog -> String -> String -> IO Inventario
executarOperacao deveSalvar inventario resultado acaoOperacao idItem detalheFalha =
  case resultado of
    Right resultadoOk -> do
      when deveSalvar (salvarInventario (novoInventario resultadoOk))
      adicionarLog (logGerado resultadoOk)
      putStrLn (mensagem resultadoOk)
      return (novoInventario resultadoOk)

    Left erro -> do
      tempo <- getCurrentTime
      let logFalha = criarLog tempo acaoOperacao idItem detalheFalha (Falha erro)
      adicionarLog logFalha
      putStrLn ("Erro: " ++ erro)
      return inventario

registrarFalhaEntrada :: Inventario -> AcaoLog -> String -> String -> String -> IO Inventario
registrarFalhaEntrada inventario acaoOperacao idItem detalhe erro = do
  tempo <- getCurrentTime
  adicionarLog (criarLog tempo acaoOperacao idItem detalhe (Falha erro))
  putStrLn ("Erro: " ++ erro)
  return inventario

telaAdicionar :: Inventario -> IO Inventario
telaAdicionar inventario = do
  putStrLn ""
  putStrLn "--- Adicionar item ---"
  idItem <- prompt "ID: "
  nomeItem <- prompt "Nome: "
  qtdTexto <- prompt "Quantidade: "
  categoriaItem <- prompt "Categoria: "
  tempo <- getCurrentTime

  case readMaybe qtdTexto :: Maybe Int of
    Nothing ->
      registrarFalhaEntrada inventario Add idItem "Quantidade inválida ao adicionar item." "A quantidade precisa ser um número inteiro."

    Just qtd ->
      let item = Item idItem nomeItem qtd categoriaItem
      in executarOperacao True inventario (addItem tempo item inventario) Add idItem "Tentativa de adicionar item."

telaRemover :: Inventario -> IO Inventario
telaRemover inventario = do
  putStrLn ""
  putStrLn "--- Remover quantidade de item ---"
  idItem <- prompt "ID do item: "
  qtdTexto <- prompt "Quantidade a remover: "
  tempo <- getCurrentTime

  case readMaybe qtdTexto :: Maybe Int of
    Nothing ->
      registrarFalhaEntrada inventario Remove idItem "Quantidade inválida ao remover item." "A quantidade precisa ser um número inteiro."

    Just qtd ->
      executarOperacao True inventario (removeItem tempo idItem qtd inventario) Remove idItem "Tentativa de remover item."

telaAtualizar :: Inventario -> IO Inventario
telaAtualizar inventario = do
  putStrLn ""
  putStrLn "--- Atualizar item ---"
  idItem <- prompt "ID do item: "
  novoNome <- prompt "Novo nome: "
  qtdTexto <- prompt "Nova quantidade: "
  novaCategoria <- prompt "Nova categoria: "
  tempo <- getCurrentTime

  case readMaybe qtdTexto :: Maybe Int of
    Nothing ->
      registrarFalhaEntrada inventario Update idItem "Quantidade inválida ao atualizar item." "A quantidade precisa ser um número inteiro."

    Just qtd ->
      executarOperacao True inventario (updateItem tempo idItem novoNome qtd novaCategoria inventario) Update idItem "Tentativa de atualizar item."

telaConsultar :: Inventario -> IO Inventario
telaConsultar inventario = do
  putStrLn ""
  putStrLn "--- Consultar item ---"
  idItem <- prompt "ID do item: "
  tempo <- getCurrentTime
  executarOperacao False inventario (queryItem tempo idItem inventario) Query idItem "Tentativa de consultar item."

telaListar :: Inventario -> IO Inventario
telaListar inventario = do
  putStrLn ""
  putStrLn "--- Inventário atual ---"

  if Map.null inventario
    then putStrLn "Inventário vazio."
    else mapM_ print (Map.elems inventario)

  tempo <- getCurrentTime
  adicionarLog (criarLog tempo Query "TODOS" "Listagem completa do inventário." Sucesso)
  return inventario

telaReport :: Inventario -> IO Inventario
telaReport inventario = do
  putStrLn ""
  logsAtuais <- carregarLogs
  putStrLn (formatarRelatorio logsAtuais)

  tempo <- getCurrentTime
  adicionarLog (criarLog tempo Report "SISTEMA" "Relatório de auditoria gerado pelo comando report." Sucesso)
  return inventario

telaPopularExemplo :: Inventario -> IO Inventario
telaPopularExemplo inventario = do
  putStrLn ""
  putStrLn "--- Populando inventário com dados de exemplo ---"
  inventarioFinal <- foldM inserirItem inventario itensExemplo
  putStrLn "Processo de população concluído."
  return inventarioFinal
  where
    inserirItem invAtual item = do
      tempo <- getCurrentTime
      case addItem tempo item invAtual of
        Right resultadoOk -> do
          salvarInventario (novoInventario resultadoOk)
          adicionarLog (logGerado resultadoOk)
          putStrLn ("Adicionado: " ++ itemID item)
          return (novoInventario resultadoOk)

        Left erro -> do
          adicionarLog (criarLog tempo Add (itemID item) "Tentativa de popular item de exemplo." (Falha erro))
          putStrLn ("Não foi possível adicionar " ++ itemID item ++ ": " ++ erro)
          return invAtual

itensExemplo :: [Item]
itensExemplo =
  [ Item "1" "Teclado" 10 "Periféricos"
  , Item "2" "Mouse" 15 "Periféricos"
  , Item "3" "Monitor" 8 "Vídeo"
  , Item "4" "Cabo HDMI" 20 "Cabos"
  , Item "5" "Notebook" 5 "Computadores"
  , Item "6" "Webcam" 7 "Periféricos"
  , Item "7" "Headset" 12 "Áudio"
  , Item "8" "SSD" 9 "Armazenamento"
  , Item "9" "Memória RAM" 14 "Hardware"
  , Item "10" "Fonte" 6 "Hardware"
  ]
# Sistema de Inventário em Haskell

## 1. Informações do Trabalho

**Instituição:** [PUCPR - Pontifícia Universidade Católica do Paraná]

**Disciplina:** [Programação Lógica e Funcional]

**Professor(a):** [Frank Coelho de Alcantara]

## 2. Integrantes do Grupo

Os integrantes estão listados

| Nome do aluno | Usuário do GitHub |
| ------------- | ----------------- |
| [Pedro Muller Volpe]     | [@PedroVol]       |

## 3. Link do Ambiente de Execução

O programa pode ser executado no ambiente online abaixo:

**Link:** [https://www.onlinegdb.com/edit/Qliw4BC9e]

## 4. Descrição do Projeto

Este projeto consiste em um sistema de inventário desenvolvido em Haskell.
O sistema permite adicionar, remover, atualizar, consultar e listar itens do inventário por meio do terminal.

Além disso, o programa realiza a persistência dos dados em disco, salvando o estado atual do inventário no arquivo `Inventario.dat`. Também registra todas as tentativas de operação, sejam elas bem-sucedidas ou com falha, no arquivo `Auditoria.log`.

O projeto utiliza funções puras para a lógica de negócio e separa as operações de entrada e saída em módulos próprios.

## 5. Estrutura dos Arquivos

```txt
SistemaInventario/
│
├── Main.hs
├── Types.hs
├── InventoryLogic.hs
├── Persistence.hs
├── Reports.hs
├── Inventario.dat
├── Auditoria.log
```

### Descrição dos principais arquivos

| Arquivo             | Descrição                                                                                                   |
| ------------------- | ----------------------------------------------------------------------------------------------------------- |
| `Main.hs`           | Controla o menu, a interação com o usuário e o fluxo principal do programa.                                 |
| `Types.hs`          | Define os tipos de dados usados no sistema, como `Item`, `Inventario`, `AcaoLog`, `StatusLog` e `LogEntry`. |
| `InventoryLogic.hs` | Contém as funções puras responsáveis pela lógica de adicionar, remover, atualizar e consultar itens.        |
| `Persistence.hs`    | Responsável por carregar e salvar o inventário e os logs em arquivos.                                       |
| `Reports.hs`        | Contém as funções de análise dos logs e geração de relatórios.                                              |
| `Inventario.dat`    | Arquivo onde o inventário atual é armazenado.                                                               |
| `Auditoria.log`     | Arquivo onde são registrados os logs de auditoria.                                                          |

## 6. Como Compilar e Executar

### Opção 1: Executando no terminal com GHC

Para compilar o programa, execute:

```bash
ghc Main.hs -o inventario
```

Depois, para executar:

```bash
./inventario
```

No Windows, o comando de execução pode ser:

```bash
inventario.exe
```

### Opção 2: Executando com `runghc`

Também é possível executar diretamente sem gerar arquivo executável:

```bash
runghc Main.hs
```

### Opção 3: Executando no Online GDB ou Replit

1. Acesse o link do ambiente de execução informado neste README.
2. Verifique se todos os arquivos `.hs` estão no projeto.
3. Execute o arquivo `Main.hs`.
4. O programa abrirá um menu interativo no terminal.
5. Escolha as opções digitando o número correspondente.

## 7. Comandos Disponíveis no Sistema

Ao iniciar o programa, o menu exibido será semelhante a este:

```txt
========== MENU ==========
1 - Adicionar item
2 - Remover quantidade de item
3 - Atualizar item
4 - Consultar item
5 - Listar inventário
6 - Gerar relatório
7 - Popular com 10 itens de exemplo
0 - Sair
```

## 8. Exemplo de Uso

### Exemplo 1: Popular o inventário

Ao escolher a opção:

```txt
7 - Popular com 10 itens de exemplo
```

O sistema adiciona automaticamente 10 itens ao inventário, como teclado, mouse, monitor, notebook, headset, entre outros.
Além disso, pode usar:

```txt
1 - Adicionar item
```
para adicionar manualmente e como desejar.

Depois disso, o arquivo `Inventario.dat` será criado ou atualizado.

### Exemplo 2: Listar itens

Escolha a opção:

```txt
5 - Listar inventário
```

O sistema exibirá os itens atualmente cadastrados no inventário.

### Exemplo 3: Remover item com estoque suficiente

Escolha a opção:

```txt
2 - Remover quantidade de item
```

Depois informe:

```txt
ID do item: 1
Quantidade a remover: 2
```

Se o item existir e houver estoque suficiente, a quantidade será atualizada e a operação será registrada no arquivo `Auditoria.log`.

### Exemplo 4: Remover item com estoque insuficiente

Escolha a opção:

```txt
2 - Remover quantidade de item
```

Depois informe:

```txt
ID do item: 1
Quantidade a remover: 15
```

Se o item possuir menos unidades do que a quantidade solicitada, o sistema exibirá uma mensagem de erro e registrará a falha no arquivo `Auditoria.log`.

### Exemplo 5: Gerar relatório

Escolha a opção:

```txt
6 - Gerar relatório
```

O sistema exibirá um relatório com informações sobre os registros de auditoria, incluindo falhas e movimentações de itens.

## 9. Persistência dos Dados

O sistema utiliza dois arquivos principais para persistência:

### `Inventario.dat`

Armazena o estado atual do inventário.

Esse arquivo é atualizado sempre que uma operação bem-sucedida altera o inventário, como adicionar, remover ou atualizar um item.

### `Auditoria.log`

Armazena o histórico de operações realizadas no sistema.

Cada operação, seja ela bem-sucedida ou com falha, gera um registro de log contendo:

* data e horário da operação;
* tipo da ação realizada;
* item afetado;
* detalhes da operação;
* status da operação.

## 10. Cenários de Teste

#Cenário 1: Persistência de Estado

Objetivo: verificar se o sistema salva o inventário no arquivo Inventario.dat e carrega os dados novamente ao reiniciar o programa.

Passos executados
Iniciar o programa.
Escolher a opção 7 - Popular com 10 itens de exemplo.
Escolher a opção 5 - Listar inventário.
Encerrar o programa com a opção 0.
Executar o programa novamente.
Escolher novamente a opção 5 - Listar inventário.
Exemplo de saída
====================================
 Sistema de Inventário em Haskell
====================================
Inventário carregado com 0 item(ns).
Auditoria carregada com 0 registro(s).

========== MENU ==========
1 - Adicionar item
2 - Remover quantidade de item
3 - Atualizar item
4 - Consultar item
5 - Listar inventário
6 - Gerar relatório
7 - Popular com 10 itens de exemplo
0 - Sair
Escolha uma opção: 7

--- Populando inventário com dados de exemplo ---
Adicionado: 1
Adicionado: 2
Adicionado: 3
Adicionado: 4
Adicionado: 5
Adicionado: 6
Adicionado: 7
Adicionado: 8
Adicionado: 9
Adicionado: 10
Processo de população concluído.

Após escolher a opção 5, a saída esperada é semelhante a:

--- Inventário atual ---
Item {itemID = "1", nome = "Teclado", quantidade = 10, categoria = "Periféricos"}
Item {itemID = "2", nome = "Mouse", quantidade = 15, categoria = "Periféricos"}
Item {itemID = "3", nome = "Monitor", quantidade = 8, categoria = "Vídeo"}
Item {itemID = "4", nome = "Cabo HDMI", quantidade = 20, categoria = "Cabos"}
Item {itemID = "5", nome = "Notebook", quantidade = 5, categoria = "Computadores"}
Item {itemID = "6", nome = "Webcam", quantidade = 7, categoria = "Periféricos"}
Item {itemID = "7", nome = "Headset", quantidade = 12, categoria = "Áudio"}
Item {itemID = "8", nome = "SSD", quantidade = 9, categoria = "Armazenamento"}
Item {itemID = "9", nome = "Memória RAM", quantidade = 14, categoria = "Hardware"}
Item {itemID = "10", nome = "Fonte", quantidade = 6, categoria = "Hardware"}

Depois de encerrar e executar novamente o programa, a saída inicial deve indicar que os itens foram carregados:

====================================
 Sistema de Inventário em Haskell
====================================
Inventário carregado com 10 item(ns).
Auditoria carregada com 11 registro(s).

Isso confirma que o arquivo Inventario.dat foi criado e que o estado do inventário foi persistido entre diferentes execuções.

#Cenário 2: Erro de Estoque Insuficiente

Objetivo: verificar se o sistema impede a remoção de uma quantidade maior do que a disponível no estoque e registra a falha no arquivo Auditoria.log.

Passos executados
Iniciar o programa com o inventário já populado.
Escolher a opção 2 - Remover quantidade de item.
Informar o ID 1, referente ao item Teclado.
Informar a quantidade 15, sendo que o item possui apenas 10 unidades.
Verificar a mensagem de erro.
Verificar se a falha foi registrada no log.
Exemplo de saída
========== MENU ==========
1 - Adicionar item
2 - Remover quantidade de item
3 - Atualizar item
4 - Consultar item
5 - Listar inventário
6 - Gerar relatório
7 - Popular com 10 itens de exemplo
0 - Sair
Escolha uma opção: 2

--- Remover quantidade de item ---
ID do item: 1
Quantidade a remover: 15
Erro: Estoque insuficiente.

Após esse teste, o item continua com a quantidade original, pois a operação falhou e o inventário não foi sobrescrito.

Ao listar o inventário novamente, o item ainda aparece com 10 unidades:

Item {itemID = "1", nome = "Teclado", quantidade = 10, categoria = "Periféricos"}

Esse comportamento confirma que falhas de lógica não alteram o arquivo Inventario.dat, mas são registradas no arquivo Auditoria.log.

#Cenário 3: Geração de Relatório de Erros

Objetivo: verificar se o comando de relatório exibe os registros de erro armazenados no arquivo Auditoria.log.

Passos executados
Executar o Cenário 2 para gerar uma falha de estoque insuficiente.
Escolher a opção 6 - Gerar relatório.
Verificar se o relatório exibe a falha registrada.
Exemplo de saída
========== MENU ==========
1 - Adicionar item
2 - Remover quantidade de item
3 - Atualizar item
4 - Consultar item
5 - Listar inventário
6 - Gerar relatório
7 - Popular com 10 itens de exemplo
0 - Sair
Escolha uma opção: 6

===== RELATÓRIO DE AUDITORIA =====
Total de registros no log: 12
Total de falhas: 1

----- ITENS MAIS MOVIMENTADOS -----
1: 2 operação(ões)
2: 1 operação(ões)
3: 1 operação(ões)
4: 1 operação(ões)
5: 1 operação(ões)
6: 1 operação(ões)
7: 1 operação(ões)
8: 1 operação(ões)
9: 1 operação(ões)
10: 1 operação(ões)

----- LOGS DE ERRO -----
2026-06-12 20:15:43.000000 UTC | Remove | Item: 1 | Tentativa de remover item. | Falha "Estoque insuficiente."

A data e o horário podem variar conforme o momento em que o programa for executado.

Esse teste confirma que o sistema registra operações malsucedidas no arquivo Auditoria.log e consegue gerar relatórios a partir dos registros armazenados.

## 11. Observações

O projeto foi desenvolvido com foco na separação entre funções puras e operações de entrada e saída.

A lógica principal do inventário está concentrada no módulo `InventoryLogic.hs`, enquanto a leitura e escrita de arquivos ficam no módulo `Persistence.hs`.

Dessa forma, o sistema atende aos requisitos de programação funcional, persistência em disco e registro de auditoria.

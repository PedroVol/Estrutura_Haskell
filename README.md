# Sistema de Inventário em Haskell

## 1. Informações do Trabalho

**Instituição:** [PUCPR - Pontifícia Universidade Católica do Paraná]

**Disciplina:** [Programação Lógica e Funcional]

**Professor(a):** [Frank Coelho de Alcantara]

## 2. Integrantes do Grupo

Os integrantes estão listados em ordem alfabética

| Nome do aluno | Usuário do GitHub |
| ------------- | ----------------- |
| [Pedro Muller Volpe]     | [@PedroVol]       |

## 3. Link do Ambiente de Execução

O programa pode ser executado no ambiente online abaixo:

**Link:** [Cole aqui o link do Online GDB ou Replit]

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

### Cenário 1: Persistência de Estado

1. Iniciar o programa.
2. Popular o inventário com a opção `7`.
3. Listar os itens com a opção `5`.
4. Encerrar o programa com a opção `0`.
5. Executar o programa novamente.
6. Listar os itens novamente.
7. Verificar se os itens cadastrados continuam no inventário.

### Cenário 2: Erro de Estoque Insuficiente

1. Iniciar o programa.
2. Adicionar ou usar um item já existente com determinada quantidade.
3. Tentar remover uma quantidade maior do que a disponível.
4. Verificar se o sistema exibe uma mensagem de erro.
5. Verificar se a falha foi registrada no arquivo `Auditoria.log`.

### Cenário 3: Geração de Relatório de Erros

1. Executar o Cenário 2.
2. Escolher a opção `6 - Gerar relatório`.
3. Verificar se o relatório exibe a falha relacionada à tentativa de remover estoque insuficiente.

## 11. Observações

O projeto foi desenvolvido com foco na separação entre funções puras e operações de entrada e saída.

A lógica principal do inventário está concentrada no módulo `InventoryLogic.hs`, enquanto a leitura e escrita de arquivos ficam no módulo `Persistence.hs`.

Dessa forma, o sistema atende aos requisitos de programação funcional, persistência em disco e registro de auditoria.

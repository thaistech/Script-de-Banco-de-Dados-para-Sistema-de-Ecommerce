# Ecommerce Database

Este repositório contém o modelo de banco de dados para um sistema de ecommerce, com tabelas que gerenciam clientes, pedidos, produtos, estoque, fornecedores, vendedores, pagamentos, e entregas.

## 🔑 Entidades Principais

O diagrama de relacionamento abrange as seguintes entidades:

- **Cliente**: Representa os clientes, com tipos Pessoa Física (PF) ou Pessoa Jurídica (PJ).
- **Pedido**: Registra os pedidos realizados pelos clientes.
- **Fornecedor**: Gerencia os fornecedores dos produtos.
- **Produto**: Contém os produtos disponíveis para venda.
- **Estoque**: Gerencia a quantidade de produtos em estoque.
- **Vendedor**: Representa os vendedores terceirizados que realizam as vendas.
- **Pagamento**: Define as formas de pagamento associadas aos pedidos.
- **Entrega**: Controla o status e o código de rastreio das entregas de pedidos.

## 🔄 Relacionamentos no Banco de Dados

O modelo de dados define vários relacionamentos, incluindo:

### Relacionamentos N:M (Muitos para Muitos):

- **Vendedor e Produto**: Um vendedor pode vender vários produtos e um produto pode ser vendido por vários vendedores.
- **Fornecedor e Produto**: Um fornecedor pode fornecer vários produtos e um produto pode ser fornecido por vários fornecedores.
- **Produto e Estoque**: Um produto pode estar presente em vários estoques e um estoque pode conter vários produtos.

### Relacionamentos 1:N (Um para Muitos):

- **Cliente e Pedido**: Um cliente pode realizar vários pedidos.
- **Pedido e Pagamento**: Um pedido pode ter múltiplos pagamentos (ex: parcelado).
- **Pedido e Entrega**: Um pedido pode ter múltiplas entregas (ex: entregas parciais).

## 📊 Estrutura do Banco de Dados

Cada tabela no banco de dados foi projetada para representar uma entidade, com os seguintes detalhes:

- **Chaves Primárias (PK)** e **Chaves Estrangeiras (FK)** para garantir a integridade referencial.
- **Tabelas de junção** para os relacionamentos muitos-para-muitos, como `Fornecedor_Produto`, `Vendedor_Produto` e `Produto_Estoque`.

### Tabelas Criadas:

- **Cliente**: Dados do cliente (PF ou PJ).
- **Pedido**: Informações sobre o pedido e seu status.
- **Fornecedor**: Informações do fornecedor.
- **Produto**: Dados do produto.
- **Estoque**: Informações sobre a quantidade de produtos disponíveis.
- **Vendedor**: Informações do vendedor.
- **Pagamento**: Formas de pagamento associadas ao pedido.
- **Entrega**: Status e rastreio de entrega.

## 📈 Diagrama de Entidade-Relacionamento (ER)

O diagrama ER foi criado no MySQL Workbench e visualiza todos os relacionamentos e a estrutura do banco de dados.

## ⚙️ Tecnologias Utilizadas

- **MySQL**: Para o banco de dados relacional.
- **MySQL Workbench**: Para modelagem de banco de dados e criação do diagrama ER.

## 📥 Como Usar

1. **Clonar o repositório**:
   ```bash
   git clone https://github.com/usuario/repositorio.git

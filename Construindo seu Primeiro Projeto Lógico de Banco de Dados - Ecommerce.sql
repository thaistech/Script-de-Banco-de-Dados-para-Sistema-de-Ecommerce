-- Criação do banco de dados
CREATE DATABASE ecommerce;
USE ecommerce;

-- Tabela Cliente
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(255) NOT NULL,
    tipo_cliente ENUM('PF', 'PJ') NOT NULL,
    cpf_cnpj VARCHAR(18) UNIQUE NOT NULL,  -- CPF ou CNPJ deve ser único
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    endereco VARCHAR(255) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Fornecedor
CREATE TABLE Fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome_fornecedor VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    email VARCHAR(100),
    endereco VARCHAR(255) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Produto
CREATE TABLE Produto (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome_produto VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Estoque
CREATE TABLE Estoque (
    id_estoque INT AUTO_INCREMENT PRIMARY KEY,
    nome_estoque VARCHAR(255) NOT NULL,
	estoque_minimo INT DEFAULT 0,  -- Estoque mínimo para alerta
	estoque_maximo INT DEFAULT 100,  -- Estoque máximo para alerta
    localizacao VARCHAR(255),
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela Vendedor
CREATE TABLE Vendedor (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT DEFAULT NULL,
    nome_vendedor VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(15),
    comissao DECIMAL(5, 2) NOT NULL,  -- Comissão do vendedor
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vendedor_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor) ON DELETE SET NULL
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    tipo_pagamento ENUM('Cartão de Crédito', 'Boleto', 'Pix', 'Dinheiro') NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pagamento ENUM('Pago', 'Pendente', 'Atrasado', 'Em processamento') NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE
);

-- Tabela Pedido
CREATE TABLE Pedido (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_pedido ENUM('Pendente', 'Enviado', 'Entregue', 'Cancelado') NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);

-- Tabela Entrega
CREATE TABLE Entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    codigo_rastreio VARCHAR(50),
    status_entrega ENUM('Aguardando', 'Em Transito', 'Entregue', 'Falha') NOT NULL,
    data_entrega DATETIME,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido) ON DELETE CASCADE
);

-- Tabela Fornecedor_Produto (Relacionamento N:M entre Fornecedor e Produto)
CREATE TABLE Fornecedor_Produto (
    id_fornecedor INT NOT NULL,
    id_produto INT NOT NULL,
    preco_fornecedor DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_fornecedor, id_produto),
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto) ON DELETE CASCADE
);

-- Tabela Vendedor_Produto (Relacionamento N:M entre Vendedor e Produto)
CREATE TABLE Vendedor_Produto (
    id_vendedor INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade_vendida INT NOT NULL,
    PRIMARY KEY (id_vendedor, id_produto),
    FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto) ON DELETE CASCADE
);

-- Tabela Produto_Estoque (Relacionamento N:M entre Produto e Estoque)
CREATE TABLE Produto_Estoque (
    id_produto INT NOT NULL,
    id_estoque INT NOT NULL,
    quantidade_estoque INT DEFAULT 0,
    PRIMARY KEY (id_produto, id_estoque),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto) ON DELETE CASCADE,
    FOREIGN KEY (id_estoque) REFERENCES Estoque(id_estoque) ON DELETE CASCADE
);

-- População inicial (Exemplo)
INSERT INTO Cliente (nome_cliente, tipo_cliente, cpf_cnpj, email, telefone, endereco, data_cadastro)
VALUES 
('Maria Oliveira', 'PF', '123.456.789-01', 'maria@exemplo.com', '11987654321', 'Rua A, 100', '2024-01-15 08:30:00'),
('Pedro Santos', 'PF', '987.654.321-00', 'pedro@exemplo.com', '11987654322', 'Rua B, 200', '2024-02-02 10:00:00'),
('Loja XYZ Ltda', 'PJ', '12.345.678/0001-99', 'contato@lojaxyz.com', '1134567890', 'Avenida Brasil, 300', '2024-03-10 14:45:00'),
('Ana Souza', 'PF', '111.222.333-44', 'ana@exemplo.com', '11987654323', 'Rua C, 150', '2024-04-05 09:00:00'),
('Tecno Store Ltda', 'PJ', '23.456.789/0001-88', 'vendas@tecnostore.com', '1145678901', 'Rua D, 400', '2024-05-18 13:30:00');

INSERT INTO Produto (nome_produto, descricao, preco, data_cadastro)
VALUES 
('Camiseta Básica', 'Camiseta de algodão, disponível em diversas cores', 29.90, '2024-01-16 10:30:00'),
('Tênis Esportivo', 'Tênis de corrida com tecnologia de amortecimento', 199.90, '2024-02-03 11:00:00'),
('Notebook Gamer', 'Notebook com 16GB de RAM e placa de vídeo dedicada', 3999.90, '2024-03-12 14:00:00'),
('Smartphone X', 'Smartphone com 128GB de armazenamento e câmera de 64MP', 2499.90, '2024-04-06 15:30:00'),
('Cadeira Ergonômica', 'Cadeira de escritório com ajuste de altura e apoio lombar', 499.90, '2024-05-19 17:00:00');

INSERT INTO Pedido (id_cliente, data_pedido, status_pedido, valor_total)
VALUES 
(1, '2024-06-01 08:00:00', 'Pendente', 29.90),
(2, '2024-06-02 09:30:00', 'Entregue', 199.90),
(3, '2024-06-03 10:45:00', 'Enviado', 3999.90),
(4, '2024-06-04 11:15:00', 'Entregue', 2499.90),
(5, '2024-06-05 12:00:00', 'Cancelado', 499.90);

-- Inserindo dados na tabela Estoque
INSERT INTO Estoque (nome_estoque, estoque_minimo, estoque_maximo, localizacao, data_cadastro)
VALUES 
    ('Estoque A', 10, 100, 'Local A', '2024-06-01 08:00:00'),
    ('Estoque B', 5, 50, 'Local B', '2024-06-01 09:00:00'),
    ('Estoque C', 1, 20, 'Local C', '2024-06-01 10:00:00');
    
    -- Inserir dados na tabela Produto_Estoque
INSERT INTO Produto_Estoque (id_produto, id_estoque, quantidade_estoque)
VALUES 
    (1, 1, 50),  -- Camiseta Básica no Estoque A com 50 unidades
    (1, 2, 20),  -- Camiseta Básica no Estoque B com 20 unidades
    (2, 1, 30),  -- Tênis Esportivo no Estoque A com 30 unidades
    (2, 3, 15),  -- Tênis Esportivo no Estoque C com 15 unidades
    (3, 2, 10),  -- Notebook Gamer no Estoque B com 10 unidades
    (3, 3, 5),   -- Notebook Gamer no Estoque C com 5 unidades
    (4, 1, 25),  -- Smartphone X no Estoque A com 25 unidades
    (4, 3, 30),  -- Smartphone X no Estoque C com 30 unidades
    (5, 2, 40);  -- Cadeira Ergonômica no Estoque B com 40 unidades

-- Inserindo dados na tabela Fornecedor
INSERT INTO Fornecedor (nome_fornecedor, cnpj, telefone, email, endereco, data_cadastro)
VALUES 
    ('Fornecedor A', '12.345.678/0001-99', '11987654321', 'contato@fornecedorA.com', 'Rua A, 100', '2024-01-15 08:30:00'),
    ('Fornecedor B', '98.765.432/0001-88', '11987654322', 'contato@fornecedorB.com', 'Rua B, 200', '2024-02-02 10:00:00'),
    ('Fornecedor C', '23.456.789/0001-77', '11987654323', 'contato@fornecedorC.com', 'Avenida Brasil, 300', '2024-03-10 14:45:00');
    
    -- Inserir um novo fornecedor (Fornecedor D)
INSERT INTO Fornecedor (nome_fornecedor, cnpj, telefone, email, endereco, data_cadastro)
VALUES 
    ('Fornecedor D', '45.678.910/0001-11', '11987654324', 'contato@fornecedorD.com', 'Rua D, 500', '2024-06-01 09:00:00');
    
-- Relacionando Fornecedores com Produtos
INSERT INTO Fornecedor_Produto (id_fornecedor, id_produto, preco_fornecedor)
VALUES 
    (1, 1, 25.00),  -- Fornecedor A fornece Camiseta Básica
    (1, 2, 180.00), -- Fornecedor A fornece Tênis Esportivo
    (2, 3, 3800.00), -- Fornecedor B fornece Notebook Gamer
    (3, 4, 2400.00), -- Fornecedor C fornece Smartphone X
    (4, 5, 450.00);  -- Fornecedor D fornece Cadeira Ergonômica
    
    -- Inserir um Vendedor que também é Fornecedor
INSERT INTO Vendedor (nome_vendedor, email, telefone, comissao, id_fornecedor, data_cadastro)
VALUES 
    ('Carlos Souza', 'carlos@vendedor.com', '11987654321', 10.00, 1, '2024-06-15 09:00:00'); -- Carlos também é fornecedor (id_fornecedor = 1)

-- Inserir um Vendedor que NÃO é Fornecedor
INSERT INTO Vendedor (nome_vendedor, email, telefone, comissao, id_fornecedor, data_cadastro)
VALUES 
    ('Lucas Lima', 'lucas@vendedor.com', '11987654322', 12.00, NULL, '2024-06-16 10:00:00'); -- Lucas não é fornecedor (id_fornecedor = NULL)

-- Inserir produto que foi vendido por um vendedor que não é fornecedor
INSERT INTO Vendedor_Produto (id_vendedor, id_produto, quantidade_vendida)
VALUES 
    (1, 1, 10); -- Vendedor 1 vendeu 10 camisetas

-- Fim do script


show tables;
desc vendedor;
select * from vendedor;


-- Contagem de pedidos feitos por cada cliente
select c.id_cliente, c.nome_cliente, count(p.id_pedido) as total_pedidos
from Cliente c
left join Pedido p on c.id_cliente = p.id_pedido
group by c.id_cliente
order by total_pedidos desc;

-- Verificando se algum vendedor também é fornecedor
select v.id_vendedor, v.nome_vendedor, f.id_fornecedor, f.nome_fornecedor
from Vendedor v
left join Fornecedor f on v.id_vendedor = f.id_fornecedor
where v.id_fornecedor is not null;

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT f.nome_fornecedor, p.nome_produto
FROM Fornecedor f
INNER JOIN Fornecedor_Produto fp ON f.id_fornecedor = fp.id_fornecedor
INNER JOIN Produto p ON fp.id_produto = p.id_produto
ORDER BY f.nome_fornecedor, p.nome_produto;

-- Relação de produtos, fornecedores e quantidade de estoque
SELECT 
    p.id_produto, 
    p.nome_produto, 
    f.id_fornecedor, 
    f.nome_fornecedor, 
    e.id_estoque, 
    e.nome_estoque, 
    pe.quantidade_estoque
FROM Produto p
INNER JOIN Fornecedor_Produto fp ON p.id_produto = fp.id_produto  -- Relacionando produto e fornecedor
INNER JOIN Fornecedor f ON fp.id_fornecedor = f.id_fornecedor  -- Obtendo dados do fornecedor
INNER JOIN Produto_Estoque pe ON p.id_produto = pe.id_produto  -- Relacionando produto com estoque
INNER JOIN Estoque e ON pe.id_estoque = e.id_estoque  -- Obtendo dados do estoque
ORDER BY f.nome_fornecedor, p.nome_produto, e.nome_estoque;


-- Selecionando dados simples da tabela Cliente
SELECT id_cliente, nome_cliente, email
FROM Cliente
WHERE tipo_cliente = 'PF';  -- Seleciona apenas clientes Pessoa Física

-- Concatenando o nome do cliente com o tipo de cliente
SELECT id_cliente, CONCAT(nome_cliente, ' - ', tipo_cliente) AS cliente_info
FROM Cliente;

-- Usando alias para renomear a coluna
SELECT id_cliente, nome_cliente AS nome_do_cliente
FROM Cliente;

-- Relacionando Cliente e Pedido com INNER JOIN
SELECT c.id_cliente, c.nome_cliente, p.id_pedido, p.data_pedido, p.status_pedido
FROM Cliente c
INNER JOIN Pedido p ON c.id_cliente = p.id_cliente
ORDER BY p.data_pedido DESC;

-- Usando LEFT JOIN para pegar todos os clientes, mesmo os que não têm pedidos
SELECT c.id_cliente, c.nome_cliente, p.id_pedido
FROM Cliente c
LEFT JOIN Pedido p ON c.id_cliente = p.id_cliente
ORDER BY c.nome_cliente;

-- Filtrando clientes que fizeram mais de 2 pedidos
SELECT c.id_cliente, c.nome_cliente, COUNT(p.id_pedido) AS total_pedidos
FROM Cliente c
LEFT JOIN Pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente
HAVING total_pedidos > 2
ORDER BY total_pedidos DESC;

-- Ordenando os pedidos por data de pedido
SELECT p.id_pedido, c.id_cliente, p.data_pedido, p.status_pedido
FROM Pedido p
LEFT JOIN Cliente c ON p.id_cliente = c.id_cliente
ORDER BY data_pedido ASC;

-- Relacionando Produtos e Fornecedores com INNER JOIN
SELECT p.id_produto, p.nome_produto, f.id_fornecedor, f.nome_fornecedor
FROM Produto p
INNER JOIN Fornecedor_Produto fp ON p.id_produto = fp.id_produto
INNER JOIN Fornecedor f ON fp.id_fornecedor = f.id_fornecedor;

-- Concatenando produto e fornecedor
SELECT p.id_produto, CONCAT(p.nome_produto, ' - ', f.nome_fornecedor) AS produto_fornecedor
FROM Produto p
INNER JOIN Fornecedor_Produto fp ON p.id_produto = fp.id_produto
INNER JOIN Fornecedor f ON fp.id_fornecedor = f.id_fornecedor;

-- Contagem de produtos vendidos por cada vendedor
SELECT v.id_vendedor, v.nome_vendedor, COUNT(pv.id_produto) AS total_produtos_vendidos
FROM Vendedor v
INNER JOIN Vendedor_Produto pv ON v.id_vendedor = pv.id_vendedor
GROUP BY v.id_vendedor
ORDER BY total_produtos_vendidos DESC;

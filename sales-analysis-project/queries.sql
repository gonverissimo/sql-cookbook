CREATE DATABASE Analise_Vendas;

SHOW DATABASES;

SHOW TABLES;


CREATE TABLE Produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    preco DECIMAL(10,2) NOT NULL,
    stock_atual INT NOT NULL
);


CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100),
    estado VARCHAR(50)
);

CREATE TABLE Pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);


CREATE TABLE Itens_Pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_produto INT,
    valor_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produtos(id_produto)
);


INSERT INTO Produtos (nome, categoria, preco, stock_atual) VALUES
('Teclado Mecânico RGB', 'Periféricos', 89.99, 40),
('Rato Sem Fios', 'Periféricos', 49.99, 30),
('Monitor LED 27”', 'Monitores', 229.99, 15),
('Portátil Dell XPS 13', 'Computadores', 1299.99, 8),
('Cadeira Gaming', 'Mobiliário', 299.99, 12),
('Disco SSD 512GB', 'Armazenamento', 99.99, 25),
('Impressora Multifuncional', 'Periféricos', 149.99, 10),
('Coluna Bluetooth JBL', 'Áudio', 79.99, 20),
('Smartwatch Samsung', 'Gadgets', 199.99, 18),
('Tablet Lenovo 10”', 'Tablets', 249.99, 14);


INSERT INTO Clientes (nome, cidade, estado) VALUES
('João Silva', 'Lisboa', 'Lisboa'),
('Diogo Cruz', 'Porto', 'Porto'),
('Carlos Santos', 'Braga', 'Braga'),
('Ana Costa', 'Coimbra', 'Coimbra'),
('Rui Pereira', 'Faro', 'Faro'),
('Sofia Almeida', 'Aveiro', 'Aveiro'),
('Pedro Matos', 'Guimarães', 'Braga'),
('Gonçalo Veríssimo', 'Setúbal', 'Setúbal'),
('Tiago Moreira', 'Évora', 'Évora'),
('Patrícia Rocha', 'Viseu', 'Viseu');


INSERT INTO Pedidos (id_cliente, data_pedido, valor_total) VALUES
(1, '2025-03-10', 139.98),
(2, '2025-03-11', 299.99),
(3, '2025-03-12', 229.99),
(4, '2025-03-13', 1299.99),
(5, '2025-03-14', 99.99),
(6, '2025-03-15', 49.99),
(7, '2025-03-16', 199.99),
(8, '2025-03-17', 249.99),
(9, '2025-03-18', 79.99),
(10, '2025-03-19', 149.99);


INSERT INTO Itens_Pedido (id_pedido, id_produto, valor_unitario) VALUES
(1, 1, 89.99),
(1, 2, 49.99),
(2, 5, 299.99),
(3, 3, 229.99),
(4, 4, 1299.99),
(5, 6, 99.99),
(6, 2, 49.99),
(7, 9, 199.99),
(8, 10, 249.99),
(9, 8, 79.99),
(10, 7, 149.99);


SELECT * FROM Produtos;
SELECT * FROM Clientes;
SELECT * FROM Pedidos;
SELECT * FROM Itens_Pedido;


-- Valor Total das Vendas em Euros (€) por Dia
SELECT data_pedido, SUM(valor_total) AS total_vendas
FROM Pedidos
GROUP BY data_pedido
ORDER BY data_pedido;


-- Produtos Mais Vendidos
SELECT p.nome, SUM(ip.valor_unitario) AS soma_valor_unitario
FROM Itens_Pedido ip
JOIN Produtos p ON ip.id_produto = p.id_produto
GROUP BY p.nome;


-- Percentagem do Valor Total em Euros (€) por Categoria 
SELECT 
    p.categoria, 
    (SUM(i.valor_unitario) / (SELECT SUM(valor_unitario) FROM itens_pedido)) * 100 AS percentagem_receita
FROM itens_pedido i
JOIN produtos p ON i.id_produto = p.id_produto
GROUP BY p.categoria
ORDER BY percentagem_receita DESC;


-- Clientes que Mais Compraram
SELECT C.nome, SUM(P.valor_total) AS total_gasto
FROM Pedidos P
JOIN Clientes C ON P.id_cliente = C.id_cliente
GROUP BY C.nome
ORDER BY total_gasto DESC
LIMIT 5;


-- Previsão de Ruptura de Stock (Produtos com menos de 20 unidades)
SELECT nome, stock_atual
FROM Produtos
WHERE stock_atual < 20
ORDER BY stock_atual ASC;
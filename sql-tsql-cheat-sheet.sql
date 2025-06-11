-- ==============================================================
-- RESUMO SQL / T-SQL - Fundamentos e Funcionalidades Importantes
-- ==============================================================
-- Este ficheiro apresenta os principais comandos, conceitos e exemplos
-- para uso prático em SQL Server (T-SQL) e bases de dados relacionais.

-- 1. LINGUAGENS SQL
-- -----------------
-- DDL (Data Definition Language): Define e altera a estrutura da BD
--   CREATE, ALTER, DROP, TRUNCATE, RENAME
-- DML (Data Manipulation Language): Manipula os dados
--   SELECT, INSERT, UPDATE, DELETE, MERGE
-- DCL (Data Control Language): Controla permissões
--   GRANT, REVOKE
-- TCL (Transaction Control Language): Controla transações
--   BEGIN TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT


-- 2. CRIAÇÃO E ALTERAÇÃO DE OBJETOS
-- ----------------------------------
-- Criar tabela:
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE,
    Idade INT,
    DataRegisto DATETIME DEFAULT GETDATE()
);

-- Alterar tabela (adicionar coluna):
ALTER TABLE Clientes
ADD Telefone NVARCHAR(20);

-- Apagar tabela:
DROP TABLE Clientes;

-- Truncar tabela (apaga dados, mantém estrutura):
TRUNCATE TABLE Clientes;

-- Renomear tabela (SQL Server 2016+):
EXEC sp_rename 'Clientes', 'Clientes_Ativos';


-- 3. TIPOS DE DADOS COMUNS
-- -------------------------
-- INT, BIGINT, SMALLINT, TINYINT (números inteiros)
-- DECIMAL(p,s), NUMERIC(p,s) (números decimais com precisão)
-- FLOAT, REAL (ponto flutuante)
-- CHAR(n), VARCHAR(n), NVARCHAR(n) (texto)
-- DATETIME, DATE, TIME, DATETIME2, SMALLDATETIME (datas e horas)
-- BIT (booleano 0/1)
-- UNIQUEIDENTIFIER (GUID)


-- 4. CONSULTAS BÁSICAS (SELECT)
-- -----------------------------
-- Selecionar tudo:
SELECT * FROM Clientes;

-- Selecionar colunas específicas:
SELECT Nome, Email FROM Clientes;

-- Filtros com WHERE:
SELECT * FROM Clientes WHERE Idade >= 18;

-- Ordenar resultados:
SELECT * FROM Clientes ORDER BY Nome ASC, Idade DESC;

-- Limitar resultados (TOP N):
SELECT TOP 10 * FROM Clientes ORDER BY DataRegisto DESC;

-- Distintos:
SELECT DISTINCT Idade FROM Clientes;


-- 5. INSERIR, ATUALIZAR E APAGAR DADOS
-- ------------------------------------
-- Inserir uma linha:
INSERT INTO Clientes (Nome, Email, Idade) VALUES ('Ana', 'ana@mail.com', 30);

-- Inserir múltiplas linhas:
INSERT INTO Clientes (Nome, Email, Idade) VALUES
('Pedro', 'pedro@mail.com', 25),
('Maria', 'maria@mail.com', 28);

-- Atualizar dados:
UPDATE Clientes SET Idade = Idade + 1 WHERE Nome = 'Ana';

-- Apagar dados:
DELETE FROM Clientes WHERE Idade < 18;


-- 6. JOINS (Junções)
-- -------------------
-- Usado para combinar dados de duas ou mais tabelas relacionadas

-- INNER JOIN: só registos que existem em ambas as tabelas
SELECT c.Nome, p.PedidoID, p.DataPedido
FROM Clientes c
INNER JOIN Pedidos p ON c.ClienteID = p.ClienteID;

-- LEFT JOIN: todos da esquerda + correspondentes da direita (NULL se não houver)
SELECT c.Nome, p.PedidoID
FROM Clientes c
LEFT JOIN Pedidos p ON c.ClienteID = p.ClienteID;

-- RIGHT JOIN: todos da direita + correspondentes da esquerda
SELECT c.Nome, p.PedidoID
FROM Clientes c
RIGHT JOIN Pedidos p ON c.ClienteID = p.ClienteID;

-- FULL OUTER JOIN: todos os registos de ambas as tabelas
SELECT c.Nome, p.PedidoID
FROM Clientes c
FULL OUTER JOIN Pedidos p ON c.ClienteID = p.ClienteID;

-- CROSS JOIN: produto cartesiano (todas as combinações possíveis)
SELECT c.Nome, p.PedidoID
FROM Clientes c
CROSS JOIN Pedidos p;


-- 7. SUBCONSULTAS (Subqueries)
-- ----------------------------
-- Consulta dentro de outra consulta

-- Exemplo: Clientes com idade maior que a média
SELECT Nome, Idade
FROM Clientes
WHERE Idade > (SELECT AVG(Idade) FROM Clientes);

-- Subconsulta no FROM (tabela derivada)
SELECT AvgAge
FROM (SELECT AVG(Idade) AS AvgAge FROM Clientes) AS Sub;

-- Subconsulta correlacionada (dependente da linha da query externa)
SELECT Nome,
       (SELECT COUNT(*) FROM Pedidos p WHERE p.ClienteID = c.ClienteID) AS TotalPedidos
FROM Clientes c;


-- 8. FUNÇÕES DE AGREGAÇÃO E AGRUPAMENTO
-- -------------------------------------
-- SUM, COUNT, AVG, MIN, MAX
SELECT COUNT(*) AS TotalClientes FROM Clientes;

SELECT Idade, COUNT(*) AS NumClientes
FROM Clientes
GROUP BY Idade
HAVING COUNT(*) > 1;  -- Filtrar grupos


-- 9. EXPRESSÕES CONDICIONAIS
-- --------------------------
-- CASE - similar a if-then-else
SELECT Nome,
       CASE
           WHEN Idade < 18 THEN 'Menor de idade'
           WHEN Idade BETWEEN 18 AND 65 THEN 'Adulto'
           ELSE 'Idoso'
       END AS FaixaEtaria
FROM Clientes;


-- 10. TRANSAÇÕES
-- ---------------
-- Permitem garantir atomicidade (tudo ou nada) numa sequência de comandos

BEGIN TRANSACTION;

UPDATE Clientes SET Idade = Idade + 1 WHERE Nome = 'Ana';

-- Confirmar alterações
COMMIT;

-- Reverter alterações
-- ROLLBACK;


-- 11. ÍNDICES
-- -------------
-- Melhoram o desempenho da pesquisa e ordenação

-- Criar índice clustered (organiza fisicamente os dados)
CREATE CLUSTERED INDEX idx_ClienteID ON Clientes(ClienteID);

-- Criar índice não-clustered
CREATE NONCLUSTERED INDEX idx_Nome ON Clientes(Nome);

-- Apagar índice
DROP INDEX idx_Nome ON Clientes;


-- 12. VIEWS (Vistas)
-- ------------------
-- Tabelas virtuais baseadas numa consulta
CREATE VIEW vw_ClientesAdultos AS
SELECT * FROM Clientes WHERE Idade >= 18;

-- Usar a view
SELECT * FROM vw_ClientesAdultos;

-- Atualizar uma view simples
CREATE OR ALTER VIEW vw_ClientesAtivos AS
SELECT ClienteID, Nome, Email FROM Clientes WHERE DataRegisto > '2024-01-01';


-- 13. STORED PROCEDURES (Procedimentos Armazenados)
-- ---------------------------------------------------
-- Blocos de código SQL pré-definidos para reuso

-- Criar procedimento
CREATE PROCEDURE sp_GetClientesAdultos
AS
BEGIN
    SELECT * FROM Clientes WHERE Idade >= 18;
END;
GO

-- Executar procedimento
EXEC sp_GetClientesAdultos;

-- Procedimento com parâmetros
CREATE PROCEDURE sp_GetClientePorID
    @ClienteID INT
AS
BEGIN
    SELECT * FROM Clientes WHERE ClienteID = @ClienteID;
END;
GO

EXEC sp_GetClientePorID 5;


-- 14. FUNÇÕES DEFINIDAS PELO UTILIZADOR
-- -------------------------------------
-- Função escalares (retornam valor único)
CREATE FUNCTION fn_GetIdadeMedia()
RETURNS FLOAT
AS
BEGIN
    DECLARE @media FLOAT;
    SELECT @media = AVG(CAST(Idade AS FLOAT)) FROM Clientes;
    RETURN @media;
END;
GO

-- Usar função
SELECT dbo.fn_GetIdadeMedia() AS IdadeMedia;


-- 15. TRIGGERS (Gatilhos)
-- ------------------------
-- Código executado automaticamente em resposta a eventos DML (INSERT, UPDATE, DELETE)

CREATE TRIGGER trg_AposInsertCliente
ON Clientes
AFTER INSERT
AS
BEGIN
    PRINT 'Novo cliente inserido';
    -- Exemplo: inserir log, validações, notificações
END;
GO


-- 16. CURSORES
-- -------------
-- Permitem iterar linha a linha sobre um conjunto de resultados (usar com moderação)

DECLARE cursor_clientes CURSOR FOR
SELECT ClienteID, Nome FROM Clientes WHERE Idade >= 18;

DECLARE @ClienteID INT, @Nome NVARCHAR(100);

OPEN cursor_clientes;
FETCH NEXT FROM cursor_clientes INTO @ClienteID, @Nome;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Cliente: ' + @Nome;
    FETCH NEXT FROM cursor_clientes INTO @ClienteID, @Nome;
END;

CLOSE cursor_clientes;
DEALLOCATE cursor_clientes;


-- 17. VARIÁVEIS E CONTROLO DE FLUXO
-- ---------------------------------
-- Declarar variável
DECLARE @contador INT = 0;

-- WHILE loop
WHILE @contador < 5
BEGIN
    PRINT 'Contador = ' + CAST(@contador AS NVARCHAR(10));
    SET @contador = @contador + 1;
END;

-- IF ELSE
DECLARE @idade INT = 20;
IF @idade >= 18
    PRINT 'Maior de idade';
ELSE
    PRINT 'Menor de idade';


-- 18. TABELAS TEMPORÁRIAS
-- -----------------------
-- Tabelas temporárias locais (existem só na sessão)
CREATE TABLE #TempClientes (
    ClienteID INT,
    Nome NVARCHAR(100)
);

INSERT INTO #TempClientes VALUES (1, 'João'), (2, 'Maria');

SELECT * FROM #TempClientes;

DROP TABLE #TempClientes;


-- 19. WINDOW FUNCTIONS
-- --------------------
-- Funções que operam numa janela de linhas para cálculo avançado

-- Exemplo: calcular média móvel, ranking

SELECT ClienteID, Nome, Idade,
       ROW_NUMBER() OVER (ORDER BY Idade DESC) AS Ranking,
       AVG(Idade) OVER () AS MediaIdade,
       SUM(Idade) OVER (PARTITION BY Idade) AS SomaIdadesMesmaFaixa
FROM Clientes;


-- 20. MERGE
-- ---------
-- Comando para inserir, atualizar ou apagar dados numa tabela alvo conforme tabela fonte

MERGE Clientes AS alvo
USING (SELECT ClienteID, Nome FROM ClientesTemp) AS fonte
ON alvo.ClienteID = fonte.ClienteID
WHEN MATCHED THEN
    UPDATE SET Nome = fonte.Nome
WHEN NOT MATCHED BY TARGET THEN
    INSERT (Nome) VALUES (fonte.Nome)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


-- 21. CONTROL DE PERMISSÕES
-- -------------------------
-- Conceder e revogar permissões

GRANT SELECT ON Clientes TO UtilizadorX;
REVOKE SELECT ON Clientes FROM UtilizadorX;


-- 22. CONFIGURAÇÕES E UTILITÁRIOS
-- ------------------------------
-- Exemplo: SET NOCOUNT para evitar mensagens de "x linhas afetadas"
SET NOCOUNT ON;

-- Obter a versão do SQL Server
SELECT @@VERSION;


-- ==============================
-- DICAS E NOTAS IMPORTANTES
-- ==============================
-- - Usar parâmetros em stored procedures para evitar SQL Injection
-- - Evitar cursores sempre que possível, prefira operações em conjunto
-- - Utilizar índices para melhorar desempenho, mas não em excesso
-- - Transações garantem atomicidade e integridade dos dados
-- - Views simplificam consultas complexas e promovem reutilização
-- - Funções escalares devem ser usadas com cuidado para não prejudicar desempenho
-- - Triggers são úteis para auditoria, validação e automatizações
-- - Window functions são poderosas para análises avançadas
-- - MERGE facilita sincronização de dados entre tabelas
-- - Sempre testar scripts em ambiente de desenvolvimento antes de produção
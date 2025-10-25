-- 1º Criar a database
CREATE DATABASE bomgosto;

-- 2º Crias as Tabelas
-- Cria a tabela Comanda
CREATE TABLE Comanda (
   id_comanda INT PRIMARY KEY,
   data DATE NOT NULL,
   numero_mesa INT NOT NULL,
   nome_cliente VARCHAR(100) NOT NULL
);

-- Cria a tabela Cardapio
CREATE TABLE Cardapio (
   id_cardapio INT PRIMARY KEY NOT NULL,
   nome_item VARCHAR(100) UNIQUE NOT NULL,
   descricao  VARCHAR(255),
   preco_unitario DECIMAL (10, 2) NOT NULL
);

-- Cria a tabela dos itens da Comanda
CREATE TABLE Item_Comanda(
   id_comanda INT NOT NULL,
   id_cardapio INT NOT NULL,
   quantidade INT NOT NULL,
   FOREIGN KEY(id_comanda) REFERENCES Comanda(id_comanda),
   FOREIGN KEY(id_cardapio) REFERENCES Cardapio(id_cardapio)
);

-- Verifica como estão as tabelas(uma de cada vez)
SELECT * FROM comanda
SELECT * FROM cardapio
SELECT * FROM item_comanda

-- 3º Populando as tabelas
-- Comanda
INSERT INTO comanda 
VALUES	(10, '2025-10-04', 1, 'Arthur Morgan'),
		(20, '2025-10-04', 1, 'Joel Miller'),
		(30, '2025-10-04', 2, 'Aloy'),
		(40, '2025-10-04', 3, 'Sonic'),
		(50, '2025-10-04', 3, 'Cloud Strife')


-- Cardapio
INSERT INTO cardapio (id_cardapio, nome_item, descricao, preco_unitario)
VALUES 	(1, 'Torrada', 'Mortadela e queijo', 12.00),
		(2, 'Coxinha', 'Frango', 10.00),
		(3, 'Café Americano', 'Expresso com água', 7.00),
		(4, 'Café Irish', 'Espuma de leite, whiskey, expresso', 10.00),
		(5, 'Pão de Queijo', 'Muito queijo', 5.00),
		(6, 'Bolo', 'Chocolate amargo', 10.00),
		(7, 'Cookie', 'Gotas de chocolate', 2.00),
		(8, 'Petit Gateau', 'Chocolate', 9.00),
		(9, 'Brigadeiro', 'Meio Amargo', 4.00),
		(10, 'Chocolate Quente', 'Quentinho', 8.00)

-- Itens da Comanda
INSERT INTO item_comanda(id_comanda, id_cardapio, quantidade)
VALUES (10, 1, 2),
	   (10, 3, 1),
	   (20, 2, 1),
	   (30, 4, 3),
	   (40, 6, 1),
	   (30, 4, 1)


-- EXERCICIOS
-- 1) Faça uma listagem do cardápio ordenada por nome;
SELECT * FROM cardapio ORDER BY nome_item DESC

-- 2) Apresente todas as comandas (código, data, mesa e nome do cliente) 
-- e os itens da comanda (código comanda, nome do café, descricão, quantidade, preço unitário e preço total do café) 
-- destas ordenados data e código da comanda e, também o nome do café;
SELECT
    c.id_comanda,
    TO_CHAR(data, 'DD/MM/YYYY') AS data,
    c.numero_mesa,
    c.nome_cliente,
    i.id_comanda AS comanda_item,
    ca.nome_item,
    ca.descricao,
    i.quantidade,
    ca.preco_unitario,
    (i.quantidade * ca.preco_unitario) AS preco_total
FROM comanda c, item_comanda i, cardapio ca
WHERE c.id_comanda = i.id_comanda
AND i.id_cardapio = ca.id_cardapio
ORDER BY c.data, c.id_comanda, ca.nome_item;

--3) Liste todas as comandas (código, data, mesa e nome do cliente) mais uma coluna com o valor total da comanda. 
--Ordene por data esta listagem;
SELECT
    c.id_comanda,
    TO_CHAR(data, 'DD/MM/YYYY') AS data,
    c.numero_mesa,
    c.nome_cliente,
    SUM(i.quantidade * ca.preco_unitario) AS total_comanda
FROM comanda c, item_comanda i, cardapio ca
where c.id_comanda = i.id_comanda
and i.id_cardapio = ca.id_cardapio
GROUP BY c.id_comanda, c.data, c.numero_mesa, c.nome_cliente
ORDER BY c.data;

--4) Faça a mesma listagem das comandas da questão anterior (6), 
--mas traga apenas as comandas que possuem mais do que um tipo de café na comanda;
SELECT
    c.id_comanda,
     TO_CHAR(data, 'DD/MM/YYYY') AS data,
    c.numero_mesa,
    c.nome_cliente,
    SUM(i.quantidade * ca.preco_unitario) AS total_comanda
FROM comanda c, item_comanda i, cardapio ca
where c.id_comanda = i.id_comanda
and i.id_cardapio = ca.id_cardapio
GROUP BY c.id_comanda, c.data, c.numero_mesa, c.nome_cliente
HAVING COUNT(DISTINCT i.id_cardapio) > 1
ORDER BY c.data;

--5) Qual o total de faturamento por data? ordene por data esta consulta.
SELECT
     TO_CHAR(data, 'DD/MM/YYYY') AS data,
    SUM(i.quantidade * ca.preco_unitario) AS total_faturamento
FROM comanda c, item_comanda i, cardapio ca
where c.id_comanda = i.id_comanda
and i.id_cardapio = ca.id_cardapio
GROUP BY c.data
ORDER BY c.data;




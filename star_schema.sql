create database star;

use star;

CREATE TABLE dim_cliente (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome_cliente VARCHAR(150),
    email_cliente VARCHAR(200)
);

CREATE TABLE dim_prato (
    prato_id INT AUTO_INCREMENT PRIMARY KEY,
    nome_prato VARCHAR(100),
    tipo_prato VARCHAR(50),
    preco_unitario_prato DECIMAL(10, 2)
);

CREATE TABLE dim_data (
    data_id INT AUTO_INCREMENT PRIMARY KEY,
    ano INT,
    mes INT,
    dia INT,
    dia_semana VARCHAR(100)
);



CREATE TABLE fato_pedido (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    prato_id INT,
    data_id INT,
    quantidade INT,
    valor_unitario_prato DECIMAL(10, 2),
    valor_total_pedido DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES dim_cliente(cliente_id),
    FOREIGN KEY (prato_id) REFERENCES dim_prato(prato_id),
    FOREIGN KEY (data_id) REFERENCES dim_data(data_id)
);

-- Dimensão Cliente
INSERT INTO dim_cliente (nome_cliente, email_cliente) VALUES
('João Silva', 'joao.silva@example.com'),
('Maria Oliveira', 'maria.oliveira@example.com'),
('Carlos Souza', 'carlos.souza@example.com');

-- Dimensão Prato
INSERT INTO dim_prato (nome_prato, tipo_prato, preco_unitario_prato) VALUES
('Bife à Parmegiana', 'Prato Principal', 25.00),
('Salada Caesar', 'Entrada', 15.00),
('Sorvete de Chocolate', 'Sobremesa', 10.00);

-- Dimensão Data
INSERT INTO dim_data (ano, mes, dia, dia_semana) VALUES
(2024, 1, 1, 'Segunda-feira'),
(2024, 1, 2, 'Terça-feira'),
(2024, 1, 3, 'Quarta-feira');

-- Tabela de Fatos
INSERT INTO fato_pedido (cliente_id, prato_id, data_id, quantidade, valor_unitario_prato, valor_total_pedido) VALUES
(1, 1, 1, 2, 25.00, 50.00),  -- João Silva pediu 2 Bifes à Parmegiana no dia 2024-01-01
(2, 2, 2, 1, 15.00, 15.00); -- Maria Oliveira pediu 



SELECT
    c.nome_cliente,
    d.ano,
    SUM(f.valor_total_pedido) AS total_gasto
FROM
    fato_pedido f
JOIN
    dim_cliente c ON f.cliente_id = c.cliente_id
JOIN
    dim_data d ON f.data_id = d.data_id
WHERE
    d.ano = 2024
GROUP BY
    c.nome_cliente, d.ano;

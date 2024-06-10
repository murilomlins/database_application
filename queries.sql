SELECT 
    ano,
    id_cliente,
    nome_cliente,
    total_pedidos
FROM (
    SELECT 
        YEAR(m.data_hora_entrada) AS ano,
        c.id_cliente,
        c.nome_cliente,
        COUNT(p.codigo_prato) AS total_pedidos,
        ROW_NUMBER() OVER (PARTITION BY YEAR(m.data_hora_entrada) ORDER BY COUNT(p.codigo_prato) DESC) AS row_num
    FROM 
        tb_cliente c
    JOIN 
        tb_mesa m ON c.id_cliente = m.id_cliente
    JOIN 
        tb_pedido p ON m.codigo_mesa = p.codigo_mesa
    GROUP BY 
        YEAR(m.data_hora_entrada),
        c.id_cliente,
        c.nome_cliente
) AS ranked
WHERE 
    row_num = 1;
    
    -- 2
    
    SELECT 
    c.id_cliente,
    c.nome_cliente,
    SUM(p.quantidade_pedido * pr.preco_unitario_prato) AS total_gasto
FROM 
    tb_cliente c
JOIN 
    tb_mesa m ON c.id_cliente = m.id_cliente
JOIN 
    tb_pedido p ON m.codigo_mesa = p.codigo_mesa
JOIN 
    tb_prato pr ON p.codigo_prato = pr.codigo_prato
GROUP BY 
    c.id_cliente,
    c.nome_cliente
ORDER BY 
    total_gasto DESC
LIMIT 1;

-- 3 
WITH TotalPessoasPorAno AS (
    SELECT
        YEAR(m.data_hora_entrada) AS ano,
        c.id_cliente,
        c.nome_cliente,
        SUM(m.num_pessoa_mesa) AS total_pessoas
    FROM
        tb_cliente c
    JOIN
        tb_mesa m ON c.id_cliente = m.id_cliente
    GROUP BY
        YEAR(m.data_hora_entrada),
        c.id_cliente,
        c.nome_cliente
),
RankedClientes AS (
    SELECT
        ano,
        id_cliente,
        nome_cliente,
        total_pessoas,
        ROW_NUMBER() OVER (PARTITION BY ano ORDER BY total_pessoas DESC) AS row_num
    FROM
        TotalPessoasPorAno
)
SELECT
    ano,
    id_cliente,
    nome_cliente,
    total_pessoas
FROM
    RankedClientes
WHERE
    row_num = 1;

-- 4

SELECT 
    e.nome_empresa,
    COUNT(c.id_cliente) AS total_clientes
FROM 
    tb_cliente c
JOIN 
    tb_beneficio b ON c.email_cliente = b.email_funcionario
JOIN 
    tb_empresa e ON b.codigo_empresa = e.codigo_empresa
GROUP BY 
    e.nome_empresa
ORDER BY 
    total_clientes DESC
LIMIT 1;

-- 5

SELECT
    e.nome_empresa,
    YEAR(m.data_hora_entrada) AS ano,
    COUNT(DISTINCT c.id_cliente) AS total_clientes
FROM
    tb_cliente c
JOIN
    tb_beneficio b ON c.email_cliente = b.email_funcionario
JOIN
    tb_empresa e ON b.codigo_empresa = e.codigo_empresa
JOIN
    tb_mesa m ON c.id_cliente = m.id_cliente
JOIN
    tb_pedido p ON m.codigo_mesa = p.codigo_mesa
JOIN
    tb_prato pr ON p.codigo_prato = pr.codigo_prato
JOIN
    tb_tipo_prato tp ON pr.codigo_tipo_prato = tp.codigo_tipo_prato
WHERE
    tp.nome_tipo_prato = 'Sobremesa'
GROUP BY
    e.nome_empresa,
    YEAR(m.data_hora_entrada)
ORDER BY
    total_clientes DESC
    limit 1;

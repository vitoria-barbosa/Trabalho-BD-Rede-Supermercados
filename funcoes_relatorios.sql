CREATE OR REPLACE FUNCTION FOLHA_DE_PAGAMENTO(F_ID_MERCADO INT) 
RETURNS TABLE (
	id_mercado int,
	id_func int,
	nome_func varchar,
	id_cargo int,
	nome_cargo varchar,
	salario numeric
) AS $$
BEGIN
	PERFORM VALIDAR_ID('mercado', 'id_mercado', F_ID_MERCADO);
	
	RETURN QUERY 
	SELECT F.ID_MERC, F.ID_FUNC, F.NOME, F.ID_CARGO, C.NOME, C.SALARIO 
	FROM FUNCIONARIO F INNER JOIN CARGO C ON
	F.ID_CARGO = C.ID_CARGO 
	WHERE F.ID_MERC = F_ID_MERCADO AND F.ATIVO = TRUE;
END;
$$ LANGUAGE PLPGSQL;


----------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION ESTOQUE_COMPLETO(F_ID_MERCADO INT) 
RETURNS TABLE (
	id_mercado int,
	id_produto int,
	nome_prod varchar,
	descricao varchar,
	valor numeric,
	qtd_estoque int,
	id_marca int,
	marca varchar,
	id_cat int,
	nome_cat varchar
) AS $$
BEGIN
	PERFORM VALIDAR_ID('mercado', 'id_mercado', F_ID_MERCADO);

	RETURN QUERY
	SELECT E.ID_MERC, E.ID_PROD, P.NOME, P.DESCRICAO, P.VALOR, E.QTD_ESTOQUE, P.ID_MARCA, M.NOME, P.ID_CAT, C.NOME
	FROM ESTOQUE E INNER JOIN PRODUTO P ON E.ID_PROD = P.ID_PROD 
	LEFT JOIN MARCA M ON P.ID_MARCA = M.ID_MARCA
	LEFT JOIN CATEGORIA C ON P.ID_CAT = C.ID_CAT 
	WHERE E.ID_MERC = F_ID_MERCADO AND P.ATIVO = TRUE;
END;
$$ LANGUAGE PLPGSQL;


----------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION VENDA_COMPLETA(F_ID_VENDA INT)
RETURNS TABLE (
	id_mercado int,
	id_venda int,
	id_cliente int,
	nome_cliente varchar,
	id_func int,
	nome_func varchar,
	forma_pag varchar,
	id_prod int,
	nome_prod varchar,
	valor_prod numeric,
	qtd_vendida int,
	valor_total_item numeric,
	valor_total_compra numeric
) AS $$
BEGIN
	PERFORM VALIDAR_ID('venda', 'id_venda', F_ID_VENDA);
	
	RETURN QUERY
	SELECT E.ID_MERC, V.ID_VENDA, V.ID_CLI, C.NOME, V.ID_FUNC, F.NOME, PG.NOME, E.ID_PROD, P.NOME, P.VALOR,
	IV.QTD_VENDIDA, IV.VALOR_TOTAL_ITEM, V.VALOR_TOTAL
	FROM ITEM_VENDA IV RIGHT JOIN VENDA V ON IV.ID_VENDA = V.ID_VENDA 
	LEFT JOIN CLIENTE C ON V.ID_CLI = C.ID_CLI
	LEFT JOIN FUNCIONARIO F ON V.ID_FUNC = F.ID_FUNC
	LEFT JOIN PAGAMENTO PG ON V.ID_PAG = PG.ID_PAG
	LEFT JOIN ESTOQUE E ON IV.ID_ESTOQUE = E.ID_ESTOQUE
	LEFT JOIN PRODUTO P ON E.ID_PROD = P.ID_PROD
	WHERE V.ID_VENDA = F_ID_VENDA;
END;
$$ LANGUAGE PLPGSQL;


----------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION LISTAR_PRODUTOS_PELA_CATEGORIA(F_ID_MERCADO INT, F_NOME_CATEGORIA VARCHAR)
RETURNS TABLE (
	id_mercado int,
	id_produto int,
	nome_prod varchar,
	descricao varchar,
	valor numeric,
	qtd_estoque int,
	id_marca int,
	marca varchar,
	id_cat int,
	nome_cat varchar
) AS $$
DECLARE 
	F_CATEGORIA VARCHAR;
BEGIN
	SELECT F_NOME_CAT INTO F_CATEGORIA FROM BUSCAR_PELO_NOME(F_NOME_CATEGORIA, 'CATEGORIA') 
	AS (ID_CAT INT, F_NOME_CAT VARCHAR, ATIVO BOOLEAN);
	
	RETURN QUERY
	SELECT * FROM ESTOQUE_COMPLETO(F_ID_MERCADO) EC WHERE EC.NOME_CAT = F_CATEGORIA;
END;
$$ LANGUAGE PLPGSQL;


SELECT * FROM VENDA_COMPLETA(1);
SELECT * FROM FOLHA_DE_PAGAMENTO(1);
SELECT * FROM ESTOQUE_COMPLETO(1);
SELECT * FROM LISTAR_PRODUTOS_PELA_CATEGORIA(1, 'ALIMENTOS');
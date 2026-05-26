CREATE OR REPLACE FUNCTION CADASTRAR_CAT(NOME VARCHAR) RETURNS VOID AS $$
BEGIN
	INSERT INTO CATEGORIA VALUES(DEFAULT, NOME);
		RAISE NOTICE 'Categoria cadastrada com sucesso!';
	EXCEPTION
		WHEN OTHERS THEN
			RAISE NOTICE 'ERRO: Não foi possível cadastrar a categoria de nome %', NOME;
END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION ATUALIZAR_CAT(C_NOME VARCHAR, C_ID INT) RETURNS VOID AS $$
BEGIN
	IF EXISTS (SELECT ID_CAT FROM CATEGORIA WHERE ID_CAT = C_ID) THEN
		UPDATE CATEGORIA SET NOME = C_NOME WHERE ID_CAT = C_ID; 
		RAISE NOTICE 'Categoria atualizada com sucesso!';
	ELSE
		RAISE EXCEPTION 'Não existe categoria com esse ID';
	END IF;
	EXCEPTION
		WHEN SQLSTATE '22001' THEN
			RAISE NOTICE 'ERRO: O nome fornecido excede a quantidade máxima de caracteres permitidos.';
END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION ATUALIZAR_CAT(C_NOME VARCHAR, C_NOVO_NOME VARCHAR) RETURNS VOID AS $$
DECLARE
	C_ID INT;
BEGIN
	SELECT ID_CAT INTO C_ID FROM BUSCAR_PELO_NOME(C_NOME, 'categoria') AS (ID_CAT INT, NOME VARCHAR);
		UPDATE CATEGORIA SET NOME = C_NOVO_NOME WHERE ID_CAT = C_ID; 
		RAISE NOTICE 'Categoria atualizada com sucesso!';
	EXCEPTION
		WHEN SQLSTATE '22001' THEN
			RAISE NOTICE 'ERRO: O nome fornecido excede a quantidade máxima de caracteres permitidos.';
END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION EXCLUIR_CAT(ID INT) RETURNS VOID AS $$
BEGIN
	IF EXISTS (SELECT ID_CAT FROM CATEGORIA WHERE ID_CAT = ID) THEN
		DELETE FROM CATEGORIA WHERE ID_CAT = ID; 
		RAISE NOTICE 'Categoria excluída com sucesso!';
	ELSE
		RAISE EXCEPTION 'Não existe categoria com esse ID';
	END IF;
		-- Fazer: quando houver erro de integridade na tabela produto e mudar para nulo a categoria dos produtos antes de excluir
		-- ou fazer a validação antes de excluir e lançar o erro. 
END;
$$ LANGUAGE PLPGSQL;

SELECT CADASTRAR_CAT('Limpeza');
SELECT CADASTRAR_CAT('Padaria');

SELECT ATUALIZAR_CAT('Higiene', 3);
SELECT ATUALIZAR_CAT('Padaria', 'Padaria e frios');

SELECT EXCLUIR_CAT(4);

SELECT * FROM CATEGORIA;
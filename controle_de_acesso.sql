CREATE ROLE caixa;
CREATE ROLE estoquista;
CREATE ROLE gerente;

GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO gerente;
GRANT DELETE ON TABLE venda, item_venda TO gerente;

GRANT SELECT ON TABLE produto, categoria, marca, estoque, funcionario TO caixa;
GRANT SELECT, INSERT, UPDATE ON TABLE venda, item_venda, pagamento, cliente TO caixa;

GRANT SELECT, INSERT, UPDATE ON TABLE estoque, produto, categoria, marca TO estoquista;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO gerente, caixa, estoquista;
-- permissão de sequences é necessário para o auto-incremento dos IDs em INSERTs:
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO gerente, caixa, estoquista;

CREATE USER vitoria PASSWORD 'vitoria123';
CREATE USER kamila PASSWORD 'kamila123';
CREATE USER maria PASSWORD 'maria123';

GRANT ESTOQUISTA TO VITORIA;
GRANT CAIXA TO KAMILA;
GRANT GERENTE TO MARIA;
--Este comando cria o usuario
CREATE USER gustavo_gazzinelli WITH PASSWORD 'raiz'
CREATEDB 
CREATEROLE;

--Este comando cria o banco de dados uvv
CREATE DATABASE uvv
OWNER gustavo_gazzinelli
TEMPLATE template0
ENCODING 'UTF-8'
LC_COLLATE 'pt_BR.UTF-8'
LC_CTYPE 'pt_BR.UTF-8'
ALLOW_CONNECTIONS true;

--comando de conexão ao banco de dados
\c uvv gustavo_gazzinelli 

--Este comando cria o schema "lojas"
CREATE SCHEMA lojas;
ALTER USER gustavo_gazzinelli
SET SEARCH_PATH TO lojas, "$user", public;

--Comando para criar a tabela cliente
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT clientes_id PRIMARY KEY (cliente_id)
);

--Comando para comentar a tabela e as colunas
COMMENT ON TABLE lojas.clientes IS 'tabela dos clientes da loja';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'chave primaria da tabela clientes';
COMMENT ON COLUMN lojas.clientes.email IS 'informa o e-mail dos clientes';
COMMENT ON COLUMN lojas.clientes.nome IS 'informa o nome do cliente';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'informa o telefone do cliente';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'informa o telefone do cliente';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'informa o telefone do cliente';

--Comando para criar a tabela produtos
CREATE TABLE lojas.produtos (
                produto_id NUMERIC NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA NOT NULL,
                imagem BYTEA NOT NULL,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);

--Comando para não permitir valores negativos na coluna quantidade
ALTER TABLE lojas.produtos
ADD CONSTRAINT preco_unitario_positivo_produtos CHECK (preco_unitario >= 0);

--Comando para comentar a tabela e as colunas
COMMENT ON TABLE lojas.produtos IS 'tabela dos produtos da loja';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'chave primaria da tabela produtos';
COMMENT ON COLUMN lojas.produtos.nome IS 'informa o nome do produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'informa o preço unitario do produto';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'informa os detalhes do produto';
COMMENT ON COLUMN lojas.produtos.imagem IS 'uma imagem do produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'informa o tipo d midia da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'informa o arquivo da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'informa o parametro da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'informa a ultima vez q a imagem foi atualizada';


CREATE SEQUENCE lojas.lojas_loja_id_seq;

--Comando para criar a tabela lojas
CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL DEFAULT nextval('lojas.lojas_loja_id_seq'),
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC NOT NULL,
                longitude NUMERIC NOT NULL,
                logo BYTEA NOT NULL,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);

--Comando para comentar a tabela e as colunas
COMMENT ON TABLE lojas.lojas IS 'tabela das lojas da loja';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'chave primaria da tabela lojas';
COMMENT ON COLUMN lojas.lojas.nome IS 'informa o nome da loja';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'informa o endereço eb da loja';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'informa a localização fiica da loja';
COMMENT ON COLUMN lojas.lojas.latitude IS 'informa a latitude exata da loja';
COMMENT ON COLUMN lojas.lojas.longitude IS 'informa a longitude exata da loja';
COMMENT ON COLUMN lojas.lojas.logo IS 'a logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'informa o tipo de midia da logo';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'informa o arquivo da logo';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'informa o parametro da logo';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'informa a ultima vez q a logo foi atualizada';


ALTER SEQUENCE lojas.lojas_loja_id_seq OWNED BY lojas.lojas.loja_id;

--Comando para criar a tabela pedidos
CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                status VARCHAR(15) NOT NULL,
                fk_loja_pedidos NUMERIC(38) NOT NULL,
                fk_cliente_pedidos NUMERIC(38) NOT NULL,
                CONSTRAINT pedido_id PRIMARY KEY (pedido_id)
);

--Comando que limita oque pode ser escrito na coluna status
ALTER TABLE lojas.pedidos
ADD CONSTRAINT chk_envio CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

--Comando para comentar a tabela e as colunas
COMMENT ON TABLE lojas.pedidos IS 'tabela dos pedidos da loja';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'chave primaria da tabela pedidos';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'informa a hora que foi feito o pedido';
COMMENT ON COLUMN lojas.pedidos.status IS 'informa o estado atual do pedido se ja foi entregue entre outros';
COMMENT ON COLUMN lojas.pedidos.fk_loja_pedidos IS 'chave estrangeira da tabela pedidos em relação a tabela lojas';
COMMENT ON COLUMN lojas.pedidos.fk_cliente_pedidos IS 'chave estrangeira da tabela pedidos em relação a tabela clientes';

--Comando para criar a tabela envio
CREATE TABLE lojas.envio (
                envio_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                fk_loja_envio NUMERIC(38) NOT NULL,
                fk_cliente_envio NUMERIC(38) NOT NULL,
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
);

--Comando que limita oque pode ser escrito na coluna status
ALTER TABLE lojas.envio 
ADD CONSTRAINT chk_envio CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));

--Comando para comentar a tabela e as colunas
COMMENT ON TABLE lojas.envio IS 'tabela dos envios feitos pela loja';
COMMENT ON COLUMN lojas.envio.envio_id IS 'chave primaria  da tabela envio';
COMMENT ON COLUMN lojas.envio.endereco_entrega IS 'informa o endereço da entrega';
COMMENT ON COLUMN lojas.envio.status IS 'informa qual status do envio se ja chegou entre outros';
COMMENT ON COLUMN lojas.envio.fk_loja_envio IS 'chave estrangeira da tabela envio em relação a tabela lojas';
COMMENT ON COLUMN lojas.envio.fk_cliente_envio IS 'chave estrangeira da tabela envio em relação a clientes';

--Comando para criar a tabela pedidos_itens
CREATE TABLE lojas.pedidos_itens (
                pedido_id_pfk NUMERIC(38) NOT NULL,
                produto_id_pfk NUMERIC NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                fk_envio_pedidos_itens NUMERIC(38) NOT NULL,
                CONSTRAINT pitens_id PRIMARY KEY (pedido_id_pfk, produto_id_pfk)
);

--Comando para não permitir valores negativos na coluna quantidade
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT quantidade_positivo_pedidos_itens CHECK (quantidade >=0);

--Comando para não permitir valores negativos na coluna preco_unitario
ALTER TABLE lojas.pedidos_itens
ADD CONSTRAINT preco_unitario_positivo_pedidos_itens CHECK (quantidade >=0);

--Comando para comentar a tabela e as colunas
COMMENT ON TABLE lojas.pedidos_itens IS 'tabela dos itens que foram pedidos a loja';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id_pfk IS 'chave estrangeira primaria da tabela pedidos_itens';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id_pfk IS 'chave estrangeira primaria a tabela pedidos_itens';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'informa o numero da linha do item pedido';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'informa o preço unitario do item pedido';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'informa quantos desse item foram pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.fk_envio_pedidos_itens IS 'chave estrangeira da tabela pedidos_itens em relação a tabela envio';

--Comando para criar a tabela estoque
CREATE TABLE lojas.estoque (
                estoque_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                fk_produto_estoque NUMERIC NOT NULL,
                fk_loja_estoque NUMERIC(38) NOT NULL,
                CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);

--Comando para não permitir valores negativos na coluna quantidade
ALTER TABLE lojas.estoque
ADD CONSTRAINT quantidade_positivo_estoque CHECK (quantidade >=0);

--Comando para comentar a tabela e as colunas
COMMENT ON TABLE lojas.estoque IS 'tabela do estoque da loja';
COMMENT ON COLUMN lojas.estoque.estoque_id IS 'chave primaria da tabela estoque';
COMMENT ON COLUMN lojas.estoque.quantidade IS 'informa quantos itens tem no estoque';
COMMENT ON COLUMN lojas.estoque.fk_produto_estoque IS 'chave estrangeira da tabela estoque em relação a tabela produtos';
COMMENT ON COLUMN lojas.estoque.fk_loja_estoque IS 'chave estrangeira da tabela estoque em relação a tabela lojas';


--Comando ue cria chave estrangeira 
ALTER TABLE lojas.pedidos ADD CONSTRAINT tabela_clientes_tabela_pedidos_fk
FOREIGN KEY (fk_cliente_pedidos)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Comando ue cria chave estrangeira 
ALTER TABLE lojas.envio ADD CONSTRAINT tabela_clientes_tabela_envio_fk
FOREIGN KEY (fk_cliente_envio)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Comando ue cria chave estrangeira 
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT tabela_produtos_tabela_pedidos_itens_fk
FOREIGN KEY (produto_id_pfk)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Comando ue cria chave estrangeira 
ALTER TABLE lojas.estoque ADD CONSTRAINT tabela_produtos_estoque_fk
FOREIGN KEY (fk_produto_estoque)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Comando ue cria chave estrangeira 
ALTER TABLE lojas.estoque ADD CONSTRAINT tabela_lojas_estoque_fk
FOREIGN KEY (fk_loja_estoque)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Comando ue cria chave estrangeira 
ALTER TABLE lojas.envio ADD CONSTRAINT tabela_lojas_tabela_envio_fk
FOREIGN KEY (fk_loja_envio)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Comando ue cria chave estrangeira 
ALTER TABLE lojas.pedidos ADD CONSTRAINT tabela_lojas_tabela_pedidos_fk
FOREIGN KEY (fk_loja_pedidos)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Comando ue cria chave estrangeira 
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT tabela_pedidos_tabela_pedidos_itens_fk
FOREIGN KEY (pedido_id_pfk)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Comando ue cria chave estrangeira 
ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT tabela_envio_tabela_pedidos_itens_fk
FOREIGN KEY (fk_envio_pedidos_itens)
REFERENCES lojas.envio (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

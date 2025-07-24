-- CRIAÇÃO DO BANCO DE DADOS PARA O CENÁRIO DE E-COMMERCE
create database ecommerce;
SHOW TABLES;
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;
SELECT * FROM clients;
SELECT * FROM orders;
SELECT * FROM payments;
SELECT * FROM product;
SELECT * FROM seller;
SELECT * FROM productOrder;
SELECT * FROM productStorage;
-- (adicione todas as tabelas que você tiver)
-- com JOIN para ver dados conectados:
SELECT 
    c.idClient, c.Fname, c.Lname, 
    o.idOrder, o.orderStatus, o.orderDescription, 
    p.typePayment, p.amountPaid, p.paymentStatus
FROM clients c
JOIN orders o ON c.idClient = o.idClient
JOIN payments p ON o.idOrder = p.idOrder;

-- cliente->produto->pedido
-- criar tabela cliente
-- desc clients; dá a estrutura da tabela u seja, ele te diz quais colunas existem na tabela clients,
-- qual o tipo de dado de cada coluna, se aceita NULL, se tem DEFAULT, se é PRIMARY KEY etc.
-- select * from '' consultaos dados
-- fk : chave estrangeira ou foreing key- ligação entre duas tabelas
select * from clients;
desc clients;
desc orders;
desc product;
desc productstorage;
desc seller;
SELECT idClient FROM clients;

create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char (3),
    Lname varchar (20),
    CPF char (11) not null,
    Address varchar (30),
    constraint unique_cpf_clients unique (CPF)
);
-- criar tabela produto(size= dimensão do produto)
desc product;
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(10) not null,
    classification_kids bool default false,
    category enum('eletrônico','vestimenta','brinquedo','alimento', 'móveis') not null,
	avaliação float default 0,
    size varchar(10)
);
-- criar tabela pagamentos
desc orders;
show tables;
select * from orders;

create table orders (
	idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    orderStatus ENUM('cancelado', 'confirmado', 'em processamento') DEFAULT 'em processamento',
    orderDescription varchar(255),
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOL DEFAULT FALSE,
    CONSTRAINT fk_ordes_client FOREIGN KEY (idClient) REFERENCES clients (idClient)
);
desc payments;
create table payments(
	id_payment INT AUTO_INCREMENT PRIMARY KEY,
	idClient int,
    idOrder INT,
    typePayment ENUM('à vista pix','à vista espécie', 'crédito', 'débito', 'boleto') NOT NULL,
    amountPaid DECIMAL(10,2) NOT NULL,
    limitAvailable DECIMAL (10,2),
    paymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    paymentStatus ENUM ('PAGO','PENDENTE','FALHOU') DEFAULT 'PENDENTE',
    transactionCode VARCHAR(50),
    installments INT DEFAULT 1,
    constraint fk_payments_client foreign key (idClient) references clients (idClient),
    CONSTRAINT fk_payments_order FOREIGN KEY (idOrder) REFERENCES orders (idOrder)
);

-- criar tabela pedido
-- criar tabela de estoque
create table productStorage (
	idProductStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 10
);
--  criar tabela fornecedor
desc supplier;
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char (11) not null,
    constraint unique_supplier unique  (cnpj)
);
-- criar tabela de vendedor
desc seller;
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9) default null,
    location varchar(255),
    contact char (11) not null,
    constraint unique_CNPJ_seller unique  (CNPJ),
	constraint unique_CPF_seller unique  (CPF)
);
-- chave primaria tem uma chave estrangeira quando essa tabela depende de outra pre-existente
-- produto_vendedor
desc productSeller;
create table productSeller(
	idPseller int,
    idproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idproduct) references product(idproduct)
);
create table productOrder(
	idProduct int,
    idOrder int,
    poQuantity int default 1,
    poStatus enum ('disponível','sem estoque') default 'disponível',
    primary key (idProduct, idOrder),
    constraint fk_productorder_product foreign key (idProduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idOrder) references orders (idOrder)
);
desc storageLocation;
create table storageLocation(
	idProduct int,
    idProductStorage int,
    location varchar (255) not null,
    primary key (idProduct, idProductStorage),
    constraint fk_storage_location_product foreign key (idProduct) references product (idproduct),
    constraint fk_storage_location_storage foreign key (idProductStorage) references productStorage (idProductStorage)
);
show tables;
create table productSupplier(
	idSupplier int,
    idProduct int,
    quantity int not null,
    primary key (idSupplier, idProduct),
    constraint fk_product_supplier_supplier foreign key (idSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idProduct) references product (idProduct)
);
desc clients;
SELECT * FROM clients;

select * from clients;
alter table clients auto_increment=1;
-- drop table clients; 
-- codigo abaixo adiciona dados novos sem precisar alterar o antigo ja que daria duplicidade de querie unique
INSERT IGNORE INTO clients (Fname, Minit, Lname, CPF, Address)
VALUES ('Jeca', 'J.', 'Vieira','67854390281','Rua da lua, 67'),
('Silvio','S.', 'Santos','33333389721','Av. Jequiti, 01');
-- codigo abaixo serve para contar a quantidade de idclients 
SELECT COUNT(idClient) AS total_clientes
FROM clients;
-- o codigo abaixo apaga id especifico 
DELETE FROM clients
WHERE idClient IN (129, 127);
INSERT INTO clients (Fname, Minit, Lname, CPF, Address) VALUES  ('Lucas', 'M.', 'Silva', '12345878601', 'Rua das Flores, 45'),
('Ana', 'B.', 'Costa', '23406784012', 'Av. Brasil, 102'),
('Carlos', 'L.', 'Santos', '34567800123', 'Rua João Paulo, 33'),
('Mariana', 'R.', 'Almeida', '45678901234', 'Rua do Sol, 99'),
('Paulo', 'J.', 'Oliveira', '56789012345', 'Rua Verde, 18'),
('Fernanda', 'T.', 'Souza', '67890123456', 'Av. Central, 76'),
('Juliana', 'K.', 'Nascimento', '78901234567', 'Rua Pérola, 222'),
('Eduardo', 'S.', 'Barros', '89012345678', 'Rua Vitória, 39'),
('Gabriela', 'F.', 'Lima', '90123456789', 'Rua Alegria, 88'),
('Thiago', 'A.', 'Ferreira', '01234567890', 'Av. Nova, 147'),
('Beatriz', 'V.', 'Melo', '10987654321', 'Travessa das Acácias, 17'),
('Ricardo', 'C.', 'Gomes', '21987654321', 'Rua das Laranjeiras, 19'),
('Camila', 'D.', 'Martins', '32987654321', 'Av. das Rosas, 13'),
('Rafael', 'E.', 'Pereira', '43987654321', 'Rua Bela Vista, 61'),
('Larissa', 'G.', 'Teixeira', '54987654321', 'Alameda Marfim, 11');
-- para contar a quantidade de clientes
SELECT COUNT(*) AS total_clientes
FROM clients;
select * from product;
INSERT INTO product (Pname, classification_kids, category, avaliação, size) VALUES
('TV LG 32"', false, 'eletrônico', 4.5, '32pol'),
('Camiseta Algodão', false, 'vestimenta', 4.8, 'M'),
('Boneca Elsa', true, 'brinquedo', 4.2, '30cm'),
('Sofá Retrátil', false, 'móveis', 4.0, '3m'),
('Biscoito Recheado', false, 'alimento', 3.9, '500g'),
('Notebook Dell', false, 'eletrônico', 4.7, '15.6pol'),
('Carrinho Controle', true, 'brinquedo', 4.3, '40cm'),
('Mesa de Jantar', false, 'móveis', 4.1, '1.5m'),
('Arroz Integral', false, 'alimento', 4.0, '1kg'),
('Smartphone Samsung', false, 'eletrônico', 4.6, '6.1pol'),
('Tênis Esportivo', false, 'vestimenta', 4.4, '42'),
('Quebra-cabeça 1000pçs', true, 'brinquedo', 4.5, '40x60cm'),
('Estante de Livros', false, 'móveis', 4.2, '2m'),
('Suco de Uva', false, 'alimento', 3.8, '1L'),
('Jaqueta Jeans', false, 'vestimenta', 4.7, 'G'),
('Bola de Futebol', true, 'brinquedo', 4.3, '70cm'),
('Geladeira Brastemp', false, 'eletrodoméstico', 4.6, '400L');
select * from productStorage;
INSERT INTO productStorage (storageLocation, quantity) VALUES
('Depósito Central', 100),
('Filial Recife', 50),
('Filial SP', 75),
('Filial RJ', 60),
('Depósito Sul', 40),
('Depósito Norte', 80),
('Filial BH', 55),
('Filial Porto Alegre', 70),
('Filial Salvador', 30),
('Filial Fortaleza', 45),
('Filial Curitiba', 35),
('Depósito Leste', 90),
('Depósito Oeste', 85),
('Filial Manaus', 20),
('Filial Natal', 25),
('Filial Goiânia', 50),
('Filial Brasília', 65);
select * from seller;
desc supplier;
select * from supplier;

INSERT INTO supplier (socialName, CNPJ, contact) VALUES
('Distribuidora Central LTDA', '11822333444475', '81999998888'),
('Fornecedora Brasil', '22333444855666', '81988887777'),
('Super Distribuição', '33445566878800', '81977776655'),
('Distribuidora Sul', '44556677809911', '81966665544'),
('Fornecedora Norte', '55667788980022', '81955554433'),
('Distribuidora Nordeste', '66776899001133', '81944443322'),
('Central Fornecedora', '77889903112244', '81933332211'),
('Fornecedora Express', '88990013223355', '81922221100'),
('Distribuidora VIP', '99001122304466', '81911110099'),
('Mega Fornecedores', '00112233495577', '81900009988'),
('Express Fornecedores', '11223360556688', '81899998877'),
('Distribuidora Alpha', '22334050667799', '81888887766'),
('Beta Fornecedora', '33045566770810', '81877776655'),
('Gama Distribuidora', '40556677089921', '81866665544'),
('Delta Fornecedora', '55667788950030', '81855554433'),
('Épsilon Distribuição', '66708859001143', '81844443322'),
('Zeta Fornecedora', '77889990116254', '81833332211');
desc seller;
SELECT * FROM seller ;

INSERT INTO seller (SocialName, AbstName, CNPJ, CPF, location, contact) VALUES
('Loja TopTech', 'TopTech', '33445566778890', NULL, 'Shopping Recife', '81977776666'),
('Vendas Rápidas LTDA', NULL, NULL, '45600012314', 'Centro São Paulo', '11988889999'),
('Eletrônicos Brasil', 'EletrBrasil', '44556677889900', NULL, 'Shopping RJ', '2133334444'),
('Moda Total', NULL, NULL, '78945612305', 'Shopping BH', '3195556666'),
('Brinquedos & Cia', 'BrinqCia', '55667788990021', NULL, 'Shopping Fortaleza', '8533322110'),
('Móveis Lar', NULL, NULL, '12378945613', 'Centro Curitiba', '4131122334'),
('Casa & Cia LTDA', 'CasaCia', '66778899001122', NULL, 'Shopping Porto Alegre', '5132211445'),
('TecnoFácil', NULL, NULL, '98765432100', 'Centro Manaus', '9233344556'),
('Loja Central', 'Central', '77889900112233', NULL, 'Shopping Natal', '8433355778'),
('Fast Shop', NULL, NULL, '45612378900', 'Shopping Goiânia', '6233344556'),
('MegaStore', 'Mega', '88990011223344', NULL, 'Centro Brasília', '6133344556'),
('Loja Nova', NULL, NULL, '32165498700', 'Shopping Salvador', '7133344556'),
('TechPoint', 'TechP', '99001122334455', NULL, 'Shopping SP', '1195556677'),
('Fashion House', NULL, NULL, '85296374100', 'Centro RJ', '2135556677'),
('Auto Peças', 'AutoP', '11223344556677', NULL, 'Shopping BH', '3196667788'),
('Supermercado Fácil', NULL, NULL, '14725836900', 'Shopping Recife', '8196667788'),
('Loja Digital', 'LojaD', '22334455667788', NULL, 'Centro São Paulo', '1196667788');
select * from supplier;
select * from orders;

INSERT INTO orders (idClient, idOrder, orderStatus, orderDescription, sendValue, paymentCash) VALUES
(2, 86,'confirmado', 'Compra de TV LG', 50.00, TRUE),
(3, 87 , 'em processamento', 'Compra de camiseta e boneca', 20.00, FALSE),
(128, 88, 'enviado', 'Compra de sofá', 100.00, TRUE),
(130, 89 ,  'cancelado', 'Compra de geladeira', 200.00, FALSE),
(131, 90 ,'confirmado', 'Compra de smartphone', 75.00, TRUE),
(132, 91 , 'em processamento', 'Compra de livro', 10.00, TRUE),
(133, 92 ,'entregue', 'Compra de tênis', 40.00, TRUE),
(134, 93 , 'confirmado', 'Compra de mochila', 30.00, FALSE),
(135, 94 , 'em processamento', 'Compra de brinquedo', 25.00, TRUE),
(136, 95 ,'entregue', 'Compra de relógio', 60.00, TRUE),
(137, 96 , 'confirmado', 'Compra de fone de ouvido', 45.00, FALSE),
(138, 97 ,'enviado', 'Compra de impressora', 120.00, TRUE),
(139, 98 ,'confirmado', 'Compra de câmera', 150.00, TRUE),
(140, 99 ,'em processamento', 'Compra de cadeira', 85.00, FALSE),
(141, 100 ,'entregue', 'Compra de teclado', 35.00, TRUE),
(193, 101 ,'cancelado', 'Compra de mouse', 20.00, FALSE),
(194, 102 ,'confirmado', 'Compra de monitor', 90.00, TRUE);
-- ver o idorders que existem
-- SELECT idOrder FROM orders;
-- ver o idclients que existem
-- SELECT idClient FROM clients;
select * from payments;

select * from orders;
INSERT INTO payments (idClient,idOrder, typePayment, amountPaid, limitAvailable, transactionCode, installments, paymentStatus) VALUES
(2, 86, 'crédito', 1800.00, 5000.00, 'TRX123456', 3, 'PAGO'),
(3, 87 ,  'débito', 150.00, 800.00, 'TRX654321', 1, 'PENDENTE'),
(128, 88 , 'boleto', 1200.00, 3000.00, 'TRX111222', 1, 'PAGO'),
(130, 89 , 'pix', 2200.00, 4000.00, 'TRX333444', 1, 'PENDENTE'),
(131, 90 , 'crédito', 900.00, 3500.00, 'TRX555666', 2, 'PAGO'),
(132, 91 , 'débito', 75.00, 1000.00, 'TRX777888', 1, 'PAGO'),
(133, 92 , 'pix', 200.00, 1500.00, 'TRX999000', 1, 'PAGO'),
(134, 93 , 'crédito', 300.00, 2000.00, 'TRX112233', 3, 'PENDENTE'),
(135, 94 , 'boleto', 120.00, 700.00, 'TRX445566', 1, 'PAGO'),
(136, 95 , 'débito', 60.00, 900.00, 'TRX778899', 1, 'PAGO'),
(137, 96 , 'crédito', 450.00, 2500.00, 'TRX000111', 1, 'PAGO'),
(138, 97 , 'pix', 1300.00, 3200.00, 'TRX222333', 1, 'PENDENTE'),
(139, 98 , 'débito', 1500.00, 3800.00, 'TRX444555', 2, 'PAGO'),
(140, 99 , 'crédito', 850.00, 2700.00, 'TRX666777', 1, 'PENDENTE'),
(141, 100 , 'boleto', 350.00, 1100.00, 'TRX888999', 1, 'PAGO'),
(193, 101 , 'pix', 200.00, 800.00, 'TRX101010', 1, 'CANCELADO'),
(194, 102 , 'crédito', 900.00, 2900.00, 'TRX121212', 2, 'PAGO');
select * from idProduct;
select * from productOrder;

INSERT INTO productOrder (idProduct, idOrder, poQuantity, poStatus) VALUES
(1, 86 , 1, 'disponível'),
(2, 87 , 1, 'disponível'),
(3, 88 , 1, 'disponível'),
(4, 89 , 2, 'disponível'),
(5, 90 , 1, 'pendente'),
(6, 91 , 3, 'disponível'),
(7, 92 , 1, 'disponível'),
(8, 93 , 1, 'pendente'),
(9, 94 , 2, 'disponível'),
(10, 95 , 1, 'disponível'),
(11, 96 , 1, 'disponível'),
(12, 97 , 4, 'disponível'),
(13, 98 , 1, 'pendente'),
(14, 99 , 2, 'disponível'),
(15, 100 , 1, 'disponível'),
(16, 101 , 1, 'pendente'),
(17, 102 , 1, 'disponível');


-- Criação do BD
create database ecommerce;

-- Usando o BD
use ecommerce;

-- =============== --
-- CRIANDO TABELAS --
-- =============== --
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(255),
    constraint unique_cpf_client unique (CPF)
);

alter table clients auto_increment=1;

-- Criar tabela Produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(255) not null,
	classification_kids bool default false,
    category enum('Eletrônico', 'Vestimenta','Brinquedos','Alimentos','Móveis') not null,
    avaliação float default 0,
    size varchar(10)
);

alter table product auto_increment=1;

-- termine de implementar a tabela e crie a conexao com as tabelas necessarias, 
-- alem disso reflita essas modificacoes no diagrama do schema relacional
-- criar constraints relacionadas ao pagamento
create table payments(
	idClient int,
    idPayment int,
    typePayment enum('Boleto','Cartao','Dois cartões'),
    limitAvailable float,
    primary key(idClient, idPayment)
);

create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false, 
    constraint fk_ordes_client foreign key (idOrderClient) references clients(idClient)
			on update cascade
);
alter table orders auto_increment=1;

create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

alter table productStorage auto_increment=1;

create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

alter table supplier auto_increment=1;

create table seller(
	idSeller int auto_increment primary key,
	SocialName varchar(255) not null,
    AbstName varchar(255),
	CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique(CNPJ),
    constraint unique_cpf_seller unique(CPF)
);

alter table seller auto_increment=1;

create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

-- ================= --
-- INSERÇÃO DE DADOS --
-- ================= --
insert into Clients (Fname, Minit, Lname, CPF, Address) values
	('Maria','M','Silva', 12346789, 'rua silva de prata 29, Carangola - Cidade das flores'),
	('Matheus','O','Pimentel', 987654321,'rua alemeda 289, Centro - Cidade das flores'),
	('Ricardo','F','Silva', 45678913,'avenida alemeda vinha 1009, Centro - Cidade das flores'),
	('Julia','S','França', 789123456,'rua lareijras 861, Centro - Cidade das flores'),
	('Roberta','G','Assis', 98745631,'avenidade koller 19, Centro - Cidade das flores'),
	('Isabela','M','Cruz', 654789123,'rua alemeda das flores 28, Centro - Cidade das flores');

-- idProduct, Pname, classification_kids boolean, category('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis'), avaliação, size
insert into product (Pname, classification_kids, category, avaliação, size) values
	('Fone de ouvido',false,'Eletrônico','4',null),
	('Barbie Elsa',true,'Brinquedos','3',null),
	('Body Carters',true,'Vestimenta','5',null),
	('Microfone Vedo - Youtuber',False,'Eletrônico','4',null),
	('Sofá retrátil',False,'Móveis','3','3x57x80'),
	('Farinha de arroz',False,'Alimentos','2',null),
	('Fire Stick Amazon',False,'Eletrônico','3',null);

-- idOrder, idOrderClient, orderStatus, orderDescription, sendValue, paymentCash
insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values 
	(1,default,'compra via aplicativo',null,1),
	(2,default,'compra via aplicativo',50,0),
	(3,'Confirmado',null,null,1),
	(4,default,'compra via web site',150,0);

-- idPOproduct, idPOorder, poQuantity, poStatus
insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values
	(1,1,2,null),
	(2,1,1,null),
	(3,2,1,null);

-- storageLocation,quantity
insert into productStorage (storageLocation,quantity) values 
	('Rio de Janeiro',1000),
	('Rio de Janeiro',500),
	('São Paulo',10),
	('São Paulo',100),
	('São Paulo',10),
	('Brasília',60);

-- idLproduct, idLstorage, location
insert into storageLocation (idLproduct, idLstorage, location) values
	(1,2,'RJ'),
	(2,6,'GO');

-- idSupplier, SocialName, CNPJ, contact
insert into supplier (SocialName, CNPJ, contact) values 
	('Almeida e filhos', 123456789123456,'21985474'),
	('Eletrônicos Silva',854519649143457,'21985484'),
	('Eletrônicos Valma', 934567893934695,'21975474');
                            
-- idPsSupplier, idPsProduct, quantity
insert into productSupplier (idPsSupplier, idPsProduct, quantity) values
	(1,1,500),
	(1,2,400),
	(2,4,633),
	(3,3,5),
	(2,5,10);

-- idSeller, SocialName, AbstName, CNPJ, CPF, location, contact
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values 
	('Tech eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
	('Botique Durgas',null,null,123456783,'Rio de Janeiro', 219567895),
	('Kids World',null,456789123654485,null,'São Paulo', 1198657484);

-- idPseller, idPproduct, prodQuantity
insert into productSeller (idPseller, idPproduct, prodQuantity) values 
	(1,6,80),
	(2,7,10);

-- ================== --
-- QUERIES DO DESAFIO --
-- ================== --

-- selecionar todos os clientes
select * from clients;

-- selecionar um cliente especifico
select * from clients where CPF = 12346789;

-- Criação de um atributo derivado chamado total_de_clientes
select count(*) as total_de_clientes from clients;

-- selecionando todos os clientes ordenando por nome
select * from clients order by Fname;

-- usando junções, group by e having
select c.Fname, c.Lname, count(*) as numeros_de_pedidos from clients c
	inner join orders o ON c.idClient = o.idOrderClient
	group by idClient having c.Lname = 'Silva';
    

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) 
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs(name) VALUES
	('Процессоры'),
	('Материнские платы'),
	('Видеокарты'),
	('Жесткие диски'),
	('Оперативная память'),
    ('Мониторы');
   
DROP TRIGGER IF EXISTS watchlog_catalogs;
delimiter //
	CREATE TRIGGER watchlog_catalogs AFTER INSERT ON catalogs
	FOR EACH ROW
	BEGIN
		INSERT INTO logs (created, table_name, key_id, name_value)
		VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
	END //
delimiter ;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	birthday_at DATE COMMENT 'Дата рождения',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
	('Геннадий', '1990-07-07'),
	('Алексей', '1995-08-05'),
	('Виктор', '1975-02-12'),
	('София', '1993-07-07'), 
	('Наталья', '1971-08-05'),
	('Ирина', '1983-02-12');

DROP TRIGGER IF EXISTS watchlog_users;
delimiter //
	CREATE TRIGGER watchlog_users AFTER INSERT ON users
	FOR EACH ROW
	BEGIN
		INSERT INTO logs (created, table_name, key_id, name_value)
		VALUES (NOW(), 'users', NEW.id, NEW.name);
	END //
delimiter ;



DROP TABLE IF EXISTS products;
CREATE TABLE products(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	description TEXT,
	price DECIMAL (11,2),
	catalog_id INT UNSIGNED,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Товарные позиции';

CREATE INDEX index_of_catalog_id ON products (catalog_id);

INSERT INTO products (name, description, price, catalog_id) VALUES
	('Процессор AMD A6-7480 OEM', 'Процессор AMD A6-7480 OEM представляет собой сбалансированное', 2299, 1),
	('Процессор Intel Celeron G5905 BOX', 'чип со сбалансированной производительностью', 3699, 1),
	('Материнская плата ASRock H310CM-DVS', 'совместима с процессорами Intel LGA 1151-v2', 2799, 2),
	('Материнская плата Esonic G41CPL3', 'использует в своей основе чипсет Intel G41', 4000, 2),
	('GV-N210D3-1GI', 'Видеокарта GIGABYTE GeForce 210', 3299, 3),
	('GV-N710D5-1GL Rev2.0', 'Видеокарта GIGABYTE GeForce GT 710', 3599, 3),
	('HDWD105UZSVA', '500 ГБ Жесткий диск Toshiba P300', 2850, 4),
	('ST1000DM010', '1 ТБ Жесткий диск Seagate 7200 BarraCuda', 3099, 4),
	('R532G1601S1S-U', 'Оперативная память SODIMM AMD Radeon R5 Entertainment Series', 850, 5);

CREATE OR REPLACE VIEW  name_prod AS
	SELECT p.name AS product_name, c.name AS catalog_name
	FROM products AS p, catalogs AS c 
	WHERE p.catalog_id = c.id;

DROP TRIGGER IF EXISTS watchlog_products;
delimiter //
	CREATE TRIGGER watchlog_products AFTER INSERT ON products
	FOR EACH ROW
	BEGIN
		INSERT INTO logs (created, table_name, key_id, name_value)
		VALUES (NOW(), 'products', NEW.id, NEW.name);
	END //
delimiter ;


DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
	user_id INT UNSIGNED,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
) COMMENT = 'Заказы';

INSERT INTO orders (user_id) VALUES
	(1),(1),(5),(5),(3),(2),(1);


DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products(
	id SERIAL PRIMARY KEY,
	order_id INT UNSIGNED,
	product_id INT UNSIGNED,
	total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных позиций',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

INSERT INTO orders_products(order_id, product_id, total) VALUES
	(1, 1, 2),
	(1, 3, 1),
	(1, 4, 1),
	(2, 9, 2),
	(3, 8, 1),
	(4, 7, 2),
	(5, 6, 3),
	(2, 5, 2),
	(3, 4, 5),
	(2, 6, 1),
	(5, 2, 2);


DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts(
	id SERIAL PRIMARY KEY,
	user_id INT UNSIGNED,
	product_id INT UNSIGNED,
	discount FLOAT UNSIGNED,
	started_at DATETIME,
	finished_at DATETIME,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Скидка';

INSERT INTO DISCOUNTS (user_id, product_id, discount, started_at, finished_at) VALUES 
	(1, 1, 0.1, '2021-01-26', '2022-02-26'),
    (2, 2, 0.1, '2020-02-21', '2022-02-26'),
    (3, 3, 0.2, '2020-05-26', '2022-02-26'),
	(1, 4, 0.3, '2020-04-26', '2022-02-26'),
	(2, 5, 0.2, '2020-03-26', '2022-02-26'),
	(3, 6, 0.1, '2021-02-26', '2022-02-26');


 DROP TABLE IF EXISTS storehouses;
 CREATE TABLE storehouses(
 	id SERIAL PRIMARY KEY,
 	name VARCHAR(255),
 	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
 ) COMMENT = 'Склады';
 
 DROP TABLE IF EXISTS storehouses_products;
 CREATE TABLE storehouses_products(
 	id SERIAL PRIMARY KEY,
 	storehouses_id INT UNSIGNED,
 	product_id INT UNSIGNED,
 	value INT UNSIGNED,
 	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
 ) COMMENT = 'Запасы на складе';
 
 
 

USE warehouse;

-- 3.1 INSERT
-- a. Без указания списка полей
-- INSERT INTO table_name VALUES (value1, value2, value3, ...);

INSERT INTO warehouse 
VALUES 
	(@id_warehouse, "Центральный", "г.Йошкар-Ола", "88362-35-35-36"),
	(@id_warehouse, "Восточный", "г.Йошкар-Ола", "88362-35-35-37");

-- b. С указанием списка полей
-- INSERT INTO table_name (column1, column2, column3, ...) VALUES (value1, value2, value3, ...);
INSERT INTO warehouse (`warehouse_name`, address, phone)
VALUES
	("Западный", "пгт.Морки", "883638-9-15-37"),
	("Южный", "г.Волжск", "8961123456");

INSERT INTO employee 
VALUES 
	(@id_employee, "Иван", "Иванов", "директор", "г.Москва", 1),
	(@id_employee, "Петр", "Петров", "директор", "г.Волжск", 2),
	(@id_employee, "Сидор", "Сидоров", "директор", "пгт.Морки", 3),
	(@id_employee, "Вася", "Васильев", "грузчик", "г.Волжск", 4);

INSERT INTO employee 
VALUES 
	(@id_employee, "Влентина", "Терешкова", "кладовщик", "г.Москва", 1),
	(@id_employee, "Юрий", "Гагарин", "зам.директора", "г.Москва", 1),
	(@id_employee, "Алексей", "Титов", "водитель", "г.Москва", 1),
	(@id_employee, "Андриян", "Николаев", "приемщик", "г.Москва", 1);
	

INSERT INTO producer 
VALUES 
	(@id_producer, "ООО ""Заря""", "г.Йошкар-Ола", "88362-40-40-40"),
	(@id_producer, "ООО ""Рога и Копыта""", "г.Волжск", "88362-10-10-10"),
	(@id_producer, "ООО ""John Doe""", "г.Xt,jrcfhs", "88352-37-40-40");

INSERT INTO product
VALUES 
	(@id_product, "Хлеб", "2022.03.18", "500", 1),
	(@id_product, "Батон нарезной", "2022.03.12", "500", 2),
	(@id_product, "Колбаса докторская", "2022.03.12", "1000", 3),
	(@id_product, "СЫр", "2022.03.19", "200", 1);

INSERT INTO product 
VALUES 
	(@id_product, "Мыло банное", "2022.03.01", "200", 1),
	(@id_product, "Батон московский", "2022.03.14", "400", 2),
	(@id_product, "Колбаса колбасная", "2022.03.15", "500", 3),
	(@id_product, "Печенье", "2022.03.14", "200", 1);

SELECT * FROM producer;
DROP TABLE warehouse_has_product;
INSERT INTO warehouse_has_product
VALUES 
	(@id_warehouse_has_product, "2022.03.12", "2022.03.13", 1, 1, 10),
	(@id_warehouse_has_product, "2022.03.12", "2022.03.14", 2, 12, 2),
	(@id_warehouse_has_product, "2022.03.12", "2022.03.14", 2, 13, 3),
	(@id_warehouse_has_product, "2022.03.13", "2022.03.14", 3, 15, 3),
	(@id_warehouse_has_product, "2022.03.14", "2022.03.15", 4, 16, 4),
	(@id_warehouse_has_product, "2022.03.15", "2022.03.16", 2, 13, 5),
	(@id_warehouse_has_product, "2022.03.15", "2022.03.16", 1, 19, 6),
	(@id_warehouse_has_product, "2022.03.15", "2022.03.16", 4, 18, 7),
	(@id_warehouse_has_product, "2022.03.15", "2022.03.16", 1, 12, 10),
	(@id_warehouse_has_product, "2022.03.15", "2022.03.17", 2, 1, 10),
	(@id_warehouse_has_product, "2022.03.14", "2022.03.15", 3, 17, 10);

INSERT INTO warehouse_has_product
VALUES 
	(@id_warehouse_has_product, "2022.03.12", "2022.03.13", 1, 1, 10),
	(@id_warehouse_has_product, "2022.03.12", "2022.03.14", 2, 1, 2),
	(@id_warehouse_has_product, "2022.03.12", "2022.03.14", 2, 1, 3),
	(@id_warehouse_has_product, "2022.03.13", "2022.03.14", 3, 1, 3),
	(@id_warehouse_has_product, "2022.03.14", "2022.03.15", 4, 1, 4),
	(@id_warehouse_has_product, "2022.03.15", "2022.03.16", 2, 13, 5),
	(@id_warehouse_has_product, "2022.03.15", "2022.03.16", 1, 13, 6),
	(@id_warehouse_has_product, "2022.03.15", "2022.03.16", 4, 13, 7);


SELECT * FROM warehouse_has_product;

-- c. С чтением значения из другой таблицы
-- INSERT INTO table2 (column_name(s)) SELECT column_name(s) FROM table1;
INSERT INTO 
	warehouse (address, `warehouse_name`) 
SELECT 
	address, 
    producer_name
FROM producer;

SELECT * FROM warehouse;

-- 3.2. DELETE
-- a. Всех записей
SET SQL_SAFE_UPDATES=0;
DELETE FROM employee;

SELECT * FROM employee;

-- b. По условию DELETE FROM table_name WHERE condition;
DELETE FROM employee 
WHERE position = "грузчик";

-- 3.3. UPDATE
-- a. Всех записей
UPDATE employee 
SET first_name = "Евгений";

-- b. По условию обновляя один атрибут
-- UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;

UPDATE employee 
SET first_name = "Василий" 
WHERE id_employee = 11; 

-- c. По условию обновляя несколько атрибутов
-- UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;
UPDATE 
	employee 
SET 
	first_name = "Геннадий", 
    last_name = "Иванов" 
WHERE first_name = "Евгений"; 

-- 3.4. SELECT
-- a. С набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
SELECT `product_name`, weight FROM product;

-- b. Со всеми атрибутами (SELECT * FROM...)
SELECT * FROM product;

-- c. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = value)
SELECT * 
FROM employee 
WHERE position = "директор";

-- 3.5 SELECT ORDER BY + TOP (LIMIT)
-- C сортировкой по возрастанию + ограничение вывода количества записей
SELECT *
FROM product 
ORDER BY `product_name` 
ASC LIMIT 2;

-- С сортировкой по убыванию DESC
SELECT * 
FROM employee 
ORDER BY `last_name` DESC;

-- C сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT * 
FROM employee 
ORDER BY 
	`first_name`, 
    `id_warehouse` 
    ASC LIMIT 3;

 -- C сортировкой по первому атрибуту из списка извлекаемых
 SELECT 
	`product_name`, 
    `production_date` 
FROM product 
ORDER BY 2;
 
 -- 3.6 Работа с датами
 -- WHERE по дате 
 SELECT 
	`product_name`, 
	`production_date` 
FROM 
	product 
WHERE production_date = "2022-03-12";
 
 -- WHERE дата в диапазоне 
 SELECT
	`product_name`, 
    `production_date` 
FROM 
	product 
WHERE production_date >= "2022-03-01" AND production_date <= "2022-03-14"
ORDER BY 2;
 
 -- Извлечь из таблицы не всю дату, а только год
 SELECT 
	`product_name`, 
    YEAR(`production_date`) 
FROM product;
 
 -- 3.7. Функции агрегации
 -- a. Посчитать количество записей в таблице
SELECT COUNT(*) 
FROM employee;
 
-- b. Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT first_name) 
FROM employee;

-- c. Вывести уникальные значения столбца
SELECT DISTINCT first_name 
FROM employee;

-- d. Найти максимальное значение столбца
SELECT 
	MAX(weight) 
FROM
	product;

-- e. Найти минимальное значение столбца
SELECT 
	MIN(weight) 
FROM 
	product;

-- f. Написать запрос COUNT() + GROUP BY
SELECT 
	first_name, 
	COUNT(first_name) AS num_of_name
FROM 
	employee 
GROUP BY first_name;

-- 3.8. SELECT GROUP BY + HAVING
-- a. Написать 3 разных запроса с использованием GROUP BY + HAVING. 
-- Для каждого запроса написать комментарий с пояснением, какую информацию
-- извлекает запрос. Запрос должен быть осмысленным, т.е. находить информацию,
-- которую можно использовать.
SELECT * FROM warehouse_has_product;
SELECT * FROM product;

-- найти продукты, которые завезены на склад более 3 раз
SELECT 
	id_product, 
    COUNT(date_of_delivery) AS delivery_quantity 
FROM 
	warehouse_has_product
		GROUP BY id_product 
        HAVING delivery_quantity > 3;


-- найти склады, где работает более 4 работников
SELECT 
	id_warehouse, 
    COUNT(id_warehouse) AS quantity 
FROM 
	employee 
		GROUP BY id_warehouse 
        HAVING quantity > 4;

-- извлечь дату последней поставки на склад батона нарезного id_product = 13 
SELECT 
	id_product, 
    MAX(date_of_delivery) AS last_delivery 
FROM 
	warehouse_has_product 
		GROUP BY id_product 
        HAVING id_product = 13;

-- вывести количество батона нарезного id_product = 13 на складе
SELECT 
	id_product, 
    SUM(quantity) AS quantity 
FROM 
	warehouse_has_product 
		GROUP BY id_product 
        HAVING id_product = 13;

-- вывести товар который требуется отправить из склада до 14.03.22
 SELECT 
	id_product, 
    quantity, 
    MIN(shipment_date) AS shipment_date
 FROM 
	warehouse_has_product 
		GROUP BY id_product 
		HAVING shipment_date < "2022-03-14";

-- 3.9. SELECT JOIN
-- a. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT *
FROM producer
LEFT JOIN product
	ON producer.id_producer = product.id_producer
WHERE producer.producer_name = "ООО ""Рога и копыта""";

ALTER TABLE `producer` CHANGE COLUMN `name` `producer_name` VARCHAR(45) NOT NULL;
ALTER TABLE `warehouse` CHANGE COLUMN `name` `warehouse_name` VARCHAR(45) NOT NULL;

-- b. RIGHT JOIN. Получить такую же выборку, как и в 3.9 a
SELECT *
FROM 
	product
		RIGHT JOIN producer
			ON product.id_producer = producer.id_producer;

-- c. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT 
	p.product_name,
    pr.producer_name,
    whp.quantity,
    whp.date_of_delivery,
    w.warehouse_name
FROM 
	warehouse_has_product whp
		LEFT JOIN warehouse w
			ON w.id_warehouse = whp.id_warehouse
		LEFT JOIN product p
			ON p.id_product = whp.id_product
        LEFT JOIN producer pr
			ON p.id_producer = pr.id_producer
WHERE 
	w.warehouse_name = "Центральный" 
    AND p.product_name = "Хлеб" 
    AND whp.date_of_delivery = "2022-03-12";

-- d. INNER JOIN двух таблиц
SELECT DISTINCT 
	w.warehouse_name,
    w.address,
    e.last_name,
    e.first_name,
    e.position,
    e.address AS residential_address
FROM warehouse w
	INNER JOIN employee e
		ON w.address = e.address;
-- WHERE w.address = "г.Волжск";

-- 3.10. Подзапросы
-- a. Написать запрос с условием WHERE IN (подзапрос)
SELECT
	id_employee,
    last_name,
    first_name,
    id_warehouse
FROM employee
WHERE id_warehouse IN (
	SELECT
		id_warehouse
	FROM
		warehouse
	WHERE
		address = "г.Волжск"
)
ORDER BY last_name;

SELECT * FROM employee;
SELECT * FROM warehouse;

-- b. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT
	id_employee,
    last_name,
    (SELECT warehouse_name FROM warehouse w WHERE w.id_warehouse = e.id_warehouse)
FROM employee e
ORDER BY 2;

SELECT * FROM employee;

-- c. Написать запрос вида SELECT * FROM (подзапрос)
SELECT *
FROM (SELECT * FROM warehouse_has_product) AS whp;

-- d. Написать запрос вида SELECT * FROM table JOIN (подзапрос) ON …
SELECT *
FROM warehouse_has_product whp
JOIN (SELECT id_warehouse, warehouse_name FROM warehouse) AS warehouse_name
	ON whp.id_warehouse = warehouse_name.id_warehouse;
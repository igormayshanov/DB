USE warehouse;

-- Без указания списка полей
INSERT INTO warehouse VALUES 
(@id_warehouse, "Центральный", "г.Йошкар-Ола", "88362-35-35-36"),
(@id_warehouse, "Восточный", "г.Йошкар-Ола", "88362-35-35-37");

-- С указанием списка полей
INSERT INTO warehouse (`name`, address, phone) VALUES
("Западный", "пгт.Морки", "883638-9-15-37"),
("Южный", "г.Волжск", "8961123456");

INSERT INTO employee VALUES 
(@id_employee, "Иван", "Иванов", "директор", "г.Москва", 1),
(@id_employee, "Петр", "Петров", "директор", "г.Волжск", 2),
(@id_employee, "Сидор", "Сидоров", "директор", "пгт.Морки", 3),
(@id_employee, "Вася", "Васильев", "грузчик", "г.Волжск", 4);

INSERT INTO producer VALUES 
(@id_producer, "ООО ""Заря""", "г.Йошкар-Ола", "88362-40-40-40"),
(@id_producer, "ООО ""Рога и Копыта""", "г.Волжск", "88362-10-10-10"),
(@id_producer, "ООО ""John Doe""", "г.Xt,jrcfhs", "88352-37-40-40");

INSERT INTO product VALUES 
(@id_product, "Хлеб", "2022.03.18", "500", 1),
(@id_product, "Батон нарезной", "2022.03.12", "500", 2),
(@id_product, "Колбаса докторская", "2022.03.12", "1000", 3),
(@id_product, "СЫр", "2022.03.19", "200", 1);

INSERT INTO product VALUES 
(@id_product, "Мыло банное", "2022.03.01", "200", 1),
(@id_product, "Батон московский", "2022.03.14", "400", 2),
(@id_product, "Колбаса колбасная", "2022.03.15", "500", 3),
(@id_product, "Печенье", "2022.03.14", "200", 1);

SELECT * FROM producer;
DROP TABLE warehouse_has_product;
INSERT INTO warehouse_has_product VALUES 
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
SELECT * FROM warehouse_has_product;

-- С чтением значения из другой таблицы
INSERT INTO warehouse (address, `name`) SELECT address, `name` FROM producer;

SELECT * FROM warehouse;
-- 3.2 Удаление всех записей из таблицы
SET SQL_SAFE_UPDATES=0;
DELETE FROM employee;

SELECT * FROM employee;

-- 3.2 Удаление записей по условию
DELETE FROM employee WHERE position = "грузчик";

-- 3.3 Изменение занечений всех записей 
UPDATE employee SET first_name = "Евгений";
-- 3.3 По условию обновляем один атрибут
UPDATE employee SET first_name = "Василий" WHERE id_employee = 11; 
-- 3.3 По условию обновляем несколько атрибутов
UPDATE employee SET first_name = "Геннадий", last_name = "Иванов" WHERE first_name = "Евгений"; 

-- 3.4 SELECT с набором извлекаемых элементов
SELECT `name`, weight FROM product;
-- 3.4 SELECT со всеми атрибутами
SELECT * FROM product;
-- 3.4 SELECT с условием по атрибуту
SELECT * FROM employee WHERE position = "директор";

-- 3.5 SELECT ORDER BY + TOP (LIMIT)
-- C сортировкой по возрастанию + ограничение вывода количества записей
SELECT * FROM product ORDER BY `name` ASC LIMIT 2;

-- С сортировкой по убыванию DESC
SELECT * FROM employee ORDER BY `last_name` DESC;

-- C сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT * FROM employee ORDER BY `first_name`, `id_warehouse` ASC LIMIT 3;

 -- C сортировкой по первому атрибуту из списка извлекаемых
 SELECT `name`, `production_date` FROM product ORDER BY 2;
 
 -- 3.6 Работа с датами
 -- WHERE по дате 
 SELECT `name`, `production_date` FROM product WHERE production_date = "2022-03-12";
 
 -- WHERE дата в диапазоне 
 SELECT `name`, `production_date` FROM product WHERE production_date >= "2022-03-01" AND production_date <= "2022-03-14" ORDER BY 2;
 
 -- Извлечь из таблицы не всю дату, а только год
 SELECT `name`, YEAR(`production_date`) FROM product;
 
 -- 3.7. Функции агрегации
 -- a. Посчитать количество записей в таблице
 SELECT COUNT(*) FROM employee;
 
-- b. Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT first_name) FROM employee;

-- c. Вывести уникальные значения столбца
SELECT DISTINCT first_name FROM employee;

-- d. Найти максимальное значение столбца
SELECT MAX(weight) FROM product;

-- e. Найти минимальное значение столбца
SELECT MIN(weight) FROM product;

-- f. Написать запрос COUNT() + GROUP BY
SELECT first_name, 
COUNT(first_name) AS num_of_name
FROM employee GROUP BY first_name;

-- 3.8. SELECT GROUP BY + HAVING
-- a. Написать 3 разных запроса с использованием GROUP BY + HAVING. 
-- Для каждого запроса написать комментарий с пояснением, какую информацию
-- извлекает запрос. Запрос должен быть осмысленным, т.е. находить информацию,
-- которую можно использовать.
SELECT * FROM warehouse_has_product;
SELECT * FROM product;
-- извлечь дату последней поставки на склад батона нарезного id_product = 13 
SELECT id_product, MAX(date_of_delivery) AS last_delivery FROM warehouse_has_product GROUP BY id_product HAVING id_product = 13;

-- вывести количество батона нарезного id_product = 13 на складе
SELECT id_product, SUM(quantity) AS quantity FROM warehouse_has_product GROUP BY id_product HAVING id_product = 13;

-- вывести товар который требуется отправить из склада до 14.03.22
 SELECT id_product, quantity, MIN(shipment_date) AS shipment_date
 FROM warehouse_has_product 
 GROUP BY id_product 
 HAVING shipment_date < "2022-03-14";

-- 3.9. SELECT JOIN
-- a. LEFT JOIN двух таблиц и WHERE по одному из атрибутов



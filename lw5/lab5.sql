USE hotel_complex;

-- 1. Добавить внешние ключи
ALTER TABLE hotel_complex.dbo.booking
	ADD CONSTRAINT FK_booking_id_client FOREIGN KEY (id_client)
		REFERENCES hotel_complex.dbo.client (id_client)
		ON DELETE CASCADE
		ON UPDATE CASCADE
;

ALTER TABLE hotel_complex.dbo.room
	ADD CONSTRAINT FK_room_id_hotel FOREIGN KEY (id_hotel)
		REFERENCES hotel_complex.dbo.hotel (id_hotel)
		ON DELETE CASCADE
		ON UPDATE CASCADE
;

ALTER TABLE hotel_complex.dbo.room
	ADD CONSTRAINT FK_room_id_room_category FOREIGN KEY (id_room_category)
		REFERENCES hotel_complex.[dbo].[room_category] (id_room_category)
		ON DELETE CASCADE
		ON UPDATE CASCADE
;

ALTER TABLE hotel_complex.[dbo].[room_in_booking]
	ADD CONSTRAINT FK_room_in_booking_id_booking FOREIGN KEY (id_booking)
		REFERENCES hotel_complex.[dbo].[booking] (id_booking)
		ON DELETE CASCADE
		ON UPDATE CASCADE
;

ALTER TABLE hotel_complex.[dbo].[room_in_booking]
	ADD CONSTRAINT FK_room_in_booking_id_room FOREIGN KEY (id_room)
		REFERENCES hotel_complex.[dbo].[room] (id_room)
		ON DELETE CASCADE
		ON UPDATE CASCADE
;

-- 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г.
-- переписать через  JOIN
USE hotel_complex;

SELECT client.id_client, client.name, client.phone FROM [dbo].[client]
LEFT JOIN [dbo].[booking] ON booking.id_client = client.id_client
JOIN [dbo].room_in_booking ON room_in_booking.id_booking = booking.id_booking
JOIN [dbo].room ON room.id_room = room_in_booking.id_room
JOIN [dbo].room_category ON room_category.id_room_category = room.id_room_category
JOIN [dbo].[hotel] ON hotel.id_hotel = room.id_hotel
WHERE hotel.name = 'Космос' AND room_category.name = 'Люкс' AND checkin_date <= '2019.04.01' AND '2019.04.01' < checkout_date;

SELECT *
FROM [dbo].[room_in_booking]
WHERE checkin_date <= '2019.04.01' AND '2019.04.01' < checkout_date AND (id_room = 13 OR id_room = 16);

SELECT *
FROM [dbo].[booking]
JOIN (SELECT id_client, name AS client_name FROM [dbo].[client]) AS client_name
	ON booking.id_client = client_name.id_client;


	-- 3. Дать список свободных номеров всех гостиниц на 22 апреля.
-- Почему NOT IN?
SELECT DISTINCT number, id_hotel FROM [dbo].[room]
WHERE room.id_room NOT IN (
	SELECT id_room
		FROM [dbo].[room_in_booking]
		WHERE checkin_date <= '2019.04.22' AND '2019.04.22' < checkout_date);

SELECT room.number, hotel.name FROM [dbo].[room]
LEFT JOIN [dbo].hotel ON room.id_hotel = hotel.id_hotel
WHERE room.id_room NOT IN(SELECT id_room FROM [dbo].[room_in_booking]
						WHERE checkin_date <= '2019.04.22' AND '2019.04.22' < checkout_date)
ORDER BY room.number;

--4. Дать количество проживающих в гостинице “Космос” на 23 марта по каждой категории номеров

SELECT room.id_room_category, COUNT(client.id_client) AS client_number
FROM [dbo].[room_in_booking] rib
LEFT JOIN [dbo].[room] ON room.id_room = rib.id_room
LEFT JOIN [dbo].[booking] ON booking.id_booking = rib.id_booking
LEFT JOIN [dbo].[client] ON client.id_client = booking.id_client
WHERE id_hotel
		IN (SELECT id_hotel
			FROM [dbo].[hotel]
			WHERE name = 'Космос')
		AND '2019.03.23' BETWEEN rib.checkin_date AND rib.checkout_date
GROUP BY room.id_room_category;

-- 5. Дать список последних проживавших клиентов по всем комнатам гостиницы
-- “Космос”, выехавшим в апреле с указанием даты выезда. 
-- TODO комната, человек, дата

--Найдем ид номеров с последней датой выезда в апреле
SELECT id_room, MAX(checkout_date) FROM [dbo].[room_in_booking]
WHERE checkout_date BETWEEN '2019.04.01' AND '2019.04.30'
GROUP BY id_room;

SELECT rib.id_room_in_booking, r.number, c.name, temp.max_checkout, h.name FROM (SELECT rib.id_room, MAX(checkout_date) AS max_checkout FROM [dbo].[room_in_booking] rib
				JOIN [dbo].[room] r ON r.id_room = rib.id_room
				JOIN [dbo].[hotel] h ON h.id_hotel = r.id_hotel
				WHERE checkout_date BETWEEN '2019.04.01' AND '2019.04.30' AND h.name = 'Космос'
				GROUP BY rib.id_room) temp
JOIN  [dbo].[room_in_booking] rib ON temp.id_room = rib.id_room AND temp.max_checkout = rib.checkout_date
JOIN [dbo].[booking] b ON b.id_booking = rib.id_booking
JOIN [dbo].[client] c ON c.id_client = b.id_client
JOIN [dbo].[room] r ON r.id_room = rib.id_room
JOIN [dbo].[hotel] h ON h.id_hotel = r.id_hotel
ORDER BY r.number;
				
SELECT * FROM [dbo].[room] r
JOIN [dbo].[hotel] h ON h.id_hotel = r.id_hotel
WHERE h.name = 'Космос';

-- 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам
 -- комнат категории “Бизнес”, которые заселились 10 мая.
UPDATE room_in_booking SET checkout_date = DATEADD(day, 2, checkout_date)
WHERE id_room_in_booking IN (SELECT rib.id_room_in_booking FROM [dbo].[room_in_booking] rib
								JOIN [dbo].[room] ON rib.id_room = room.id_room
								JOIN [dbo].[hotel] ON room.id_hotel = hotel.id_hotel 
								JOIN [dbo].[room_category] ON room.id_room_category = room_category.id_room_category AND room_category.name = 'Бизнес'
								WHERE checkin_date = '2019.05.10' AND hotel.name = 'Космос');

SELECT * FROM [dbo].[room_in_booking] rib
JOIN [dbo].[room] ON rib.id_room = room.id_room
JOIN [dbo].[hotel] ON room.id_hotel = hotel.id_hotel
JOIN [dbo].[room_category] ON room.id_room_category = room_category.id_room_category
WHERE checkin_date = '2019.05.10' AND hotel.name = 'Космос' AND room_category.name = 'Бизнес';

UPDATE room_in_booking SET checkin_date = '2019.05.10'
WHERE id_room_in_booking IN (118, 1495, 928, 624);

-- 7. Найти все "пересекающиеся" варианты проживания. Правильное состояние: не 
-- может быть забронирован один номер на одну дату несколько раз, т.к. нельзя
-- заселиться нескольким клиентам в один номер. Записи в таблице
-- room_in_booking с id_room_in_booking = 5 и 2154 являются примером
-- неправильного состояния, которые необходимо найти. Результирующий кортеж
-- выборки должен содержать информацию о двух конфликтующих номерах.

SELECT * FROM [dbo].[room_in_booking] rib1
CROSS JOIN [dbo].[room_in_booking] rib2
WHERE rib1.id_room = rib2.id_room AND rib1.id_room_in_booking != rib2.id_room_in_booking AND ((rib1.checkin_date >= rib2.checkin_date AND rib1.checkin_date < rib2.checkout_date) 
									OR (rib2.checkin_date >= rib1.checkin_date AND rib2.checkin_date < rib1.checkout_date));

-- 8. Создать бронирование в транзакции.
BEGIN TRANSACTION
	INSERT INTO [dbo].[client]
	VALUES 
		('Иванов Иван Иванович', '89623412345')
	INSERT INTO [dbo].[booking]
	VALUES
		((SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]), '2022.05.01')
	INSERT INTO [dbo].[room_in_booking]
	VALUES
		((SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]), 1, '2022.05.02', '2022.05.07')
COMMIT;

SELECT * FROM dbo.client
WHERE name = 'Иванов Иван Иванович';

SELECT client.name, client.phone, rib.id_room_in_booking, rib.id_booking, rib.checkin_date, rib.checkout_date FROM dbo.room_in_booking rib
JOIN dbo.booking ON rib.id_booking = booking.id_booking
JOIN dbo.client ON booking.id_client = client.id_client
WHERE client.name = 'Иванов Иван Иванович';

-- 9. Добавить необходимые индексы для всех таблиц

CREATE NONCLUSTERED INDEX [IX_room_id_hotel] ON
[dbo].[room]
(
	[id_hotel] ASC
);

CREATE NONCLUSTERED INDEX [IX_room _in_booking_id_booking] ON
[dbo].[room_in_booking]
(
	[id_booking] ASC
);

CREATE NONCLUSTERED INDEX [IX_room _in_booking__booking] ON
[dbo].[room_in_booking]
(
	[id_booking] ASC
);


CREATE NONCLUSTERED INDEX [IX_room _in_booking_id_room] ON
[dbo].[room_in_booking]
(
	[id_room] ASC
);

CREATE NONCLUSTERED INDEX [IX_booking_id_client] ON
[dbo].[booking]
(
	[id_client] ASC
);

CREATE NONCLUSTERED INDEX [IX_room_id_room_category] ON
[dbo].[room]
(
	[id_room_category] ASC
);

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
	ADD CONSTRAINT FK_room_room_category FOREIGN KEY (id_room_category)
		REFERENCES hotel_complex.[dbo].[room_category] (id_room_category)
		ON DELETE CASCADE
		ON UPDATE CASCADE
;

ALTER TABLE hotel_complex.[dbo].[room_in_booking]
	ADD CONSTRAINT FK_room_in_booking_booking FOREIGN KEY (id_booking)
		REFERENCES hotel_complex.[dbo].[booking] (id_booking)
		ON DELETE CASCADE
		ON UPDATE CASCADE
;

ALTER TABLE hotel_complex.[dbo].[room_in_booking]
	ADD CONSTRAINT FK_room_in_booking_room FOREIGN KEY (id_room)
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
FROM [dbo].[client]
-- JOIN 
--	ON 
WHERE id_client 
		IN (SELECT id_client
			FROM [dbo].[booking]
			WHERE id_booking 
				IN (SELECT id_booking
					FROM [dbo].[room_in_booking]
					WHERE id_room
							IN (SELECT id_room
								FROM [dbo].[room]
								WHERE 
									id_hotel 
										IN (SELECT
												id_hotel
											FROM
												[dbo].[hotel]
											WHERE
												name = 'Космос') AND
									id_room_category
										IN (SELECT
												id_room_category
											FROM
												[dbo].[room_category]
											WHERE
												name = 'Люкс')) 
										AND '2019.04.01' BETWEEN checkin_date AND checkout_date));

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

SELECT * FROM [dbo].[room]
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

SELECT client.name, MAX(room_in_booking.checkout_date) AS max_checkout_date FROM [dbo].[client]
JOIN [dbo].[booking] ON client.id_client = booking.id_client
JOIN [dbo].room_in_booking ON booking.id_booking = room_in_booking.id_booking AND room_in_booking.checkout_date BETWEEN '2019.04.01' AND '2019.04.30'
JOIN [dbo].[room] ON room_in_booking.id_room = room.id_room
JOIN [dbo].[hotel] ON room.id_hotel = hotel.id_hotel AND hotel.name = 'Космос'
GROUP BY client.name;

-- 6. Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам
 -- комнат категории “Бизнес”, которые заселились 10 мая. UPDATE room_in_booking SET checkout_date = DATEADD(day, 2, checkout_date) WHERE id_room_in_booking IN (SELECT rib.id_room_in_booking FROM [dbo].[room_in_booking] rib								JOIN [dbo].[room] ON rib.id_room = room.id_room								 JOIN [dbo].[hotel] ON room.id_hotel = hotel.id_hotel AND hotel.name = 'Космос'								 JOIN [dbo].[room_category] ON room.id_room_category = room_category.id_room_category AND room_category.name = 'Бизнес'								 WHERE checkin_date = '2019.05.10');SELECT * FROM [dbo].[room_in_booking] ribJOIN [dbo].[room] ON rib.id_room = room.id_roomJOIN [dbo].[hotel] ON room.id_hotel = hotel.id_hotel AND hotel.name = 'Космос'JOIN [dbo].[room_category] ON room.id_room_category = room_category.id_room_category AND room_category.name = 'Бизнес'WHERE checkin_date = '2019.05.10';UPDATE room_in_booking SET checkin_date = '2019.05.10'WHERE id_room_in_booking IN (118, 1495, 928, 624);-- 7. Найти все "пересекающиеся" варианты проживания. Правильное состояние: не 
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
	
COMMIT

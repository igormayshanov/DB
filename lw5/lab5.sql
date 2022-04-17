USE hotel_complex;

-- 1. Добавить внешние ключи
ALTER TABLE hotel_complex.dbo.booking
	ADD CONSTRAINT FK_booking_client FOREIGN KEY (id_client)
		REFERENCES hotel_complex.dbo.client (id_client)
		ON DELETE CASCADE
		ON UPDATE CASCADE
;

ALTER TABLE hotel_complex.dbo.room
	ADD CONSTRAINT FK_room_hotel FOREIGN KEY (id_hotel)
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

SELECT TOP 10* FROM booking;
SELECT TOP 10* FROM client;
SELECT TOP 10* FROM hotel;
SELECT * FROM room;
SELECT TOP 10* FROM room_category;
SELECT TOP 10* FROM room_in_booking;

SELECT *
FROM [dbo].[room] r
JOIN (SELECT id_hotel, name AS hotel_name FROM [dbo].[hotel]) AS hotel_name
	ON r.id_hotel = hotel_name.id_hotel
JOIN (SELECT id_room_category, name AS category_name FROM [dbo].[room_category]) AS category
	ON r.id_room_category = category.id_room_category
WHERE hotel_name = 'Космос' AND category_name = 'Люкс';

SELECT *
FROM [dbo].[booking]
JOIN (SELECT id_client, name AS client_name FROM [dbo].[client]) AS client_name
	ON booking.id_client = client_name.id_client;

SELECT *
FROM [dbo].[room_in_booking]
WHERE id_room = 13 OR id_room = 16;

SELECT id_room
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
				name = 'Люкс');

SELECT *
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
							name = 'Люкс')) AND
		checkin_date <= '2019.04.01' AND '2019.04.01' <= checkout_date;

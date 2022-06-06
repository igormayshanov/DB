USE [pharmacy]

-- 1. Добавить внешние ключи.
ALTER TABLE [pharmacy].[dbo].[dealer]
	ADD CONSTRAINT FK_dealer_id_company FOREIGN KEY (id_company)
		REFERENCES [pharmacy].[dbo].[company] (id_company)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [pharmacy].[dbo].[production]
	ADD CONSTRAINT FK_production_id_company FOREIGN KEY (id_company)
		REFERENCES [pharmacy].[dbo].[company] (id_company)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [pharmacy].[dbo].[production]
	ADD CONSTRAINT FK_production_id_medicine FOREIGN KEY (id_medicine)
		REFERENCES [pharmacy].[dbo].[medicine] (id_medicine)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [pharmacy].[dbo].[production]
	ADD CONSTRAINT FK_production_id_medicine FOREIGN KEY (id_medicine)
		REFERENCES [pharmacy].[dbo].[medicine] (id_medicine)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [pharmacy].[dbo].[order]
	ADD CONSTRAINT FK_production_id_production FOREIGN KEY (id_production)
		REFERENCES [pharmacy].[dbo].[production] (id_production)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

ALTER TABLE [pharmacy].[dbo].[order]
	ADD CONSTRAINT FK_production_id_dealer FOREIGN KEY (id_dealer)
		REFERENCES [pharmacy].[dbo].[dealer] (id_dealer)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION;

ALTER TABLE [pharmacy].[dbo].[order]
	ADD CONSTRAINT FK_production_id_pharmacy FOREIGN KEY (id_pharmacy)
		REFERENCES [pharmacy].[dbo].[pharmacy] (id_pharmacy)
		ON DELETE CASCADE
		ON UPDATE CASCADE;

-- 2. Выдать информацию по всем заказам лекарства “Кордерон” компании “Аргус” с
-- указанием названий аптек, дат, объема заказов.

SELECT * FROM dbo.medicine;

SELECT m.name, c.name, ph.name, o.date,  o.quantity FROM [dbo].[order] o
JOIN [dbo].[production] p ON o.id_production = p.id_production
JOIN [dbo].[company] c ON p.id_company = c.id_company 
JOIN [dbo].[medicine] m ON p.id_medicine = m.id_medicine 
JOIN [dbo].[pharmacy] ph ON o.id_pharmacy = ph.id_pharmacy
WHERE c.name = 'Аргус' AND m.name = 'Кордерон';
-- 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.

--список лекарств Фарма, на которые были сделан заказы до 25.01
SELECT DISTINCT m.name FROM [dbo].[order] o
LEFT JOIN [dbo].[production] p ON o.id_production = p.id_production
JOIN [dbo].[company] c ON p.id_company = c.id_company 
JOIN [dbo].[medicine] m ON p.id_medicine = m.id_medicine
JOIN [dbo].[pharmacy] ph ON o.id_pharmacy = ph.id_pharmacy
WHERE o.date < '2019.01.25' AND c.name = 'Фарма'
ORDER BY m.name;

SELECT DISTINCT m.name AS medicine_name, c.name AS company_name FROM [dbo].[production] p
LEFT JOIN [dbo].[order] o ON p.id_production = o.id_production
JOIN [dbo].[company] c ON p.id_company = c.id_company
JOIN [dbo].[medicine] m ON p.id_medicine = m.id_medicine
WHERE c.name = 'Фарма' AND p.id_production NOT IN (SELECT id_production FROM [dbo].[order]
						WHERE date < '2019.01.25');

SELECT * FROM dbo.production p
JOIN [dbo].[company] c ON p.id_company = c.id_company
JOIN [dbo].[medicine] m ON p.id_medicine = m.id_medicine
WHERE c.name = 'Фарма'
ORDER BY m.name;

SELECT * FROM [dbo].[order];

-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.
--не принято, переделать
--Фирмы, которые оформили более 120 заказов
SELECT COUNT(o.id_order), c.name AS company_name FROM [dbo].[production] p
LEFT JOIN [dbo].[order] o ON p.id_production = o.id_production
JOIN [dbo].[company] c ON p.id_company = c.id_company
JOIN [dbo].[medicine] m ON p.id_medicine = m.id_medicine
GROUP BY c.name
HAVING COUNT(*) > 120;

SELECT c.name AS company, MAX(p.rating) AS max_rating, MIN(p.rating) AS min_rating FROM [dbo].[production] p
JOIN [dbo].[company] c ON c.id_company = p.id_company
WHERE p.id_company IN (SELECT c.id_company FROM [dbo].[production] p
						LEFT JOIN [dbo].[order] o ON p.id_production = o.id_production
						JOIN [dbo].[company] c ON p.id_company = c.id_company
						GROUP BY c.id_company
						HAVING COUNT(o.id_order) > 120)
GROUP BY c.name;

-- 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.
 --Если у дилера нет заказов, в названии аптеки проставить NULL.
SELECT * FROM [dbo].[dealer] 
WHERE id_company = 4
ORDER BY id_company;

SELECT * FROM [dbo].[company];

SELECT * FROM [dbo].[order] o
LEFT JOIN [dbo].[production] p ON p.id_production = o.id_production
JOIN [dbo].[company] c ON c.id_company = p.id_company
JOIN [dbo].[dealer] d ON d.id_dealer = o.id_dealer 
							AND d.id_dealer IN 
							(SELECT id_dealer FROM [dbo].[dealer] d
							JOIN [dbo].[company] c ON c.id_company = d.id_company 
							WHERE c.name = 'AstraZeneca')
LEFT JOIN [dbo].[pharmacy] ph ON ph.id_pharmacy = o.id_pharmacy;

SELECT DISTINCT ph.name FROM [dbo].[dealer] d
JOIN [dbo].[company] c ON c.id_company = d.id_company 
LEFT JOIN [dbo].[order] o ON o.id_dealer = d.id_dealer
LEFT JOIN [dbo].[pharmacy] ph ON ph.id_pharmacy = o.id_pharmacy
WHERE c.name = 'AstraZeneca';

-- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а
-- длительность лечения не более 7 дней.

SELECT * FROM medicine m
JOIN production p ON p.id_medicine = m.id_medicine
WHERE m.cure_duration <= 7 AND p.price >= 3000;

UPDATE production SET price = price * 0.8
WHERE id_medicine IN 
(
	SELECT m.id_medicine FROM medicine m
	JOIN production p ON p.id_medicine = m.id_medicine
	WHERE m.cure_duration <= 7 AND p.price >= 3000
)

-- 7. Добавить необходимые индексы.

CREATE NONCLUSTERED INDEX [IX_production_id_company] ON [dbo].[production]
(
	[id_company] ASC
);

CREATE NONCLUSTERED INDEX [IX_production_id_medicine] ON [dbo].[production]
(
	[id_medicine] ASC
);

CREATE NONCLUSTERED INDEX [IX_order_id_production] ON [dbo].[order]
(
	[id_production] ASC
);

CREATE NONCLUSTERED INDEX [IX_order_id_dealer] ON [dbo].[order]
(
	[id_dealer] ASC
);

CREATE NONCLUSTERED INDEX [IX_order_id_pharmacy] ON [dbo].[order]
(
	[id_pharmacy] ASC
);
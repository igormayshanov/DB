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
JOIN [dbo].[company] c ON p.id_company = c.id_company AND c.name = 'Аргус'
JOIN [dbo].[medicine] m ON p.id_medicine = m.id_medicine AND m.name = 'Кордерон'
JOIN [dbo].[pharmacy] ph ON o.id_pharmacy = ph.id_pharmacy;

-- 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.

SELECT o.id_order, m.name, c.name, o.date FROM [dbo].[order] o
LEFT JOIN [dbo].[production] p ON o.id_production = p.id_production
JOIN [dbo].[company] c ON p.id_company = c.id_company AND c.name = 'Фарма'
JOIN [dbo].[medicine] m ON p.id_medicine = m.id_medicine
JOIN [dbo].[pharmacy] ph ON o.id_pharmacy = ph.id_pharmacy
WHERE o.date < '2019.01.25';

SELECT * FROM [dbo].[production] p
LEFT JOIN [dbo].[order] o ON p.id_production = o.id_production
JOIN [dbo].[company] c ON p.id_company = c.id_company AND c.name = 'Фарма'
JOIN [dbo].[medicine] m ON p.id_medicine = m.id_medicine
WHERE o.id_order NOT IN (SELECT id_order FROM [dbo].[order]
						WHERE date < '2019.01.25');

SELECT * FROM dbo.production;


-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.
-- 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.
 --Если у дилера нет заказов, в названии аптеки проставить NULL.
-- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а
-- длительность лечения не более 7 дней.
-- 7. Добавить необходимые индексы.
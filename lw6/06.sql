-- 1. Добавить внешние ключи.

ALTER TABLE dealer ADD CONSTRAINT FK_dealer_company
FOREIGN KEY (id_company)
REFERENCES company (id_company) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order" ADD CONSTRAINT FK_order_production
FOREIGN KEY (id_production)
REFERENCES production (id_production) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order" ADD CONSTRAINT FK_order_dealer
FOREIGN KEY (id_dealer)
REFERENCES dealer (id_dealer) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order" ADD CONSTRAINT FK_order_pharmacy
FOREIGN KEY (id_pharmacy)
REFERENCES pharmacy (id_pharmacy) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE production ADD CONSTRAINT FK_production_company
FOREIGN KEY (id_company)
REFERENCES company (id_company) 
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE production ADD CONSTRAINT FK_production_medicine
FOREIGN KEY (id_medicine)
REFERENCES medicine (id_medicine) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- 2. Выдать информацию по всем заказам лекарства “Кордеон” компании “Аргус” с
-- указанием названий аптек, дат, объема заказов.

SELECT ph.name, o.date, o.quantity FROM pharmacy ph
JOIN "order" o ON o.id_pharmacy = ph.id_pharmacy
JOIN production pr ON pr.id_production = o.id_production
JOIN medicine m ON m.id_medicine = pr.id_medicine
JOIN company c ON c.id_company = pr.id_company
WHERE m.name = 'Кордеон' AND c.name = 'Аргус'

-- 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы 
-- до 25 января.

SELECT m.name FROM medicine m
LEFT JOIN production pr ON pr.id_medicine = m.id_medicine
LEFT JOIN company c ON c.id_company = pr.id_company
WHERE c.name = 'Фарма' AND m.name NOT IN 
(
	SELECT m.name FROM medicine m
	LEFT JOIN production pr ON pr.id_medicine = m.id_medicine
	LEFT JOIN company c ON c.id_company = pr.id_company
	LEFT JOIN "order" o ON o.id_production = pr.id_production
	WHERE o.date < '2019-01-25' AND c.name = 'Фарма'
	GROUP BY m.name
)

-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая
-- оформила не менее 120 заказов

SELECT m.name, c.name, MAX(pr.rating), MIN(pr.rating), COUNT(o.id_order) FROM medicine m
LEFT JOIN production pr ON pr.id_medicine = m.id_medicine
LEFT JOIN company c ON c.id_company = pr.id_company
LEFT JOIN "order" o ON o.id_production = pr.id_production
INNER JOIN (
	SELECT c.name AS compay_name, COUNT(o.id_order) FROM company c
	JOIN production pr ON c.id_company = pr.id_company
	JOIN "order" o ON o.id_production = pr.id_company
	GROUP BY c.name
	HAVING COUNT(o.id_order) >= 120
) AS found_companies ON c.name = found_companies.compay_name
GROUP BY m.name, c.name

-- 5. ❌ Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.
-- Если у дилера нет заказов, в названии аптеки проставить NULL.

SELECT DISTINCT ph.name FROM dealer d
JOIN company c ON c.id_company = d.id_company
LEFT JOIN "order" o ON d.id_dealer = o.id_dealer
LEFT JOIN pharmacy ph ON ph.id_pharmacy = o.id_pharmacy
WHERE c.name = 'AstraZeneca'

--6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а
-- длительность лечения не более 7 дней

UPDATE production pr SET price = price * 0.8
WHERE pr.id_medicine IN 
(
	SELECT m.id_medicine FROM medicine m
	JOIN production pr ON pr.id_medicine = m.id_medicine
	WHERE m.cure_duration <= 7 AND pr.price::numeric >= 3000
)

-- 7. Добавить необходимые индексы.

CREATE INDEX IX_production_id_company
ON production(id_company);

CREATE INDEX IX_production_id_medicine
ON production(id_medicine);

CREATE INDEX IX_order_id_production
ON "order"(id_production);

CREATE INDEX IX_order_id_dealer
ON "order"(id_dealer);

CREATE INDEX IX_order_id_pharmacy
ON "order"(id_pharmacy);




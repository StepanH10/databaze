 
-- Úloha 1
SELECT
  COUNT(*)                 AS pocet_objednavek,
  COUNT(rating)            AS pocet_hodnocenych,
  COUNT(*) - COUNT(rating) AS pocet_bez_hodnoceni,
  ROUND(AVG(rating), 2)    AS prumerne_hodnoceni,
  MIN(unit_price)          AS nejnizsi_cena,
  MAX(unit_price)          AS nejvyssi_cena
FROM orders;

-- Úloha 2
SELECT
  category        AS kategorie,
  COUNT(*)        AS pocet_objednavek,
  SUM(quantity)   AS prodano_kusu,
  MIN(unit_price) AS nejnizsi_cena,
  MAX(unit_price) AS nejvyssi_cena
FROM orders
GROUP BY category
ORDER BY prodano_kusu DESC;

-- Úloha 3
SELECT
  city                       AS mesto,
  COUNT(*)                   AS pocet_objednavek,
  COUNT(DISTINCT customer)   AS pocet_zakazniku,
  SUM(quantity * unit_price) AS celkova_trzba
FROM orders
GROUP BY city
ORDER BY celkova_trzba DESC
LIMIT 3;

-- Úloha 4
SELECT
  customer                   AS zakaznik,
  COUNT(*)                   AS pocet_objednavek,
  SUM(quantity * unit_price) AS utracena_castka
FROM orders
WHERE order_date BETWEEN '2026-01-01' AND '2026-03-31'
GROUP BY customer
HAVING SUM(quantity * unit_price) > 3500
ORDER BY utracena_castka DESC;

-- Úloha 5
SELECT
  customer                 AS zakaznik,
  COUNT(DISTINCT category) AS pocet_kategorii,
  GROUP_CONCAT(DISTINCT category ORDER BY category SEPARATOR ', ') AS seznam_kategorii,
  COUNT(rating)            AS pocet_hodnocenych,
  ROUND(AVG(rating), 2)    AS prumerne_hodnoceni
FROM orders
GROUP BY customer
HAVING COUNT(DISTINCT category) >= 3
   AND AVG(rating) >= 3.5
ORDER BY prumerne_hodnoceni DESC;
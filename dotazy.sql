-- Zapiš syntakticky správně následující dotazy:
--Vytvoř nového uživatele jan nad hostem localhost identifikovaného heslem Xa5*s23_9
--Vytvoř nového uživatele eva nad hostem localhost identifikovaného heslem Yb6*t24_0
--Vytvoř roli ucetni, která bude mít oprávnění SELECT, INSERT a UPDATE nad tabulkou faktury v databázi firma.
--Přiřaď roli ucetni uživatelům jan a eva. 
--Uprav roli ucetni tak, aby měl také oprávnění DELETE.
--Odeber roli ucetni oprávnění DELETE.
-- Odstraň uživatele jan.

CREATE USER 'jan'@'localhost' IDENTIFIED 'Xa5*s23_9'

CREATE USER 'eva'@'localhost' IDENTIFIED 'Yb6*t24_0'

CREATE ROLE 'ucetni';
GRANT SELECT, INSERT, UPDATE firma.faktury TO 'ucetni'
GRANT 'ucetni' TO 'jan'@'localhost', 'eva'@'localhost';
GRANT DELETE ON firma.faktury TO 'ucetni';
REVOKE DELETE ON firma.faktury FROM 'ucetni';
DROP USER 'jan'@'localhost'
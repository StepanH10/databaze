-- =====================================================================
-- Databázový skript: Uživatelé, Účty, Transakce
-- Kompatibilní s MySQL 8+ / MariaDB 10.5+
-- =====================================================================

DROP DATABASE IF EXISTS banka_demo;
CREATE DATABASE banka_demo CHARACTER SET utf8mb4 COLLATE utf8mb4_czech_ci;
USE banka_demo;

-- ---------------------------------------------------------------------
-- Tabulka: users (uživatelé)
-- ---------------------------------------------------------------------
CREATE TABLE users (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    jmeno           VARCHAR(100)    NOT NULL,
    prijmeni        VARCHAR(100)    NOT NULL,
    email           VARCHAR(255)    NOT NULL UNIQUE,
    heslo_hash      VARCHAR(255)    NOT NULL,
    vytvoreno       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Tabulka: accounts (účty) — jeden uživatel může mít více účtů
-- ---------------------------------------------------------------------
CREATE TABLE accounts (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT             NOT NULL,
    cislo_uctu      VARCHAR(34)     NOT NULL UNIQUE,     -- IBAN nebo interní číslo
    nazev_uctu      VARCHAR(100)    NOT NULL DEFAULT 'Běžný účet',
    mena            CHAR(3)         NOT NULL DEFAULT 'CZK',
    zustatek        DECIMAL(15,2)   NOT NULL DEFAULT 0.00,
    vytvoreno       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_accounts_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_zustatek_nezaporny CHECK (zustatek >= 0)
) ENGINE=InnoDB;

CREATE INDEX idx_accounts_user_id ON accounts(user_id);

-- ---------------------------------------------------------------------
-- Tabulka: transactions (transakce) — vázané na konkrétní účet
-- typ: 'vklad' (příjem), 'vyber' (výdaj), 'prevod_odchozi', 'prevod_prichozi'
-- ---------------------------------------------------------------------
CREATE TABLE transactions (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id          INT             NOT NULL,
    typ                 ENUM('vklad', 'vyber', 'prevod_odchozi', 'prevod_prichozi') NOT NULL,
    castka              DECIMAL(15,2)   NOT NULL,          -- vždy kladné číslo
    popis               VARCHAR(255)    NULL,
    protiucet_id        INT             NULL,              -- druhá strana převodu (pokud jde o převod)
    vytvoreno           DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_transactions_account
        FOREIGN KEY (account_id) REFERENCES accounts(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_transactions_protiucet
        FOREIGN KEY (protiucet_id) REFERENCES accounts(id)
        ON DELETE SET NULL,

    CONSTRAINT chk_castka_kladna CHECK (castka > 0)
) ENGINE=InnoDB;

CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_vytvoreno ON transactions(vytvoreno);

-- =====================================================================
-- TESTOVACÍ DATA
-- =====================================================================

INSERT INTO users (jmeno, prijmeni, email, heslo_hash) VALUES
('Jan',   'Novák',   'jan.novak@example.cz',   'hash_placeholder_1'),
('Petra', 'Svobodová','petra.svobodova@example.cz', 'hash_placeholder_2');

-- Jan má dva účty, Petra jeden
INSERT INTO accounts (user_id, cislo_uctu, nazev_uctu, mena, zustatek) VALUES
(1, 'CZ6508000000192000145399', 'Běžný účet',  'CZK', 15320.50),
(1, 'CZ1201000000195005620097', 'Spořicí účet','CZK', 100000.00),
(2, 'CZ4703000000000123456789', 'Běžný účet',  'CZK', 4250.00);

-- Ukázkové transakce
INSERT INTO transactions (account_id, typ, castka, popis) VALUES
(1, 'vklad', 20000.00, 'Výplata'),
(1, 'vyber',  4679.50, 'Výběr z bankomatu');

-- Ukázkový převod mezi Janovými účty (běžný -> spořicí)
INSERT INTO transactions (account_id, typ, castka, popis, protiucet_id) VALUES
(1, 'prevod_odchozi', 5000.00, 'Převod na spoření', 2),
(2, 'prevod_prichozi', 5000.00, 'Převod z běžného účtu', 1);

-- =====================================================================
-- UŽITEČNÉ DOTAZY (příklady)
-- =====================================================================

-- Všechny účty konkrétního uživatele
-- SELECT * FROM accounts WHERE user_id = 1;

-- Historie transakcí na účtu
-- SELECT * FROM transactions WHERE account_id = 1 ORDER BY vytvoreno DESC;

-- Celkový zůstatek uživatele přes všechny jeho účty
-- SELECT u.jmeno, u.prijmeni, SUM(a.zustatek) AS celkovy_zustatek
-- FROM users u
-- JOIN accounts a ON a.user_id = u.id
-- GROUP BY u.id;

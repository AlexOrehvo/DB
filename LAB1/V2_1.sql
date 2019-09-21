-- 1
CREATE DATABASE ALEX_OREHVO
GO

USE ALEX_OREHVO
GO

CREATE SCHEMA sales;
GO

CREATE TABLE sales.Orders
(
    OrderNum INT NULL
);
GO

-- 2
BACKUP DATABASE ALEX_OREHVO
    TO DISK='ALEX_OREHVO.bak';
GO

USE master;
GO

DROP DATABASE ALEX_OREHVO
GO

-- 3
RESTORE DATABASE ALEX_OREHVO
    FROM DISK = 'ALEX_OREHVO.bak'
GO
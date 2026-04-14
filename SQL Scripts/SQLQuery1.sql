--to delete all
TRUNCATE TABLE STG_OnlineRetail;
DELETE FROM DIM_PRODUCT;
DELETE FROM DIM_COUNTRY;
DELETE FROM DIM_CUSTOMER;

--only staging area
TRUNCATE TABLE STG_OnlineRetail;
----
select count(Invoice)
from STG_OnlineRetail

select count(InvoiceNo)
from FACT_SALES


--only country
DELETE FROM DIM_COUNTRY;
---
select count(CountryID)
from DIM_COUNTRY

--only Customers
DELETE FROM DIM_CUSTOMER;
---
select count(CustomerID)
from DIM_CUSTOMER

--only Products
DELETE FROM DIM_PRODUCT;
----
select *
from DIM_PRODUCT

select count(DateID)
from DIM_DATE

DELETE FROM FACT_SALES;

select *
from STG_OnlineRetail
where Invoice = NULL or StockCode = NULL or [Description] = NULL or InvoiceDate = NULL or Price = NULL or CustomerID = NULL or Country = NULL

--preview all
SELECT 'STG_OnlineRetail' AS TableName, COUNT(*) AS RowCnt FROM STG_OnlineRetail
UNION ALL
SELECT 'DIM_COUNTRY',  COUNT(*) FROM DIM_COUNTRY
UNION ALL
SELECT 'DIM_PRODUCT',  COUNT(*) FROM DIM_PRODUCT
UNION ALL
SELECT 'DIM_CUSTOMER', COUNT(*) FROM DIM_CUSTOMER
UNION ALL
SELECT 'DIM_DATE',     COUNT(*) FROM DIM_DATE
UNION ALL
SELECT 'FACT_SALES',   COUNT(*) FROM FACT_SALES;


SELECT COUNT(*) 
FROM STG_OnlineRetail s
WHERE NOT EXISTS (
    SELECT 1 FROM DIM_PRODUCT p 
    WHERE p.StockCode = LTRIM(RTRIM(s.StockCode))
)
AND s.CustomerID IS NOT NULL
AND s.Quantity > 0
AND s.Price > 0
AND LEFT(LTRIM(s.Invoice), 1) <> 'C'

SELECT COUNT(*) 
FROM STG_OnlineRetail
WHERE StockCode IS NULL OR LTRIM(RTRIM(StockCode)) = ''

ALTER TABLE DIM_COUNTRY
ALTER COLUMN CountryName NVARCHAR(255);

ALTER TABLE DIM_PRODUCT
ALTER COLUMN StockCode NVARCHAR(255);

SELECT TOP 10 * FROM DIM_COUNTRY



SELECT TOP 10 * FROM DIM_PRODUCT





SELECT TOP 10 * FROM DIM_CUSTOMER




SELECT TOP 10 * FROM DIM_DATE



SELECT TOP 10 * FROM FACT_SALES






-- Verify CustomerID in FACT_SALES exists in DIM_CUSTOMER
SELECT COUNT(*) AS OrphanedCustomers
FROM FACT_SALES f
WHERE NOT EXISTS (
    SELECT 1 FROM DIM_CUSTOMER c 
    WHERE c.CustomerID = f.CustomerID
);

-- Verify ProductID in FACT_SALES exists in DIM_PRODUCT
SELECT COUNT(*) AS OrphanedProducts
FROM FACT_SALES f
WHERE NOT EXISTS (
    SELECT 1 FROM DIM_PRODUCT p 
    WHERE p.ProductID = f.ProductID
);

-- Verify DateID in FACT_SALES exists in DIM_DATE
SELECT COUNT(*) AS OrphanedDates
FROM FACT_SALES f
WHERE NOT EXISTS (
    SELECT 1 FROM DIM_DATE d 
    WHERE d.DateID = f.DateID
);

-- Verify CountryID in FACT_SALES exists in DIM_COUNTRY
SELECT COUNT(*) AS OrphanedCountries
FROM FACT_SALES f
WHERE NOT EXISTS (
    SELECT 1 FROM DIM_COUNTRY c 
    WHERE c.CountryID = f.CountryID
);
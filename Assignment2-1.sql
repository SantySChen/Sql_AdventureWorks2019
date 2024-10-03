USE AdventureWorks2019
GO

--1. How many products can you find in the Production.Product table?
SELECT COUNT(p.ProductID) AS TheNumberOfProducts
FROM Production.Product p

--2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(p.ProductID) AS TheNumberOfProducts
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NOT NULL

--3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
-- ProductSubcategoryID CountedProducts
-- -------------------- ---------------
SELECT p.ProductSubcategoryID, COUNT(p.ProductSubcategoryID) AS CountedProducts
FROM Production.Product p
GROUP BY p.ProductSubcategoryID

--4. How many products that do not have a product subcategory.
SELECT COUNT(p.ProductID) AS TheNumberOfProducts
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NULL

--5. Write a query to list the sum of products quantity of each product in the Production.ProductInventory table.
SELECT p.ProductID, SUM(p.Quantity) AS TotalQuantity
FROM Production.ProductInventory p
GROUP BY p.ProductID

--6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
--              ProductID    TheSum
--             ----------  ----------
SELECT p.ProductID, SUM(p.Quantity) AS TheSum
FROM Production.ProductInventory p
WHERE p.LocationID = 40
GROUP BY p.ProductID
HAVING SUM(p.Quantity) < 100

--7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
--    Shelf      ProductID           TheSum
--  ----------   -----------        -----------
SELECT p.Shelf, p.ProductID, SUM(p.Quantity) AS TheSum
FROM Production.ProductInventory p
WHERE p.LocationID = 40
GROUP BY p.Shelf, p.ProductID
HAVING SUM(p.Quantity) < 100


--8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
WHERE p.LocationID = 10

--9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
--    ProductID     Shelf      TheAvg
--    ----------- ---------- -----------
SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
GROUP BY p.ProductID, p.Shelf

--10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
--    ProductID    Shelf      TheAvg
--   ----------- ---------- -----------
SELECT p.ProductID, p.Shelf, AVG(p.Quantity) AS TheAvg
FROM Production.ProductInventory p
WHERE p.Shelf != 'N/A'
GROUP BY p.ProductID, p.Shelf

--11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
--         Color                   Class               TheCount          AvgPrice
--    -------------- - -----    -----------            ---------------------
SELECT p.Color, p.Class, COUNT(p.Class) AS TheCount, AVG(p.ListPrice) AS AvgPrice
FROM Production.Product p
WHERE p.Color IS NOT NULL AND p.Class IS NOT NULL
GROUP BY p.Color, p.Class

--JOINS
--12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
--     Country                        Province
--    ---------                 ----------------------
SELECT pc.Name AS Country, ps.Name AS Province
FROM Person.CountryRegion pc JOIN Person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode

--13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
--     Country                        Province
--    ---------                 ----------------------
SELECT pc.Name AS Country, ps.Name AS Province
FROM Person.CountryRegion pc JOIN Person.StateProvince ps ON pc.CountryRegionCode = ps.CountryRegionCode
WHERE pc.Name IN ('Germany', 'Canada')
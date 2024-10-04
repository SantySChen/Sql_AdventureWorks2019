USE Northwind
GO

--1. List all cities that have both Employees and Customers.
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City IN (
	SELECT City
	FROM Customers
)

--2. List all cities that have Customers but no Employee.
--a. Use sub-query
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City NOT IN (
	SELECT City
	FROM Employees
)

--b. Do not use sub-query
SELECT DISTINCT c.City
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE e.City IS NULL

--3. List all products and their total order quantities throughout all orders.
SELECT p.ProductID, p.ProductName, SUM(od.Quantity) AS TheTotalQuantities
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName

--4. List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity) AS TheTotalProducts
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City

--5. List all Customer Cities that have at least two customers.
SELECT City
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2

--6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(DISTINCT od.ProductID) AS TheTotalProducts
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT od.ProductID) >= 2

--7. List all Customers who have ordered products, but have the ¡®ship city¡¯ on the order different from their own customer cities.
SELECT c.CustomerID, c.CompanyName
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City <> o.ShipCity

--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
WITH MostPopularCTE
AS(
	SELECT dt.ProductID, od.OrderID
	FROM (SELECT ProductID, SUM(Quantity) AS Total, RANK() OVER(ORDER BY SUM(Quantity) DESC) RNK FROM [Order Details]
		GROUP BY ProductID) dt JOIN [Order Details] od ON dt.ProductID = od.ProductID
	WHERE dt.RNK <= 5
)
SELECT od.ProductID, AVG(od.UnitPrice) AS [Average Price], dt.City
FROM [Order Details] od JOIN (
	SELECT c.City, od.ProductID, SUM(od.Quantity) AS TheTotalProducts, RANK() OVER(PARTITION BY od.ProductID ORDER BY SUM(od.Quantity) DESC) RNK
	FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
	GROUP BY c.City, od.ProductID
) dt ON od.ProductID = dt.ProductID
WHERE RNK = 1 AND dt.ProductID IN (SELECT ProductID FROM MostPopularCTE)
GROUP BY od.ProductID, dt.City

--9. List all cities that have never ordered something but we have employees there.
--a. Use sub-query
SELECT DISTINCT City
FROM Employees
WHERE City NOT IN (
	SELECT City
	FROM Customers
)

--b. Do not use sub-query
SELECT DISTINCT e.City
FROM Employees e LEFT JOIN Customers c ON e.City = c.City
WHERE c.City IS NULL

--10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT mostOrders.City
FROM (
	SELECT TOP 1 e.City
	FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
	GROUP BY e.City
	ORDER BY COUNT(o.OrderID) DESC
	) mostOrders 
JOIN 
(
	SELECT TOP 1 o.ShipCity
	FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
	GROUP BY o.ShipCity
	ORDER BY SUM(Quantity) DESC
) mostProducts 
ON mostOrders.City = mostProducts.ShipCity

--11. How do you remove the duplicates record of a table?
--a. During creating a table, we can use Primary key or Unique key word to avoid duplicate record.
--b. Using DELETE with ROW_NUMBER(), such as PATRITION BY all columns, then delete all row of which row_num greater than 1.
--c. Using GROUP BY all columns.



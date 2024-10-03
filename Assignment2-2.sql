USE Northwind
Go

--Using Northwnd Database: (Use aliases for all the Joins)
--14. List all Products that has been sold at least once in last 27 years.
SELECT DISTINCT p.ProductID
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID JOIN dbo.Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate >= '1997-10-02'

--15. List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 o.ShipPostalCode AS [Zip Code]
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.ShipPostalCode
ORDER BY SUM(od.Quantity)

--16. List top 5 locations (Zip Code) where the products sold most in last 27 years.
SELECT TOP 5 o.ShipPostalCode AS [Zip Code]
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
WHERE o.OrderDate >= '1997-10-02'
GROUP BY o.ShipPostalCode
ORDER BY SUM(od.Quantity)

--17. List all city names and number of customers in that city.     
SELECT o.ShipCity AS [City Name], COUNT(DISTINCT o.CustomerID) AS [The Number of Customers]
FROM dbo.Orders o
GROUP BY o.ShipCity

--18. List city names which have more than 2 customers, and number of customers in that city
SELECT o.ShipCity AS [City Name], COUNT(DISTINCT o.CustomerID) AS [The Number of Customers]
FROM dbo.Orders o
GROUP BY o.ShipCity
HAVING COUNT(DISTINCT o.CustomerID) > 2

--19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT c.CompanyName AS Names
FROM dbo.Orders o JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate >= '1998-01-01'

--20. List the names of all customers with most recent order dates
SELECT c.CompanyName AS Names
FROM dbo.Orders o JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate IN 
	(SELECT TOP 1 OrderDate
	 FROM dbo.Orders
	 ORDER BY OrderDate DESC)

--21. Display the names of all customers  along with the  count of products they bought
SELECT c.CompanyName AS Names, SUM(od.Quantity) AS TheCount
FROM dbo.Orders o JOIN dbo.Customers c ON o.CustomerID = c.CustomerID JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName

--22. Display the customer ids who bought more than 100 Products with count of products.
SELECT o.CustomerID
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
HAVING SUM(od.Quantity) > 100

--23. List all of the possible ways that suppliers can ship their products. Display the results as below
--        Supplier Company Name                          Shipping Company Name
--    ---------------------------------            ----------------------------------
SELECT su.CompanyName AS [Supplier Company Name], s.CompanyName AS [Shipping Company Name]
FROM dbo.Suppliers su JOIN dbo.Products p ON su.SupplierID = p.SupplierID JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID
	JOIN dbo.Orders o ON od.OrderID = o.OrderID JOIN dbo.Shippers s ON o.ShipVia = s.ShipperID
GROUP BY su.CompanyName, s.CompanyName
ORDER BY su.CompanyName

--24. Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName
FROM dbo.Orders o JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID JOIN dbo.Products p ON od.ProductID = p.ProductID 

--25. Displays pairs of employees who have the same job title.
SELECT e1.FirstName + ' ' + e1.LastName AS FisrtEmployee, e2.FirstName + ' ' + e2.LastName AS SecondEmployee
FROM dbo.Employees e1 JOIN dbo.Employees e2 ON e1.Title = e2.Title AND e1.EmployeeID < e2.EmployeeID

--26. Display all the Managers who have more than 2 employees reporting to them.
SELECT e.FirstName + ' ' + e.LastName AS Managers
FROM dbo.Employees e 
WHERE e.EmployeeID IN (SELECT ReportsTo
FROM employees
WHERE ReportsTo IS NOT NULL
GROUP BY ReportsTo
HAVING COUNT(employeeID) > 2)

--27. Display the customers and suppliers by city. The results should have the following columns
--   City Name, Contact Name, Type (Customer or Supplier)
SELECT s.City, s.ContactName, 'Supplier' AS Type
FROM dbo.Suppliers s 
UNION
SELECT c.City, c.ContactName, 'Customer' AS Type
FROM dbo.Customers c
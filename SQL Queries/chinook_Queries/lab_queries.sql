				-- SQLITE QUERIES


-- How old are the employees now
SELECT firstName || " " || lastName AS fullName,
    (strftime('%Y', 'now') - strftime('%Y', BirthDate)) - (strftime('%m-%d', 'now') < strftime('%m-%d', BirthDate)) AS Age
FROM employees;

-- how old were the employees when started working
SELECT firstName || " " || lastName AS fullName,
    (strftime('%Y', HireDate) - strftime('%Y', BirthDate)) - (strftime('%m-%d', HireDate) < strftime('%m-%d', BirthDate)) AS HiredAtAge
FROM employees;

-- how many years have the employees been working in Chinook corp.
SELECT firstName || " " || lastName AS fullName,
    (strftime('%Y', 'now') - strftime('%Y', HireDate)) - (strftime('%m-%d', 'now') < strftime('%m-%d', HireDate)) AS WorkingYears
FROM employees;

-- sum of all these three query in one
SELECT firstName || " " || lastName AS fullName,
    (strftime('%Y', HireDate) - strftime('%Y', BirthDate)) - (strftime('%m-%d', HireDate) < strftime('%m-%d', BirthDate)) AS HiredAtAge,
    (strftime('%Y', 'now') - strftime('%Y', HireDate)) - (strftime('%m-%d', 'now') < strftime('%m-%d', HireDate)) AS WorkingYears,
    (strftime('%Y', 'now') - strftime('%Y', BirthDate)) - (strftime('%m-%d', 'now') < strftime('%m-%d', BirthDate)) AS CurrentAge
FROM employees;

-- Provide a query showing only the Employees who are Sales Agents.
SELECT FirstName || " " || LastName AS "Sales Employee"
FROM Employees
WHERE Title LIKE "Sales%";

-- What about manager?
SELECT FirstName || " " || LastName AS "Sales Employee"
FROM Employees
WHERE Title LIKE "%Manager";

-- Provide a query that shows the total sales per country.
SELECT BillingCountry,
    sum(total) Total
FROM Invoices
GROUP BY BillingCountry
ORDER BY Total DESC;

-- Provide a query that shows the total sales per country with 2 decimal points 
SELECT BillingCountry,
    printf("$%.2f", sum(total)) Total
FROM Invoices
GROUP BY BillingCountry
ORDER BY Total DESC;

-- Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT FirstName || " " || LastName AS "Name",
    customerId,
    Country
FROM Customers
WHERE Country != "USA";

-- Provide a query showing a unique/distinct list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry
FROM Invoices
WHERE BillingCountry IS NOT NULL;

-- Provide a query showing how many Customers for each country
SELECT Country,
    COUNT(customerId) AS CustomerCount,
FROM Customers
GROUP BY Country
ORDER BY CustomerCount DESC;

--  Provide a query that shows the total sales per country.
SELECT BillingCountry,
    SUM(Total) AS "Total Sales For Country"
FROM Invoices
GROUP BY BillingCountry
ORDER BY SUM(Total) DESC;

-- Yearly total sales
SELECT strftime('%Y', InvoiceDate) AS Year,
    sum(total) AS TotalSales
FROM Invoices
-- WHERE InvoiceDate BETWEEN ('2009-01-01') AND date('2011-12-31')
GROUP BY Year;
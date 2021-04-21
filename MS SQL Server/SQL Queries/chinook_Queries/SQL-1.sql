			--SQLITE QUERIES

--1. Write a query that displays InvoiceId, CustomerId and total dollar amount for each invoice, 
--sorted first by CustomerId (in ascending order), and then by total dollar amount  (in descending order).
SELECT InvoiceId, CustomerId, Total
FROM invoices
ORDER by CustomerId asc, Total desc;


--2. Write a query that displays InvoiceId, CustomerId and total dollar amount for each invoice, 
--but this time sorted first by total dollar amount (in descending order), and then by CustomerId (in ascending order).
SELECT InvoiceId, CustomerId, Total
FROM invoices
ORDER by Total desc, CustomerId asc;


--3. Compare the results of these two queries above. How are the results different when you switch the column you sort on first? (Explain it in your own words.)
Order By önündeki field lar içinde ilk field ın sıralaması önceliklidir. 2.fieldın sıralaması 1.fieldın sıralamasını bozmayacak şekilde olur.

--4. Write a query to pull the first 10 rows and all columns 
--from the invoices table that have a dollar amount of total greater than or equal to 10.

SELECT *
FROM invoices
where Total>=10
LIMIT 10;

--5. Write a query to pull the first 5 rows and all columns 
--from the invoices table that have a dollar amount of total less than 10.

SELECT *
FROM invoices
where Total<10
LIMIT 5;

--6. Find all track names that start with 'B' and end with 's'.

SELECT name
FROM tracks
WHERE name like "B%s";

--7. Use the invoices table to find all information regarding invoices 
--whose billing address is USA or Germany or Norway or Canada 
--and invoice date is at any point in 2010, sorted from newest to oldest.

SELECT *
FROM invoices
WHERE BillingCountry in ("USA","Germany","Norway","Canada") 
and InvoiceDate BETWEEN "2010-01-01" and "2011-01-01"
ORDER by InvoiceDate DESC;









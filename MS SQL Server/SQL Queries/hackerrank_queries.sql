--1.Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
SELECT count(CITY) - count(distinct CITY)
FROM STATION;

--2.Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). 
--If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically
select * 
from (
    select top 1 CITY , LEN(CITY ) name_len 
    from STATION  
    order by name_len ASC, CITY  ASC) TblMin
UNION
select * 
from (
    select top 1 CITY , LEN(CITY ) name_len 
    from STATION  
    order by name_len desc, CITY  desc) TblMax;

--3.Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.

SELECT distinct CITY 
FROM STATION
WHERE CITY LIKE '[aeiou]%';

--4.Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
SELECT distinct CITY 
FROM STATION
WHERE CITY LIKE '%[aeiou]';

--5.Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. 
--Your result cannot contain duplicates.
SELECT distinct CITY 
FROM STATION
WHERE CITY LIKE '[aeiou]%[aeiou]';

--6.Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
SELECT distinct CITY 
FROM STATION
WHERE CITY NOT LIKE '[aeiou]%';

--7.Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.
SELECT distinct CITY 
FROM STATION
WHERE CITY LIKE '[^aeiou]%[^aeiou]';

--8.Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. 
--If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
SELECT name
FROM students
WHERE marks > 75
ORDER BY RIGHT(name, 3) ASC, id ASC;

--9.Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
SELECT name
FROM Employee 
ORDER BY name ASC;

--10.Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary 
--greater than 2000$ per month who have been employees for less than 10 months. Sort your result by ascending employee_id.
SELECT name
FROM Employee 
WHERE salary>2000 AND months<10
ORDER BY employee_id;

--11.P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
--* 
--* * 
--* * * 
--* * * * 
--* * * * *
--Write a query to print the pattern P(20).

declare @row int = 1
while (@row < 21)
begin
    print replicate('* ', @row)
    set @row = @row + 1
end

--or

with cte as
(select 1 i union all
 select i+1 i from cte where i < 20)
select REPLICATE('* ', i) from cte
order by i ASC;

--12.Write a query to print all prime numbers less than or equal to 1000. 
--Print your result on a single line, and use the ampersand (&) character as your separator (instead of a space).
--For example, the output for all prime numbers <=10 would be: 2&3&5&7

DECLARE @i int=2;
declare @prime int = 0;
DECLARE @result nvarchar(1000) = ''; --CAN BE ADJUSTED
WHILE (@i<=1000)
begin
   DECLARE @j int = @i-1;
   SET @prime = 1;
   WHILE(@j > 1)
   begin
      IF @i % @j = 0
      begin 
         SET @PRIME = 0;
      end
    set @j = @j - 1;
   end
   
   IF @PRIME = 1
   BEGIN
      set @result += cast(@i as nvarchar(1000)) + '&';
   END
set @i = @i + 1;
end
set @result = SUBSTRING(@result, 1, LEN(@result) - 1)
select @result









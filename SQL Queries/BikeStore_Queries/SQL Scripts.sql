SQL Scripts

=, !=, <, <= , >, >=
IN, NOT IN
BETWEEN, NOT BETWEEN
ANY, ALL

SELECT * FROM sales.customers
SELECT * FROM sales.staffs
SELECT * FROM sales.orders
SELECT * FROM sales.order_items

SELECT * FROM production.products
SELECT * FROM production.brands
SELECT * FROM production.categories

--1-new yorktataki musteri id leri, siparis id leri ve siparis tarihleri gelsin ve en son tarihe gore siralansin

SELECT order_id, order_date, customer_id
FROM sales.orders
WHERE customer_id IN ( SELECT customer_id FROM sales.customers WHERE city = 'New York' )
ORDER BY order_date DESC;

--OR

SELECT order_id, order_date, o.customer_id
FROM sales.orders o
INNER JOIN sales.customers c
ON o.customer_id=c.customer_id
WHERE city = 'New York'
ORDER BY order_date DESC;

--2-Strider veya Trek marka urunlerin fiyat ortalamasindan buyuk urunlerin product_name, list_price i getir.

SELECT product_name, list_price
FROM production.products
WHERE list_price > ( SELECT AVG(list_price)
					 FROM production.products
					 WHERE brand_id IN 
					  ( SELECT brand_id
						FROM production.brands
						WHERE brand_name = 'Strider' OR brand_name = 'Trek' )
				   )
ORDER BY list_price;

--OR


--3-Her bir siparis icindeki maksimum liste fiyatinina sahip urunun fiyatini, siparis tarihini ve siparis id sini ver

SELECT order_id, order_date,
 (
 SELECT MAX(list_price) FROM sales.order_items i WHERE i.order_id = o.order_id
 ) AS max_list_price
FROM sales.orders o
ORDER BY order_date DESC;

--OR



--4- dag bisikleti ile sehir bisikleti kategorindeki urun id ve adlarini ver

SELECT product_id, product_name
FROM production.products
WHERE category_id IN (
			SELECT category_id
			FROM production.categories
			WHERE category_name = 'Mountain Bikes' OR category_name = 'Road Bikes' );

--5-  marka bazinda urunlerin ortalama fiyatlarinin herhangi birinden buyuk liste fiyati olan urun ve fiyatlari getir

SELECT product_name, list_price
FROM production.products
WHERE
 list_price >= ANY (
 SELECT AVG(list_price) FROM production.products GROUP BY brand_id );

--6-marka bazinda urunlerin ortalama fiyatlarinin hepsinden yuksek fiyatli urun ve fiyatlarini getir

SELECT product_name, list_price
FROM production.products
WHERE
 list_price >= ALL (
 SELECT AVG(list_price) FROM production.products GROUP BY brand_id );

--7-2017 de siparis veren musteri varsa, id. ad, soyad ve sehrini ver ve ad-soyada gore a dan z ye sirala

SELECT customer_id, first_name, last_name, city
FROM sales.customers c
WHERE
 EXISTS (
 SELECT customer_id
 FROM sales.orders o
 WHERE o.customer_id = c.customer_id AND YEAR (order_date) = 2017
 )
ORDER BY first_name, last_name;

--8- satis elemani bazinda siparis sayilarinin ortalamasini ver.

SELECT AVG(order_count) average_order_count_by_staff
FROM
	(SELECT staff_id, COUNT(order_id) order_count
	 FROM sales.orders GROUP BY staff_id) t;

--9- Her kategorinin maximum liste fiyatina sahip urununun urun adi, liste fiyati ve categori id sini ver, 
--categori id ve urun adina gore sirala

SELECT product_name, list_price, category_id
FROM production.products p1
WHERE
 list_price IN (
 SELECT MAX (p2.list_price)
 FROM production.products p2
 WHERE p2.category_id = p1.category_id
 GROUP BY p2.category_id
 )
ORDER BY category_id, product_name;

--10-musteri id, isim soyismi ver, isim soyisme gore sirali ve queryde exists kullanilmis olsun.

SELECT customer_id, first_name, last_name
FROM sales.customers
WHERE
 EXISTS (SELECT NULL)
ORDER BY first_name, last_name;

--11-musteri id lerini ad-soyada gore siralayarak getir. ancak musteri bazinda siparis sayisi 2 den buyuk olsun


--Correlated query: sub query icinde main query nin tablosu kullanilir. tek basina calismaz.
SELECT customer_id, first_name, last_name
FROM sales.customers c
WHERE
 EXISTS (
 SELECT COUNT (*)
 FROM sales.orders o
 WHERE o.customer_id = c.customer_id
 GROUP BY o.customer_id
 HAVING COUNT (*) > 2
 )
ORDER BY first_name, last_name;

--12- 2018 deki satis elemani tam adi ve toplam satislarini getir. CTE kullan

--Common Table Expressions, sub query ye gore daha okunabilirdir. 

WITH cte_sales_amounts (staff, sales, year) AS (
 SELECT first_name + ' ' + last_name, SUM(quantity * list_price * (1 - discount)),
YEAR(order_date)
 FROM sales.orders o
 INNER JOIN sales.order_items i ON i.order_id = o.order_id
 INNER JOIN sales.staffs s ON s.staff_id = o.staff_id
 GROUP BY first_name + ' ' + last_name, year(order_date)
)
SELECT staff, sales
FROM cte_sales_amounts
WHERE year = 2018;

--13-2018de satis elemani bazinda ortalama siparis sayisini ver, CTE kullan

WITH cte_sales AS (
 SELECT staff_id, COUNT(*) order_count
 FROM sales.orders
 WHERE YEAR(order_date) = 2018
 GROUP BY staff_id
)
SELECT AVG(order_count) average_orders_by_staff
FROM cte_sales;

--14-her musterinin en eski tarihli siparisi ne zamansa, onun siparis tarihini ve diger tum sutunlari veren sorgu (nested query)  

SELECT *
FROM
(
	SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS row_number  
    FROM sales.orders
) t
WHERE row_number = 1

--15 her musterinin en eski tarihli siparisi ne zamansa, onun siparis tarihini ve diger tum sutunlari veren sorgu (CTE query) 

WITH orders_with_row_numbers AS
(
	SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS row_number  
    FROM sales.orders
)
SELECT *
FROM orders_with_row_numbers
WHERE row_number = 1



--16- Her Categorinin en pahali urun fiyatini ver. category id ve categori ismi ile beraber (nested query)
select cp.category_id, category_name, max_price
from  ( select category_id, max(list_price) max_price
		from production.products
		group by  category_id ) cp

inner join production.categories c 
on cp.category_id = c.category_id;


--17- Her Categorinin en pahali urun fiyatini ver. category id ve categori ismi ile beraber (CTE)

with category_price as (
	select category_id, max(list_price) max_price
	from production.products
	group by  category_id )

select cp.category_id, category_name, max_price
from category_price cp
inner join production.categories c 
on cp.category_id = c.category_id;


18-

select *
from (select getdate() present_date) derived_table
where present_date like '%2020%';

19-

select getdate() present_date, next_date
from (select getdate() + 1000000 next_date) derived_table  --anlik tarihe 1 milyon gun ekleyip next_date olarak adlandirdi. 
where derived_table.next_date != getdate()

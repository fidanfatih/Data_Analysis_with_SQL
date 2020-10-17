/*
**1. Find the customers who placed at least two orders per year.**

**2. Find the total amount of each order which are placed in 2018. Then categorize them according to limits stated below.(You can use case when statements here)**

If the total amount of order

less then 500 then "very low"
between 500 - 1000 then "low"
between 1000 - 5000 then "medium"
between 5000 - 10000 then "high"
more then 10000 then "very high"


**3. By using Exists Statement find all customers who have placed more than two orders.**

**4. Show all the products and their list price, that were sold with more than two units in a sales order.**

**5. Show the total count of orders per product for all times. (Every product will be shown in one line and the total order count will be shown besides it)**

**6. Find the products whose list prices are more than the average list price of products of all brands**

**7. You ara given a HR Database's ERD on below link. Please do the following:**

- Discuss the HR ERD; entity names, primary keys, attributes for each entity, relationships between the entities and cardinality. (Shortly, read the HR ERD :)
- Then create the database named "HR" with all tables, keys (PKs, FKs)

- [HR Database Diagram](https://github.com/clarusway/cw-ds-workshop/blob/master/2-weekly%20agenda/week7-HR-DB-Diagram.png)
*/

--**1. Find the customers who placed at least two orders per year.**

--Solution-1 with window functions & subQuery
select *
from (	select	distinct c.customer_id,year(o.[order_date]) as [year],
				count (order_id) over(partition by c.customer_id, year([order_date]) ) as num_of_order
		from [sales].[customers] c
		inner join [sales].[orders] o
		on c.customer_id=o.customer_id
		--order by [year]  --subquery de order by kullanilamaz
		) temp
where num_of_order >=2;

--Solution-2 with VIEW
CREATE view temp as
select	distinct c.customer_id,year(o.[order_date]) as [year],
		count (order_id) over(partition by c.customer_id, year([order_date]) ) as num_of_order
from [sales].[customers] c
inner join [sales].[orders] o
on c.customer_id=o.customer_id;

Select * from temp
where num_of_order >=2;

--Solution-4 with WITH AS
With temp as(
				select	distinct c.customer_id,year(o.[order_date]) as [year],
						count (order_id) over(partition by c.customer_id, year([order_date]) ) as num_of_order
				from [sales].[customers] c
				inner join [sales].[orders] o
				on c.customer_id=o.customer_id)
Select * from temp
where num_of_order >=2;

--Solution-4 with group by
select	c.customer_id,
		year(o.[order_date]) as [year],
		count (order_id) as num_of_order
from [sales].[customers] c
inner join [sales].[orders] o
on c.customer_id=o.customer_id
group by c.customer_id, year(o.[order_date])
having count (order_id) >=2
order by c.[customer_id],year(o.[order_date])

/*
**2. Find the total amount of each order which are placed in 2018. 
--Then categorize them according to limits stated below.(You can use case when statements here)**

If the total amount of order

less then 500 then "very low"
between 500 - 1000 then "low"
between 1000 - 5000 then "medium"
between 5000 - 10000 then "high"
more then 10000 then "very high" */


--Solution-1 with WITH AS and WINDOW FUNCTIONS
with tmp as(
			select	distinct o.[order_id], 
					SUM([list_price]*[quantity]*(1-[discount])) Over(partition by o.[order_id]) as total_amount
			from [sales].[orders] as o
			inner join [sales].[order_items]  as i
			on o.order_id=i.order_id
			Where YEAR(o.[order_date]) = 2018
			--order by o.order_id --order by, with ile calismaz
			)
select order_id, total_amount,
		CASE
			WHEN total_amount < 500 then 'very low'
			WHEN total_amount between 500 and 1000 then 'low'
			WHEN total_amount between 1001 and 5000 then 'medium'
			WHEN total_amount between 5001 and 10000 then 'high'
			WHEN total_amount > 10000 then 'very high'
			ELSE 'out of category'
		END as category
		--The BETWEEN operator is inclusive: begin and end values are included. 
from tmp
order by category

--Solution-2 with SUBQUERY and GROUP BY
select *,
		CASE
			WHEN total_amount < 500 then 'very low'
			WHEN total_amount between 500 and 1000 then 'low'
			WHEN total_amount between 1001 and 5000 then 'medium'
			WHEN total_amount between 5001 and 10000 then 'high'
			WHEN total_amount > 10000 then 'very high'
			ELSE 'out of category'
		END as category
from (
		select o.[order_id], 
				SUM([list_price]*[quantity]*(1-[discount])) as total_amount
		from [sales].[orders] as o
		inner join [sales].[order_items]  as i
		on o.order_id=i.order_id
		Where YEAR(o.[order_date]) = 2018
		group by o.[order_id]) t

--**3. By using Exists Statement find all customers who have placed more than two orders.**

--Solution-1 with EXISTS
select c.customer_id
from [sales].[customers] c
WHERE EXISTS (
				select count(*)
				from [sales].[orders] o
				WHERE c.customer_id=o.customer_id
				group by o.customer_id
				HAVING count(*)>2
				);

--Solution-2 with IN
select customer_id
from [sales].[customers]
WHERE customer_id IN (
						select customer_id
						from [sales].[orders]
						group by customer_id
						having COUNT(*)>2
						);

--Solution-3 with GROUP BY
select customer_id
--,COUNT([order_id]) as num_of_order
from [sales].[orders] o
group by customer_id
HAVING COUNT([order_id])>2

--**4. Show all the products and their list price, that were sold with more than two units in a sales order.**

--Solution-1 with WINDOW FUNCTIONS
select	[order_id],
		[product_id],
		[list_price],
		num_of_product
from (
		Select	[order_id],
				[product_id],
				COUNT([product_id]) OVER(partition by [order_id]) as num_of_product,
				[list_price]
		from [sales].[order_items]) t
where num_of_product > 2
order by [order_id]

--Solution-2 with GROUP BY
select	i1.order_id,
		[product_id],
		[list_price],
		num_of_product
from [sales].[order_items] i1
join (
		select	[order_id],
				COUNT([product_id]) as num_of_product
		from [sales].[order_items] i2
		group by [order_id]
		HAVING COUNT([product_id]) >2
		) t
on i1.order_id=t.[order_id]
where num_of_product >2;

--**5. Show the total count of orders per product for all times. 
--(Every product will be shown in one line and the total order count will be shown besides it)**

select i.[product_id], count([order_id]) as [total count of orders]
from [sales].[order_items] i
join [production].[products] p
on i.product_id=p.product_id
group by i.[product_id]
order by i.[product_id];


--**6. Find the products whose list prices are more than the average list price of products of each brands**

--Solution-1 with SUBQUERY IN FROM
select *
from (
		select [product_id],[brand_id],list_price, 
		AVG([list_price]) Over (partition by [brand_id]) as [average list price of brand]
		from [production].[products]
		) t
where list_price > [average list price of brand]
order by [product_id];

--Solution-2 with WITH AS
with temp as(
			select [product_id],[brand_id],list_price, 
					AVG([list_price]) Over (partition by [brand_id]) as [average list price of brand]
			from [production].[products] )
select * from temp
where list_price > [average list price of brand];





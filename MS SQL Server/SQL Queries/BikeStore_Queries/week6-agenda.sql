/*
1-What is the sales quantity of product according to the brands and sort them highest-lowest
2-Select the top 5 most expensive products
3-What are the categories that each brand has
4-Select the avg prices according to brands and categories
5-Select the annual amount of product produced according to brands
6-Select the least 3 products in stock according to stores.
7-Select the store which has the most sales quantity in 2016
8-Select the store which has the most sales amount in 2016
9-Select the personnel which has the most sales amount in 2016
10-Select the least 3 sold products in 2016 and 2017 according to city.*/--1-What is the sales quantity of product according to the brands and sort them highest-lowestSelect b.[brand_name], p.[product_name],SUM(i.quantity) as [saled quantity of product]from [production].[products] pjoin [sales].[order_items] ion p.product_id=i.product_idjoin [production].[brands] bon p.brand_id=b.brand_idgroup by b.[brand_name],p.[product_name]order by [saled quantity of product] desc;--2-Select the top 5 most expensive productsselect top 5 [product_id],[product_name],[list_price]from [production].[products]order by [list_price] desc;--3-What are the categories that each brand has
select distinct [brand_name],[category_name]
from [production].[products] p
join [production].[brands] b
on b.brand_id=p.brand_id
join [production].[categories] c
on c.category_id=p.category_id;

--4-Select the avg prices according to brands and categories
select [brand_name],[category_name], AVG([list_price]) [avg prices]
from [production].[products] p
join [production].[brands] b
on b.brand_id=p.brand_id
join [production].[categories] c
on c.category_id=p.category_id
group by [brand_name],[category_name];

--5-Select the annual amount of product produced according to brands

select [brand_name],[model_year], SUM([quantity]) as [annual amount of product]
from [production].[products] p
join [production].[brands] b
on b.brand_id=p.brand_id
join [production].[stocks] s
on s.product_id=p.product_id
group by [brand_name],[model_year];

--6-Select the least 3 products in stock according to stores.

--Solution-1 with WITH AS
with temp as (
select	[store_name],p.product_id, p.[product_name], quantity
		,ROW_NUMBER() over (partition by [store_name] order by [quantity]) as row_num
from [sales].[stores] st
join [production].[stocks] stc
on st.[store_id]=stc.store_id
join [production].[products] p
on p.product_id=stc.product_id 
where [quantity]>0
)
select *
from temp
where row_num <= 3;


--Solution-2 with SUBQUERY IN FROM
SELECT	*
FROM	(
		select	store_name, p.product_id, product_name, quantity
				,row_number() over(partition by store_name order by quantity) row_num
		from [sales].[stores] s1
		inner join [production].[stocks] s2
		on s1.store_id=s2.store_id
		inner join [production].[products] p
		on s2.product_id=p.product_id
		where quantity > 0
		) sub
WHERE	sub.row_num <4

--7-Select the store which has the most sales quantity in 2016
select top 1 [store_name],SUM([quantity]) as [sales quantity]
from [sales].[orders] o
join [sales].[stores] s
on o.store_id= s.store_id
join [sales].[order_items] i
on i.[order_id]=o.[order_id]
where YEAR([order_date])=2016
group by [store_name]
order by SUM([quantity]) DESC;

--8-Select the store which has the most sales amount in 2016
select top 1 [store_name],SUM([list_price]*[quantity]*(1-[discount])) as [sales amount]
from [sales].[orders] o
join [sales].[stores] s
on o.store_id= s.store_id
join [sales].[order_items] i
on i.[order_id]=o.[order_id]
where YEAR([order_date])=2016
group by [store_name]
order by SUM([list_price]*[quantity]*(1-[discount])) DESC;


--9-Select the personnel which has the most sales amount in 2016

select top 1 sf.[staff_id],[first_name],[last_name], SUM([list_price]*[quantity]*(1-[discount])) as [sales amount]
from [sales].[orders] o
join [sales].[order_items] i
on i.[order_id]=o.[order_id]
join [sales].[staffs] sf
on o.[staff_id]=sf.[staff_id]
where YEAR([order_date])=2016
group by sf.[staff_id],[first_name],[last_name]
order by SUM([list_price]*[quantity]*(1-[discount])) DESC;


--10-Select the least 3 sold products in 2016 and 2017 according to city.with temp as(select	[city], p.product_id, p.product_name		, Count(o.[order_id]) as num_of_order		, row_number() over(partition by [city] order by Count(o.[order_id])) as row_numfrom [sales].[customers] cjoin [sales].[orders] oon o.customer_id=c.customer_idjoin [sales].[order_items] ion i.order_id=o.order_idjoin [production].[products] pon p.product_id=i.product_idwhere year([order_date]) in ('2016','2017')group by [city], p.product_id, p.product_name)select *from tempwhere row_num<=3;
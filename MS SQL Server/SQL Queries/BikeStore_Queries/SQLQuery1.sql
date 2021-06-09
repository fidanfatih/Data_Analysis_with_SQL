

/*		01 Mayıs 2021			*/
/*	Data Science - Session 01	*/

-- 1- Ürünleri kategori isimleri ile birlikte listeleyin

SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	production.products A
INNER JOIN	production.categories B
	ON	A.category_id = B.category_id
;

-- alternatif yazım
SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	production.products A,
		production. categories B
WHERE	A.category_id = B.category_id
;

-- 2-Mağaza çalışanlarını çalıştıkları mağaza bilgileriyle birlikte listeleyin
SELECT	A.first_name, A.last_name, B.store_name
FROM	sales.staffs A
INNER JOIN sales.stores B
	ON	A.store_id = B.store_id
;

-- 3-Inner join ile yaptığınız sorguyu LEFT JOIN ile yapın
SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	production.products A
LEFT JOIN	production.categories B
	ON	A.category_id = B.category_id
;

-- 4-Ürün bilgilerini stok miktarları ile birlikte listeleyin, Stokta bulunmayan ürünlerin bilgileri de gelsin istiyoruz, ProductID si 310 dan büyük olan ürünleri getirin
-- ProductID, ProductName ve stok bilgilerini seçin
SELECT	A.product_id, A.product_name, B.*
FROM	production.products A
LEFT JOIN production.stocks B
	ON	A.product_id = B.product_id
WHERE	A.product_id > 310
;

-- 5-Stok miktarları ile ilgili LEFT JOIN ile yaptığınız sorguyu RIGHT JOIN ile yapın
-- Her iki sorgu sonucunun da aynı olmasını sağlayın (satır sayısı, sütun sıralaması vs.)
SELECT	B.product_id, B.product_name, A.*
FROM	production.stocks A
RIGHT JOIN production.products B
	ON	A.product_id = B.product_id
WHERE	B.product_id > 310
;

-- 6-Mağaza çalışanlarını yaptıkları satışlar ile birlikte listeleyin
--		Hiç satış yapmayan çalışan varsa onların da gelmesini istiyoruz.
--		Staff ID, Staff adı, soyadı ve sipariş bilgilerini seçin
--		Sonucu daha iyi analiz edebilmek için sorguyu Staff ID alanına göre sıralayın.
SELECT	A.staff_id, A.first_name, A.last_name, B.*
FROM	sales.staffs A
LEFT JOIN sales.orders B
	ON	A.staff_id = B.staff_id
ORDER BY A.staff_id
;

-- 7- Ürünlerin stok miktarları ve sipariş bilgilerini birlikte listeleyin
-- production.stocks ve sales.order_items tablolarını kullanın
-- Sorgu sonucunda bütün sütunların gelmesini sağlayın
-- Çıkan sonucu daha kolay yorumlamak için product_id ve order_id alanlarına göre sıralayın 
SELECT	*
FROM	production.stocks A
FULL OUTER JOIN	sales.order_items B
	ON	A.product_id = B.product_id
ORDER BY A.product_id, B.order_id
;



------ CROSS JOIN ------
-- 8-Hangi markada hangi kategoride kaçar ürün olduğu bilgisine ihtiyaç duyuluyor
-- Ürün sayısı hesaplamadan sadece marka * kategori ihtimallerinin hepsini içeren bir tablo oluşturun.
-- Çıkan sonucu daha kolay yorumlamak için brand_id ve category_id alanlarına göre sıralayın 
SELECT	*
FROM	production.brands A
CROSS JOIN production.categories B
ORDER BY A.brand_id, B.category_id
;

-- 9-Bazı ürünlerin stok bilgileri stocks tablosunda yok.
-- Bu ürünlerin herbir mağazada 0 adet olacak şekilde stocks tablosuna basılması isteniyor.
-- Bunu nasıl yaparsınız?
-- Örneğin product_id = 314 olan ürünün stok bilgilerini kontrol edebilirsiniz
-- Sadece stock tablosuna basılacak listeyi oluşturun, INSERT etmeyin
SELECT	B.store_id, A.product_id, 0 quantity
FROM	production.products A
CROSS JOIN sales.stores B
WHERE	A.product_id NOT IN (SELECT product_id FROM production.stocks)
ORDER BY A.product_id, B.store_id
;



------ SELF JOIN ------
-- 10-Personelleri ve şeflerini listeleyin
-- Çalışan adı ve yönetici adı bilgilerini getirin
SELECT	A.first_name, B.first_name manager_name
FROM	sales.staffs A
JOIN	sales.staffs B
	ON	A.manager_id = B.staff_id
ORDER BY B.first_name
;

-- alternatif yazım
SELECT	A.first_name, B.first_name manager_name
FROM	sales.staffs A, sales.staffs B
WHERE	A.manager_id = B.staff_id
ORDER BY B.first_name
;

-- 11-Bir önceki sorgu sonucunda gelen şeflerin yanına onların da şeflerini getiriniz
-- Çalışan adı, şef adı, şefin şefinin adı bilgilerini getirin
SELECT	A.first_name,
		B.first_name manager1_name,
		C.first_name manager2_name
FROM	sales.staffs A
JOIN	sales.staffs B
	ON	A.manager_id = B.staff_id
JOIN	sales.staffs C
	ON	B.manager_id = C.staff_id
ORDER BY C.first_name, B.first_name
;



------ BREAKOUT SESSION ------

-- 12-Bir liste oluşturun ve bu listede ürün adı, model yılı, fiyatı, kategorisi ve markası bulunsun.
-- Toplam satır sayısı 321 olmalı

SELECT	A.product_name, A.model_year, A.list_price,
		B.category_name, C.brand_name
FROM	production.products A, production.categories B, production.brands C
WHERE	A.category_id = B.category_id AND
		A.brand_id = C.brand_id
;

-- 13-Bu liste oluşturun ve bu listede çalışan adı soyadı, sipariş tarihi, müşteri adı soyadı bulunsun.
-- Bu listede tüm çalışanların olmasını sağlayın fakat müşterilerden sadece sipariş verenler bulunsun.
-- Toplam satır sayısı 1.619 olmalı

SELECT	A.first_name staff_fname, A.last_name staff_lname,
		B.order_date,
		C.first_name customer_fname, C.last_name customer_lname
FROM	sales.staffs A
LEFT JOIN	sales.orders B
ON		A.staff_id = B.staff_id
LEFT JOIN	sales.customers C
ON		B.customer_id = C.customer_id
;


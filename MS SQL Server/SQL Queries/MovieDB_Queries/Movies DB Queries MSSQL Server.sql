--[Movies DB Questions]
--(https://www.w3resource.com/sql-exercises/movie-database-exercise/joins-exercises-on-movie-database.php) 

--1.Write a query in SQL to find the name of all reviewers who have rated their ratings with a NULL value.

SELECT rev_name
FROM reviewer re
INNER JOIN rating ra
on ra.[rev_id]=re.[rev_id]
WHERE rev_stars IS NULL;

--2. Write a query in SQL to list the first and last names of all the actors 
--who were cast in the movie 'Annie Hall', and the roles they played in that production.
select [act_fname],[act_lname],mc.[role]
from [actor] a
inner join [movie_cast] mc
on mc.[act_id]=a.[act_id]
inner join [movie] m
on m.[mov_id]=mc.[mov_id]
where m.[mov_title]='Annie Hall';

--or

SELECT act_fname,act_lname,role
  FROM actor 
	  JOIN movie_cast ON actor.act_id=movie_cast.act_id
		JOIN movie ON movie_cast.mov_id=movie.mov_id 
		  AND movie.mov_title='Annie Hall';

--3. Write a query in SQL to find the name of movie and director (first and last names) 
--who directed a movie that casted a role for 'Eyes Wide Shut'

select [mov_title],[dir_fname],[dir_lname]
from [dbo].[movie] m
join [dbo].[movie_direction] md
on md.[mov_id]=m.[mov_id] and [mov_title]='Eyes Wide Shut'
join [dbo].[director] d
on d.[dir_id]=md.[dir_id];

--4. Write a query in SQL to find the name of movie and director (first and last names) 
--who directed a movie that casted a role as Sean Maguire.. 

SELECT dir_fname, dir_lname, mov_title
from [dbo].[movie] m
join [dbo].[movie_cast] mc
on mc.[mov_id]=m.[mov_id] and [role]='Sean Maguire'
join [dbo].[movie_direction] md
on md.[mov_id]=m.[mov_id]
join [dbo].[director] d
on d.[dir_id]=md.[dir_id]

--OR

SELECT dir_fname, dir_lname, mov_title
FROM  director, movie_direction, movie, movie_cast
WHERE director.dir_id=movie_direction.dir_id
AND movie_direction.mov_id=movie.mov_id
AND movie.mov_id=movie_cast.mov_id
AND movie_cast.role='Sean Maguire';

--5. Write a query in SQL to list all the actors who have not acted in any movie between 1990 and 2000
select distinct a.*,mov_title, m.[mov_year]
from	[dbo].[actor] as a, 
		[dbo].[movie_cast] as mc,
		[dbo].[movie] as m
where	a.[act_id]=mc.[act_id]
		and mc.[mov_id]=m.[mov_id]
		and m.[mov_year] not between '1990' and '2000' -- NOT BETWEEN 1990 and 2000 bu da calisir
		
--OR

SELECT distinct act_fname, act_lname, mov_title, mov_year
FROM actor
JOIN movie_cast 
ON actor.act_id=movie_cast.act_id
JOIN movie 
ON movie_cast.mov_id=movie.mov_id
WHERE mov_year NOT BETWEEN 1990 and 2000;

--6. Write a query in SQL to list first and last name of all the directors with number of genres movies 
--the directed with genres name, and arranged the result alphabetically with the first and last name of the director. 

select	distinct [dir_fname],[dir_lname],[gen_title], 
		count(*) over (partition by [gen_title],[dir_fname],[dir_lname]) as num_of_genre
from [dbo].[director] as d
join [dbo].[movie_direction] as md
on md.[dir_id]=d.[dir_id]
join [dbo].[movie_genres] as mg
on mg.[mov_id]=md.[mov_id]
join [dbo].[genres] as g
on g.[gen_id]=mg.[gen_id]
order by [dir_fname],[dir_lname]

--OR

SELECT dir_fname,dir_lname, gen_title, count(gen_title) num_of_genre
from [dbo].[director] as d
join [dbo].[movie_direction] as md
on md.[dir_id]=d.[dir_id]
join [dbo].[movie_genres] as mg
on mg.[mov_id]=md.[mov_id]
join [dbo].[genres] as g
on g.[gen_id]=mg.[gen_id]
GROUP BY dir_fname, dir_lname, gen_title
ORDER BY dir_fname,dir_lname;

--7. Write a query in SQL to list all the movies with year and genres. . 
select distinct m.[mov_id], [mov_title],[mov_year],[gen_title]
from [dbo].[movie] as m,[dbo].[movie_genres] as mg, [dbo].[genres] as g
where	m.[mov_id]=mg.[mov_id]
		and mg.[gen_id]=g.[gen_id]
order by m.[mov_id]

--OR 

select distinct m.[mov_id], [mov_title], [mov_year], [gen_title]
from [dbo].[genres] as g 
join [dbo].[movie_genres] as mg
on mg.[gen_id]=g.[gen_id]
join [dbo].[movie] as m
on m.[mov_id]=mg.[mov_id]
order by m.[mov_id];

--8. Write a query in SQL to list all the movies with year, genres, and name of the director.

select distinct m.[mov_id], [mov_title], [mov_year], [gen_title], [dir_fname],[dir_lname]
from [dbo].[genres] as g 
join [dbo].[movie_genres] as mg
on mg.[gen_id]=g.[gen_id]
join [dbo].[movie] as m
on m.[mov_id]=mg.[mov_id]
left join [dbo].[movie_direction] as md
on md.[mov_id]=m.[mov_id]
left join [dbo].[director] as d
on d.[dir_id]=md.[dir_id]
order by m.[mov_id];

--9. Write a query in SQL to list all the movies with title, year, date of release, movie duration,
--and first and last name of the director which released before 1st january 1989,
--and sort the result set according to release date from highest date to lowest.

select distinct m.[mov_id], [mov_title], [mov_year],[mov_dt_rel],[mov_time],[dir_fname],[dir_lname]
from [dbo].[movie_direction] as md
right join [dbo].[movie] as m
on m.[mov_id]=md.[mov_id]
left join [dbo].[director] as d
on d.[dir_id]=md.[dir_id]
--where year([mov_dt_rel])<1989
WHERE mov_dt_rel <'01/01/1989'
order by [mov_dt_rel] desc;

--or 

SELECT distinct movie.mov_title, mov_year, mov_dt_rel,
       mov_time,dir_fname, dir_lname 
FROM movie
JOIN  movie_direction 
   ON movie.mov_id = movie_direction.mov_id
JOIN director 
   ON movie_direction.dir_id=director.dir_id
WHERE mov_dt_rel <'01/01/1989'
ORDER BY mov_dt_rel desc;

--10. Write a query in SQL to compute a report which contain the genres of
--those movies with their average time and number of movies for each genres. 

select [gen_title], COUNT(mg.[mov_id]) num_of_movies, avg([mov_time]) avg_of_duration
from [dbo].[genres] g
left join [dbo].[movie_genres] mg
on mg.[gen_id]=g.[gen_id]
join [dbo].[movie] m
on m.[mov_id]=mg.[mov_id]
group by [gen_title]

--11. Write a query in SQL to find those lowest duration movies along with the year, 
--director's name, actor's name and his/her role in that production.

select top 1 [mov_title],[mov_year],[dir_fname],[dir_lname],[act_fname],[act_lname],[role],[mov_time]
from [dbo].[movie] m
join [dbo].[movie_direction] md
on md.[mov_id]=m.[mov_id]
join [dbo].[director] d
on d.[dir_id]=md.[dir_id]
join [dbo].[movie_cast] mc
on mc.[mov_id]=m.[mov_id]
join [dbo].[actor] a
on a.[act_id]=mc.[act_id]
order by [mov_time] asc;

--12. Write a query in SQL to find all the years which produced a movie that received a rating of 3 or 4, 
--and sort the result in increasing order.

SELECT DISTINCT [mov_title], [rev_stars], [mov_year]
FROM movie m
INNER JOIN [dbo].[rating] r
on r.[mov_id]=m.[mov_id]
WHERE rev_stars IN (3,4)
ORDER BY mov_year;

--OR
SELECT DISTINCT [mov_title], [rev_stars], [mov_year]
FROM movie, rating
WHERE movie.mov_id = rating.mov_id 
AND rev_stars IN (3, 4)
ORDER BY mov_year;

--13. Write a query in SQL to return the reviewer name, movie title, and stars in an order that reviewer name 
--will come first, then by movie title, and lastly by number of stars.

select distinct [rev_stars], [mov_title], [rev_name]
from [dbo].[reviewer] re
join [dbo].[rating] ra
on ra.[rev_id]=re.[rev_id]
join [dbo].[movie] m
on m.[mov_id]=ra.[mov_id]
order by [rev_stars] desc;

--14. Write a query in SQL to find movie title and number of stars for each movie 
--that has at least one rating and find the highest number of stars that movie received and sort the result by movie title. 

select distinct [mov_title], [rev_stars]
from [dbo].[movie] m
join [dbo].[rating] r
on r.[mov_id]=m.[mov_id]
where [num_o_ratings]>0
order by [mov_title];

--OR

SELECT mov_title, MAX(rev_stars)
FROM movie m
INNER JOIN rating r
on r.mov_id=m.[mov_id]
GROUP BY mov_title 
HAVING MAX(rev_stars)>0
ORDER BY mov_title;

--15. Write a query in SQL to find the director's first and last name together 
--with the title of the movie(s)they directed and received the rating.

select distinct [dir_fname],[dir_lname],[mov_title]
from [dbo].[director] d
join [dbo].[movie_direction] md
on md.[dir_id]=d.[dir_id]
join [dbo].[movie] m
on m.[mov_id]=md.[mov_id]
order by [dir_fname],[dir_lname];

--16. Write a query in SQL to find the movie title, actor first and last name, and the role for those movies 
--where one or more actors acted in two or more movies. 

select distinct [mov_title],[act_fname],[act_lname],[role]
from [dbo].[movie] m
join [dbo].[movie_cast] mc
on mc.[mov_id]=m.[mov_id]
join [dbo].[actor] a
on a.[act_id]=mc.[act_id]
order by [mov_title];

--17. Write a query in SQL to find the first and last name of a director and the movie he or she directed, 
--and the actress appeared which first name was Claire and last name was Danes along with her role in that movie.

select distinct [mov_title],[dir_fname], [dir_lname], [act_fname],[act_lname],[role]
from [dbo].[movie] m
join [dbo].[movie_cast] mc
on mc.[mov_id]=m.[mov_id]
join [dbo].[actor] a
on a.[act_id]=mc.[act_id]
join [dbo].[movie_direction] md
on md.[mov_id]=m.[mov_id]
join [dbo].[director] d
on d.[dir_id]=md.[dir_id]
where	trim([act_fname])= 'Claire' 
		and
		trim([act_lname])= 'Danes';

--18. Write a query in SQL to find the first and last name of an actor with their role in the movie 
--which was also directed by themselve. 

select distinct [mov_title],[dir_fname], [dir_lname], [act_fname],[act_lname]
from [dbo].[movie] m
join [dbo].[movie_cast] mc
on mc.[mov_id]=m.[mov_id]
join [dbo].[actor] a
on a.[act_id]=mc.[act_id]
join [dbo].[movie_direction] md
on md.[mov_id]=m.[mov_id]
join [dbo].[director] d
on d.[dir_id]=md.[dir_id]
where	[act_fname]=[dir_fname]
		and
		[act_lname]= [dir_lname];

--19. Write a query in SQL to find the cast list for the movie Chinatown.  

select distinct [act_fname],[act_lname],[mov_title]
from [dbo].[actor] a
join [dbo].[movie_cast] mc
on mc.[act_id]=a.[act_id]
join [dbo].[movie] m
on m.[mov_id]=mc.[mov_id]
where [mov_title]='Chinatown';

--20. Write a query in SQL to find the movie in which the actor appeared 
--whose first and last name are 'Harrison' and 'Ford'

select distinct [act_fname],[act_lname],[mov_title]
from [dbo].[actor] a
join [dbo].[movie_cast] mc
on mc.[act_id]=a.[act_id]
join [dbo].[movie] m
on m.[mov_id]=mc.[mov_id]
where [act_fname]='Harrison'
		and [act_lname]='Ford';

--21. Write a query in SQL to find the highest-rated movie, and report its title, year, rating, and releasing country.
select distinct [mov_title],[mov_year],rev_stars,[mov_rel_country]
from [dbo].[movie] m
join [dbo].[rating] ra
on ra.[mov_id]=m.mov_id
where rev_stars= (
						select MAX(rev_stars)
						from [dbo].[rating]
							)

--22. Write a query in SQL to find the highest-rated Mystery movie, and report the title, year, and rating. 

select distinct top 1 [mov_title],[mov_year],rev_stars,[gen_title]
from [dbo].[movie] m
join [dbo].[movie_genres] mg
on mg.[mov_id]=m.[mov_id]
join [dbo].[rating] r
on r.[mov_id]=m.[mov_id]
join [dbo].[genres] g
on g.[gen_id]=mg.[gen_id]
where [gen_title]='Mystery'
order by rev_stars desc;

--23. Write a query in SQL to generate a report which shows the year when most of the Mystery movies produces, 
--and number of movies and their average rating.

select	distinct [mov_year], [gen_title], count([mov_title]) over(partition by [mov_year]) as num_of_movies
		,AVG(rev_stars) over(partition by [mov_year]) as avg_of_rating
from [dbo].[movie] m
join [dbo].[movie_genres] mg
on mg.[mov_id]=m.[mov_id]
join [dbo].[rating] r
on r.[mov_id]=m.[mov_id]
join [dbo].[genres] g
on g.[gen_id]=mg.[gen_id]
where [gen_title]='Mystery'
order by avg_of_ratings desc;

--OR

SELECT mov_year,gen_title,count(gen_title) num_of_movies, avg(rev_stars) avg_of_rating
FROM [dbo].[movie] m
join [dbo].[movie_genres] mg
on mg.[mov_id]=m.[mov_id]
join [dbo].[rating] r
on r.[mov_id]=m.[mov_id]
join [dbo].[genres] g
on g.[gen_id]=mg.[gen_id]
WHERE gen_title='Mystery' 
GROUP BY mov_year,gen_title;


--24. Write a query in SQL to generate a report which contain the columns movie title, 
--name of the female actor, year of the movie, role, movie genres, the director, date of release, 
--and rating of that movie.

select distinct [mov_title],[dir_fname], [dir_lname],[gen_title], [act_fname], [act_lname], [role], [mov_year],[mov_dt_rel],[rev_stars]
from [dbo].[actor] a
join [dbo].[movie_cast] mc
on mc.[act_id]=a.[act_id]
full join [dbo].[movie] m
on m.[mov_id]=mc.[mov_id]
full join [dbo].[movie_genres] mg
on mg.[mov_id]=m.[mov_id]
full join [dbo].[genres] g
on g.[gen_id]=mg.[gen_id]
full join [dbo].[rating] r
on r.[mov_id]=m.[mov_id]
full join [dbo].[movie_direction] md
on md.[mov_id]=m.[mov_id]
full join [dbo].[director] d
on d.[dir_id]=md.[dir_id]
where [act_gender] ='F';

--25. Write a query that returns the shortest and longest actor name and number of characters in a table. 
--If the number of characters in the name is the same, it will look in the dictionary order.

select * 
from (
	select top 1 act_fname, LEN(act_fname) name_len 
	from actor 
	order by name_len ASC, act_fname ASC) TblMin
UNION
select * 
from (
	select top 1 act_fname, LEN(act_fname) name_len 
	from actor 
	order by name_len desc, act_fname desc) TblMax


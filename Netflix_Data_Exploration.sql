--1. Count the number of Movies vs TV Shows
Select type,Count(*) [Count] from NetflixData
Group by type;

--2. Find the most common rating for movies and TV shows
Select type,[Rating Count],rating from(
Select type,rating,Count(*)[Rating Count],
Rank() Over(partition by type order by Count(*) desc) [Ranking]
from NetflixData
Group by type,rating) a
Where [Ranking] = 1;

--3. List all movies released in a specific year (e.g., 2020)
Select title,release_year,type from NetflixData
where type='Movie' and release_year='2020';

--4. Find the top 5 countries with the most content on Netflix
Select Top 5 Countries,COUNT(Countries) Content from
(SELECT Trim(value) AS Countries  
FROM NetflixData  
CROSS APPLY STRING_SPLIT(country, ',')
)a
Group by Countries
Order By 2 Desc;

--5. Identify the longest movie
Select TOP 1title,MAX(CAST(LEFT(Duration, CHARINDEX('min', Duration) - 1)as int)) [Max _Duration]  from NetflixData
where type like 'Movie'
Group By title 
Order By 2 desc;
	
--6. Find content added in the last 5 years
Select * from NetflixData
where (CAST(date_added AS DATE) > DATEADD(YEAR,-5,GETDATE()) )

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
Select type,title,director from NetflixData
where director like '%Rajiv Chilaka%'

--8. List all TV shows with more than 5 seasons
Select title,duration from NetflixData 
where Cast(LEFT(duration,CHARINDEX('Season',duration)-1)as int)>5 and type like 'TV Show'
	
--9. Count the number of content items in each genre
Select Genre,Count(*) from(
Select value as Genre from NetflixData Cross Apply string_split(listed_in,','))a
Group by Genre
Order by 1;

--10.Find each year and the average numbers of content release in India on netflix. 
SELECT release_year,Total_Release,AVG(Total_Release*0.1) from
(Select YEAR(cast(date_added as date))as release_year ,COUNT(*) [Total_Release]
from NetflixData
where country like 'India'
Group by YEAR(cast(date_added as date)))a
group by release_year,Total_Release;

--11. List all movies that are documentaries 
Select title,listed_in from NetflixData
where listed_in like '%Documentaries%';

--12. Find all content without a director
Select * from NetflixData
where director is null;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
Select title,release_year from NetflixData
where cast like '%Salman Khan%' and 
release_year >=  year(Dateadd(year,-10,(getdate()))) 
	
--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
Select Top 10 actors,COUNT(actors)[Total Movies] from
(Select country,title,value as actors from NetflixData cross apply string_split(cast,',')
where country like '%India%')a
group by actors
order by 2 desc;

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--   the description field. Label content containing these keywords as 'Bad' and all other 
--   content as 'Good'. Count how many items fall into each category.
Select Category,Count(*) [Total Items] from
(
Select *,
Case
	When 
		description like '%kill%' OR description like '%Voilence%'
	Then 'Bad'
	Else 'Good'
	End Category
from NetflixData)containt_type
Group By Category;



Select * from NetflixData






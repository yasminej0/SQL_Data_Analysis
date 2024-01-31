--EDA:
--1.Check the number of unique apps in both tables
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM applesStore_description_combined
--2.Check for missing values in key fields
SELECT COUNT(*) as MissingValues
from AppleStore 
WHERE track_name is NULL or user_rating is NULL or prime_genre is null
 
SELECT COUNT(*) as MissingValues
from applesStore_description_combined
where app_desc is NULL
--3.Find the number of apps per genre
SELECT prime_genre,COUNT(DISTINCT id) as NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC
--4.Get an overview of apps ratings
SELECT track_name as AppName,user_rating as UserRating
FROM AppleStore
GROUP by track_name
order by user_rating DESC
--5.Determine wether paid apps have higher ratings than free apps
SELECT CASE
     when price>0 THEN 'paid'
     ELSE 'Free'
  END AS App_type,
  avg(user_rating) as AvgRating
 FROM AppleStore
 GROUP BY App_type
--6.Check if apps withe more supported language have higher ratings
SELECT CASE
     when lang_num<10 THEN '<10 languages'
     when lang_num BETWEEN 10 and 30 THEN '10-30 languages'
     ELSE '>30 languages'
  END AS Supp_lang,
  avg(user_rating) as AvgRating
 FROM AppleStore
 GROUP BY Supp_lang
 ORDER by AvgRating DESC
 --7.Check genre with low ratings 
 SELECT prime_genre ,avg(user_rating) as AvgRating
 from AppleStore
 group BY prime_genre
 order by AvgRating 
  LIMIT 10
--8.Check if any correlation beteween  length and user rating
SELECT CASE
     when length(d.app_desc)<500 THEN 'Short'
     when length(d.app_desc) BETWEEN 500 and 1000 THEN 'Medium'
     ELSE 'Long'
  END AS Description_length,
  avg(a.user_rating) as AvgRating
 FROM AppleStore as a
 join applesStore_description_combined as d
 ON  a.id=d.id
 GROUP BY Description_length
 ORDER by AvgRating DESC
 --9.Check the top-rated apps for each genre 
  SELECT
 	prime_genre,
    track_name,
    user_rating
 FROM(
	 SELECT
 	prime_genre,
    track_name,
    user_rating,
    RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating desc, rating_count_tot DESC) 
    AS rank
    FROM
    AppleStore
  )AS a
  WHERE
  a.rank=1
---------------------------
--Insights:
--Paid apps  have better ratings 
--Apps supporting between 10 and 3 languages have better ratings 
--Finance adn book apps have low ratings (new market penetration)
--apps with a longer description have better ratings
--A new app should aim for an average rating above 3.5 
--Games and entertainement have high competition (high user demand /market saturation)

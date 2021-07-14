--combining two table by Eric

WITH on_both_stores AS(SELECT a.name AS aname, a.price::money AS aprice, a.rating AS arating, a.review_count AS areview,
					   		  p.name AS pname, p.price::money AS pprice, p.rating AS prating, p.review_count AS preview
		FROM app_store_apps AS a INNER JOIN play_store_apps AS p
		 ON a.name=p.name)
	
SELECT aname, arating, prating, aprice, pprice
FROM on_both_stores;

--- life span +income&cost
WITH projected_lifespan AS (SELECT *,
							CASE 
							    WHEN rating < 0.5 THEN 12
								WHEN rating < 1.0 THEN 24
								WHEN rating < 1.5 THEN 36
								WHEN rating < 2.0 THEN 48
								WHEN rating < 2.5 THEN 60
								WHEN rating < 3.0 THEN 72
								WHEN rating < 3.5 THEN 84
								WHEN rating < 4.0 THEN 96
								WHEN rating < 4.5 THEN 108
								WHEN rating < 5.0 THEN 120
							    WHEN rating = 5.0 THEN 132
							END AS projected_lifespan_months
				            FROM app_store_apps)
SELECT *,
      (projected_lifespan_months*5000)::money as app_income,
	  (projected_lifespan_months*1000)::money as app_spanding,
	  
	   CASE 
	       WHEN price > 0.00 THEN price * 10000
		   ELSE 10000.00 END AS app_cost
	   
	   
FROM projected_lifespan



--top 10 on review_count
--all free
--games/SNS/music/bible!!
SELECT *
FROM app_store_apps
ORDER BY review_count::numeric DESC
LIMIT 10 

--top10 on rating
--13 games / Domino/photo&video 2 / shopping/Finance/SNS
SELECT *
FROM app_store_apps
WHERE rating = 5.0
ORDER BY review_count::numeric DESC
LIMIT 20


--top 10 on review count <> games

SELECT *
FROM app_store_apps
WHERE rating = 5.0
AND primary_genre <> 'Games'
ORDER BY review_count::numeric DESC
LIMIT 10



---top 100 on genre
SELECT COUNT(primary_genre) as genre_count
FROM app_store_apps
WHERE rating = 5.0
GROUP BY primary_genre
--ORDER BY review_count::numeric DESC
LIMIT 100

						
--general recommandation on genre /contents rating/price range
                   WITH top100 as (SELECT * 
								   FROM app_store_apps
								   WHERE rating = 5.0
								   ORDER BY review_count::numeric DESC
								   LIMIT 100)
							
                    SELECT primary_genre,COUNT(primary_genre) as genre_count
                    FROM top100
                    GROUP BY primary_genre
					ORDER BY genre_count DESC
							
--content_rating
                   WITH top100 as (SELECT * 
								   FROM app_store_apps
								   WHERE rating = 5.0
								   ORDER BY review_count::numeric DESC
								   LIMIT 100)
							
                    SELECT content_rating,COUNT(content_rating) as c_rating_count
                    FROM top100
                    GROUP BY content_rating
					ORDER BY c_rating_count DESC

--price_range
	             WITH top100 as (SELECT * 
								  FROM app_store_apps
								  WHERE rating = 5.0
								  ORDER BY review_count::numeric DESC
								  LIMIT 100)
							
                    SELECT price,COUNT(price) as price_count
                    FROM top100
                    GROUP BY price
					ORDER BY price_count DESC
							
						
-- content_rating % for apple							
SELECT content_rating, 
	   COUNT(content_rating), 
		     ROUND((COUNT(content_rating)/(SELECT COUNT(*) FROM APP_Store_apps)::numeric)*100,2) AS percent_of_all_rating
FROM App_store_apps
GROUP BY content_rating
ORDER BY percent_of_all_rating DESC
LIMIT 5;


-- price range
SELECT content_rating, 
	   COUNT(content_rating), 
	   ROUND((COUNT(content_rating)/(SELECT COUNT(*) FROM APP_Store_apps)::numeric)*100,2) AS percent_of_all_rating
FROM App_store_apps
GROUP BY content_rating
ORDER BY percent_of_all_rating DESC
LIMIT 5;
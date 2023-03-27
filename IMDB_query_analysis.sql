USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name, table_rows
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'imdb';



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- select *
-- from information_schema.columns 
-- where table_name = 'movie' 
-- ORDER BY ordinal_position;

-- select * from movie;
-- show columns from movie;     -- same as desc movie;
-- desc movie;

SELECT column_name
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_name = 'movie'
  ORDER BY ordinal_position;


-- select count(*) from movie where title is null;

select sum(isnull(title)) from movie;
select sum(isnull(year)) from movie;
select sum(isnull(date_published)) from movie;
select sum(isnull(duration)) from movie;
select sum(isnull(country)) from movie; 				 -- null present 
select sum(isnull(worlwide_gross_income)) from movie;	-- null present
select sum(isnull(languages)) from movie;				-- null present
select sum(isnull(production_company)) from movie;		-- null present





-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    year as Year, COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY year;


SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
    movie
GROUP BY month_num
ORDER BY month_num;





/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(*) AS movies_US_Ind
FROM
    movie
WHERE
    ( country LIKE '%INDIA%' OR country LIKE '%USA%' ) 
    AND year = 2019;





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT
    genre
FROM
    genre;





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    g.genre, COUNT(id) AS total_movies
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY genre
ORDER BY total_movies DESC
limit 1;





/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


with movie_with_one_genre as (
SELECT 
    id, COUNT(DISTINCT genre) AS genre_cnt
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY id
)
SELECT 
    COUNT(*) AS cnt_moviesOneGenre
FROM
    movie_with_one_genre
WHERE
    genre_cnt = 1;





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, ROUND(AVG(duration),2) AS avg_duration
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY genre;






/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH cte as (
SELECT 
    g.genre, COUNT(id) AS movie_count,
    rank() over (order by COUNT(id) desc) as genre_rank
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY genre
) 
select * from cte where genre = 'Thriller';


-- Thriller movies is in top 3 among all genres in terms of number of movies




/*
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
    ratings;


-- So, the minimum and maximum values in each column of the ratings table are in the expected range. 
-- This implies there are no outliers in the table.

    

/*  
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT 
    title, avg_rating,
    ROW_NUMBER() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM
    ratings r
        INNER JOIN
    movie m ON r.movie_id = m.id
LIMIT 10;






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, COUNT(*) AS movie_count
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
GROUP BY median_rating
ORDER BY movie_count desc;


-- Movies with a median rating of 7 is highest in number. 



/* 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH cte as(
SELECT 
    production_company, count(id) AS movie_count,
    DENSE_RANK() OVER (ORDER BY count(*) DESC) AS prod_company_rank
FROM
    ratings r
        INNER JOIN
    movie m ON r.movie_id = m.id
WHERE avg_rating > 8 AND production_company IS NOT NULL
GROUP BY production_company
) 
select * from cte where prod_company_rank = 1;







-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, COUNT(id) AS movie_count
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    genre g ON g.movie_id = m.id
WHERE
    year = 2017
        AND MONTH(date_published) = 3
        AND country like '%USA%'
        AND total_votes > 1000
GROUP BY genre
ORDER BY movie_count desc;






-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    title, avg_rating, genre
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    genre g ON m.id = g.movie_id
WHERE 
avg_rating > 8
AND 
title LIKE 'The%'
ORDER BY genre;






-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
    COUNT(id) AS movie_count
FROM
    movie AS m
        INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01';






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    country, SUM(total_votes) AS totalVotes
FROM
    ratings r
        INNER JOIN
    movie m ON m.id = r.movie_id
WHERE
    country IN ('Germany' , 'Italy')
GROUP BY country;



-- We can say that German movies get more votes than Italian movies.



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(ISNULL(name)) AS name_nulls,
    SUM(ISNULL(height)) AS height_nulls,
    SUM(ISNULL(date_of_birth)) AS date_of_birth_nulls,
    SUM(ISNULL(known_for_movies)) AS known_for_movies_nulls
FROM
    names;

-- Thus, There are no Null value in the column 'name'



/* .
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



WITH t1 AS (SELECT 
            genre
        FROM
            genre g
                INNER JOIN
            movie m ON g.movie_id = m.id
                INNER JOIN
            ratings r ON m.id = r.movie_id
        WHERE
			avg_rating > 8
        GROUP BY genre
        ORDER BY COUNT(*) DESC
        LIMIT 3)
SELECT 
    n.name, COUNT(m.id) AS movie_count
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    director_mapping dm ON dm.movie_id = m.id
        INNER JOIN
    names n ON dm.name_id = n.id,
    t1
WHERE
    g.genre IN (t1.genre)
	AND r.avg_rating > 8
GROUP BY name
ORDER BY movie_count DESC
LIMIT 3
;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?

SELECT 
    name, COUNT(*) AS movie_count
FROM
    names n
        INNER JOIN
    role_mapping rm ON n.id = rm.name_id
        INNER JOIN
    ratings r ON r.movie_id = rm.movie_id
WHERE
    median_rating >= 8 
    AND category="actor"
GROUP BY name
ORDER BY movie_count DESC
LIMIT 2;






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    production_company, 
    SUM(total_votes) AS vote_count,
    RANK() OVER ( ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
GROUP BY production_company
LIMIT 3;






/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
    name AS actor_name,
    SUM(total_votes) AS total_votes,
    COUNT(*) AS movie_count,
    ROUND(SUM(total_votes * avg_rating) / SUM(total_votes), 2) AS actor_avg_rating,
	rank() over (order by round(sum(total_votes*avg_rating)/sum(total_votes),2) desc , sum(total_votes) desc) as actor_rank
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    role_mapping rm ON m.id = rm.movie_id
        INNER JOIN
    names n ON rm.name_id = n.id
WHERE
    m.country = 'India'
        AND category = 'actor'
GROUP BY actor_name
HAVING movie_count >= 5;






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. 
-- If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
    name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(*) AS movie_count,
    ROUND(SUM(total_votes * avg_rating) / SUM(total_votes),
            2) AS actress_avg_rating,
	rank() over (order by round(sum(total_votes*avg_rating)/sum(total_votes),2) desc , sum(total_votes) desc) as actress_rank
FROM
    movie m
        INNER JOIN
    ratings r ON m.id = r.movie_id
        INNER JOIN
    role_mapping rm ON m.id = rm.movie_id
        INNER JOIN
    names n ON rm.name_id = n.id
WHERE
    m.country = 'India'
	AND category = 'actress'
	AND languages = 'Hindi'
GROUP BY actress_name
HAVING movie_count >= 3
LIMIT 5;







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

with movie_type_info AS
(
SELECT 
    id,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS movie_type
FROM
    movie m
        INNER JOIN
    ratings r ON r.movie_id = m.id
		INNER JOIN
	genre g ON g.movie_id = m.id
WHERE genre = 'Thriller'
)
SELECT 
    movie_type, COUNT(*) AS total_movies
FROM
    movie_type_info
GROUP BY movie_type;









/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT     title,
           genre,
           duration,
           sum(duration) OVER w AS running_total_duration,
           avg(duration) OVER w AS moving_avg_duration
FROM       movie m
INNER JOIN genre g
ON         g.movie_id = m.id 
WINDOW w AS (PARTITION BY genre ORDER BY duration ROWS UNBOUNDED PRECEDING)
ORDER BY   genre;




-- Round is good to have and not a must have; Same thing applies to sorting




-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- cleaning worlwide_gross_income column
SELECT 
    worlwide_gross_income
FROM
    movie
ORDER BY worlwide_gross_income DESC;

-- Few values are in INR , rest are in $, so clean this column first

drop view if exists grossincome;
CREATE VIEW grossincome AS
(SELECT 
	id,
    worlwide_gross_income,
    CASE
        WHEN
            worlwide_gross_income LIKE 'INR%'
        THEN
            ROUND(CONVERT( SUBSTRING(worlwide_gross_income, 5) , UNSIGNED) * 0.012)
        ELSE CONVERT(SUBSTRING(worlwide_gross_income, 3), UNSIGNED)
    END AS gross_income_cleaned
FROM
    movie
ORDER BY worlwide_gross_income DESC);




WITH top_genres AS
(
           SELECT     genre,
                      Count(*)
           FROM       genre g
           INNER JOIN movie m
           ON         g.movie_id = m.id
           GROUP BY   genre
           ORDER BY   Count(*) DESC limit 3), 
info AS
(
           SELECT     g.genre,
                      year,
                      title AS movie_name,
                      gi.gross_income_cleaned,
                      Dense_rank() OVER (partition BY year ORDER BY gross_income_cleaned DESC) AS movie_rank
           FROM       movie m
           INNER JOIN grossincome gi
           using     (id)
           INNER JOIN genre g
           ON         g.movie_id = m.id,
                      top_genres
           WHERE      g.genre IN (top_genres.genre) )
SELECT *
FROM   info
WHERE  movie_rank <= 5 ;







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- checking for multilingual movies
SELECT production_company,title,languages,median_rating
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
WHERE  languages LIKE '%,%'
       AND median_rating >= 8; 



SELECT     production_company,
           Count(*)                                   AS movie_count,
           Dense_rank() OVER (ORDER BY Count(*) DESC) AS prod_comp_rank
FROM       movie m
INNER JOIN ratings r
ON         m.id = r.movie_id
WHERE      languages LIKE '%,%'
AND        median_rating >= 8
AND        production_company IS NOT NULL
GROUP BY   production_company limit 2;



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT n.NAME                                                     AS actress_name,
       Sum(total_votes)                                           AS total_votes,
       Count(*)                                                   AS movie_count,
       Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) AS actress_avg_rating,
       Dense_rank() OVER (ORDER BY Round(Sum(total_votes * avg_rating) / Sum(total_votes), 2) desc,
       Sum(total_votes) DESC)                 AS actress_rank
FROM   movie m
       INNER JOIN ratings r
               ON m.id = r.movie_id
       INNER JOIN genre g
               ON g.movie_id = m.id
       INNER JOIN role_mapping rm
               ON m.id = rm.movie_id
       INNER JOIN names n
               ON n.id = rm.name_id
WHERE  rm.category = 'actress'
       AND avg_rating > 8
       AND genre = 'Drama'
GROUP  BY NAME
LIMIT 3; 






/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH top9 AS
(
           SELECT     name_id                                   AS director_id,
                      NAME                                      AS director_name,
                      Count(*)                                  AS number_of_movies,
                      Row_number() OVER(ORDER BY Count(*) DESC) AS rank_
           FROM       director_mapping                          AS dm
           INNER JOIN names n
           ON         dm.name_id = n.id
           INNER JOIN movie m
           ON         dm.movie_id = m.id
           GROUP BY   name_id 
           limit 9), 
           
publish_info AS
(
           SELECT top9.*
                      ,
                      m.id,
                      m.title,
                      m.date_published,
                      m.duration,
                      Lead(date_published,1) OVER (partition BY director_id ORDER BY director_id,date_published) AS next_published_date
           FROM       movie m
           INNER JOIN director_mapping dm
           ON         m.id = dm.movie_id,
                      top9
           WHERE      dm.name_id IN (top9.director_id)
)
SELECT     pi.director_id,
           pi.director_name,
           pi.number_of_movies ,
           Round(Avg(Datediff(next_published_date, date_published))) AS avg_inter_movie_days,
           Round(Sum(total_votes*avg_rating)/Sum(total_votes), 2)    AS avg_rating,
           Sum(total_votes)                                          AS total_votes,
           Min(avg_rating)                                           AS min_rating,
           Max(avg_rating)                                           AS max_rating,
           Sum(duration)                                             AS total_movie_durations
FROM       publish_info pi
INNER JOIN ratings r
ON         pi.id = r.movie_id
GROUP BY   pi.director_id
ORDER BY   pi.rank_;





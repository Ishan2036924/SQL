USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    TABLE_NAME, TABLE_ROWS AS Row_Count
FROM
    INFORMATION_SCHEMA.TABLES
WHERE
    TABLE_SCHEMA = 'imdb'
ORDER BY Row_Count DESC;

/* Output:
'TABLE_NAME', 'Row_Count'
'names', '25735'
'role_mapping', '15615'
'genre', '14662'
'ratings', '7997'
'movie', '7997'
'director_mapping', '3867'

below are the 2 views displayed in the output-
'avg_diff_between_movie_dates', 'NULL'
'top_directors', 'NULL'
*/







-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS id_null_count,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_null_count,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_null_count,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_null_count,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_null_count,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_null_count,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worlwide_gross_income_null_count,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_null_count,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_null_count
FROM
    movie;

/* columns with null values along with their count according to the output
'country', '20'
'languages', '194'
'production_company', '528'
'worlwide_gross_income', '3724'
*/




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
    Year, COUNT(id) AS Number_Of_Movies
FROM
    movie
GROUP BY Year
ORDER BY COUNT(id) DESC;

/*
output:
Year Number_Of_Movies
'2017', '3052'
'2018', '2944'
'2019', '2001'
*/

SELECT 
    MONTH(date_published) AS month_num,
    COUNT(id) AS Number_Of_Movies
FROM
    movie
GROUP BY MONTH(date_published)
ORDER BY month_num ASC;


/* 
output:
month_num  number_Of_movies
'3', '824'
'9', '809'
'1', '804'
'10', '801'
'4', '680'
'8', '678'
'2', '640'
'5', '625'
'11', '625'
'6', '580'
'7', '493'
'12', '438'
 */






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(id) AS 'Movies_produced_India_or_USA_2019'
FROM
    movie
WHERE
    year = 2019
        AND (country LIKE '%USA%'
        OR country LIKE '%India%');

-- output:
-- Movies_produced_India_or_USA_2019- 1059








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT DISTINCT
    (genre) AS Unique_genres
FROM
    genre;


/*
output:
Type    
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/








/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


SELECT 
    g.genre AS Highest_Produced_Genre,
    COUNT(m.id) AS Count_Of_Movies
FROM
    genre g
       INNER JOIN
    movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY COUNT(m.id) DESC
LIMIT 1;

-- output:
-- 'Drama', '4285'








/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


SELECT 
    COUNT(*) AS Number_Of_Movies_Having_1_Genre
FROM
    (SELECT 
        movie_id
    FROM
        genre
    GROUP BY movie_id
    HAVING COUNT(genre) = 1) mg1;

-- output:
-- '3289'








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
    g.genre AS genre, ROUND(AVG(m.duration), 2) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY avg_duration DESC;

/*
output:
genre      avg_duration
'Action', '112.88'
'Romance', '109.53'
'Crime', '107.05'
'Drama', '106.77'
'Fantasy', '105.14'
'Comedy', '102.62'
'Adventure', '101.87'
'Mystery', '101.80'
'Thriller', '101.58'
'Family', '100.97'
'Others', '100.16'
'Sci-Fi', '97.94'
'Horror', '92.72'
*/






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


WITH Genres AS 
(
    SELECT g.genre, 
           COUNT(m.id) AS movie_count, 
           RANK()
			OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
    FROM genre g
		INNER JOIN movie m
			ON g.movie_id = m.id
    GROUP BY g.genre
)
SELECT *
FROM Genres
WHERE genre = 'Thriller';

/*
output:
genre, movie_Count, genre_rank
'Thriller', '1484', '3'
*/







/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
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
    MAX(median_rating) AS max_median_rting
FROM
    ratings;

/*
output:
min_avg_rating	max_avg_rating	min_total_votes   max_total_votes  min_median_rating  max_median_rating
'1.0', '10.0', '100', '725138', '1', '10'
*/




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
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
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)

WITH movies_rank AS
(
	SELECT m.title,
		r.avg_rating,
		Dense_rank()
			OVER (ORDER BY r.avg_rating DESC) AS movie_rank
	FROM   movie m
		INNER JOIN ratings r
			ON m.id = r.movie_id
	)
SELECT *
FROM   movies_rank
WHERE  movie_rank <= 10;

/*
output:
Title,Average_Rating,Movie_Rank
'Kirket', '10.0', '1'
'Love in Kilnerry', '10.0', '1'
'Gini Helida Kathe', '9.8', '2'
'Runam', '9.7', '3'
'Android Kunjappan Version 5.25', '9.6', '4'
'Fan', '9.6', '4'
'Safe', '9.5', '5'
'The Brighton Miracle', '9.5', '5'
'Yeh Suhaagraat Impossible', '9.5', '5'
'Ananthu V/S Nusrath', '9.4', '6'
*/







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
    median_rating,
    COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY movie_count DESC; 

/*
output:
median_rating, movie_count
'7', '2257'
'6', '1975'
'8', '1030'
'5', '985'
'4', '479'
'9', '429'
'10', '346'
'3', '283'
'2', '119'
'1', '94'
*/







/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH Hit_Movies_Rating AS 
(
    SELECT 
        m.production_company AS production_company, 
        COUNT(m.id) AS movie_count, 
        DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank 
    FROM movie m
		INNER JOIN ratings r
			ON m.id = r.movie_id 
    WHERE r.avg_rating > 8
    AND m.production_company IS NOT NULL
    GROUP BY m.production_company
)
SELECT *
FROM Hit_Movies_Rating
WHERE Prod_Company_Rank = 1;

/*
output:
Production_Company,Movie_Count,Prod_Company_Rank
'Dream Warrior Pictures', '3', '1'
'National Theatre Live', '3', '1'
*/







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
    genre,
    COUNT(id) AS movie_count
FROM
    genre g
INNER JOIN
    movie m
ON
    m.id = g.movie_id
INNER JOIN
    ratings r
ON
    m.id = r.movie_id
WHERE
    MONTH(date_published) = 3
    AND YEAR(date_published) = 2017
    AND total_votes > 1000
    AND country LIKE '%USA%'
GROUP BY
    genre
ORDER BY
    movie_count DESC;

/*
output:
genre,movie_count
'Drama', '24'
'Comedy', '9'
'Action', '8'
'Thriller', '8'
'Sci-Fi', '7'
'Crime', '6'
'Horror', '6'
'Mystery', '4'
'Romance', '4'
'Fantasy', '3'
'Adventure', '3'
'Family', '1'
*/





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

SELECT m.title, 
	r.avg_rating,
    g.genre
FROM movie m
	INNER JOIN ratings r 
		ON m.id = r.movie_id
	INNER JOIN genre g 
		ON m.id = g.movie_id
WHERE m.title LIKE 'The%' 
    AND r.avg_rating > 8
ORDER BY r.avg_rating DESC;


/*
output:
Title,Avg_Ratingm,Genre
The Brighton Miracle	9.5	Drama
The Colour of Darkness	9.1	Drama
The Blue Elephant 2	8.8	Drama
The Blue Elephant 2	8.8	Horror
The Blue Elephant 2	8.8	Mystery
The Irishman	8.7	Crime
The Irishman	8.7	Drama
The Mystery of Godliness: The Sequel	8.5	Drama
The Gambinos	8.4	Crime
The Gambinos	8.4	Drama
Theeran Adhigaaram Ondru	8.3	Action
Theeran Adhigaaram Ondru	8.3	Crime
Theeran Adhigaaram Ondru	8.3	Thriller
The King and I	8.2	Drama
The King and I	8.2	Romance

*/





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT COUNT(id) AS Movie_released_april2018_april2019
FROM movie m
	INNER JOIN ratings r
		ON m.id = r.movie_id
WHERE
    (date_published BETWEEN '2018-04-01' AND '2019-04-01')
    AND (median_rating = 8);

/*
output:
Movie_released_april2018_april2019
'361'
*/






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    m.country, 
    SUM(r.total_votes) AS Total_Votes
FROM movie m
	INNER JOIN ratings r 
		ON r.movie_id = m.id
WHERE m.country IN ('Germany', 'Italy')
GROUP BY m.country;

/*
output:
Germany	106710
Italy	77965
*/






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
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
    END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
    END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
    END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
    END) AS known_for_movies_nulls
FROM
    names;

/*
output:
name_nulls,height_nulls,date_of_birth_nulls,known_for_movies_nulls
'0', '17335', '13431', '15226'
*/





/* There are no Null value in the column 'name'.
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


WITH Top_3_Genres AS 
(
    SELECT g.genre
    FROM genre g
    INNER JOIN movie m 
		ON g.movie_id = m.id
    INNER JOIN ratings r
		ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY COUNT(m.id) DESC
    LIMIT 3
)
SELECT n.name AS director_name, 
       COUNT(d.movie_id) AS movie_count
FROM director_mapping d
INNER JOIN names n 
	ON d.name_id = n.id
INNER JOIN movie m 
	ON d.movie_id = m.id
INNER JOIN ratings r 
	ON m.id = r.movie_id
JOIN genre g 
	ON g.movie_id = m.id
WHERE r.avg_rating > 8 
  AND g.genre IN 
	(
		SELECT genre 
        FROM Top_3_Genres)
GROUP BY n.name
ORDER BY movie_count DESC
LIMIT 3;

/*
output:
director_name,movie_count
'James Mangold', '4'
'Anthony Russo', '3'
'Joe Russo', '3'
*/






/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT n.name AS actor_name,
    COUNT(m.id) AS movie_count
FROM movie m
	INNER JOIN ratings r 
		ON m.id = r.movie_id
	INNER JOIN role_mapping rm 
		ON m.id = rm.movie_id
	INNER JOIN names n
		ON n.id = rm.name_id
WHERE median_Rating >= 8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/*
output:
actor_name,movie_count
'Mammootty', '8'
'Mohanlal', '5'
*/






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


WITH pcvotes AS 
(
    -- adding the total votes for each individual production company from the movie table after joining with ratings table
    SELECT 
        m.production_company, 
        SUM(r.total_votes) AS vote_count
    FROM movie m
    INNER JOIN ratings r
		ON m.id = r.movie_id
    WHERE m.production_company IS NOT NULL
    GROUP BY m.production_company
)
-- Ranking the production companies based on the higher number of votes
SELECT 
    production_company, 
    vote_count,
    RANK()
		OVER (ORDER BY vote_count DESC) AS prod_comp_rank
FROM pcvotes
ORDER BY prod_comp_rank
LIMIT 3;

/*
output:
production_company,vote_count,prod_comp_rank
'Marvel Studios', '2656967', '1'
'Twentieth Century Fox', '2411163', '2'
'Warner Bros.', '2396057', '3'
*/







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
	n.name AS actor_name, 
	SUM(r.total_votes) AS total_votes, 
	COUNT(m.id) AS movie_count, 
	SUM(r.total_votes * r.avg_rating) / SUM(r.total_votes) AS actor_avg_rating,
	ROW_NUMBER()
	OVER (ORDER BY  ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actor_rank
FROM
    names n
INNER JOIN
    role_mapping rm 
		ON n.id = rm.name_id
INNER JOIN ratings r 
		ON rm.movie_id = r.movie_id
INNER JOIN movie m 
	ON m.id = rm.movie_id
WHERE
    category = "actor"
    AND country LIKE "%india%"
GROUP BY actor_name
HAVING movie_count >= 5;

/*
output:
actor_name,total_votes,movie_count,actor_avg_rting,actor_rank
'Vijay Sethupathi', '23114', '5', '8.41673', '1'
'Fahadh Faasil', '13557', '5', '7.98604', '2'
'Yogi Babu', '8500', '11', '7.83018', '3'
'Joju George', '3926', '5', '7.57967', '4'
'Ammy Virk', '2504', '6', '7.55383', '5'
'Dileesh Pothan', '6235', '5', '7.52133', '6'
'Kunchacko Boban', '5628', '6', '7.48351', '7'
'Pankaj Tripathi', '40728', '5', '7.43706', '8'
'Rajkummar Rao', '42560', '6', '7.36701', '9'
'Dulquer Salmaan', '17666', '5', '7.30087', '10'
'Amit Sadh', '13355', '5', '7.21306', '11'
'Tovino Thomas', '11596', '8', '7.14540', '12'
'Mammootty', '12613', '8', '7.04208', '13'
'Nassar', '4016', '5', '7.03312', '14'
'Karamjit Anmol', '1970', '6', '6.90863', '15'
'Hareesh Kanaran', '3196', '5', '6.57747', '16'
'Naseeruddin Shah', '12604', '5', '6.53622', '17'
'Anandraj', '2750', '6', '6.53571', '18'
'Mohanlal', '17622', '7', '6.46746', '19'
'Aju Varghese', '2237', '5', '6.43375', '20'
'Siddique', '5953', '7', '6.42565', '21'
'Prakash Raj', '8548', '6', '6.37126', '22'
'Jimmy Sheirgill', '3826', '6', '6.28772', '23'
'Mahesh Achanta', '2716', '6', '6.21141', '24'
'Biju Menon', '1916', '5', '6.21091', '25'
'Suraj Venjaramoodu', '4284', '6', '6.18625', '26'
'Abir Chatterjee', '1413', '5', '5.80078', '27'
'Sunny Deol', '4594', '5', '5.70509', '28'
'Radha Ravi', '1483', '5', '5.70223', '29'
'Prabhu Deva', '2044', '5', '5.68014', '30'
'Atul Sharma', '9604', '5', '4.78024', '31'
*/






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
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

WITH ActressRatings AS (
    -- Calculate weighted average rating and total votes for each actress in Hindi Indian movies
    SELECT 
        n.name AS actress_name, 
        SUM(r.total_votes) AS total_votes, 
        COUNT(m.id) AS movie_count, 
        SUM(r.total_votes * r.avg_rating) / SUM(r.total_votes) AS actress_avg_rating
    FROM movie m
    JOIN role_mapping rm ON m.id = rm.movie_id
    JOIN names n ON rm.name_id = n.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.country = 'India' 
      AND m.languages LIKE '%Hindi%' 
      AND rm.category = 'actress'
    GROUP BY n.name
    HAVING COUNT(m.id) >= 3
)
-- Rank actresses based on their weighted average rating and use total_votes as a tie breaker
SELECT 
    actress_name, 
    total_votes, 
    movie_count, 
    ROUND(actress_avg_rating, 2) AS avg_rating,
    RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM ActressRatings
ORDER BY actress_rank
LIMIT 5;

/*
output:
actress_name,total_votes,movie_count,avg_rating,actress_rank
'Taapsee Pannu', '18061', '3', '7.74', '1'
'Kriti Sanon', '21967', '3', '7.05', '2'
'Divya Dutta', '8579', '3', '6.88', '3'
'Shraddha Kapoor', '26779', '3', '6.63', '4'
'Kriti Kharbanda', '2549', '3', '4.80', '5'
*/







/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:


SELECT 
    m.title AS movie_name,
    CASE 
        WHEN r.avg_rating > 8 THEN 'Superhit'
        WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        WHEN r.avg_rating < 5 THEN 'Flop'
    END AS movie_category
FROM movie m
JOIN ratings r ON m.id = r.movie_id  -- Join the movie table with ratings table
JOIN genre g ON m.id = g.movie_id  -- Join the genre table to access movie genre
WHERE g.genre LIKE '%Thriller%'  -- Adjusting to include movies where genre contains 'Thriller'
  AND r.total_votes >= 25000  -- Assuming the number of votes is in the ratings table
ORDER BY r.avg_rating DESC;

/*
output:
'Joker', 'Superhit'
'Andhadhun', 'Superhit'
'Ah-ga-ssi', 'Superhit'
'Contratiempo', 'Superhit'
'Mission: Impossible - Fallout', 'Hit'
'Forushande', 'Hit'
'Searching', 'Hit'
'Get Out', 'Hit'
'Hotel Mumbai', 'Hit'
'John Wick: Chapter 3 - Parabellum', 'Hit'
'John Wick: Chapter 2', 'Hit'
'Miss Sloane', 'Hit'
'Den skyldige', 'Hit'
'Good Time', 'Hit'
'Shot Caller', 'Hit'
'Split', 'Hit'
'Elle', 'Hit'
'First Reformed', 'Hit'
'Brimstone', 'Hit'
'The Mule', 'Hit'
'The Killing of a Sacred Deer', 'Hit'
'The Foreigner', 'Hit'
'Widows', 'One-time-watch'
'Us', 'One-time-watch'
'The Autopsy of Jane Doe', 'One-time-watch'
'Thoroughbreds', 'One-time-watch'
'Glass', 'One-time-watch'
'Atomic Blonde', 'One-time-watch'
'Venom', 'One-time-watch'
'Jungle', 'One-time-watch'
'The Equalizer 2', 'One-time-watch'
'The Fate of the Furious', 'One-time-watch'
'Hunter Killer', 'One-time-watch'
'Anna', 'One-time-watch'
'Red Sparrow', 'One-time-watch'
'Halloween', 'One-time-watch'
'Life', 'One-time-watch'
'Happy Death Day', 'One-time-watch'
'Peppermint', 'One-time-watch'
'Annabelle: Creation', 'One-time-watch'
'Roman J. Israel, Esq.', 'One-time-watch'
'Alien: Covenant', 'One-time-watch'
'The Commuter', 'One-time-watch'
'The Ritual', 'One-time-watch'
'Fractured', 'One-time-watch'
'Revenge', 'One-time-watch'
'The Beguiled', 'One-time-watch'
'American Assassin', 'One-time-watch'
'Maze Runner: The Death Cure', 'One-time-watch'
'Scary Stories to Tell in the Dark', 'One-time-watch'
'Mile 22', 'One-time-watch'
'The Belko Experiment', 'One-time-watch'
'The Perfection', 'One-time-watch'
'Captive State', 'One-time-watch'
'Kidnap', 'One-time-watch'
'Annabelle Comes Home', 'One-time-watch'
'Skyscraper', 'One-time-watch'
'Pet Sematary', 'One-time-watch'
'Jigsaw', 'One-time-watch'
'Would You Rather', 'One-time-watch'
'Velvet Buzzsaw', 'One-time-watch'
'Insidious: The Last Key', 'One-time-watch'
'Sleepless', 'One-time-watch'
'In the Tall Grass', 'One-time-watch'
'Mute', 'One-time-watch'
'The Curse of La Llorona', 'One-time-watch'
'The Circle', 'One-time-watch'
'The Nun', 'One-time-watch'
'Geostorm', 'One-time-watch'
'Serenity', 'One-time-watch'
'Robin Hood', 'One-time-watch'
'xXx: Return of Xander Cage', 'One-time-watch'
'Rough Night', 'One-time-watch'
'Truth or Dare', 'One-time-watch'
'Fifty Shades Freed', 'Flop'
'The Open House', 'Flop'
'Race 3', 'Flop'
*/






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


WITH Average_Movie_Duration AS (
    SELECT 
        g.genre, 
        ROUND(AVG(m.duration), 2) AS avg_duration
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    GROUP BY g.genre
)
SELECT 
    genre, 
    avg_duration,
    SUM(avg_duration) OVER (ORDER BY avg_duration DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_duration,
    AVG(avg_duration) OVER (ORDER BY avg_duration DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg_duration
FROM Average_Movie_Duration;

/*
output:
'Action', '112.88', '112.88', '112.880000'
'Romance', '109.53', '222.41', '111.205000'
'Crime', '107.05', '329.46', '109.820000'
'Drama', '106.77', '436.23', '109.057500'
'Fantasy', '105.14', '541.37', '108.274000'
'Comedy', '102.62', '643.99', '107.331667'
'Adventure', '101.87', '745.86', '106.551429'
'Mystery', '101.80', '847.66', '105.957500'
'Thriller', '101.58', '949.24', '105.471111'
'Family', '100.97', '1050.21', '105.021000'
'Others', '100.16', '1150.37', '104.579091'
'Sci-Fi', '97.94', '1248.31', '104.025833'
'Horror', '92.72', '1341.03', '103.156154'
*/






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

WITH Top_3_Genres AS (
    SELECT 
        g.genre, 
        COUNT(m.id) AS movie_count, 
        RANK() OVER (ORDER BY COUNT(m.id) DESC) AS genre_rank
    FROM genre g
    LEFT JOIN movie m ON g.movie_id = m.id
    GROUP BY g.genre
),
Highest_Grossing AS (
    SELECT 
        g.genre AS Genre, 
        m.year AS Year, 
        m.title AS Movie_Name, 
        m.worlwide_gross_income AS Worldwide_Gross_Income, 
        RANK() OVER (PARTITION BY g.genre, m.year
                     ORDER BY CONVERT(REPLACE(TRIM(m.worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS Movie_Rank
    FROM movie m
    JOIN genre g ON g.movie_id = m.id
    WHERE g.genre IN (SELECT genre FROM Top_3_Genres WHERE genre_rank <= 3)
)
SELECT 
    Genre, 
    Year, 
    Movie_Name, 
    Worldwide_Gross_Income
FROM Highest_Grossing
WHERE Movie_Rank < 6
ORDER BY Year;

/*
output:
'Comedy', '2017', 'Despicable Me 3', '$ 1034799409'
'Comedy', '2017', 'Jumanji: Welcome to the Jungle', '$ 962102237'
'Comedy', '2017', 'Guardians of the Galaxy Vol. 2', '$ 863756051'
*/







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


WITH Ranked_Prod_Comp AS (
    SELECT 
        m.production_company,
        COUNT(r.movie_id) AS movie_count,
        RANK() OVER (ORDER BY COUNT(r.movie_id) DESC) AS prod_comp_rank
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.production_company IS NOT NULL 
      AND r.median_rating >= 8 
      AND m.languages LIKE '%,%'
    GROUP BY m.production_company
)
SELECT 
    production_company, 
    movie_count, 
    prod_comp_rank
FROM Ranked_Prod_Comp
WHERE prod_comp_rank <= 2;

/*
output:
'Star Cinema', '7', '1'
'Twentieth Century Fox', '4', '2'
*/





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:

WITH Ranked_Actress AS (
    SELECT 
        n.name AS Actress_Name, 
        SUM(ra.total_votes) AS Total_Votes, 
        COUNT(n.id) AS Movie_Count,
        SUM(ra.avg_rating * ra.total_votes) / SUM(ra.total_votes) AS Actress_Avg_Rating
    FROM names n
    JOIN role_mapping r ON n.id = r.name_id
    JOIN movie m ON r.movie_id = m.id
    JOIN ratings ra ON m.id = ra.movie_id
    JOIN genre g ON m.id = g.movie_id
    WHERE r.category = 'actress' 
      AND g.genre = 'drama' 
      AND ra.avg_rating > 8
    GROUP BY n.name
)
SELECT 
    Actress_Name, 
    Total_Votes, 
    Movie_Count, 
    Actress_Avg_Rating,
    ROW_NUMBER() OVER (ORDER BY Actress_Avg_Rating DESC, Total_Votes DESC, Actress_Name) AS Actress_Rank
FROM Ranked_Actress
LIMIT 3;

/*
output:t
'Sangeetha Bhat', '1010', '1', '9.60000', '1'
'Adriana Matoshi', '3932', '1', '9.40000', '2'
'Fatmire Sahiti', '3932', '1', '9.40000', '3'
*/






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


CREATE VIEW avg_diff_between_movie_dates AS
WITH movie_dates AS (
    SELECT
        nm.id AS director_id,
        nm.name AS director_name,
        m.id AS movie_id,
        m.date_published AS movie_date,
        LEAD(m.date_published, 1) OVER (PARTITION BY nm.name ORDER BY m.date_published) AS next_movie_date
    FROM
        names nm
    INNER JOIN
        director_mapping dm ON nm.id = dm.name_id
    INNER JOIN
        movie m ON dm.movie_id = m.id
)
SELECT
    director_id,
    director_name,
    AVG(DATEDIFF(next_movie_date, movie_date)) AS avg_inter_movie_days
FROM
    movie_dates
GROUP BY
    director_id, director_name;

-- Create the top_directors view
CREATE VIEW top_directors AS
WITH top_directors_cte AS (
    SELECT
        nm.id AS director_id,
        nm.name AS director_name,
        COUNT(DISTINCT dm.movie_id) AS number_of_movies,
        ROUND(AVG(r.avg_rating), 2) AS avg_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        SUM(m.duration) AS total_duration,
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT dm.movie_id) DESC) AS director_rank
    FROM
        names nm
    INNER JOIN
        director_mapping dm ON nm.id = dm.name_id
    INNER JOIN
        movie m ON dm.movie_id = m.id
    INNER JOIN
        ratings r ON m.id = r.movie_id
    GROUP BY
        nm.id, nm.name
)
SELECT
    director_id,
    director_name,
    number_of_movies,
    avg_rating,
    total_votes,
    min_rating,
    max_rating,
    total_duration,
    director_rank
FROM top_directors_cte;

-- Final query to select top directors
SELECT
    td.director_id,
    td.director_name,
    td.number_of_movies,
    avgd.avg_inter_movie_days AS avg_inter_movie_days,
    td.avg_rating,
    td.total_votes,
    td.min_rating,
    td.max_rating,
    td.total_duration
FROM
    top_directors td
LEFT JOIN
    avg_diff_between_movie_dates avgd ON td.director_id = avgd.director_id
WHERE
    td.director_rank <= 9
ORDER BY 
    td.number_of_movies DESC, 
    td.director_name;

/*
output:
'nm1777967', 'A.L. Vijay', '5', '176.7500', '5.42', '1754', '3.7', '6.9', '613'
'nm2096009', 'Andrew Jones', '5', '190.7500', '3.02', '1989', '2.7', '3.2', '432'
'nm0831321', 'Chris Stokes', '4', '198.3333', '4.33', '3664', '4.0', '4.6', '352'
'nm0425364', 'Jesse V. Johnson', '4', '299.0000', '5.45', '14778', '4.2', '6.5', '383'
'nm2691863', 'Justin Price', '4', '315.0000', '4.50', '5343', '3.0', '5.8', '346'
'nm6356309', 'Özgür Bakar', '4', '112.0000', '3.75', '1092', '3.1', '4.9', '374'
'nm0515005', 'Sam Liu', '4', '260.3333', '6.23', '28557', '5.8', '6.7', '312'
'nm0814469', 'Sion Sono', '4', '331.0000', '6.03', '2972', '5.4', '6.4', '502'
'nm0001752', 'Steven Soderbergh', '4', '254.3333', '6.48', '171684', '6.2', '7.0', '401'
*/





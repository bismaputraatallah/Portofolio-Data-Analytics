CREATE TABLE reviewers (
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
    );

CREATE TABLE series (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    released_year YEAR,
    genre VARCHAR(100)
    );

CREATE TABLE reviews (
	id INT PRIMARY KEY AUTO_INCREMENT,
    rating DECIMAL(2,1),
    series_id INT,
    reviewer_id INT,
    FOREIGN KEY (series_id) REFERENCES series (id),
    FOREIGN KEY (reviewer_id) REFERENCES reviewers (id)
    );
    
INSERT INTO series (title, released_year, genre) VALUES
    ('Archer', 2009, 'Animation'),
    ('Arrested Development', 2003, 'Comedy'),
    ("Bob's Burgers", 2011, 'Animation'),
    ('Bojack Horseman', 2014, 'Animation'),
    ("Breaking Bad", 2008, 'Drama'),
    ('Curb Your Enthusiasm', 2000, 'Comedy'),
    ("Fargo", 2014, 'Drama'),
    ('Freaks and Geeks', 1999, 'Comedy'),
    ('General Hospital', 1963, 'Drama'),
    ('Halt and Catch Fire', 2014, 'Drama'),
    ('Malcolm In The Middle', 2000, 'Comedy'),
    ('Pushing Daisies', 2007, 'Comedy'),
    ('Seinfeld', 1989, 'Comedy'),
    ('Stranger Things', 2016, 'Drama');
    
INSERT INTO reviewers (first_name, last_name) VALUES
    ('Thomas', 'Stoneman'),
    ('Wyatt', 'Skaggs'),
    ('Kimbra', 'Masters'),
    ('Domingo', 'Cortes'),
    ('Colt', 'Steele'),
    ('Pinkie', 'Petit'),
    ('Marlon', 'Crafford');

INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
    (1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
    (2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
    (3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
    (4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
    (5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
    (6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
    (7,2,9.1),(7,5,9.7),
    (8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
    (9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
    (10,5,9.9),
    (13,3,8.0),(13,4,7.2),
    (14,2,8.5),(14,3,8.9),(14,4,8.9);

-- series with most reviews 
SELECT
	s.title,
    COUNT(rs.series_id) AS total_reviews
FROM reviews rs 
	JOIN series s ON rs.series_id = s.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- genre with number reviews
SELECT
	s.genre,
    COUNT(rs.series_id) AS total_reviews
FROM reviews rs
	JOIN series s ON rs.series_id = s.id
GROUP BY 1
ORDER BY 2 DESC;
	


-- Which series have the highest and lowest average ratings?
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
(SELECT 
	'hisghest-rating' AS series_type,
	title,
    genre,
    ROUND(AVG(rating), 2) AS avg_rating
FROM reviews r
	JOIN series s ON r.series_id = s.id
GROUP BY 1,2,3
ORDER BY 4 DESC
LIMIT 1)
UNION
(SELECT
	'lowest-rating' AS series_type,
    title,
    genre,
    ROUND(AVG(rating), 2) AS avg_rating
FROM reviews r 
	JOIN series s ON r.series_id = s.id
GROUP BY 1,2,3
ORDER BY 4 ASC
LIMIT 1);

(SELECT 
	'hisghest-rating' AS series_type,
    genre,
    ROUND(AVG(rating), 2) AS avg_rating
FROM reviews r
	JOIN series s ON r.series_id = s.id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1)
UNION
(SELECT
	'lowest-rating' AS series_type,
    genre,
    ROUND(AVG(rating), 2) AS avg_rating
FROM reviews r 
	JOIN series s ON r.series_id = s.id
GROUP BY 1,2
ORDER BY 3 ASC
LIMIT 1);

-- Which reviewers have written the most reviews?
-- What is their average rating compared to others?
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
SELECT
	rv.id,
    CONCAT(first_name, ' ', last_name) AS name_reviewer,
    COUNT(rs.id) AS total_reviews,
    ROUND(AVG(rating), 2) AS avg_rating,
    (SELECT ROUND(AVG(rating), 2) FROM reviews) AS overall_avg
FROM reviewers rv
	JOIN reviews rs ON rv.id = rs.reviewer_id
GROUP BY 1
ORDER BY 3 DESC;

-- We want to know which series perform better than the global average — meaning, their own average rating is 
-- higher than the average of all series’ average ratings.
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
SELECT
	s.id,
	title,
    ROUND(AVG(rating), 2) AS avg_rating,
    (SELECT ROUND(AVG(rating), 2) FROM reviews) AS overall_average
FROM series s 
	JOIN reviews r ON s.id = r.series_id
GROUP BY 1,2
HAVING AVG(rating) > (SELECT ROUND(AVG(rating), 2) FROM reviews)
ORDER BY 3 DESC;

-- Find the most recent or oldest series by genre
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
(SELECT
	genre,
    title,
    released_year,
    'oldest-series' AS series_type
FROM series
WHERE (genre, released_year) IN (
			SELECT
				genre,
                MIN(released_year)
			FROM series
            GROUP BY 1))
UNION
(SELECT
	genre,
    title,
    released_year,
    'newest-series' AS series_type
FROM series
WHERE (genre, released_year) IN (
			SELECT
				genre,
                MAX(released_year)
			FROM series
            GROUP BY 1));


-- which year have most review
SELECT
	s.released_year,
    COUNT(r.id) AS num_reviews
FROM series s 
LEFT JOIN reviews r ON s.id = r.series_id
GROUP BY 1
ORDER BY 2 DESC;

-- How many reviews does each release year have on average?
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
SELECT
	s.released_year,
    ROUND(COUNT(r.id) * 1.0 / COUNT(DISTINCT s.id), 2) AS average_reviews_per_year
FROM series s 
LEFT JOIN reviews r ON s.id = r.series_id
GROUP BY 1
ORDER BY 2 DESC;

-- Which reviewers haven’t written any reviews?
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
SELECT 
	*
FROM reviewers r1
	LEFT JOIN reviews r2 ON r1.id = r2.reviewer_id
WHERE r2.id IS NULL;
-- For each genre, show: --
-- the number of series
-- the total number of reviews
-- the average rating
-- the reviewer who wrote the most reviews in that genre

SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
WITH genre_summary AS (
	SELECT
		s.genre,
		COUNT(DISTINCT s.id) AS num_series,
		COUNT(r.id) AS total_reviews,
		ROUND(AVG(r.rating), 2) AS avg_rating
	FROM series s 
		LEFT JOIN reviews r ON s.id = r.series_id
	GROUP BY 1),
	reviewer_rank AS (
		SELECT
			s.genre,
            r2.reviewer_id,
            CONCAT(rv.first_name, ' ', rv.last_name) AS reviewer_name,
            COUNT(r2.id) AS review_count,
            ROW_NUMBER() OVER (PARTITION BY s.genre ORDER BY COUNT(r2.id) DESC) AS rank_in_genre
		FROM series s
			JOIN reviews r2 ON s.id = r2.series_id
            JOIN reviewers rv ON r2.reviewer_id = rv.id
		GROUP BY 1, 2, 3)
SELECT
	g.genre,
    g.num_series,
    g.total_reviews,
    g.avg_rating,
    review_count
FROM genre_summary g
	JOIN reviewer_rank rr ON g.genre = rr.genre
WHERE rr.rank_in_genre = 1
ORDER BY g.avg_rating DESC;


SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
SELECT
	genre,
    CONCAT(r2.first_name, ' ', r2.last_name) AS name_reviewer,
    COUNT(s.id) AS num_series,
    COUNT(r1.id) AS num_reviews,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(reviewer_id) AS total_review
FROM series s
	JOIN reviews r1 ON s.id = r1.series_id
    JOIN reviewers r2 ON r1.reviewer_id = r2.id
GROUP BY 1, 2
ORDER BY 6 DESC;

SELECT
	released_year,
    COUNT(r.id) AS num_review
FROM series s
	JOIN reviews r ON r.series_id = s.id
GROUP BY 1
ORDER BY 2 DESC;


SELECT 
	title, 
    rating
FROM series s
	JOIN reviews r ON s.id = r.series_id
ORDER BY 2 DESC;

SELECT 
	title, 
    ROUND(AVG(rating), 2) as avg_rating
FROM series s
	JOIN reviews r ON s.id = r.series_id
GROUP BY 1
ORDER BY 2 ASC;

SELECT 
	title, 
	ROUND(AVG(rating), 2) AS avg_rating
FROM reviews r
	JOIN series s ON  s.id = r.series_id
GROUP BY 1
ORDER BY 2;

SELECT first_name,
	last_name,
    rating
FROM reviewers rs
JOIN reviews r ON r.reviewer_id = rs.id;

-- Find series unreview
SELECT 
	title AS unreviewed_series
FROM series s
	LEFT JOIN reviews r ON s.id = r.series_id
WHERE rating IS NULL;

SELECT 
	genre,
	ROUND(AVG(rating), 2) AS avg_rating
FROM series s 
	JOIN reviews r ON s.id = r.series_id
GROUP BY 1
ORDER BY 2;

-- Evaluate reviewer activity and rating behavior
SELECT
	CONCAT(first_name, ' ', last_name) AS reviewers,
	COUNT(rating) AS count,
	IFNULL(MAX(rating), 0) AS max,
	IFNULL(MIN(rating), 0) AS min,
	IFNULL(ROUND(AVG(rating), 2), 0) AS average,
	CASE 
		WHEN COUNT(rating) > 0 THEN 'ACTIVE'
        ELSE 'INACTIVE'
        END AS statues
FROM reviewers r
	LEFT JOIN reviews rs ON r.id = rs.reviewer_id
GROUP BY 1;

-- USING IF
SELECT 
    first_name,
    last_name,
    COUNT(rating) AS count,
    IFNULL(MIN(rating), 0) AS min,
    IFNULL(MAX(rating), 0) AS max,
    ROUND(IFNULL(AVG(rating), 0), 2) AS average,
    IF(COUNT(rating) > 0,
        'ACTIVE',
        'INACTIVE') AS status
FROM
    reviewers
        LEFT JOIN
    reviews ON reviewers.id = reviews.reviewer_id
GROUP BY first_name , last_name;

SELECT
	title,
    rating,
	CONCAT(first_name, ' ', last_name) AS reviewers
FROM reviews r
	JOIN reviewers rs ON rs.id = r.reviewer_id
	JOIN series s ON s.id = r.series_id
ORDER BY 1 ASC;

-- Find the top 3 reviewers who rated the most diverse genres
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
SELECT
	CONCAT(first_name, ' ', last_name) AS reviewers,
    COUNT(DISTINCT genre) AS num_genre
FROM reviewers rs 
	JOIN reviews r ON rs.id = r.reviewer_id
    JOIN series s ON r.series_id = s.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- Find reviewers that only review one genre
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
SELECT
	CONCAT(first_name, ' ', last_name) AS reviewers,
    COUNT(DISTINCT genre) AS num_genre
FROM reviewers rs 
	JOIN reviews r ON rs.id = r.reviewer_id
    JOIN series s ON r.series_id = s.id
GROUP BY 1
HAVING COUNT(DISTINCT genre) = 1;
-- none reviewers just review one genre

-- Series with fewer reviews than average
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
WITH cte_num AS (
	SELECT
		s.id,
		s.title,
		COUNT(r.series_id) AS num_reviews
	FROM series s
		JOIN reviews r ON s.id = r.series_id
	GROUP BY 1,2)
SELECT
	id,
	title,
	num_reviews,
	(SELECT AVG(num_reviews) FROM cte_num) AS avg_reviews
FROM cte_num
    WHERE num_reviews < (SELECT AVG(num_reviews) FROM cte_num);
    
-- For each genre, find the top-rated series (highest average rating).
-- If two series have the same rating, pick the one with more reviews.
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
WITH cte_avg_count AS (
	SELECT
		s.genre,
		s.id,
		title,
		ROUND(AVG(r.rating), 2) AS avg_rating,
		COUNT(r.series_id) AS num_series
	FROM series s 
		JOIN reviews r ON s.id = r.series_id
	GROUP BY 1,2,3), 
	cte_rank AS (
    SELECT
		*,
        DENSE_RANK() OVER (PARTITION BY genre ORDER BY avg_rating DESC, num_series DESC) AS rank_genre
	FROM cte_avg_count)
SELECT
	*
FROM cte_rank
WHERE rank_genre = 1;

-- For each series, show:
-- total number of reviews (popularity)
-- average rating (quality)
-- rank genres by popularity
-- rank genres by quality
-- and show whether a genre is “popular but low quality”, “low popular but high quality”, etc.
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
WITH cte_count_avg AS (
	SELECT
		s.title,
		COUNt(r.id) AS popularity,
		ROUND(AVG(rating), 2) AS quality
	FROM series s 
		JOIN reviews r ON s.id = r.series_id
	GROUP BY 1),
    cte_rank AS (
    SELECT
		title,
        popularity,
        quality,
        DENSE_RANK() OVER (ORDER BY popularity DESC) AS rank_popularity,
		DENSE_RANK() OVER (ORDER BY quality DESC) AS rank_quality
	FROM cte_count_avg)
SELECT 
	title,
    popularity,
    quality,
    CASE WHEN rank_popularity <= 3 AND rank_quality <= 3 THEN 'hight popularity & quality'
		WHEN rank_popularity > 3 AND rank_quality <= 3 THEN 'low  popularity but hight quality'
		WHEN rank_popularity <= 3 AND rank_quality > 3 THEN 'hight popularity but low quality'
    ELSE 'low popularity & quality' END AS category
FROM cte_rank
ORDER BY popularity DESC;

-- Case: Reviewer Consistency Score
-- Calculate a consistency score for each reviewer based on how stable their ratings are.
-- Formula (common for interviews):
-- Consistency = 1 / variance of ratings

-- SUMARY DATA
SELECT * FROM reviewers; SELECT * FROM reviews; SELECT * FROM series;
WITH genre_summary AS (
    SELECT
        s.genre,
        COUNT(DISTINCT s.id) AS num_series,
        COUNT(r.id) AS total_reviews,
        ROUND(AVG(r.rating), 2) AS avg_rating
    FROM series s
    LEFT JOIN reviews r ON s.id = r.series_id
    GROUP BY s.genre
), reviewer_rank AS (
    SELECT
        s.genre,
        CONCAT(rv.first_name, ' ', rv.last_name) AS top_reviewer,
        COUNT(r.id) AS review_count,
        ROW_NUMBER() OVER (
            PARTITION BY s.genre
            ORDER BY COUNT(r.id) DESC
        ) AS rn
    FROM series s
    JOIN reviews r ON s.id = r.series_id
    JOIN reviewers rv ON r.reviewer_id = rv.id
    GROUP BY s.genre, top_reviewer
)
SELECT
    g.genre,
    g.num_series,
    g.total_reviews,
    g.avg_rating,
    rr.top_reviewer,
    rr.review_count AS top_reviewer_reviews
FROM genre_summary g
LEFT JOIN reviewer_rank rr 
    ON g.genre = rr.genre
   AND rr.rn = 1
ORDER BY g.total_reviews DESC;

    
	
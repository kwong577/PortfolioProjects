-- Airbnb Data was obtained from http://insideairbnb.com/data-policies
-- This data is licensed under a Creative Commons Attribution 4.0 International License

-- Browse the entire dataset for listings
SELECT *
FROM PortfolioProject..listings_1

--- Browse the selected columns from the dataset
SELECT id, neighbourhood_cleansed, latitude, longitude, room_type, accommodates, price
FROM PortfolioProject..listings_1

--- Check for NULLS in the columns of interest
SELECT SUM(CASE WHEN id is null THEN 1 ELSE 0 END) AS [Number Of Null Values], COUNT(id) AS [Number Of Non-Null Values] 
FROM PortfolioProject..listings_1

SELECT SUM(CASE WHEN neighbourhood_cleansed is null THEN 1 ELSE 0 END) AS [Number Of Null Values], COUNT(neighbourhood_cleansed) AS [Number Of Non-Null Values] 
FROM PortfolioProject..listings_1

SELECT SUM(CASE WHEN latitude is null THEN 1 ELSE 0 END) AS [Number Of Null Values], COUNT(latitude) AS [Number Of Non-Null Values] 
FROM PortfolioProject..listings_1

SELECT SUM(CASE WHEN longitude is null THEN 1 ELSE 0 END) AS [Number Of Null Values], COUNT(longitude) AS [Number Of Non-Null Values] 
FROM PortfolioProject..listings_1

SELECT SUM(CASE WHEN room_type is null THEN 1 ELSE 0 END) AS [Number Of Null Values], COUNT(room_type) AS [Number Of Non-Null Values] 
FROM PortfolioProject..listings_1

SELECT SUM(CASE WHEN accommodates is null THEN 1 ELSE 0 END) AS [Number Of Null Values], COUNT(accommodates) AS [Number Of Non-Null Values] 
FROM PortfolioProject..listings_1

SELECT SUM(CASE WHEN price is null THEN 1 ELSE 0 END) AS [Number Of Null Values], COUNT(price) AS [Number Of Non-Null Values] 
FROM PortfolioProject..listings_1

--- Count the number of listings, grouping by neighbourhood_cleansed
SELECT neighbourhood_cleansed, COUNT(id) as listing_count, AVG(price) as avg_price
FROM PortfolioProject..listings_1
GROUP BY neighbourhood_cleansed

--- Create a new table for the above so that we can perform new calculations using the listing_count column
DROP TABLE if exists listing_proportion
CREATE TABLE listing_proportion
(
neighbourhood_cleansed nvarchar(255),
listing_count numeric,
avg_price float,
)
INSERT INTO listing_proportion
SELECT neighbourhood_cleansed, COUNT(id) as listing_count, AVG(price) as avg_price
FROM PortfolioProject..listings_1
GROUP BY neighbourhood_cleansed

--- Calculate the proportion of listings in each neighbourhood
WITH total as
    (SELECT SUM(listing_count) as total
    from listing_proportion)
SELECT neighbourhood_cleansed, listing_count, listing_count/total.total * 100 as proportion, avg_price
FROM listing_proportion,total
ORDER BY proportion

--- Create a view to store data for visualization
-- View to be used to create a pie graph to show proportion of listings in each neighbourhood and their average pricing
DROP VIEW if exists table_1
CREATE VIEW table_1 as
WITH total as
    (SELECT SUM(listing_count) as total
    from listing_proportion)
SELECT neighbourhood_cleansed, listing_count, listing_count/total.total * 100 as proportion, avg_price
FROM listing_proportion,total

--- Browse the selected columns from the dataset
SELECT id, neighbourhood_cleansed, price
FROM PortfolioProject..listings_1
ORDER BY neighbourhood_cleansed

--- Create a view to store data for visualization
-- View to be used to create a box and whisker plot to show distribution of listings within each neighbourhood
DROP VIEW if exists table_2
CREATE VIEW table_2 as
SELECT id, neighbourhood_cleansed, price
FROM PortfolioProject..listings_1

--- Calculate the average price of each room_type in each neighbourhood
SELECT neighbourhood_cleansed, room_type, COUNT(id) as listing_count, AVG(price) as avg_price
FROM PortfolioProject..listings_1
GROUP BY neighbourhood_cleansed, room_type
ORDER BY neighbourhood_cleansed, room_type

--- Create a view to store data for visualization
-- View to be used to create bar graphs to show the difference in listing count and average price for different room types in each neighbourhood
DROP VIEW if exists table_3
CREATE VIEW table_3 as
SELECT neighbourhood_cleansed, room_type, COUNT(id) as listing_count, AVG(price) as avg_price
FROM PortfolioProject..listings_1
GROUP BY neighbourhood_cleansed, room_type

--- Browse the selected columns from the dataset
SELECT neighbourhood_cleansed, accommodates, price
FROM PortfolioProject..listings_1
WHERE review_scores_rating is not NULL
ORDER BY 1,2

--- Calculate the average price, grouping by accommodation number
SELECT neighbourhood_cleansed, accommodates, AVG(price) as avg_price
FROM PortfolioProject..listings_1
WHERE review_scores_rating is not NULL
GROUP BY neighbourhood_cleansed, accommodates
ORDER BY 1,2

--- Create a view to store data for visualization
-- View to be used to create bar graphs to show the difference in accommodation number and average price for each neighbourhood
DROP VIEW if exists table_4
CREATE VIEW table_4 as
SELECT neighbourhood_cleansed, accommodates, AVG(price) as avg_price
FROM PortfolioProject..listings_1
WHERE review_scores_rating is not NULL
GROUP BY neighbourhood_cleansed, accommodates

--- Browse the selected columns from the dataset
SELECT accommodates, price
FROM PortfolioProject..listings_1

--- Create a view to store data for visualization
-- View to be used to create a scatter plot to show relationship between accommodation and price
DROP VIEW if exists table_5
CREATE VIEW table_5 as
SELECT accommodates, price
FROM PortfolioProject..listings_1

--- Browse the selected columns from the dataset
SELECT review_scores_rating, price
FROM PortfolioProject..listings_1
WHERE review_scores_rating is not NULL

--- Create a view to store data for visualization
-- View to be used to create a scatter plot to show relationship between review rating and price
DROP VIEW if exists table_6
CREATE VIEW table_6 as
SELECT review_scores_rating, price
FROM PortfolioProject..listings_1
WHERE review_scores_rating is not NULL
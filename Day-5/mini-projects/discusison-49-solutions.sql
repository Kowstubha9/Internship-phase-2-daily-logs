-- 1. Query the country table to select the Name, Continent, and Population.
select Name,continent,population from Country;

-- 2. Use aliases to rename the Name column to Country Name and the country table as c in your queries.
SELECT c.Name AS 'Country Name' FROM country c;

-- 3.  Find all countries in the 'Europe' continent with a population greater than 10 million.
SELECT Name, Population FROM country WHERE Continent = 'Europe' AND Population > 10000000;

-- 4. Retrieve all cities in 'Poland' or 'Belgium'.
SELECT Name, CountryCode FROM city WHERE CountryCode = 'POL' OR CountryCode = 'BEL';

-- 5. List all countries in 'South America' by their LifeExpectancy in descending order.
SELECT Name, LifeExpectancy FROM country WHERE Continent = 'South America' ORDER BY LifeExpectancy DESC;

-- 6. Get the top 5 largest cities by population in the database.
SELECT Name, Population FROM city ORDER BY Population DESC LIMIT 5;
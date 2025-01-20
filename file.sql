-- 1. new table certificates
CREATE TABLE certificates (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    person_id INT,
    CONSTRAINT fk_person FOREIGN KEY (person_id) REFERENCES person(id)
);

-- 2. new person/row to person table (random name, not my name)
INSERT INTO person (name, age) VALUES ('John Doe', 30);

-- 3. new row to certificates table, attach scrum to john doe
INSERT INTO certificates (name, person_id)
VALUES ('Scrum', (SELECT id FROM person WHERE name = 'John Doe'));

-- 4. sdd scrum and azure to others in the table
INSERT INTO certificates (name, person_id)
VALUES
    ('Scrum', (SELECT id FROM person WHERE name = 'Jack')),
    ('Azure', (SELECT id FROM person WHERE name = 'Alice')),
    ('Scrum', (SELECT id FROM person WHERE name = 'Bob')),
    ('Azure', (SELECT id FROM person WHERE name = 'Charlie'));

-- 5. query all scrum holders
SELECT p.*
FROM person p
JOIN certificates c ON p.id = c.person_id
WHERE c.name = 'Scrum';

-- 6. query all azure holders
SELECT p.*
FROM person p
JOIN certificates c ON p.id = c.person_id
WHERE c.name = 'Azure';

select * from person

-- all rows with coyntry_code FIN
select * from city where country_code = 'FIN'

-- how many cities can be found in the US
select count(*) as city_count
from city
where country_code = 'USA';

-- count the population of US cities
select sum(population) as population_count
from city
where country_code = 'USA';


-- list cities with populations between 1 and 2 million
SELECT name, population
FROM city
WHERE country_code = 'USA'
AND population BETWEEN 1000000 AND 2000000;

-- calculate the total population of cities in US states, grouped by state
SELECT district, SUM(population) AS total_population
FROM city
WHERE country_code = 'USA'
GROUP BY district
ORDER BY total_population DESC;

-- calculate which country has the highest life expectancy (null values not included, search result limited to one row)
SELECT name AS country_name, lifeexpectancy
FROM country
WHERE lifeexpectancy IS NOT NULL
ORDER BY lifeexpectancy DESC
LIMIT 1;

-- calculate total no. of inhabitants in all citis in a given country grouped by country
-- include relevant columns in the search result
-- include population column from the country table, the numbers should not add up
SELECT 
    c.name AS country_name, 
    c.population AS country_population, 
    SUM(ci.population) AS total_city_population
FROM 
    country c
JOIN 
    city ci 
ON 
    c.code = ci.country_code
GROUP BY 
    c.code, c.name, c.population
ORDER BY 
    total_city_population DESC;

-- list countries by capital, list all european countries and their cities
SELECT 
    c.name AS country_name, 
    ci.name AS city_name
FROM 
    country c
JOIN 
    city ci 
ON 
    c.code = ci.country_code
WHERE 
    c.continent = 'Europe'
ORDER BY 
    c.name, ci.name;

-- list all languages spoken in southeast asia region
SELECT 
    c.name AS country_name, 
    cl.language, 
    cl.isofficial, 
    cl.percentage
FROM 
    country c
JOIN 
    country_language cl 
ON 
    c.code = cl.country_code
WHERE 
    c.region = 'Southeast Asia'
ORDER BY 
    c.name, cl.language;


-- use subquery, all cities w. larger population than Finland
SELECT 
    ci.name AS city_name, 
    ci.population AS city_population
FROM 
    city ci
WHERE 
    ci.population > (
        SELECT c.population
        FROM country c
        WHERE c.name = 'Finland'
    )
ORDER BY 
    ci.population DESC;


-- with subquery, search all cities over 1 million ihabitants in countries where English is a spoken language
SELECT 
    ci.name AS city_name, 
    ci.population AS city_population, 
    c.name AS country_name
FROM 
    city ci
JOIN 
    country c 
ON 
    ci.country_code = c.code
WHERE 
    ci.population > 1000000 
    AND c.code IN (
        SELECT cl.country_code
        FROM country_language cl
        WHERE cl.language = 'English'
    )
ORDER BY 
    ci.population DESC;
-- Homework 8: Working with MySQL Queries --

USE sakila;

-- 1a.
SELECT first_name, last_name FROM actor;

-- 1b.
SELECT CONCAT(first_name, " ", last_name) as 'Actor Name' FROM actor;

-- 2a.
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

-- 2b.
SELECT * FROM actor WHERE last_name LIKE '%GEN%';

-- 2c.
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;

-- 2d.
SELECT country_id, country FROM country WHERE country IN ('Afghanistan','Bangladesh', 'China'); 

-- 3a.
ALTER TABLE actor ADD COLUMN middle_name VARCHAR(35) AFTER first_name;

-- 3b. 
ALTER TABLE actor MODIFY COLUMN middle_name BLOB;

-- 3c.
ALTER TABLE actor DROP COLUMN middle_name;

-- 4a.
SELECT last_name, COUNT(last_name) from actor GROUP BY last_name ORDER BY count(last_name) DESC; 

-- 4b.
SELECT last_name, COUNT(last_name) from actor GROUP BY last_name HAVING COUNT(last_name)>=2 ORDER BY count(last_name) DESC;

-- 4c. 
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4d.
UPDATE actor
SET	first_name = CASE 
	WHEN first_name = 'HARPO' THEN 'GROUCHO'
	ELSE 'MUCHO GROUCHO'
  END	
WHERE actor_id = 172;
        
-- 5a.
SHOW CREATE TABLE address;
-- Better than DESCRIBE

-- 6a.
SELECT staff.first_name, staff.last_name, address.address
FROM address
JOIN staff ON
staff.address_id=address.address_id;

-- 6b.
SELECT s.first_name, s.last_name, sum(p.amount) AS 'Total Rung Up' 
FROM
	staff s
    JOIN payment p 
    WHERE s.staff_id = p.staff_id 
    AND p.payment_date LIKE '2005-08-%'
    GROUP BY s.staff_id
    ORDER BY sum(p.amount) DESC;
    
-- 6c.
SELECT f.title, count(fa.actor_id) AS 'Number of Actors'
FROM 
	film f
	INNER JOIN film_actor fa
    ON f.film_id = fa.film_id
    GROUP BY f.film_id
    ORDER BY count(fa.actor_id) DESC;
    
-- 6d.
SELECT f.title, count(i.film_id) AS 'Number of Inventory'
FROM 
	film f
    INNER JOIN inventory i
    ON f.film_id = i.film_id
    WHERE f.title = 'Hunchback Impossible';
    
-- 6e.
SELECT c.first_name, c.last_name, sum(p.amount) AS 'Total Amt Paid'
FROM
	customer c
    JOIN payment p
    ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
    ORDER BY c.last_name ASC;
    
-- 7a.
SELECT title from film WHERE language_id in (SELECT language_id from language WHERE name = 'English') AND title in (SELECT title from film WHERE title LIKE 'K%' OR title LIKE 'Q%');

-- 7b.
SELECT first_name, last_name from actor WHERE actor_id in (SELECT actor_id FROM film_actor WHERE film_id in (SELECT film_id FROM film WHERE title = 'Alone Trip'));

-- 7c.
SELECT c.first_name, c.last_name, c.email, co.country
FROM 
	customer c
    JOIN address a ON
    c.address_id = a.address_id
    JOIN city ci ON
    a.city_id = ci.city_id
    JOIN country co ON
    ci.country_id = co.country_id
    WHERE co.country = 'Canada';

-- 7d.
SELECT f.*, cat.name as 'Category'
FROM 
	film f
    JOIN film_category fc ON
    f.film_id = fc.film_id
    JOIN category cat ON
    fc.category_id = cat.category_id
    WHERE cat.name = 'Family';
    
 -- 7e.
 SELECT f.film_id, f.title, f.rental_rate, f.length, f.rating, count(r.inventory_id) As 'Times Rented'
 FROM
	film f
    JOIN inventory i ON
    f.film_id = i.film_id
    JOIN rental r ON
    i.inventory_id = r.inventory_id
    GROUP BY f.title
    ORDER BY count(r.inventory_id) DESC LIMIT 20;
 
 -- 7f.
 SELECT s.store_id, SUM(p.amount) As 'Business'
 FROM 
	store s
	JOIN customer c ON
    s.store_id = c.store_id
    JOIN payment p ON
    c.customer_id = p.customer_id
    GROUP BY s.store_id;
    
-- 7g.
SELECT s.store_id As 'Store', ci.city As 'City', co.country As 'Country'
FROM
	store s
    JOIN address a ON
    s.address_id = a.address_id
    JOIN city ci ON
	a.city_id = ci.city_id
    JOIN country co ON
    ci.country_id = co.country_id;

-- 7h.
SELECT cat.name, sum(p.amount) As 'Gross Revenue'
FROM 
	category cat
    JOIN film_category fc ON
    cat.category_id = fc.category_id
    JOIN inventory i ON
    fc.film_id = i.film_id
    JOIN rental r ON
    i.inventory_id = r.inventory_id 
    JOIN payment p ON
    r.rental_id = p.rental_id
    GROUP BY cat.name
    ORDER BY sum(p.amount) DESC LIMIT 5;
    
-- 8a.
CREATE VIEW Top_Five_Genres AS
SELECT cat.name, sum(p.amount) As 'Gross Revenue'
FROM 
	category cat
    JOIN film_category fc ON
    cat.category_id = fc.category_id
    JOIN inventory i ON
    fc.film_id = i.film_id
    JOIN rental r ON
    i.inventory_id = r.inventory_id 
    JOIN payment p ON
    r.rental_id = p.rental_id
    GROUP BY cat.name
    ORDER BY sum(p.amount) DESC LIMIT 5;

-- 8b.
SELECT * FROM Top_Five_Genres;

-- 8c.
DROP VIEW Top_Five_Genres;


















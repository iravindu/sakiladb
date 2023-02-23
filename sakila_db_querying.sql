# Business Problems Relevant to film table
# 1. How Many Movies in the store and break it down by categories?
# 2. What is the AVERAGE Rental Duration and break it down by genre?
# 3. Top 10 most in demand movies by no. of rentals
# 4. Least demand movies (Bottom 10 by # of rentals)
# 5. What are the overdue movies and customer names


/* Workings */
SELECT * FROM FILM LIMIT 5;
SELECT count(film_id) AS 'Total No of Movies' from film;
SELECT AVG(rental_duration) AS 'Average Rental Duration' from film;

# Exploring the values of rental_duration and its distribution
SELECT DISTINCT rental_duration from film order by rental_duration desc;

# Distribution of rental_duration
SELECT rental_duration, COUNT(1) as count 
FROM film
GROUP BY rental_duration
ORDER BY rental_duration DESC;

# Movie Length Exploration
SELECT length, COUNT(1) as 'count of length'
from film
group by length
order by length desc;

# INNER JOIN film and inventory
SELECT count(film.film_id), film.title, film_actor.actor_id, actor.first_name
FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY film.title,film_actor.actor_id
order by first_name;

#---------------------------1---------------------------#
SELECT COUNT(film_id) AS 'Number of Films' from film_category;

SELECT category.name AS 'Category Name', count(*) AS 'Count of Category' from 
film_category INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.category_id;

#---------------------------2---------------------------#
SELECT AVG(rental_duration) AS 'Average Rental Duration' from film;

SELECT category.category_id,category.name as 'GENRE',
AVG(film.rental_duration) AS 'Average Rental Duration'
FROM film INNER JOIN film_category 
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
group by category.category_id
order by avg(film.rental_duration) DESC;

#---------------------------3---------------------------#
# top 10
SELECT inventory.film_id, count(rental.rental_id), film.title
FROM rental INNER JOIN inventory
ON rental.rental_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
group by inventory.film_id
order by count(rental.rental_id) desc
LIMIT 10;

#---------------------------4---------------------------#
# bottom 10 least demand movies
SELECT inventory.film_id, count(rental.rental_id), film.title
FROM rental INNER JOIN inventory
ON rental.rental_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id
group by inventory.film_id
order by count(rental.rental_id) asc
LIMIT 10;

#---------------------------5---------------------------#
select * from rental limit 5;
select customer_id, rental_id from rental
WHERE return_date IS NULL;

select COUNT(rental_id) from rental
WHERE return_date IS NULL;

#---------------------------SUBQUERIES---------------------------#
# Sub Query with SELECT clause
SELECT lastName, firstName from employees
WHERE officeCode IN(
SELECT officeCode from offices WHERE country = 'USA');

SELECT * FROM PAYMENTS;
# Sub Query with WHERE clause
# Returning the customer who has the highest payment amount
SELECT customerNumber, checkNumber from payments
WHERE amount = (SELECT MAX(amount) from payments);

# grab all of the movies from the film table that are in english yet have titles that start with the letter K 

SELECT film.title from film where
language_id IN(SELECT language_id from language where language.name = 'ENGLISH')
AND title like 'k%';

### IN acts as multiple OR statement
### USING Clause is used to match only one column when more than one column matches.
# find full name and address of customers who rented an action movie
SELECT CONCAT(first_name, " ", last_name) AS name, email 
FROM customer WHERE customer_id IN 
(SELECT customer_id FROM rental WHERE inventory_id IN 
 (SELECT inventory_id FROM inventory WHERE film_id IN 
  (SELECT film_id FROM film_category JOIN category USING (category_id) WHERE category.name="Action")));
  
#---------------------------Feb 13---------------------------#
# List of Customer Names who haven't returned the movies

SELECT rental.rental_id, rental.rental_date 'Rented Date',
concat(CONCAT(UPPER(LEFT(first_name,1)),
LOWER(SUBSTRING(first_name, 2, CHAR_LENGTH(first_name)))) , ' ', customer.last_name)
FROM rental
INNER JOIN customer ON
rental.customer_id = customer.customer_id
WHERE return_date IS NULL;  

# capitalizing the first letter of name
SELECT first_name, CONCAT(UPPER(LEFT(first_name,1)),
LOWER(SUBSTRING(first_name, 2, CHAR_LENGTH(first_name)))) 
AS Name
from customer
ORDER BY first_name;



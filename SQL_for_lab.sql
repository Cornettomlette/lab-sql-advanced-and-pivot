/*Lab | Advanced SQL and Pivot tables
In this lab, you will be using the Sakila database of movie rentals. 
	Instructions
1) Select the first name, last name, and email address of all the customers who have rented a movie.

2) What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

3) Select the name and email address of all the customers who have rented the "Action" movies.
	Write the query using multiple join statements
	Write the query using sub queries with multiple WHERE clause and IN condition
   Verify if the above two queries produce the same results or not
    
4) Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.*/

USE sakila_copy_lab;

 -- 1) Select the first name, last name, and email address of all the customers who have rented a movie.
 SELECT concat(first_name, ' ', last_name) as full_name, lower(email) FROM customer c
 INNER JOIN rental r ON c.customer_id = r.customer_id
 GROUP BY first_name, last_name, email;
 
 -- 2) What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT c.customer_id, concat(first_name, ' ', last_name) as full_name, round(avg(amount), 2) as average_payment from payment p
INNER JOIN customer c ON p.customer_id = c.customer_id
GROUP BY customer_id, first_name, last_name;

-- 3) Select the name and email address of all the customers who have rented the "Action" movies.
	
	# Write the query using sub queries with multiple WHERE clause and IN condition
   # Verify if the above two queries produce the same results or not

# Write the query using multiple join statements
SELECT concat(first_name, ' ', last_name) as full_name, email FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Action'
GROUP BY first_name, last_name, email;
 
# Write the query using sub queries with multiple WHERE clause and IN condition
SELECT concat(first_name, ' ', last_name) as full_name, email
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM rental
	WHERE inventory_id IN (
		SELECT inventory_id
		FROM inventory
		WHERE film_id IN (	
			SELECT film_id
			FROM film_category
			WHERE category_id IN (
				SELECT category_id
				FROM category
				WHERE category.name = 'Action'
			)
		)
	)
);
# Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
# If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
SELECT payment_id, rental_id, amount, CASE
WHEN amount > 0 and amount <= 2 THEN 'low'
WHEN amount > 2 and amount <= 4 THEN 'medium'
WHEN amount > 4 THEN 'high'
END AS 'payment_group'
FROM payment;
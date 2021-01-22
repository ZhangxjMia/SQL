/*
find salary for all the employees when they start to work, fetch emp_no & salary, and emp_no desc.

CREATE TABLE `employees` (
`emp_no` int(11) NOT NULL,
`birth_date` date NOT NULL,
`first_name` varchar(14) NOT NULL,
`last_name` varchar(16) NOT NULL,
`gender` char(1) NOT NULL,
`hire_date` date NOT NULL,
PRIMARY KEY (`emp_no`));
CREATE TABLE `salaries` (
`emp_no` int(11) NOT NULL,
`salary` int(11) NOT NULL,
`from_date` date NOT NULL,
`to_date` date NOT NULL,
PRIMARY KEY (`emp_no`,`from_date`));
*/

-- use JOIN
SELECT s.emp_no, s.salary
FROM salaries s
INNER JOIN employees e
ON s.emp_no = e.emp_no
WHERE s.from_date = e.hire_date
ORDER BY s.emp_no DESC;

-- use SUBQUERY
SELECT s.emp_no, s.salary
FROM salaries s
WHERE s.from_date = (SELECT e.hire_date FROM employees e WHERE e.emp_no = s.emp_no) 
ORDER BY s.emp_no DESC;


/*
film (film_id, title, description)
category (category_id, name, last_update)
film_category (film_id, category_id, last_update)

using subquery to find all the action movies' title and descrption.
*/
SELECT f.title, f.description
FROM film f
WHERE f.film_id IN (SELECT fc.film_id FROM film_category fc JOIN
                    category c ON fc.category_id = c.category_id
                    WHERE c.name = 'Action')
/*
Notice: here is IN instead of =, in this case, the subquery returns only one result.
*/

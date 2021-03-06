# SQL
> SQL-related notes, mini projects, exerciese, etc.

## [The Complete SQL Bootcamp](https://www.udemy.com/course/the-complete-sql-bootcamp/)
> This is 9-hour SQL bootcamp taugh by [Jose Portilla](https://www.linkedin.com/in/jmportilla/). It consists of four parts and here I uploaded all my notes on it. I updated both sql version and pdf version for your review.
1. Basic SQL
2. Advanced SQL
3. Conditional Expressions & Procedures Introduction
4. Creating Databases & Tables

#### Code Example
```SQL
SELECT AVG(grade) FROM test_scores
SELECT student, grade
FROM test_scores
WHERE grade > (SELECT AVG (grade)
		    FROM test_scores)
```

## PostgreSQL-Exercises
> [PostgreSQL Exercises](https://pgexercises.com/) was made by [Alisdair Owens](https://www.zaltys.net/). I really love this site since it offers chances to practice SQL. I selected questions that I need to focus on.

### Schema
<img width="856" alt="Screen Shot 2020-12-22 at 3 56 38 PM" src="https://user-images.githubusercontent.com/63559049/102943948-4cc4f680-446e-11eb-8392-aeb6aaab85c2.png">

### General Info
* Basic
* Joins and Subqueries
* Modifying data
* Aggregates
* Date
* String
* Recursive

#### Code Example
```SQL
SELECT name, CASE WHEN class = 1 THEN 'high'
		  WHEN class = 2 THEN 'average'
		  ELSE 'low'
	     END revenue
FROM (SELECT fac.name AS name, 
      NTILE(3) OVER(ORDER BY SUM(CASE WHEN memid = 0 THEN slots * fac.guestcost
				      ELSE slots * membercost
				 END) DESC) AS class
      FROM cd.bookings bks
      JOIN cd.facilities fac
      ON bks.facid = fac.facid
      GROUP BY fac.name) AS sub
ORDER BY class, name;
```

/*
Overview:
• Timestamps and EXTRACT
• Math Functions
• String Functions
• Sub-query
• Self-Join
*/



/*
Timestamps and EXTRACT (Part 1): Displaying current time information
• TIME – Contains only time
• DATE – Contains only date
• TIMESTAMP – Contains date and time
• TIMESTAMPTZ – Contains date, time, and time zone

Query:
SHOW ALL
SHOW TIMEZONE # US/Easten
SELECT NOW () # timestamp with time zone (date + time)
SELECT TIMEOFDAY () # string (Thu Mar 19 14:23:26)
SELECT CURRENT_TIME # timestamp with time zone
SELECT CURRENT_DATE # date
*/



/*
Timestamps and EXTRACT (Part 2): Extracting time and date information
• EXTRACT ()
  o YEAR 
    * SELECT EXTRACT (YEAR FROM date_col) FROM Table
  o MONTH
  o DAY
  o WEEK
  o QUARTER
• AGE (): calculates and returns the current age
  o SELECT AGE (date_col) FROM Table => 13 years 1 mon 5 days 01:34:13
• TO_CHAR (): general function to convert date types to text, useful for timestamp formatting, also can convert integer to string
  o SELECT TO_CHAR (date_col, ‘mm-dd-yyyy’) FROM Table
  o https://www.postgresql.org/docs/12/functions-formatting.html
*/



/*
Timestamps and Extract Challenge Tasks
*/

#1.During which months did payments occur? Format your answer to return back the full month name.
My answer: 
SELECT DISTINCT EXTRACT (MONTH FROM payment_date)
FROM payment
 
Hints: don’t need to use EXTRACT for this query
Revised:
SELECT DISTINCT TO_CHAR (payment_date, 'MONTH')
FROM payment
 

#2.How many payments occurred on a Monday? NOTE: We didn’t show you exactly how to do this but use the documentation or Google to figure this out!
Hints:
• Use EXTRACT
• Review the dow keyword
• PostgreSQL considers Sunday the start of a week (index at 0)
SELECT COUNT (*) FROM payment
WHERE EXTRACT (dow FROM payment_date) = 1



/*
Mathematical Functions and Operators
*/
• Operators
SELECT  ROUND (rental_rate/replacement_cost, 2) FROM film

• Functions
ceil(), floor(), abs()



/*
String Functions and Operations
*/
SELECT upper (first_name) || ‘ ‘ || upper (last_name) AS full_name
FROM customer


 
/*
Subquery
• The subquery is performed first since it is inside the parenthesis.
• We can also use the IN operator in conjunction with a subquery to check against multiple results returned.
*/

#How can we get a list of students who scored better than the average grade?
#Firstly, we get the average score:
SELECT AVG(grade) FROM test_scores
#Secondly, put average score under conditional query:
SELECT student, grade
FROM test_scores
WHERE grade > (SELECT AVG (grade)
		    FROM test_scores) 

#• The EXISTS operator is used to test for existence of rows in a subquery.
#• Typically, a subquery is passed in the EXISTS () function to check if any rows are returned with the subquery (return T/F).

Typical Syntax:
SELECT column_name
FROM table_name
WHERE EXISTS (SELECT column_name
		  FROM table_name
		  WHERE condition)

#Find customers who have at least one payment whose amount Is greater than 11 and list the first name and last name of those customers. (Hint: always shows condition first, here is amount > 11)
SELECT first_name, last_name
FROM customer AS c
WHERE EXISTS (SELECT * FROM payment AS p
 		   WHERE p.customer_id = c.customer_id
 		   AND amount > 11)
 
 
/*
Self-Join
•	A Self-Join is a query in which a table joined to itself.
•	Self-Joins are useful for comparing values in a column of rows within the same table.
•	When using a Self-Join, it is necessary to use an alias for the table, otherwise the table names would be ambiguous.
*/

Syntax:
SELECT tableA.col, tableB.col
FROM table AS tableA
JOIN table AS tableB 
ON tableA.some_col = tableB.other_col


#Step 1: the main table is “employees”, so replace table to “employees”
SELECT tableA.col, tableB.col
FROM employees AS tableA
JOIN employees AS tableB 
ON tableA.some_col = tableB.other_col

#Step 2: tableA should be “emp”, and table B should be “report”
SELECT emp.col, report.col
FROM employees AS emp
JOIN employees AS report
ON emp.some_col = report.other_col

#Step 3: what we care about are “emp_id” (in “emp” table) and “report_id” (in “report” table)
SELECT emp.col, report.col
FROM employees AS emp
JOIN employees AS report
ON emp.emp_id = report.report_id

#Step 4: what we need is their names
SELECT emp.name, report.name
FROM employees AS emp
JOIN employees AS report
ON emp.emp_id = report.report_id


#Find all the pairs of films that have the same length
My answer:
SELECT f1.title, f2.title
FROM film AS f1
JOIN film AS f2
ON f1.length = f2.length

 
#The 5th row got the same pair, so we need to remove this row.
Correct answer:
SELECT f1.title, f2.title
FROM film AS f1
JOIN film AS f2
ON f1.film_id != f2.film_id
AND f1.length = f2.length
 
 
/*
Assessment Test 2
*/

/* 1.How can you retrieve all the information from the cd.facilities table? */

SELECT * FROM cd.facilities
 

/* 2.You want to print out a list of all of the facilities and their cost to members. How would you retrieve a list of only facility names and costs? */

SELECT facilities.name, membercost FROM cd.facilities
 

/* 3.How can you produce a list of facilities that charge a fee to members? */

SELECT * FROM cd.facilities
WHERE membercost > 0
 

/* 4.How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? 
Return the facid, facility name, member cost, and monthly maintenance of the facilities in question. */

SELECT facid, facilities.name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0
AND membercost < monthlymaintenance * 1/50.0
 

/* 5.How can you produce a list of all facilities with the word 'Tennis' in their name? */

SELECT * FROM cd.facilities
WHERE facilities.name LIKE '%Tennis%' (ILIKE: ignore case)

/*
%: in a pattern matches any sequence of zero or more characters
_: in a pattern matches any single character
*/

/* 6.How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator. */

SELECT * FROM cd.facilities
WHERE facid IN (1,5)
 

/* 7.How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question. */

SELECT memid, surname, firstname, joindate 
FROM cd.members
WHERE joindate > '2012-08-31'
 

/* 8.How can you produce an ordered list of the first 10 surnames in the members table? The list must not contain duplicates. */

SELECT DISTINCT surname FROM cd.members
ORDER BY surname LIMIT 10
 
/* 9.You'd like to get the signup date of your last member. How can you retrieve this information? (Hint: the maximum date) */

SELECT MAX (joindate) FROM cd.members

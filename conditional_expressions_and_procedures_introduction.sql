Conditional Expressions & Procedures Introduction
/*
Section Overview
• CASE
• COALESCE
• NULLIF
• CAST
• Views
• Import and Export Functionality
*/


/*
CASE
• Use the CASE statement to only execute SQL code when certain conditions are met.
• This is very similar to IF/ELSE statement in other programming languages.
• There are two main ways to use a case STATEMENT, either CASE or a CASE expression.
*/
o General Syntax:
        CASE
	    WHEN condition1 THEN result1
            WHEN condition2 THEN result2
            ELSE some_other_result
        END

        SELECT a,
            CASE
	           WHEN a = 1 THEN ‘one’
	           WHEN a = 2 THEN ‘two’
               ELSE ‘other’ 
            END AS label
        FROM test

o The CASE expression syntax first evaluates an expression then compares the result with each value in the WHEN clauses sequentially.

        #CASE Expression Syntax:
        CASE expression 
	    WHEN value1 THEN result1
	    WHEN value2 THEN result2
            ELSE some_other_result
        END
	
        SELECT a,
	   CASE a
		WHEN 1 THEN ‘one’
		WHEN 2 THEN ‘two’
		ELSE ‘other’ 
           END AS label
	FROM test



/*
COALESCE function
• Accepts an unlimited number of arguments. It returns the first argument that is not null. If all arguments are null, the COALESCE function will return null.

 o COALESCE (arg_1, arg_2, …, arg_n)
     SELECT COALESCE (1, 2)
      Return -> 1
     SELECT COALESCE (NULL, 2, 3)
      Return -> 2

• The COALESCE function becomes useful when querying a table that contains null values and substituting it with another value.
oTable of product. What’s the final price?
*/


❌ :
SQL cannot subtract null
SELECT item, (price – discount) AS final
FROM table
 

✔️:
If the value is NULL, return 0
SELECT item, (price – COALESCE (discount, 0)) AS final
FROM table
 

/*
• Keep the COALESCE function in mind in case you encounter a table with null values that you want to perform operations on!
*/


/*
CAST operator

• Let’s you convert from one data type into another.
• Keep in mind not every instance of a data type can be CAST to another data type, it must be reasonable to convert the data, for example ‘5’ to an integer will work, ‘five’ to an integer will not.

• Two main way:
    o	SELECT CAST (‘5’ AS INTEGER)
    o	SELECT ‘5’::INTEGER

• Keep in mind you can then use this in a SELECT query with a column name instead of a single instance
    o	SELECT CAST (date AS TIMESTAMP)
        FROM table
*/


/*
NULLIF function

• NULLIF function takes in 2 inputs and returns NULL if both are equal, otherwise it returns the first argument passed.
    o	NULLIF (arg1, arg2)
        	NULLIF (10, 10)
           Return -> NULL
        	NULLIF (10, 12)
           Return -> 10

• This becomes very useful in cases where a NULL value would cause an error or unwanted result.
• Given this table calculate the ratio of Department A to Department B
*/


/*
Views

• Often there are specific combinations of tables and conditions that you find yourself using quite often for a project.
• Instead of having to perform the same query over and over again as a starting point, you can create a VIEW to quickly see this query with a simple call.

• A view is a database object that is of a stored query.
• A view can be accessed as a virtual table in PostgreSQL.
• Notice that a view does not store data physically, it simply stores the query.
• You can also update and alter the view.
*/

/*
Section Overview
    •	Data Types
    •	Primary and Foreign Keys
    •	Constraints
    •	CREATE
    •	INSERT
    •	UPDATE
    •	DELETE, ALTER, DROP

Data Types
    1.	Boolean (T/F)
    2.	Character (char, varchar, text)
    3.	Numeric (integer, floating-point number)
    4.	Temporal (date, time timestamp, interval)
    5.	Not common types:
        a.	UUID (University Unique Identifiers
        b.	Array (Stores an array of strings, numbers, etc)
        c.	JSON
        d.	Hstore key-value pair
        e.	Special types such as network address and geometric data

    •	When creating databases and tables, you should carefully consider which data types should be used for the data to be stored.
    •	https://www.postgresql.org/docs/9.6/datatype.html

    •	For example: 
        o	Store a phone number, should it be stored as numeric? If so, which type of numeric
        o	It makes sense to store it as a BIGINT data type, but we should really be thinking what is best for the situation. We don’t perform arithmetic with phone numbers, so it probably makes more sense as a VARCHAR data type instead.
        o	In fact, searching for the best practice online, you will discover its usually recommended to store as a text-based data type due to a variety of issues 
            	No arithmetic performed 
            	Leading zeros could cause issues, 7 and 07 treated same numerically, but are not the same phone number

    •	When creating a database and table, take you time to plan for long term storage

    •	Remember you can always remove historical information you’ve decided you aren’t using, but you can’t go back in time to add in information!
       
                  

Primary and Foreign Key

    •	A primary key is a column or a group of columns used to identify a row uniquely in a table

        o	For example, in our dvdrental database, we saw customers has a unique, non-null customer_id column as their primary key.

        o	Primary keys are also important since they allow us to easily discern what columns should be used for joining tables together

    •	A foreign key is a field or group of fields in a table that uniquely identifies a row in another table (a foreign key is defined in a table that references to the primary key of the other table)

        o	The table that contains the foreign key is called referencing table or child table

        o	The table to which the foreign key references is called referenced table or parent table

        o	A table can have multiple foreign keys depending on its relationships with other tables

        o	For example, in the dvdrental database payment table, each payment row had its unique payment_id (a primary key) and identified the customer that made the payment through the customer_id (a foreign key since it references the customer table’s primary key)

    •	When creating tables and defining columns, we can use constraints to define columns as being a primary key or attaching a foreign key relationship to another table

     
                  
Constraints

    •	Constraints are the rules enforced on data columns on table

    •	These are used to prevent invalid data from being entered into the database

    •	This ensures the accuracy and reliability of the data in the database

    •	Constraints can be divided into two main categories:
        o	Column Constraints
            	Constraints the data in a column to adhere to certain conditions
        o	Table Constraints
            	Applied to the entire table rather than to an individual column

    •	The most common column constraints used:
        o	NOT NULL Constraint
            	Ensure that a column cannot have NULL value
        o	UNIQUE Constraint
            	Ensure that all values in a column are different
        o	PRIMARY key
            	Uniquely identifies each row/record in a database
        o	FOREIGN key
            	Constrains data based on columns in other tables
        o	CHECK Constraint
            	Ensures that all values in a column satisfy certain conditions
        o	EXCLUSION Constraint
            	Ensures that if any two rows are compared on the specified column or expression using the specified operator, not all of these comparisons will return TRUE

    •	Table constrains:
        o	CHECK (condition)
            	to check a condition when inserting or updating data
        o	REFERENCES
            	To constrain the value stored in the column that must exist in a column in another table
        o	UNIQUE (column_list)
            	Forces the values stored in the columns listed inside the parentheses to be unique
        o	PRIMARY KEY (column_list)
            	Allows you to define the primary key that consists of multiple columns

 
CREATE table

Full General Syntax:
CREATE TABLE table_name (
	column_name TYPE column_constraint,
	column_name TYPE column_constraint,
	table_constraint table_constraint
) INHERITS existing_table_name;

Common Simple Syntax:
CREATE TABLE table_name (
	column_name TYPE column_constraint,
	column_name TYPE column_constraint,
	)

EX:
CREATE TABLE players (
	Player_id SERIAL PRIMARY KEY,
	Age SMALLINT NOT NULL
	);


                  
SERIAL
                  
    •	In PostgreSQL, a sequence is a special kind of database object that generates a sequence of integers
    •	A sequence is often used as the primary key column in a table
    •	It will create a sequence object and set the next value generated by the sequence as the default value for the column
    •	This is perfect for a primary key, because it logs unique integer entries for you automatically upon insertion
    •	If a row is later removed, the column with the SERIAL data type will not adjust, making the fact that a row was removed from the sequence, for example:
        o	1, 2, 3, 5, 6, 7
            	You know row 4 was removed at some point
*/

/*
Perform a case-insensitive search.
Perform a case-insensitive search to find all facilities whose name begins with 'tennis'. Retrieve all columns.
*/
SELECT * FROM cd.facilities
WHERE UPPER(name) LIKE 'TENNIS%';
/*
facid	name	          membercost	guestcost	initialoutlay	monthlymaintenance
0	    Tennis Court 1	5	          25	      10000	        200
1	    Tennis Court 2	5	          25	      8000	        200
*/


/*
Pad zip codes with leading zeroes.
The zip codes in our example dataset have had leading zeroes removed from them by virtue of being stored as a numeric type. Retrieve all zip codes from the members table, padding any zip codes less than 5 characters long with leading zeroes. Order by the new zip code.
*/
SELECT LPAD(CAST(zipcode AS CHAR(5)), 5, '0') AS zip
FROM cd.members
ORDER BY zip;



/*
Clean up telephone numbers.
The telephone numbers in the database are very inconsistently formatted. You'd like to print a list of member ids and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.
*/
SELECT memid, TRANSLATE(telephone, '-() ', '') AS telephone
FROM cd.members
ORDER BY memid;
-- the TRANSLATE function, which can be used to replace characters in a string. You pass it three strings: the value you want altered, the characters to replace, and the characters you want them replaced with. In our case, we want all the characters deleted, so our third parameter is an empty string.

/*
Insert some data into a table.
The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
*/
INSERT INTO cd.facilities 
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa', 20, 30, 100000, 800); 

-- Method 2:
INSERT INTO cd.facilities 
VALUES (9, 'Spa', 20, 30, 100000, 800); 



/*
Insert multiple rows of data into a table.
In the previous exercise, you learned how to add a facility. Now you're going to add multiple facilities in one command. Use the following values:
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
facid: 10, Name: 'Squash Court 2', membercost: 3.5, guestcost: 17.5, initialoutlay: 5000, monthlymaintenance: 80.
*/
INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800),
       (10, 'Squash Court 2', 3.5, 17.5, 5000, 80);
       
       

/*
Insert calculated data into a table.
Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:
Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
*/
INSERT INTO cd.facilities
SELECT (SELECT MAX(facid) FROM cd.facilities)+1, 'Spa', 20, 30, 100000, 800);
-- Since the VALUES clause is only used to supply constant data, we need to replace it with a query instead. The SELECT statement is fairly simple: there's an inner subquery that works out the next facid based on the largest current id, and the rest is just constant data. The output of the statement is a row that we insert into the facilities table.
-- Create Auto-increment column
-- CREATE TABLE table_name(
--    id SERIAL
-- );




/*
Update some existing data.
We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
*/
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;



/*
Update multiple rows and columns at the same time.
We want to increase the price of the tennis courts for both members and guests. Update the costs to be 6 for members, and 30 for guests.
*/
UPDATE cd.facilities
SET membercost = 6, 
    guestcost = 30 -- Insead of [SET membercost = 6 AND guestcost = 30]
WHERE name LIKE 'Tennis%';



/*
Update a row based on the contents of another row.
We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.
*/
UPDATE cd.facilities fac
SET membercost = (SELECT membercost*1.1 FROM cd.facilities WHERE facid = 0),
    guestcost = (SELECT guestcost*1.1 FROM cd.facilities WHERE facid = 1)
WHERE fac.facid = 1;

|facid|     name	 | membercost |  guestcost |  initialoutlay |	monthlymaintenance
|0    |Tennis Court 1 |	5	|	25    |	10000    |	200
|1    |Tennis Court 2 |	5.5	|	27.5  |	8000     |	200
|2    |Badminton Court|	0	|	15.5  |	4000	  |	50
|3    |Table Tennis	 |     0	|      5     |	320	  |	10
|4    |Massage Room 1 |	35	|	80    |	4000	  |	3000
|5    |Massage Room 2 |	35	|	80    |	4000	  |	3000
|6    |Squash Court	 |     3.5	|	17.5  |	5000	  |	80
|7    |Snooker Table	 |     0	|	5     |	45       |	15
|8    |Pool Table	 |     0	|	5     |	400	  |	15




/*
Delete all bookings.
As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. How can we accomplish this?
*/
DELETE FROM cd.bookings;
/*
bookid	 facid	 memid	 starttime	slots
*/


/*
Delete a member from the cd.members table.
We want to remove member 37, who has never made a booking, from our database. How can we achieve that?
*/
DELETE FROM cd.members
WHERE memid = 37;



/*
Delete based on a subquery.
In our previous exercises, we deleted a specific member who had never made a booking. How can we make that more general, to delete all members who have never made a booking?
*/
DELETE FROM cd.members
WHERE memid NOT IN (SELECT memid FROM cd.bookings);
-- JOIN doesn't work in DELETE

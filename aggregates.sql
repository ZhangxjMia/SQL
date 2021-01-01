/*
List the total slots booked per facility per month.
Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.
*/
SELECT facid, EXTRACT(month FROM starttime) AS month, SUM(slots)
FROM cd.bookings
WHERE EXTRACT(year FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;
/*
facid	month	Total Slots
0	7	270
0	8	459
0	9	591
1	7	207
1	8	483
1	9	588
2	7	180
2	8	459
2	9	570
3	7	104
3	8	304
3	9	422
4	7	264
4	8	492
4	9	648
5	7	24
5	8	82
5	9	122
6	7	164
6	8	400
6	9	540
7	7	156
7	8	326
7	9	426
8	7	117
8	8	322
8	9	471
*/


/*
List facilities with more than 1000 slots booked.
Produce a list of facilities with more than 1000 slots booked. Produce an output table consisting of facility id and slots, sorted by facility id.
*/
SELECT facid, SUM(slots) 
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY facid;
-- WHERE is used to filter what data gets input into the aggregate function, while HAVING is used to filter the data once it is output from the function.
/*
facid	Total Slots
0	1320
1	1278
2	1209
4	1404
6	1104
*/


/*
Find facilities with a total revenue less than 1000.
Produce a list of facilities with a total revenue less than 1000. Produce an output table consisting of facility name and revenue, sorted by revenue. Remember that there's a different cost for guests and members!
*/
SELECT name, SUM(slots * CASE WHEN bks.memid = 0 THEN guestcost
			 ELSE membercost
			 END) AS revenue
FROM cd.facilities fac
JOIN cd.bookings bks
ON fac.facid = bks.facid
GROUP BY name
WHERE revenue < 1000
ORDER BY revenue; 
❌ -- ERROR: column "revenue" does not exist. Postgres, unlike some other RDBMSs like SQL Server and MySQL, doesn't support putting column names in the HAVING clause.

-- Method 1:
SELECT name, SUM(slots * CASE WHEN bks.memid = 0 THEN guestcost
			 ELSE membercost
			 END) AS revenue
FROM cd.facilities fac
JOIN cd.bookings bks
ON fac.facid = bks.facid
GROUP BY name
HAVING SUM(slots * CASE WHEN bks.memid = 0 THEN guestcost
		   ELSE membercost
		   END) < 1000
ORDER BY revenue;
✔️ -- This is correct but looks messy.

-- Method 2:
WITH sub AS (SELECT name, SUM(slots * CASE WHEN bks.memid = 0 THEN guestcost
				      ELSE membercost
				      END) AS revenue
             FROM cd.facilities fac
             JOIN cd.bookings bks
             ON fac.facid = bks.facid
             GROUP BY name)

SELECT name, revenue
FROM sub
WHERE revenue < 1000
ORDER BY revenue;
✔️ -- Create a sub-table. This one looks good!
/*
name		revenue
Table Tennis	180
Snooker Table	240
Pool Table	270
*/


/*
Output the facility id that has the highest number of slots booked.
Output the facility id that has the highest number of slots booked. For bonus points, try a version without a LIMIT clause.
*/
-- With LIMIT
SELECT facid, SUM(slots) AS totalslots
FROM cd.bookings
GROUP BY facid
ORDER BY SUM(slots) DESC
LIMIT 1;

-- Without LIMIT, use CTE
WITH sub AS (SELECT facid, SUM(slots) AS totalslots
			 FROM cd.bookings
			 GROUP BY facid)

SELECT facid, totalslots
FROM sub
WHERE totalslots = (SELECT MAX(totalslots) FROM sub);

-- Window Function
SELECT facid, total
FROM (SELECT facid, SUM(slots) AS total, RANK() OVER(ORDER BY SUM(slots) DESC) AS rank
      FROM cd.bookings
      GROUP BY facid) AS ranked
WHERE rank = 1;



/*
List the total slots booked per facility per month, part 2
Produce a list of the total number of slots booked per facility per month in the year of 2012. In this version, include output rows containing totals for all months per facility, and a total for all months for all facilities. The output table should consist of facility id, month and slots, sorted by the id and month. When calculating the aggregated values for all months and all facids, return null values in the month and facid columns.
*/
-- ROLLUP()
SELECT facid, EXTRACT(month FROM starttime) AS month, SUM(slots) AS slots
FROM cd.bookings
WHERE starttime >= '2012-01-01' AND starttime < '2013-01-01'
GROUP BY ROLLUP(facid, month)
ORDER BY facid, month;

-- CTE
WITH bookings AS (SELECT facid, EXTRACT(month FROM starttime) AS month, slots
                  FROM cd.bookings
                  WHERE starttime >= '2012-01-01' AND starttime < '2013-01-01')
SELECT facid, month, SUM(slots) FROM bookings GROUP BY facid, month
UNION ALL
SELECT facid, NULL, SUM(slots) FROM bookings GROUP BY facid
UNION ALL
SELECT NULL, NULL, SUM(slots) FROM bookings
ORDER BY facid, month;



/*
List each member's first booking after September 1st 2012.
Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.
*/
SELECT surname, firstname, mbs.memid, MIN(bks.starttime) AS starttime
-- Notice: MIN(bks.starttime) AS starttime
FROM cd.members mbs
JOIN cd.bookings bks
ON mbs.memid = bks.memid
WHERE starttime >= '2012-09-01'
GROUP BY surname, firstname, mbs.memid
ORDER BY mbs.memid;



/*
Produce a numbered list of members.
Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining. Remember that member IDs are not guaranteed to be sequential.
*/
-- Window Function
SELECT row_number() OVER(ORDER BY joindate), firstname, surname
FROM cd.members
ORDER BY joindate;



/*
Rank members by (rounded) hours used.
Produce a list of members (including guests), along with the number of hours they've booked in facilities, rounded to the nearest ten hours. Rank them by this rounded figure, producing output of first name, surname, rounded hours, rank. Sort by rank, surname, and first name.
*/
SELECT firstname, surname, ((SUM(bks.slots) + 10)/20)*10 AS hours,
       RANK() OVER(ORDER BY ((SUM(bks.slots) + 10)/20)*10 DESC) AS rank
-- In our case, because slots are half an hour, we need to add 10, divide by 20, and multiply by 10.
FROM cd.bookings bks
JOIN cd.members mbs
ON bks.memid = mbs.memid
GROUP BY mbs.memid
ORDER BY rank, surname, firstname;



/*
Find the top three revenue generating facilities.
Produce a list of the top three revenue generating facilities (including ties). Output facility name and rank, sorted by rank and facility name.
*/
SELECT name, rank
FROM (SELECT fac.name AS name, 
	  		 RANK() OVER(order by SUM(CASE WHEN memid = 0 THEN slots * fac.guestcost
									  ELSE slots * membercost
									  END) DESC) AS rank
	  FROM cd.bookings bks
	  JOIN cd.facilities fac
	  ON bks.facid = fac.facid
	  GROUP BY fac.name) AS sub
WHERE rank <= 3
ORDER BY rank;



/*
Classify facilities by value.
Classify facilities into equally sized groups of high, average, and low based on their revenue. Order by classification and facility name.
*/
-- NTILE window function. NTILE groups values into a passed-in number of groups, as evenly as possible.
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

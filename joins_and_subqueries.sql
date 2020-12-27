/*
Produce a list of all members who have recommended another member.
How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
*/
SELECT DISTINCT mbs.firstname AS firstname, mbs.surname AS surname
FROM cd.members mbs
JOIN cd.members mbs2
ON mbs.memid = mbs2.recommendedby
ORDER BY surname, firstname;



/*
Produce a list of all members, along with their recommender.
How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).
*/
SELECT mbs.firstname AS memfname, mbs.surname AS surname, ref.firstname AS recfname, ref.surname AS recsname
FROM cd.members mbs
LEFT OUTER JOIN cd.members ref
ON mbs.recommendedby = ref.memid
ORDER BY mbs.surname, mbs.firstname;



/*
Produce a list of costly bookings.
How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost, and do not use any subqueries.
*/
-- Without Subquery
SELECT CONCAT(mbs.firstname, ' ', mbs.surname) AS member, 
	   fac.name AS facility,
	   CASE WHEN mbs.memid = 0 THEN bks.slots*fac.guestcost
		   	ELSE bks.slots*fac.membercost
	   END AS cost
FROM cd.members mbs
JOIN cd.bookings bks
ON mbs.memid = bks.memid
JOIN cd.facilities fac
ON bks.facid = fac.facid
WHERE bks.starttime >= '2012-09-14' 
AND bks.starttime < '2012-09-15'
AND (
	(mbs.memid = 0 AND bks.slots*fac.guestcost > 30)
	 OR (mbs.memid != 0 AND bks.slots*fac.membercost > 30)
     )
ORDER BY cost DESC;

-- With Subquery
SELECT member, facility, cost
FROM 
	 (SELECT CONCAT(mbs.firstname, ' ', mbs.surname) AS member
	  		 fac.name AS facility,
	  		 CASE WHEN mbs.memid = 0 THEN bks.slots*guestcost
	  			  ELSE bks.slots*membercost
	  		 END AS cost
	  FROM cd.members mbs
	  JOIN cd.bookings bks
	  ON mbs.memid = bks.memid
	  JOIN cd.facilities fac
	  ON bks.facid = fac.facid
	  WHERE bks.starttime >= '2012-09-14'
	  AND bks.starttime < '2012-09-15') AS bookings
WHERE cost > 30
ORDER BY cost DESC;

/*
Produce a list of all members, along with their recommender, using no joins.
How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.
*/
-- Without join. Create a new column for recommenders.
SELECT DISTINCT CONCAT(mbs.firstname, ' ', mbs.surname) AS member, 
	  (SELECT CONCAT(rec.firstname, ' ', rec.surname) AS recommender
	   FROM cd.members rec
	   WHERE rec.memid = mbs.recommendedby)
FROM cd.members mbs
ORDER BY member;
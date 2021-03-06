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
firstname	surname
Florence	Bader
Timothy	        Baker
Gerald	        Butters
Jemima	        Farrell
Matthew	        Genting
David	        Jones
Janice	        Joplette
Millicent	Purview
Tim	        Rownam
Darren	        Smith
Tracy	        Smith
Ponder	        Stibbons
Burton	        Tracy
*/


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
memfname	memsname	recfname	recsname
Florence	Bader	        Ponder	        Stibbons
Anne	        Baker	        Ponder	        Stibbons
Timothy	        Baker	        Jemima	        Farrell
Tim	        Boothe	        Tim	        Rownam
Gerald	        Butters	        Darren	        Smith
Joan	        Coplin	        Timothy	        Baker
Erica	        Crumpet	        Tracy	        Smith
Nancy	        Dare	        Janice	        Joplette
David	        Farrell		
Jemima	        Farrell		
GUEST	        GUEST		
Matthew	        Genting	        Gerald	        Butters
John	        Hunt	        Millicent	Purview
David	        Jones	        Janice	        Joplette
Douglas	        Jones	        David	        Jones
Janice	        Joplette	Darren	        Smith
Anna	        Mackenzie	Darren	        Smith
Charles	        Owen	        Darren	        Smith
David	        Pinker	        Jemima	        Farrell
Millicent	Purview	        Tracy	        Smith
Tim	        Rownam		
Henrietta	Rumney	        Matthew	        Genting
Ramnaresh	Sarwin	        Florence	Bader
Darren	        Smith		
Darren	        Smith		
Jack	        Smith	        Darren	        Smith
Tracy	        Smith		
Ponder	        Stibbons	Burton	        Tracy
Burton	        Tracy		
Hyacinth	Tupperware		
Henry	     Worthington-Smyth  Tracy	        Smith
*/


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
member	        facility	cost
GUEST GUEST	Massage Room 2	320
GUEST GUEST	Massage Room 1	160
GUEST GUEST	Massage Room 1	160
GUEST GUEST	Massage Room 1	160
GUEST GUEST	Tennis Court 2	150
Jemima Farrell	Massage Room 1	140
GUEST GUEST	Tennis Court 1	75
GUEST GUEST	Tennis Court 2	75
GUEST GUEST	Tennis Court 1	75
Matthew Genting	Massage Room 1	70
Florence Bader	Massage Room 2	70
GUEST GUEST	Squash Court	70.0
Jemima Farrell	Massage Room 1	70
Ponder Stibbons	Massage Room 1	70
Burton Tracy	Massage Room 1	70
Jack Smith	Massage Room 1	70
GUEST GUEST	Squash Court	35.0
GUEST GUEST	Squash Court	35.0
*/



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
/*
member	 		recommender
Anna Mackenzie		Darren Smith
Anne Baker		Ponder Stibbons
Burton Tracy	
Charles Owen		Darren Smith
Darren Smith	
David Farrell	
David Jones		Janice Joplette
David Pinker		Jemima Farrell
Douglas Jones		David Jones
Erica Crumpet		Tracy Smith
Florence Bader		Ponder Stibbons
GUEST GUEST	
Gerald Butters		Darren Smith
Henrietta Rumney	Matthew Genting
Henry Worthington-Smyth	Tracy Smith
Hyacinth Tupperware	
Jack Smith		Darren Smith
Janice Joplette		Darren Smith
Jemima Farrell	
Joan Coplin		Timothy Baker
John Hunt		Millicent Purview
Matthew Genting		Gerald Butters
Millicent Purview	Tracy Smith
Nancy Dare		Janice Joplette
Ponder Stibbons		Burton Tracy
Ramnaresh Sarwin	Florence Bader
Tim Boothe		Tim Rownam
Tim Rownam	
Timothy Baker		Jemima Farrell
Tracy Smith	
*/

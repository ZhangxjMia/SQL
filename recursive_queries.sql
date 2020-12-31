/*
Find the upward recommendation chain for member ID 27.
Find the upward recommendation chain for member ID 27: that is, the member who recommended them, and the member who recommended that member, and so on. Return member ID, first name, and surname. Order by descending member id.
*/
WITH RECURSIVE recommenders(recommender) AS (
  SELECT recommendedby FROM cd.members WHERE memid = 27
  UNION ALL 
  SELECT mbs.recommendedby 
  FROM recommenders recs
  INNER JOIN cd.members mbs
  ON mbs.memid = recs.recommender )

SELECT recs.recommender, mbs.firstname, mbs.surname
FROM recommenders recs
INNER JOIN cd.members mbs
ON recs.recommender = mbs.memid
ORDER BY memid DESC;
/*
recommender	firstname	surname
20	        Matthew	    Genting
5	        Gerald	    Butters
1	        Darren	    Smith
*/
-- The Common Table Expressions (CTEs) defined by WITH give you the ability to produce inline views over your data. This is normally just a syntactic convenience, but the RECURSIVE modifier adds the ability to join against results already produced to produce even more. A recursive WITH takes the basic form of:
/*
WITH RECURSIVE NAME(columns) as (
	<initial statement>
	UNION ALL 
	<recursive statement>
)
*/



/*
Find the downward recommendation chain for member ID 1.
Find the downward recommendation chain for member ID 1: that is, the members they recommended, the members those members recommended, and so on. Return member ID and name, and order by ascending member id.
*/
WITH RECURSIVE recommenders(memid) AS (
  SELECT memid FROM cd.members WHERE recommendedby = 1
  UNION ALL 
  SELECT mbs.memid 
  FROM recommenders recs
  INNER JOIN cd.members mbs
  ON mbs.recommendedby = recs.memid )

SELECT recs.memid, mbs.firstname, mbs.surname
FROM recommenders recs
INNER JOIN cd.members mbs
ON recs.memid = mbs.memid
ORDER BY memid;
/*
memid	firstname	surname
4	      Janice	Joplette
5	      Gerald	Butters
7	      Nancy	    Dare
10	      Charles	Owen
11	      David	    Jones
14	      Jack	    Smith
20	      Matthew	Genting
21	      Anna	    Mackenzie
26	      Douglas	Jones
27	      Henrietta	Rumney
*/



/*
Produce a CTE that can return the upward recommendation chain for any member.
Produce a CTE that can return the upward recommendation chain for any member. You should be able to select recommender from recommenders where member=x. Demonstrate it by getting the chains for members 12 and 22. Results table should have member and recommender, ordered by member ascending, recommender descending.
*/
WITH RECURSIVE recommenders(recommender, member) AS (
  SELECT recommendedby, memid
  FROM cd.members
  UNION ALL
  SELECT mbs.recommendedby, recs.member
  FROM recommenders recs
  INNER JOIN cd.members mbs
  ON mbs.memid = recs.recommender
  )

SELECT recs.member member, recs.recommender, mbs.firstname, mbs.surname
FROM recommenders recs
INNER JOIN cd.members mbs
ON recs.recommender = mbs.memid
WHERE recs.member = 22 OR recs.member = 12
ORDER BY recs.member ASC, recs.recommender DESC;
/*
member	recommender	firstname	surname
12	     9	          Ponder	Stibbons
12	     6	          Burton	Tracy
22	     16	          Timothy	Baker
22	     13	          Jemima	Farrell
*/
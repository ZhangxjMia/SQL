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
zip
00000
00234
00234
04321
04321
10383
11986
23423
28563
33862
34232
43532
43533
45678
52365
54333
56754
57392
58393
64577
65332
65464
66796
68666
69302
75655
78533
80743
84923
87630
97676                 
*/


/*
Clean up telephone numbers.
The telephone numbers in the database are very inconsistently formatted. You'd like to print a list of member ids and numbers that have had '-','(',')', and ' ' characters removed. Order by member id.
*/
SELECT memid, TRANSLATE(telephone, '-() ', '') AS telephone
FROM cd.members
ORDER BY memid;
-- the TRANSLATE function, which can be used to replace characters in a string. You pass it three strings: the value you want altered, the characters to replace, and the characters you want them replaced with. In our case, we want all the characters deleted, so our third parameter is an empty string.
/*
memid	telephone
0	    0000000000
1	    5555555555
2	    5555555555
3	    8446930723
4	    8339424710
5	    8440784130
6	    8223549973
7	    8337764001
8	    8114332547
9	    8331603900
10	  8555425251
11	  8445368036
12	  8440765141
13	  8550160163
14	  8221633254
15	  8334993527
16	  8339410824
17	  8114096734
20	  8119721377
21	  8226612898
22	  8224992232
24	  8224131470
26	  8445368036
27	  8229898876
28	  8557559876
29	  8558943758
30	  8559419786
33	  8226655327
35	  8997206978
36	  8117324816
37	  8225773541
*/

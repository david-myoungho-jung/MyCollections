-- 320380

-- SELECT MAX(starttime)  -- 출근시간 
-- , MAX(endtime)         -- 퇴근시간
--   from idwq WHERE appdate = '20211111' AND empid = '320380' AND  TYPE IN ('11','12')  -- 11:출근 12:퇴근

--  SELECT TYPE, startbreak, endbreak FROM idwq WHERE appdate = '20211111' AND empid = '320380' AND  TYPE IN ('13','14') --  13:휴식시작 14:휴식종료
/*
﻿TYPE"	"startbreak"	"endbreak"
"13"	"15:31:11"	"00:00:00"
"14"	"00:00:00"	"15:31:18"
"13"	"15:31:23"	"00:00:00"
"14"	"00:00:00"	"15:31:31"
"13"	"15:31:36"	"00:00:00"
"14"	"00:00:00"	"15:31:52"
*/

SELECT k.appdate
     , k.empId
	  , CONCAT(a.name,' ' , a.surname, '(', a.nameeng ,')') AS empName
	  , SUM(totalWorkTime) AS totalWorkTime
	  , SUM(totalBreakTme) AS totalBreakTme
  FROM (
SELECT x.appdate
     , x.empId
     , 0 AS totalWorkTime
     , ROUND(SUM(TIME_TO_SEC(TIMEDIFF(x.endbreak,x.startbreak))/3600),2) AS totalBreakTme
  FROM (
			SELECT 
			      a.appdate
			    , a.empId
			    , a.TYPE
				 , a.startbreak
				 , IFNULL((SELECT MAX(s.endbreak) FROM idwq s 
						      WHERE s.appdate =  a.appdate -- '20211111' 
							     AND s.empid = a.empId -- '320380' 
							  	  AND s.type ='14' 
								  AND s.endbreak > a.startbreak 
								  AND  s.endbreak < (SELECT MIN(k.startbreak ) 
								                     FROM idwq k 
														  WHERE  k.appdate = a.appdate -- '20211111' 
														    AND k.empid = a.empId -- '320380' 
															 AND k.type ='13' 
															 AND k.startbreak > a.startbreak )
													    
					 		  ), (SELECT MAX(w.endbreak) 
								    FROM idwq w 
									WHERE w.appdate = a.appdate -- '20211111'  
									  AND w.empid = a.empId -- '320380' 
									  AND w.type ='14' )) AS endbreak
		 	  FROM idwq a 
		  	 WHERE a.appdate BETWEEN '20220501' AND '20220531' 			 
				AND a.type ='13' 
		  ) x
GROUP BY x.appdate
     , x.empId
UNION ALL
SELECT x.appdate
     , x.empId
     , ROUND(SUM(TIME_TO_SEC(TIMEDIFF(x.endtime,x.starttime))/3600),2) AS totalWorkTime
     , 0 AS totalBreakTme
  FROM (
			SELECT 
			      a.appdate
			    , a.empId
			    , a.TYPE
				 , a.starttime
				 , IFNULL((SELECT MAX(s.endtime) FROM idwq s 
						      WHERE s.appdate =  a.appdate -- '20211111' 
							     AND s.empid = a.empId -- '320380' 
							  	  AND s.type ='12' 
								  AND s.endtime > a.starttime 
								  AND  s.endtime < (SELECT MIN(k.starttime ) 
								                     FROM idwq k 
														  WHERE  k.appdate = a.appdate -- '20211111' 
														    AND k.empid = a.empId -- '320380' 
															 AND k.type ='11' 
															 AND k.starttime > a.starttime )
													    
					 		  ), (SELECT MAX(w.endtime) 
								    FROM idwq w 
									WHERE w.appdate = a.appdate -- '20211111'  
									  AND w.empid = a.empId -- '320380' 
									  AND w.type ='12' )) AS endtime
		 	  FROM idwq a 
		  	 WHERE a.appdate BETWEEN '20220501' AND '20220531' 			 
				AND a.type ='11' 
		  ) x
GROUP BY x.appdate
     , x.empId  ) k   
, memp a
WHERE k.empId = a.id 
GROUP BY k.appdate
     , k.empId     	  

SELECT x.appdate
     , x.empId
     , x.type
     , x.startbreak
     , x.endbreak
  FROM (
			SELECT 
			     a.appdate
			   , a.empId
			   , a.TYPE
				 , a.startbreak
				 , IFNULL((SELECT MAX(s.endbreak) FROM idwq s 
						      WHERE s.appdate =  a.appdate -- '20211111' 
							     AND s.empid = a.empId -- '320380' 
							  	  AND s.type ='14' 
								  AND s.endbreak > a.startbreak 
								  AND  s.endbreak < (SELECT MIN(k.startbreak ) 
								                     FROM idwq k 
														  WHERE  k.appdate = a.appdate -- '20211111' 
														    AND k.empid = a.empId -- '320380' 
															 AND k.type ='13' 
															 AND k.startbreak > a.startbreak )
													    
					 		  ), (SELECT MAX(w.endbreak) 
								    FROM idwq w 
									WHERE w.appdate = a.appdate -- '20211111'  
									  AND w.empid = a.empId -- '320380' 
									  AND w.type ='14' )) AS endbreak
		 	  FROM idwq a 
		  	 WHERE a.appdate BETWEEN '20220501' AND '20220531' 
			  -- AND a.empid = '320380' 
				AND a.type ='13' 
		  ) x
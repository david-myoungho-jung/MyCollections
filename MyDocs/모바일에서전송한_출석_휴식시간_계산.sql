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

SELECT x.type
     , x.startbreak
     , x.endbreak
  FROM (
			SELECT 
			      a.TYPE
				 , a.startbreak
				 , IFNULL((SELECT MAX(s.endbreak) FROM idwq s 
						      WHERE s.appdate = '20211111' 
							     AND s.empid = '320380' 
							  	  AND s.type ='14' 
								  AND s.endbreak > a.startbreak 
								  AND  s.endbreak < (SELECT MIN(k.startbreak ) 
								                     FROM idwq k 
														  WHERE  k.appdate = '20211111' 
														    AND k.empid = '320380' 
															 AND k.type ='13' 
															 AND k.startbreak > a.startbreak )
													    
					 		  ), (SELECT MAX(w.endbreak) 
								    FROM idwq w 
									WHERE w.appdate = '20211111'  
									  AND w.empid = '320380' 
									  AND w.type ='14' )) AS endbreak
		 	  FROM idwq a 
		  	 WHERE a.appdate = '20211111' AND a.empid = '320380' AND a.type ='13' 
		  ) x

  
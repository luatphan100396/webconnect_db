CREATE OR REPLACE PROCEDURE usp_Account_Get_List_Time_Range
--======================================================
--Author: Linh Pham
--Created Date: 2020-01-06
--Description: Get TIME_RANGE to visti history 
--Output:
--        +Ds1: list TIME_RANGE to visit history 
--======================================================
(

)
DYNAMIC RESULT SETS 1
BEGIN
		


	 -- Sex list   
	BEGIN
		DECLARE cursor1  CURSOR WITH RETURN for
	    SELECT  
	    		KEY, 
	    		VALUE
	    FROM (
	    VALUES ('all_time','All time')
			    ,('last_hour','Last hour')
			    ,('last_24hour','last 24 hours')
			    ,('last_7days','last 7 days')
			    ,('last_4weeks','last 4 weeks')
	    )t (KEY, VALUE);
	    
		OPEN cursor1;
		  
	END;

END 



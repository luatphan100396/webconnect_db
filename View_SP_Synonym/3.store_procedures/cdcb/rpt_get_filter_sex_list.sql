CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Sex_List()
--======================================================
--Author: Nghi Ta
--Created Date: 2020-04-06
--Description: Get sex list: Male and Female
--Output: 
--       +Ds1: table with sex type are Male and Female
--======================================================  
  dynamic result sets 1
BEGIN
    
         
	 -- Sex list   
	BEGIN
		DECLARE cursor1  CURSOR WITH RETURN for
	    SELECT  SEX_TYPE
	    FROM (
	    VALUES ('Male'),
			    ('Female')
	    )t (SEX_TYPE);
	    
		OPEN cursor1;
		  
	END;
	  
END



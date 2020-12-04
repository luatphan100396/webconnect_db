CREATE OR REPLACE PROCEDURE usp_Get_Filter_Search_Option_List
--======================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Define search option list 
--Output:
--        +Ds1: Table with OPTION_KEY, OPTION_DESC 
--                     OPTION_KEY        	OPTION_DESC
--                     ANIM_KEY_17      	Animal ID (17 bytes)
--                     ANIM_KEY_17_SEX  	Animal ID + Sex Code (18 bytes)
--                     HERD_CTRL_NUM    	Herd + Cow Control Number
--                     HERD_ID          	Herd ID
--                     ITB_ID           	Interbull ID (19 bytes)
--                     NAAB_CODE        	NAAB Code
--                     PARTIAL_FULL_NAME	Partial Full Name
--                     SAMPLE_ID_SEX    	Sample ID + Sex Code (20 bytes max)
--                     SHORT_NAME       	Short Name
--======================================================
()
  
  dynamic result sets 1
BEGIN
    
         
	 -- Sex list   
	BEGIN
		DECLARE cursor1  CURSOR WITH RETURN for
	    SELECT  OPTION_KEY, OPTION_DESC
	    FROM (
	    VALUES ('ANIM_KEY_17','Animal ID (17 bytes)'),
			   ('ANIM_KEY_17_SEX','Animal ID + Sex Code (18 bytes)'),
			   ('SAMPLE_ID_SEX','Sample ID + Sex Code (20 bytes max)'),
			   ('NAAB_CODE','NAAB Code'),
			   ('ITB_ID','Interbull ID (19 bytes)'),
			   ('HERD_ID','Herd ID'),
			   ('SHORT_NAME','Short Name'),
			   ('PARTIAL_FULL_NAME','Partial Full Name'),
			   ('HERD_CTRL_NUM','Herd + Cow Control Number')
	    )t (OPTION_KEY, OPTION_DESC);
	    
		OPEN cursor1;
		  
	END;
	  
END


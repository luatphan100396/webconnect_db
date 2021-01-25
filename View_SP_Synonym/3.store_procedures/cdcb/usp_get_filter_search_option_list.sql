CREATE OR REPLACE PROCEDURE usp_Get_Filter_Search_Option_List
--======================================================
--Author: Linh Pham
--Created Date: 2020-01-25
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
(
	IN @SEARCH_FOR VARCHAR(10) -- GOAT/CATTLE
)
  
  dynamic result sets 1
BEGIN
    
      IF @SEARCH_FOR ='CATTLE' THEN   
	 -- Sex list  cattle 
	BEGIN
		DECLARE cursor1  CURSOR WITH RETURN for
	    SELECT  OPTION_KEY, OPTION_DESC
	    FROM (
	    VALUES 	('ANIM_KEY_12','Animal ID (12 bytes)'),
	    		('ANIM_KEY_17','Animal ID (17 bytes)'),
			   	('ANIM_KEY_17_SEX','Animal ID + Sex Code (18 bytes)'),
			   	('ITB_ID','Animal Interbull ID (19 bytes)'),
			    ('SAMPLE_ID_SEX','Sample ID + Sex Code (20 bytes max)'),
			    ('NAAB_CODE','NAAB Code'),
			    ('SHORT_NAME','Short Name'),
			    ('PARTIAL_FULL_NAME','Partial Full Name'),
			    ('HERD_CTRL_NUM','Herd + Cow Control Number'),
			    ('HERD_ID','Herd ID')
	    )t (OPTION_KEY, OPTION_DESC);
	    
		OPEN cursor1;
		  
	END;
	ELSEIF @SEARCH_FOR ='GOAT' THEN
	 -- Sex list  cattle 
	BEGIN
		DECLARE cursor2  CURSOR WITH RETURN for
	    SELECT  OPTION_KEY, OPTION_DESC
	    FROM (
	    VALUES  ('ANIM_KEY_6','Last 6 characters.'),
	    		('ANIM_KEY_17','Animal ID (17 bytes)'),
	    		('ANIM_KEY_17_SEX','Animal ID + Sex Code (18 bytes)'),
			    ('SHORT_NAME','Short Name'),
			    ('PARTIAL_FULL_NAME','Partial Full Name'),
			    ('HERD_ID','Herd ID')
	    )t (OPTION_KEY, OPTION_DESC);
	    
		OPEN cursor2;
		  
	END;
	END IF;
	  
END


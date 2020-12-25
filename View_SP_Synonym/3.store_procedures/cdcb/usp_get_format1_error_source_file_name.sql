CREATE OR REPLACE PROCEDURE usp_Get_format1_Error_Source_File_Name
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-24
--Description: Get list source file name for format 1 per
-- one animal
--Output: 
--        +Ds1: Table with INT_ID, source file name 
--======================================================
( 
    IN @INT_ID char(17),
    IN @page_number int,
	IN @row_per_page int
)
DYNAMIC RESULT SETS 5
    
BEGIN
 
     
  BEGIN
	DECLARE cursor1 CURSOR WITH RETURN FOR 	
	  SELECT 
		 BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM AS INT_ID
		,TRIM(LEFT(SOURCE_FILE_NAME,8)) ||'.1'||TRIM(RIGHT(SOURCE_FILE_NAME,1))  as SOURCE_FILE_NAME
	FROM ERROR1_TABLE
	WHERE BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM  =  @INT_ID
	ORDER BY SOURCE_FILE_NAME DESC
	LIMIT @row_per_page
	OFFSET (@page_number-1)*@row_per_page with UR;
		 
		    
	 OPEN cursor1;
   END;
	    
     BEGIN
		DECLARE cursor2 CURSOR WITH RETURN FOR 	
		 SELECT count(1) as Num_Recs
		FROM ERROR1_TABLE
		WHERE BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM  =  @INT_ID with UR; 
	
	 OPEN cursor2;
   END;  
    
	   
END

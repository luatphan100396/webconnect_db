CREATE OR REPLACE PROCEDURE usp_Get_Format4_Error_Source_File_Name
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-24
--Description: Get list source file name for format 4 per
-- one animal
--Output:
--        +Ds1: Table with INT_ID, CALV PDATE, DIM QTY, source file name 
--        +Ds2: Retrun number of rows
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
		 ,CALV_PDATE
		 ,DIM_QTY
		,TRIM(LEFT(SOURCE_FILE_NAME,8)) ||'.4'||TRIM(RIGHT(SOURCE_FILE_NAME,1))  as SOURCE_FILE_NAME
	FROM ERROR4_TABLE
	WHERE BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM  =  @INT_ID
	
	ORDER BY CALV_PDATE desc,  DIM_QTY desc 
	LIMIT @row_per_page
	OFFSET (@page_number-1)*@row_per_page with UR;
		 
		    
	 OPEN cursor1;
   END;
	    
      
    BEGIN
		DECLARE cursor2 CURSOR WITH RETURN FOR 	
		 SELECT count(1) as Num_Recs
		FROM ERROR4_TABLE
		WHERE BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM  =  @INT_ID with UR; 
	
	 OPEN cursor2;
   END;
	    
	   
END

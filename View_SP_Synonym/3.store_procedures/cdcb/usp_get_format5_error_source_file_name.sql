CREATE OR REPLACE PROCEDURE usp_Get_Format5_Error_Source_File_Name
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-24
--Description: Get detail input and error of format 5
-- per one animal
--Output:
--        +Ds1: Table with animal id, sire id, dam id, alias id, birth date, source, proc date,
--              affil, herd, ctrl number, lact type, lact verrification, calving date, dim, dry...
--        +Ds2: Preproduction detail: type, date, event code, seq, naab code, id
--        +Ds3: Error detail: err code, description, action, conflict id, proc date, herd, source 
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
		 ,SPECIES_CODE
		 ,CALV_PDATE
		 ,HERD_CODE
		 ,PROC_PDATE 
		,TRIM(LEFT(SOURCE_FILE_NAME,8)) ||'.5'||TRIM(RIGHT(SOURCE_FILE_NAME,1))  as SOURCE_FILE_NAME
	FROM ERROR5_TABLE
	WHERE BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM  =  @INT_ID
	ORDER BY CALV_PDATE desc, PROC_PDATE desc 
	LIMIT @row_per_page
	OFFSET (@page_number-1)*@row_per_page with UR;
		 
		    
	 OPEN cursor1;
   END;
	    
      BEGIN
		DECLARE cursor2 CURSOR WITH RETURN FOR 	
		 SELECT count(1) as Num_Recs
		FROM ERROR5_TABLE
		WHERE BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM  =  @INT_ID with UR; 
	
	 OPEN cursor2;
   END;
    
	   
END

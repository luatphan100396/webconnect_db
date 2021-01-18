CREATE OR REPLACE PROCEDURE usp_Search_Animal_By_Sample_ID_20_Bytes 
--===================================================================
--Author: Linh Pham
--Created Date: 2020-02-16
--Description: Get list INT_ID from string input
--Output:
--        +Ds1: Table with sample_id, animal id, animal key, species code, sex code, herd code, ctrl num, has error, 
--              is linked to animal 
--        +Ds2: Animal which has no information returned 
--========================================================================
(
	IN @INPUT_VALUE VARCHAR(10000) 
	,@DELIMITER VARCHAR(1) default ','
)
	DYNAMIC RESULT SETS 3
	LANGUAGE SQL
BEGIN
	    
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInputs
	(	
		INPUT_VALUE VARCHAR(128),
		ORDER INT  GENERATED BY DEFAULT AS IDENTITY 
      (START WITH 1 INCREMENT BY 1)
	
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpIntIDChar20Lists   
	(
		SAMPLE_ID VARCHAR(20),
		ANIM_KEY INT,
		INT_ID CHAR(17), 
		SEX_CODE char(1),
		SPECIES_CODE char(1), 
		ORDER INT
	) WITH REPLACE  ON COMMIT PRESERVE ROWS;
  
     
	   DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInputValid 
	(
		INPUT_VALUE varchar(128) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	INSERT INTO SESSION.TmpInputs(INPUT_VALUE)
	SELECT  ITEM FROM table(fn_Split_String (@INPUT_VALUE,@DELIMITER));
	
	-- Remove duplicate input
	MERGE INTO SESSION.TmpInputs as A
	 using
	 (
  
		 SELECT 
		 		INPUT_VALUE, 
		 		MIN(ORDER) AS MIN_ORDER
		 FROM SESSION.TmpInputs t	
		 GROUP BY INPUT_VALUE
		 with UR
	 )AS B
	 ON  A.INPUT_VALUE = B.INPUT_VALUE 
	 and A.ORDER <> B.MIN_ORDER 
	 WHEN MATCHED THEN
	 DELETE
	 ;
	  
	     -- Find matching animal id in id_xref_table
		INSERT INTO SESSION.TmpIntIDChar20Lists
		(
			SAMPLE_ID,
			ANIM_KEY,
			INT_ID, 
			SEX_CODE,
			SPECIES_CODE,  
			ORDER
		)
		  
		 SELECT
		 	 a.SAMPLE_ID, 
			 xref.ANIM_KEY, 
			 xref.INT_ID,  
			 a.SEX_CODE,
			 xref.SPECIES_CODE,
		 t.ORDER
		 FROM  SESSION.TmpInputs t
		 JOIN GENOTYPE_STATUS_TABLE a
		 on upper(t.INPUT_VALUE) = a.SAMPLE_ID
		 LEFT JOIN ID_XREF_TABLE xref 
		 on xref.ANIM_KEY = a.ANIM_KEY 
		 with UR;
		 
		 
		 INSERT INTO SESSION.TmpInputValid 
		 (
		 INPUT_VALUE
		 )
		 SELECT a.SAMPLE_ID
		 FROM SESSION.TmpIntIDChar20Lists a with UR;
	    -- Remove duplicate output, same animal ID but has different anim key
		
		MERGE INTO SESSION.TmpIntIDChar20Lists as A
		 using
		 ( 
			 SELECT INT_ID, MIN(ANIM_KEY) AS MIN_ANIM_KEY -- keep min animal_key
			 FROM SESSION.TmpIntIDChar20Lists t	
			 GROUP BY INT_ID with UR
		 )AS B
		 ON  A.INT_ID = B.INT_ID and A.ANIM_KEY <> B.MIN_ANIM_KEY
		 WHEN MATCHED THEN
		 DELETE
		 ;
		 
		 
	-- DS1: output list
     	begin
		 	DECLARE cursor1 CURSOR WITH RETURN for
		 		
		 	SELECT  
		 			a.SAMPLE_ID,
				 	a.INT_ID AS ANIMAL_ID,
				 	a.ANIM_KEY,
				 	a.SPECIES_CODE,
				 	a.SEX_CODE,
					case when  a.ANIM_KEY is not null then '1'
					      else '0' 
					end as IS_LINK_TO_ANIMAL, 
					row_number()over(order by a.ORDER )  as ORDER
		 	FROM SESSION.TmpIntIDChar20Lists a
			ORDER BY ORDER with UR;
		  
		 	OPEN cursor1;
		 	 
	   end; 
	   
	  	-- DS2: invalid list
     	begin
		 	DECLARE cursor1_1 CURSOR WITH RETURN for
		 		
		 	SELECT DISTINCT i.INPUT_VALUE
		 	FROM SESSION.TmpInputs i
		 	LEFT JOIN SESSION.TmpInputValid valid
		 	ON i.INPUT_VALUE = valid.INPUT_VALUE
		 	WHERE valid.INPUT_VALUE IS NULL
		 	AND i.INPUT_VALUE <> '' with UR;
		 	OPEN cursor1_1;
		 	 
	   end;
	    
END
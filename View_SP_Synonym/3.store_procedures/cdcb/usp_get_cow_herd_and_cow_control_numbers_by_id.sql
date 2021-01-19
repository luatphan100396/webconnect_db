CREATE OR REPLACE PROCEDURE usp_Search_Animal_By_Animal_ID_18_Bytes
--=================================================================================================
--Author: Linh Pham
--Created Date: 2020-01-15
--Description: Get list INT_ID + SEX_CODE from string input
--Output:
--        +Ds1: Table with INT_ID + SEX_CODE,animal id, animal key, species code, sex code, has error, 
--              is linked, order to animal 
--        +Ds2: Animal which has no information returned 
--=================================================================================================
(
	IN @INPUT_VALUE VARCHAR(10000) 
	,@DELIMITER VARCHAR(1) default ','
)
	DYNAMIC RESULT SETS 3
	LANGUAGE SQL
BEGIN
	    --DECALRE TABLE
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInputs
	(	
		INPUT_VALUE VARCHAR(128),
		ORDER INT  GENERATED BY DEFAULT AS IDENTITY 
      	(START WITH 1 INCREMENT BY 1)
	
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpIntIDChar18Lists   
	(
		ANIM_KEY INT,
		INT_ID CHAR(17),
		BREED_CODE CHAR(2), 
		COUNTRY_CODE CHAR(3),
		SEX_CODE char(1),
		ANIM_ID_NUM CHAR(12),
		SPECIES_CODE char(1), 
		ORDER INT
	) WITH REPLACE  ON COMMIT PRESERVE ROWS;
  
     
	   DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInputValid 
	(
		INPUT_VALUE varchar(128) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	--INSERT TABLE
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
	 	AND A.ORDER <> B.MIN_ORDER 
	 	WHEN MATCHED THEN
	 DELETE
	 ;
	  
	     -- Find matching animal id in id_xref_table
		INSERT INTO SESSION.TmpIntIDChar18Lists
		(
			ANIM_KEY,
			INT_ID, 
			BREED_CODE,
			COUNTRY_CODE,
			SEX_CODE,
			ANIM_ID_NUM,
			SPECIES_CODE,  
			ORDER
		)
		  
		 SELECT 
				a.ANIM_KEY, 
				a.INT_ID, 
				a.BREED_CODE,
				a.COUNTRY_CODE, 
				a.SEX_CODE,
				a.ANIM_ID_NUM,
				a.SPECIES_CODE,
				t.ORDER
		 FROM  SESSION.TmpInputs t
		 JOIN ID_XREF_TABLE a on upper(t.INPUT_VALUE) = a.BREED_CODE||a.COUNTRY_CODE||a.SEX_CODE ||a.ANIM_ID_NUM
		 	with UR;
		 
		 -- Find matching animal id in error data
		 INSERT INTO SESSION.TmpIntIDChar18Lists
		 (
		    ANIM_KEY,
			INT_ID, 
			SEX_CODE,
			BREED_CODE,
			COUNTRY_CODE,
			ANIM_ID_NUM,
			SPECIES_CODE,  
			ORDER
		 )
		  SELECT 
				NULL AS ANIM_KEY, 
				a.INT_ID,  
				NULL AS BREED_CODE,
				NULL AS COUNTRY_CODE,
				'U' AS  SEX_CODE,
				NULL AS ANIM_ID_NUM,
				a.SPECIES_CODE,
				t.ORDER
		 FROM  SESSION.TmpInputs t
		 LEFT JOIN 
		 		(SELECT DISTINCT 
				 		INT_ID,
				 		BREED_CODE,
				 		COUNTRY_CODE,
				 		ANIM_ID_NUM,
						SEX_CODE
				FROM SESSION.TmpIntIDChar18Lists  
		 		)validAnimal 
		 	ON t.INPUT_VALUE =validAnimal.BREED_CODE||validAnimal.COUNTRY_CODE||validAnimal.SEX_CODE ||validAnimal.ANIM_ID_NUM
		JOIN ANIM_KEY_HAS_ERROR a
			ON validAnimal.INT_ID = a.INT_ID
			WHERE validAnimal.INT_ID IS NULL
		 	with UR;
 
		 INSERT INTO SESSION.TmpInputValid 
		 (
		 INPUT_VALUE
		 )
		 SELECT BREED_CODE||COUNTRY_CODE||SEX_CODE||ANIM_ID_NUM
		 FROM SESSION.TmpIntIDChar18Lists a with UR;
  
	    -- Remove duplicate output, same animal ID but has different anim key
		
		MERGE INTO SESSION.TmpIntIDChar18Lists as A
		 using
		 ( 
			 SELECT INT_ID, MIN(ANIM_KEY) AS MIN_ANIM_KEY -- keep min animal_key
			 FROM SESSION.TmpIntIDChar18Lists t	
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
		 			a.INT_ID||a.SEX_CODE AS ID_18_BYTES,
					a.INT_ID AS ANIMAL_ID,
					a.ANIM_KEY,
					a.SPECIES_CODE,
					a.SEX_CODE,
					case when  aHasErr.INT_ID is not null then '1'
					else '0' 
					end as HAS_ERROR,
					case when  a.ANIM_KEY is not null then '1'
						else '0' 
					end as IS_LINK_TO_ANIMAL, 
					row_number()over(order by a.ORDER )  as ORDER
		 	FROM SESSION.TmpIntIDChar18Lists a
		 	LEFT JOIN ANIM_KEY_HAS_ERROR aHasErr 
		     	on aHasErr.INT_ID = a.INT_ID 
		     	and aHasErr.SPECIES_CODE = a.SPECIES_CODE 
		     
				ORDER BY ORDER with UR;
		  
		 	OPEN cursor1;
		 	 
	   END; 
	   
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
		 	 
	   END;
	    
END
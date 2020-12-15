 
CREATE OR REPLACE PROCEDURE usp_Get_Animal_Formatted_Pedigree_Info 
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-14
--Description: Get animal information: INT_ID, name, 
--birth date, cross reference...
--Output: 
--        +Ds1: Animal information: INT ID, name, birth date, sex, MBC, REG, SRC...
--======================================================
(
	IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1)
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
	--DECLARE TEMPORARY TABLE
        DECLARE GLOBAL TEMPORARY TABLE SESSION.tmpGetInput
		(
			INT_ID,
			ANIM_KEY,
			SPECIES_CODE,
			SEX_CODE
		)WITH REPLACE ON COMMIT PRESERVE ROWS;

		DECLARE GLOBAL TEMPORARY TABLE SESSION.tmpGetAnimalInfo_Alias
		(
			SEX_CODE,
			INT_ID,
			SIRE_INT_ID,
			DAM_INT_ID,
			ALIAS,
			BIRTH_PDATE,
			SOURCE_CODE,
			MODIFY_PDATE,
			
		)WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	--INSERT INTO TABLE
	INSERT INTO SESSION.tmpGetInput
	(
		INT_ID,
		ANIM_KEY,
		SPECIES_CODE,
		SEX_CODE
	)
	VALUE
	(
		@INT_ID,
		@ANIM_KEY,
		@SPECIES_CODE,
		@SEX_CODE
	)
		
	
	
	BEGIN
		DECLARE cursor1  CURSOR WITH RETURN for
	    SELECT 
	    
		OPEN cursor1;
		  
	END;
END P1
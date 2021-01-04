CREATE OR REPLACE PROCEDURE usp_Get_Animal_Aliases
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-15
--Description: Get cross reference animal: INT_ID, name, 
--birth date,...
--Output: 
--        +Ds cross reference animal information: INT ID, name, birth date, sex, MBC, REG, SRC...
--======================================================
(
	IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1)
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
	--DECLARE VARIABLES
	DECLARE DEFAULT_DATE DATE;
	DECLARE PREFERRED_INT_ID CHAR(17);
	--DECLARE TEMPORARY TABLE
        DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
		(
			INT_ID CHAR(17),
			ANIM_KEY INT,
			SPECIES_CODE CHAR(1),
			SEX_CODE CHAR(1)
		)WITH REPLACE ON COMMIT PRESERVE ROWS;

		DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_Alias --DROP TABLE SESSION.TmpAnimalLists_Alias
	(
	    ANIM_KEY INT,
		INT_ID CHAR(17),
		SPECIES_CODE char(1),
		SOURCE_CODE CHAR(1),
		REGIS_STATUS_CODE VARCHAR(128),
		SEX_CODE CHAR(1),
		PREFERRED_CODE char(1)
	)WITH REPLACE  ON COMMIT PRESERVE ROWS;
	---SET VARIABLES
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);

	--INSERT INTO TABLE
	INSERT INTO SESSION.TMP_INPUT
	(
		INT_ID,
		ANIM_KEY,
		SPECIES_CODE,
		SEX_CODE
	)
	VALUES
	(
		@INT_ID,
		@ANIM_KEY,
		@SPECIES_CODE,
		@SEX_CODE
	);
--	INSERT INTO SESSION.TMP_INPUT
--	(  
--		INT_ID,
--	   ANIM_KEY,
--	   SPECIES_CODE,
--	   SEX_CODE
--   )
--   SELECT INT_ID,
--		ANIM_KEY,
--		SPECIES_CODE,
--		SEX_CODE
--   FROM TEST_2000_ANIMALS 
--   ; 
-- 
	BEGIN
		DECLARE cursor1  CURSOR WITH RETURN for
			    
			SELECT 
			id.ANIM_KEY,
			t.INT_ID AS ROOT_ANIMAL_ID,
			id.INT_ID AS ANIMAL_ID, 
			ped.SEX_CODE,
			ped.SOURCE_CODE AS SRC,
			id.PREFERRED_CODE,
			id.REGIS_STATUS_CODE as REG_CODES,
		 	VARCHAR_FORMAT(DEFAULT_DATE + id.MODIFY_PDATE,'YYYY-MM-DD') AS MODIFY_DATE, 
		 	anim.ANIM_NAME AS NAME,
		 	case when t.INT_ID <> id.INT_ID then 1 
		 	     else 0
		 	end as IS_SHOW_UI
		FROM SESSION.TMP_INPUT t
		INNER JOIN ID_XREF_TABLE id
			  ON t.ANIM_KEY = id.ANIM_KEY
			  AND t.SEX_CODE = id.SEX_CODE
			  AND t.SPECIES_CODE = id.SPECIES_CODE  
		LEFT JOIN ANIM_NAME_TABLE anim
			ON anim.INT_ID=id.INT_ID
			AND anim.SPECIES_CODE=id.SPECIES_CODE
			AND anim.SEX_CODE=id.SEX_CODE 
		LEFT JOIN PEDIGREE_TABLE ped
		    ON ped.ANIM_KEY = t.ANIM_KEY
		    AND  ped.SPECIES_CODE = t.SPECIES_CODE 
		    with ur;    
		OPEN cursor1;
		  
	END;
END P1
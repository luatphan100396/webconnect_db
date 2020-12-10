CREATE OR REPLACE PROCEDURE usp_Get_Animal_Clonal_Family_By_ID
--======================================================
--Author: Trong Le
--Created Date: 2020-24-09
--Description: Get animal family: Member, Source code, Bod date
--Output: 
--        +Ds1: Animal famimy:
--					Member: INT_ID
--					Source code: SOURCE_CODE
--					Mod date: MODIFY_PDATE + 1960-01-01
--======================================================
( 
    IN @INT_ID CHAR(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE CHAR(1),
	IN @SEX_CODE CHAR(1)
)
DYNAMIC RESULT SETS 10
    
BEGIN

	-- Declaration
	DECLARE v_DEFAULT_DATE DATE;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalFamily --DROP TABLE SESSION.TmpAnimalFamily
	(
		MEMBER	CHAR(17),
		SOURCE_CODE	CHAR(1),
		MOD_DATE	VARCHAR(10)
		 
	)WITH REPLACE  ON COMMIT PRESERVE ROWS;
	
	SET v_DEFAULT_DATE = (SELECT STRING_VALUE FROM dbo.constants WHERE name ='Default_Date_Value' LIMIT 1 WITH UR);
	
	INSERT INTO SESSION.TmpAnimalFamily
	(
		MEMBER,
		SOURCE_CODE,
		MOD_DATE
	)
	SELECT
		ixt.INT_ID,
		cl.SOURCE_CODE,
		VARCHAR_FORMAT(DATE(v_DEFAULT_DATE) + cl.MODIFY_PDATE, 'YYYY-MM-DD') AS MOD_DATE
	FROM
		(SELECT	ANIM_KEY,
				SOURCE_CODE,
				MODIFY_PDATE
		FROM CLONE_TABLE
		WHERE BASE_ANIM_KEY = @ANIM_KEY
		) cl
	JOIN ID_XREF_TABLE ixt
		ON ixt.ANIM_KEY = cl.ANIM_KEY
	WITH UR;
	
	BEGIN
		DECLARE CUR CURSOR WITH RETURN FOR
		SELECT * FROM SESSION.TmpAnimalFamily
		WITH UR;
		OPEN CUR;
	END;
	
END
CREATE OR REPLACE FUNCTION fn_Check_Status_Changing_Animal
--======================================================
--Author: Trong Le
--Created Date: 2020-10-08
--Description: Check whether the status of editting animal is enable or disable
--======================================================
(
	@INT_ID			CHAR(17), 
	@ANIM_KEY		INT, 
	@SPECIES_CODE	CHAR(1),
	@SEX_CODE		CHAR(1)
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN
	DECLARE LATEST_STATUS VARCHAR(11);
	DECLARE IS_EDITABLE INTEGER DEFAULT NULL;
	
	
	SET LATEST_STATUS = (SELECT STATUS
						FROM CHANGE_TRACKING_ANIMAL
						WHERE ANIMAL_ID = @INT_ID
						AND ANIM_KEY = @ANIM_KEY
						AND SPECIES_CODE = @SPECIES_CODE
						AND SEX_CODE = @SEX_CODE
						ORDER BY ID DESC
						LIMIT 1);
	
	SET IS_EDITABLE = (	CASE LATEST_STATUS
						WHEN 'UNPROCESSED'	THEN 0
						WHEN 'PROCESSED'	THEN 1
						ELSE 1
						END);
	
	RETURN IS_EDITABLE;
END
CREATE OR REPLACE FUNCTION fn_Check_Has_Cross_Reference
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-19
--Description: Check whether the input animal has cross referencfe
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
	DECLARE HAS_CROSS_REFERENE SMALLINT DEFAULT 0;
	
	SET HAS_CROSS_REFERENE = (SELECT COUNT(1)
								FROM ID_XREF_TABLE 
								WHERE 
									ANIM_KEY = @ANIM_KEY
									AND SPECIES_CODE = @SPECIES_CODE
									AND SEX_CODE = @SEX_CODE
									AND INT_ID <> @INT_ID	 
								LIMIT 1);
	 
	
	RETURN HAS_CROSS_REFERENE;
END
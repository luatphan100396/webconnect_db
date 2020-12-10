CREATE OR REPLACE PROCEDURE usp_Check_Showing_Parentage_Ver_Record
--======================================================
--Author: Trong Le
--Created Date: 2020-10-21
--Description: Return whether show Parentage Validation Record or not
--Output: IS_SHOW_PARENTAGE = 0, show Parentage Validation Record
--		  IS_SHOW_PARENTAGE = 1, not show Parentage Validation Record
--======================================================
( 
    IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1)
)
DYNAMIC RESULT SETS 10
    
BEGIN

	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
	(
		INT_ID char(17), 
	    ANIM_KEY INT, 
	    SPECIES_CODE char(1),
	    SEX_CODE char(1) 
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	  INSERT INTO SESSION.TMP_INPUT
	(  INT_ID,
	   ANIM_KEY,
	   SPECIES_CODE,
	   SEX_CODE 
   )
    
   VALUES (
	   @INT_ID,
	   @ANIM_KEY,
	   @SPECIES_CODE,
	   @SEX_CODE 
   ); 
    
	
	BEGIN
		DECLARE CUR CURSOR WITH RETURN FOR
		SELECT  CASE WHEN MAX(n.CDCB_FEE_PAID_CODE) IS NOT NULL then 1 else 0 END IS_SHOW_PARENTAGE 
		FROM SESSION.TMP_INPUT t
		LEFT JOIN NOMINATION_TABLE n
			ON t.anim_key = n.anim_key
			AND n.CDCB_FEE_PAID_CODE  <> 'N'
			GROUP BY t.anim_key ; 
		OPEN CUR;
	END;
	   
END
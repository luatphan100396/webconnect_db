CREATE OR REPLACE PROCEDURE usp_Get_Animal_Nomination_Status
--===================================================================================================
--Author: Linh Pham
--Created Date: 2020-12-21
--Description: Get detail of animal genotype status
--for one animal
--Output:
--        +Ds: Nomination status: group, hrc, fee, paid, nominator
--===================================================================================================
(
	IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1)
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
 	--DECLARE VARIABLE 
 	DECLARE DEFAULT_DATE DATE;
 	DECLARE v_EVAL_PDATE SMALLINT;
 	--SET VARIABLE
 	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
 	SET v_EVAL_PDATE = (select PUBRUN_PDATE FROM ENV_VAR_TABLE LIMIT 1); 
	--DECLARE TABLE
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT --INPUT VALUE
	(
	    INT_ID char(17), 
		ANIM_KEY INT, 
		SPECIES_CODE char(1),
		SEX_CODE char(1)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	--INSERT INO TEMP TABLE
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
	
	--INSERT 200 animals
		
--		INSERT INTO SESSION.TMP_INPUT
--		(  
--			INT_ID,
--		   ANIM_KEY,
--		   SPECIES_CODE,
--		   SEX_CODE
--	   )
--	   SELECT INT_ID,
--			ANIM_KEY,
--			SPECIES_CODE,
--			SEX_CODE
--	   FROM TEST_2000_ANIMALS 
--	   ; 
--		
-- Get genotype group
 BEGIN
 DECLARE cur0 CURSOR WITH RETURN FOR
	SELECT DISTINCT   
		inp.INT_ID AS ROOT_ANIMAL_ID,
		VARCHAR_FORMAT(DEFAULT_DATE + nomin.ENTRY_PDATE,'YYYY-MM-DD') AS NOM_DATE, 
		nomin.GROUP_NAME AS GROUP_NAME,
		nomin.HERD_REASON_CODE AS HRC,
		nomin.CDCB_FEE_PAID_CODE AS FEE_CODE, 
		VARCHAR_FORMAT(DEFAULT_DATE + gFTable.LAST_APPRAISAL_PDATE,'YYYY-MM-DD') AS FEE_ASSIGNED_DATE,
		VARCHAR_FORMAT(DEFAULT_DATE + gBTable.BILLING_PDATE,'YYYY-MM-DD') AS BILLING_PDATE,
		gBTable.CDCB_FEE_AMT AS AMOUNT,
		gBTable.CDCB_FEE_PAID_CODE AS PAID,
		nomin.REQUESTER_ID AS REQUESTOR,
		nomin.MODIFY_TIMESTAMP AS MOD_DATE
	FROM NOMINATION_TABLE nomin
	INNER JOIN SESSION.TMP_INPUT inp
		ON nomin.ANIM_KEY=inp.ANIM_KEY
	LEFT JOIN GENOTYPE_FEES_TABLE gFTable 
		ON cast (gFTable.HERD_CODE as char(8))=nomin.GROUP_NAME
		AND gFTable.EVAL_PDATE=v_EVAL_PDATE
	LEFT JOIN GENOTYPE_BILLINGS_TABLE gBTable 
		ON inp.ANIM_KEY = gBTable.ANIM_KEY
		AND gBTable.REQUESTER_ID= nomin.REQUESTER_ID
	with UR;
 OPEN cur0; 
END;
END P1
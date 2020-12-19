CREATE OR REPLACE PROCEDURE usp_Get_Animal_Pedigree_Infor_Evaluation_By_ID
--========================================================================================================
--Author: Trong Le
--Created Date: 2020-11-12
--Description: Get information of Sire and Dam of animal
--Output: 
--        +Ds1: Ancestor information(id, name, sex, src, genotyped) with two generations
--============================================================================================================
( 
	IN @INT_ID			CHAR(17), 
	IN @ANIM_KEY		INT, 
	IN @SPECIES_CODE	CHAR(1),
	IN @SEX_CODE		CHAR(1)
)
DYNAMIC RESULT SETS 1
BEGIN
	/*=======================
		Variable declaration
	=========================*/
	DECLARE v_DEFAULT_DATE DATE;
	DECLARE v_EVAL_PDATE SMALLINT;
	
	
	/*=======================
		Temp table creation
	=========================*/
	DECLARE GLOBAL TEMPORARY TABLE SESSION.Input
	(
	    INT_ID			CHAR(17),
	    ANIM_KEY		INT,
	    SPECIES_CODE	CHAR(1),
	    SEX_CODE		CHAR(1)
   
	)WITH REPLACE
	ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.Pedigree_Evaluation
	(
	    INT_ID			CHAR(17),
	    ANIM_KEY		INT,
	    SIRE_ID			CHAR(17),
	    DAM_ID			CHAR(17),
	    SPECIES_CODE	CHAR(1),
	    SEX_CODE		CHAR(1)
   
	)WITH REPLACE
	ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.Result
	(
	    ROOT_ANIMAL_ID	CHAR(17),
	    INT_ID			CHAR(17),
	    ANIM_KEY		INTEGER,
	    SIRE_ID			CHAR(17),
	    DAM_ID			CHAR(17),
	    SPECIES_CODE	CHAR(1),
	    SEX_CODE		CHAR(1),
	    GENERATION		SMALLINT
   
	)WITH REPLACE
	ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmpPedGenotype
	(
		ANIM_KEY INT NULL 
	) WITH REPLACE
	ON COMMIT PRESERVE ROWS;
	
	
	SET v_DEFAULT_DATE = (SELECT STRING_VALUE FROM dbo.constants WHERE NAME ='Default_Date_Value' LIMIT 1);
	
	SET v_EVAL_PDATE = (SELECT RUN_PDATE FROM ENV_VAR_TABLE LIMIT 1);
	
	
	INSERT INTO SESSION.Input
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
	
	INSERT INTO SESSION.Pedigree_Evaluation
	(
		INT_ID,
	    ANIM_KEY,
	    SIRE_ID,
	    DAM_ID,
	    SPECIES_CODE,
	    SEX_CODE
	)
	SELECT	inp.INT_ID,
			inp.ANIM_KEY,
			bull.SIRE_ID,
			bull.DAM_ID,
			inp.SPECIES_CODE,
			inp.SEX_CODE
	FROM SESSION.Input inp
	INNER JOIN BULL_EVL_TABLE bull
		ON inp.INT_ID = bull.BULL_ID
		AND bull.EVAL_PDATE = v_EVAL_PDATE
		
	UNION ALL
	
	SELECT	inp.INT_ID,
			inp.ANIM_KEY,
			cow.SIRE_ID,
			cow.DAM_ID,
			inp.SPECIES_CODE,
			inp.SEX_CODE
	FROM SESSION.Input inp
	INNER JOIN COW_EVL_TABLE cow
		ON inp.INT_ID = cow.INT_ID
		AND cow.EVAL_PDATE = v_EVAL_PDATE
	;
	
	INSERT INTO SESSION.Result
	(
		ROOT_ANIMAL_ID,
		INT_ID,
	    ANIM_KEY,
	    SIRE_ID,
	    DAM_ID,
	    SPECIES_CODE,
	    SEX_CODE,
	    GENERATION
	)
	SELECT	ped_evl_lat.ROOT_ANIMAL_ID,
			ped_evl_lat.INT_ID,
			id.ANIM_KEY,
			ped_evl_lat.SIRE_ID,
			ped_evl_lat.DAM_ID,
			ped_evl_lat.SPECIES_CODE,
			ped_evl_lat.SEX_CODE,
			ped_evl_lat.GENERATION
	FROM
	(
		SELECT	ped_evl.INT_ID,
				ped_evl.ANIM_KEY,
				ped_evl.SIRE_ID,
				ped_evl.DAM_ID,
				ped_evl.SPECIES_CODE,
				ped_evl.SEX_CODE
		FROM SESSION.Pedigree_Evaluation ped_evl
	) AS t,
	LATERAL
	(
		VALUES 	(t.INT_ID, t.INT_ID, t.SIRE_ID, t.DAM_ID, t.SPECIES_CODE, t.SEX_CODE, 0),
				(t.INT_ID, t.SIRE_ID, NULL, NULL, t.SPECIES_CODE, 'M', 1),
				(t.INT_ID, t.DAM_ID, NULL, NULL, t.SPECIES_CODE, 'F', 1)
	) AS ped_evl_lat (ROOT_ANIMAL_ID, INT_ID, SIRE_ID, DAM_ID, SPECIES_CODE, SEX_CODE, GENERATION)
	LEFT JOIN ID_XREF_TABLE id
		ON id.INT_ID = ped_evl_lat.INT_ID
		AND id.SPECIES_CODE = ped_evl_lat.SPECIES_CODE
		AND id.SEX_CODE = ped_evl_lat.SEX_CODE
	;
	
	
	INSERT INTO SESSION.tmpPedGenotype(ANIM_KEY)
	SELECT DISTINCT rs.ANIM_KEY
	FROM SESSION.Result rs
	INNER JOIN GENOTYPE_TABLE geno
		ON rs.ANIM_KEY = geno.ANIM_KEY 
	WITH UR ;
	
	
	BEGIN
		DECLARE CUR1 CURSOR WITH RETURN FOR
		SELECT	rs.ROOT_ANIMAL_ID,
				rs.INT_ID AS ANIMAL_ID,
				rs.SIRE_ID SIRE_INT_ID,
				rs.DAM_ID DAM_INT_ID,
				rs.SEX_CODE,
				rs.GENERATION,
				VARCHAR_FORMAT(v_DEFAULT_DATE + ped.BIRTH_PDATE,'YYYY-MM-DD') AS BIRTH_DATE,
				TRIM(aname.ANIM_NAME) AS LONG_NAME,
				CASE WHEN gyno.ANIM_KEY IS NOT NULL THEN 'Y'
					 ELSE 'N'
				END AS GENOTYPED,
				ped.SOURCE_CODE AS SRC,
				CASE WHEN ped.ANIM_KEY IS NOT NULL THEN 'Y'
					 ELSE 'N'
				END AS IS_EXIST
		FROM SESSION.Result rs
		LEFT JOIN PEDIGREE_TABLE ped
			ON rs.ANIM_KEY = ped.ANIM_KEY
			AND rs.SPECIES_CODE = ped.SPECIES_CODE
		LEFT JOIN ANIM_NAME_TABLE aname
			ON rs.INT_ID = aname.INT_ID
			AND rs.SPECIES_CODE = aname.SPECIES_CODE
			AND rs.SEX_CODE = aname.SEX_CODE
		LEFT JOIN SESSION.tmpPedGenotype gyno
			ON rs.ANIM_KEY = gyno.ANIM_KEY
		ORDER BY rs.ROOT_ANIMAL_ID, rs.GENERATION
		;
		OPEN CUR1;
	END;
	   
END 

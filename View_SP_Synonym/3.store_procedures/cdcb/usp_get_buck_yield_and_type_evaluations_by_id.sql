CREATE OR REPLACE PROCEDURE usp_Get_Buck_Yield_And_Type_Evaluations_By_ID
--========================================================================================================
--Author: Tri Do
--Created Date: 2021-01-27
--Description: Get buck yield and type evaluations data: PTA, PA, Metrit, ... for one animal
--Output: 
--        +Ds1: Animal information linked to specific run
--        +Ds2: Metrit result
--        +Ds3: Pedigree inbreeding 
--        +Ds4: Evaluation data for all publish trait: Milk, Fat, Pro
--        +Ds5: Type summary data: final score, stature, Strength...
--        +Ds6: Get DAU_HD, STATES, HERDS, DAUS, APPRAISAIS for type summary
--============================================================================================================
(
	IN @INT_ID char(17),
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1)
)
	DYNAMIC RESULT SETS 7
BEGIN

	--DECLEAR VARIABLE
	DECLARE DEFAULT_DATE DATE;
	DECLARE v_EVAL_PDATE SMALLINT;
	
	--DECLEAR TABLE
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
	(
		INT_ID CHAR(17),
		ANIM_KEY INT,
		SPECIES_CODE CHAR(1),
		SEX_CODE CHAR(1)
	)WITH REPLACE ON COMMIT PRESERVE ROWS;

	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_BUCK_EVL_TABLE AS
	(
		SELECT
		bv.*,
		CAST(NULL AS CHAR(17)) AS ROOT_INT_ID,
		CAST(NULL AS INT) AS ROOT_ANIM_KEY
		FROM BUCK_EVL_TABLE bv
	) DEFINITION ONLY
	WITH REPLACE ON COMMIT PRESERVE ROWS;
 
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_Merit
	(
		ROOT_INT_ID CHAR(17),
		TRAIT char(4),
		PTA smallint,
		REL smallint
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_PTA -- drop table SESSION.TmpAnimalLists_BV_PTA
	(
		ROOT_INT_ID CHAR(17),
		TRAIT VARCHAR(5),
		PTA decimal(10,2),
		REL smallint,
		DAUS int,
		LACT_DAUS varchar(10),
		HERDS int,
		PTA_PCT varchar(10),
		MEAN int
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_indicator  --drop table SESSION.TmpAnimalLists_BV_indicator 
	(
		ROOT_INT_ID CHAR(17),
		PED_GEN varchar(10),
		INBRD smallint
	) WITH REPLACE ON COMMIT PRESERVE ROWS;

	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_type_traits
	( 
		TRAIT VARCHAR(50)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;

	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_type_bv AS
	(
		SELECT 
		CAST(NULL AS INT) AS FS_DAU_QTY,
		bv.*
		FROM BUCK_TYPE_TABLE bv
	) DEFINITION ONLY 
	WITH REPLACE ON COMMIT PRESERVE ROWS;

	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_type_PIA -- drop table SESSION.TmpAnimalLists_BV_type_PIA
	(
		ROOT_INT_ID CHAR(17),
		TRAIT varchar(128),
		DAU_SCORE decimal(10,1),
		PTA decimal(10,1),
		REL smallint
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	 
	---INSERT
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
	
	--SET VARIABLE
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
	--SET v_EVAL_PDATE = (select GOATYLD4 FROM ENV_VAR_TABLE LIMIT 1);
	SET v_EVAL_PDATE = 21884;

    --GET BULL_EVL_TABLE
	INSERT INTO  SESSION.tmp_BUCK_EVL_TABLE
		SELECT bv.*,
		inp.INT_ID AS ROOT_INT_ID,
		inp.ANIM_KEY AS ROOT_ANIM_KEY
	FROM BUCK_EVL_TABLE bv
	INNER JOIN SESSION.TMP_INPUT inp
		ON bv.ANIM_KEY = inp.ANIM_KEY
		and bv.EVAL_PDATE = v_EVAL_PDATE
	with UR;
	
	-- Get merit data
	INSERT INTO SESSION.TmpAnimalLists_BV_Merit
	(
		ROOT_INT_ID,
		TRAIT,
		PTA,
		REL
	)
	SELECT 
		cEvl.ROOT_INT_ID
		,'MFP$' AS TRAIT
		,cEvl.PTA_MFP_QTY AS PTA
		,cast(cEvl.PTA_MF_REL_PCT as varchar(5)) as REL
	FROM SESSION.tmp_BUCK_EVL_TABLE cEvl
	with UR;	 
	
	-- Get PTA from COW_EVL_TABLE
	INSERT INTO SESSION.TmpAnimalLists_BV_PTA
	(
		ROOT_INT_ID,
		TRAIT,
		PTA,
		REL,
		DAUS,
		LACT_DAUS,
		HERDS,
		PTA_PCT,
		MEAN
	)
	SELECT
		tCEvl.ROOT_INT_ID
		,trait.TRAIT_SHORT_NAME
		,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.PTA_MLK_QTY
				WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.PTA_FAT_QTY
				WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PTA_PRO_QTY
				ELSE NULL
			END AS PTA
		,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.PTA_MF_REL_PCT
				WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.PTA_MF_REL_PCT
				WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PTA_PRO_REL_PCT
				ELSE NULL
			END AS REL
		,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.MF_DAU_QTY
				WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.MF_DAU_QTY
				WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PRO_DAU_QTY
				ELSE NULL
			END  AS DAUS
		,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.AVG_LACT_DAU_MF
				WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.AVG_LACT_DAU_MF
				WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.AVG_LACT_DAU_PRO
				ELSE NULL
			END AS LACT_DAUS
		,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.MF_HERDS_QTY
				WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.MF_HERDS_QTY
				WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PRO_HERDS_QTY
				ELSE NULL
			END AS HERDS
		,CASE WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.PTA_FAT_PCT
				WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PTA_PRO_PCT
				ELSE NULL
			END AS PTA_PCT
		,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.AVG_STD_MLK
				WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.AVG_STD_FAT
				WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.AVG_STD_PRO
				ELSE NULL
			END AS MEAN
	FROM SESSION.tmp_BUCK_EVL_TABLE tCEvl
	CROSS JOIN ( SELECT TRAIT_SHORT_NAME,
						UNIT
					FROM TRAIT_TABLE
					WHERE publish_pdate >0 and publish_pdate < days(now())
							AND UPPER(TRAIT_NAME) IN ('MILK', 'FAT', 'PROTEIN')
					with UR
				)trait with UR;

	-- Get genomic indicator
	INSERT INTO SESSION.TmpAnimalLists_BV_indicator
	(
		ROOT_INT_ID,
		PED_GEN,
		INBRD
	) 
	SELECT 
		bv.ROOT_INT_ID,
		'Pedigree', 
		bv.INBRD_PCT
	FROM SESSION.tmp_BUCK_EVL_TABLE bv
	with UR;

	INSERT INTO SESSION.tmp_type_traits(TRAIT)
	VALUES ('Final Score'),
			('Stature'),
			('Strength'),
			('Dairyness'),
			('Teat diameter'),
			('Rear Legs'),
			('Rump Angle'),
			('Rump Width'),
			('Fore Udder Att'),
			('Rear Udder Ht'),
			('Rear Udder Arch'),
			('Udder Depth'),
			('Susp Lig'),
			('Teat Placement');

	INSERT INTO  SESSION.tmp_type_bv
	SELECT  
		0 as FS_DAU_QTY,
		bv.*
	FROM  BUCK_TYPE_TABLE bv
	INNER JOIN SESSION.TMP_INPUT inp
	ON bv.ANIM_KEY = inp.ANIM_KEY 
	AND bv.EVAL_PDATE = v_EVAL_PDATE
	AND inp.SPECIES_CODE='1'
	WITH UR;

	INSERT INTO SESSION.TmpAnimalLists_BV_type_PIA
	(
		ROOT_INT_ID,
		TRAIT,
		DAU_SCORE,
		PTA,
		REL
	)
	SELECT 
			tcv.INT_ID AS ROOT_INT_ID, 
			trait.TRAIT,
	case  	when trait.TRAIT ='Final Score'then tcv.AVG_DAU_FS
			when trait.TRAIT ='Stature' then tcv.AVG_DAU_STT
			when trait.TRAIT ='Strength' then tcv.AVG_DAU_STR
			when trait.TRAIT ='Dairyness' then tcv.AVG_DAU_DR
			when trait.TRAIT ='Teat diameter'  then tcv.AVG_DAU_TEAT_D
			when trait.TRAIT ='Rear Legs'  then tcv.AVG_DAU_RL
			when trait.TRAIT ='Rump Angle'  then tcv.AVG_DAU_RUMP_A
			when trait.TRAIT ='Rump Width'  then tcv.AVG_DAU_RUMP_W
			when trait.TRAIT ='Fore Udder Att' then tcv.AVG_DAU_FORE_U_ATT
			when trait.TRAIT ='Rear Udder Ht'  then tcv.AVG_DAU_REAR_U_HT
			when trait.TRAIT ='Rear Udder Arch' then tcv.AVG_DAU_REAR_U_ARCH
			when trait.TRAIT ='Udder Depth'  then tcv.AVG_DAU_UDDER_D
			when trait.TRAIT ='Susp Lig'  then tcv.AVG_DAU_SUSP_LIG
			when trait.TRAIT ='Teat Placement' then tcv.AVG_DAU_TEAT_P
		else null
	end as DAU_SCORE,
	case  	when trait.TRAIT ='Final Score'then tcv.PTA_FS_QTY
			when trait.TRAIT ='Stature' then tcv.PTA_STT_QTY
			when trait.TRAIT ='Strength' then tcv.PTA_STR_QTY
			when trait.TRAIT ='Dairyness' then tcv.PTA_DR_QTY
			when trait.TRAIT ='Teat diameter'  then tcv.PTA_TEAT_D_QTY
			when trait.TRAIT ='Rear Legs'  then tcv.PTA_RL_QTY
			when trait.TRAIT ='Rump Angle'  then tcv.PTA_RUMP_A_QTY
			when trait.TRAIT ='Rump Width'  then tcv.PTA_RUMP_W_QTY
			when trait.TRAIT ='Fore Udder Att' then tcv.PTA_FORE_U_ATT_QTY
			when trait.TRAIT ='Rear Udder Ht'  then tcv.PTA_REAR_U_HT_QTY
			when trait.TRAIT ='Rear Udder Arch' then tcv.PTA_REAR_U_ARCH_QTY
			when trait.TRAIT ='Udder Depth'  then tcv.PTA_UDDER_D_QTY
			when trait.TRAIT ='Susp Lig'  then tcv.PTA_SUSP_LIG_QTY
			when trait.TRAIT ='Teat Placement' then tcv.PTA_TEAT_P_QTY
		else null
	end as PTA,
	case 	when trait.TRAIT ='Final Score'then tcv.PTA_REL_FS_PCT
			when trait.TRAIT ='Stature' then tcv.PTA_REL_STT_PCT
			when trait.TRAIT ='Strength' then tcv.PTA_REL_STR_PCT
			when trait.TRAIT ='Dairyness' then tcv.PTA_REL_DR_PCT
			when trait.TRAIT ='Teat diameter'  then tcv.PTA_REL_TEAT_D_PCT
			when trait.TRAIT ='Rear Legs'  then tcv.PTA_REL_RL_PCT
			when trait.TRAIT ='Rump Angle'  then tcv.PTA_REL_RUMP_A_PCT
			when trait.TRAIT ='Rump Width'  then tcv.PTA_REL_RUMP_W_PCT
			when trait.TRAIT ='Fore Udder Att' then tcv.PTA_REL_FORE_U_ATT_PCT
			when trait.TRAIT ='Rear Udder Ht'  then tcv.PTA_REL_REAR_U_HT_PCT
			when trait.TRAIT ='Rear Udder Arch' then tcv.PTA_REL_REAR_U_ARCH_PCT
			when trait.TRAIT ='Udder Depth'  then tcv.PTA_REL_UDDER_D_PCT
			when trait.TRAIT ='Susp Lig'  then tcv.PTA_REL_SUSP_LIG_PCT
			when trait.TRAIT ='Teat Placement' then tcv.PTA_REL_TEAT_P_PCT
		else null
	end as REL
	FROM  SESSION.tmp_type_traits  trait
		INNER JOIN
		(
			select t.*, row_number() over(partition by INT_ID order by FS_DAU_QTY desc) as RN
			from SESSION.tmp_type_bv t
		)
		tcv
		ON tcv.RN=1 with UR;

	--Reformat data column DAU_SCORE, PTA to display 1 decimal (value*0.1)
	UPDATE SESSION.TmpAnimalLists_BV_type_PIA
	SET DAU_SCORE = float2char(DAU_SCORE*0.1,0.1)
		,PTA = float2char(PTA*0.1,0.1);
        
  	--DS1:Get animal information
		BEGIN
		 	DECLARE cursor1 CURSOR WITH RETURN for 
		 	SELECT 
				animEvl.ROOT_INT_ID AS ROOT_ANIMAL_ID 
				,animEvl.INT_ID AS PREFERED_ID
				,coalesce(animEvl.EVAL_BREED_CODE,'N/A') as EVAL_BREED
			 	,coalesce(VARCHAR_FORMAT(DEFAULT_DATE + animEvl.EVAL_PDATE,'Month YYYY'),'N/A') AS RUN_NAME
				,animEvl.MFP_PCTL as PERCENTILE 
				,animEvl.SIRE_ID AS SIRE_INT_ID
				,animEvl.DAM_ID AS DAM_INT_ID
				,trim(anim_name.ANIM_NAME) AS LONG_NAME 
				,trim(ai.BULL_SHORT_NAME) AS SHORT_NAME
				,animEvl.HERD_CODE
				,animEvl.MOST_DAU_HERD_QTY
				FROM SESSION.tmp_BUCK_EVL_TABLE animEvl 
				LEFT JOIN ANIM_NAME_TABLE anim_name
					ON  anim_name.INT_ID = animEvl.INT_ID
					AND anim_name.SPECIES_CODE ='1'
					AND anim_name.SEX_CODE ='M'
				LEFT JOIN AI_CODES_TABLE ai
				  ON ai.ANIM_KEY = animEvl.ROOT_ANIM_KEY 
			    with UR;
		 	 
		 	OPEN cursor1;
	   	END;
	  
	   
     
	--DS2: Get animal BV Merit
		BEGIN
		 	DECLARE cursor2 CURSOR WITH RETURN for
		 		 
		 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID,
					tmp.TRAIT,
					'US$',
					PTA,
					cast(cast(REL as int) || (case when REL is not null then '%' else '' end ) as varchar(30)) as REL
					 
		 	FROM SESSION.TmpAnimalLists_BV_Merit tmp
		 	ORDER BY ROOT_INT_ID
			with UR;
		 	OPEN cursor2;
	   	END;
	 
	--DS3: Get animal BV indicator
		BEGIN
		 	DECLARE cursor3 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID as ROOT_ANIMAL_ID,
				 	PED_GEN,
				 	INBRD
		 	
		 	FROM SESSION.TmpAnimalLists_BV_indicator with UR;
		 	
		 	OPEN cursor3;
	   	END;
	   
    --DS4: Get animal BV evaluation
		BEGIN
	      
		 	DECLARE cursor4 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID,
			tmp.TRAIT,
			traits.UNIT,
			case when tmp.TRAIT IN ('Mlk' ,'Fat','Pro') THEN float2char_thsnd_format(PTA,DECIMAL_ADJUST_CODE)
				 else  float2char_thsnd_format(PTA,DECIMAL_ADJUST_CODE) 
			end AS PTA,
			 
			float2char_thsnd_format(REL,1) || (case when REL is not null then '%' else '' end ) as REL,
			DAUS,
			LACT_DAUS,
			HERDS, 
			PTA_PCT, 
			MEAN
			  
		 	FROM SESSION.TmpAnimalLists_BV_PTA tmp
		 	LEFT JOIN  
		 	(
		 	  select TRAIT_FULL_NAME, 
		 	  TRAIT_SHORT_NAME,
		 	  UNIT,
		 	  case when DECIMAL_ADJUST_CODE = 2 then 0.01
		 	       when DECIMAL_ADJUST_CODE = 1 then 0.1
		 	       else 1
		 	  end as DECIMAL_ADJUST_CODE
		 	  from TRAIT_TABLE with UR
		 	)
		 	 traits on tmp.TRAIT = traits.TRAIT_SHORT_NAME
		 	ORDER BY ROOT_INT_ID	, CASE WHEN tmp.TRAIT = 	'Mlk'	THEN	1
											WHEN tmp.TRAIT = 	'Fat'	THEN	2
											WHEN tmp.TRAIT = 	'Pro'	THEN	3
											ELSE 999
										END with UR;
		 	
		 	OPEN cursor4;
	   	END;

	--DS5: Get animal BV type PIA
		BEGIN
		 	DECLARE cursor5 CURSOR WITH RETURN for
		 		
		 	SELECT 	ROOT_INT_ID AS ROOT_ANIMAL_ID,
					TRAIT,
					DAU_SCORE,
					PTA,
					cast(cast(REL as int) || (case when REL is not null then '%' else '' end ) as varchar(30)) as REL
		 	FROM SESSION.TmpAnimalLists_BV_type_PIA 
		 	ORDER BY ROOT_INT_ID, CASE 	when TRAIT ='Final Score'then 1
										when TRAIT ='Stature' then 2
										when TRAIT ='Strength' then 3
										when TRAIT ='Dairyness' then 4
										when TRAIT ='Teat diameter'  then 5
										when TRAIT ='Rear Legs'  then 6
										when TRAIT ='Rump Angle'  then 7
										when TRAIT ='Rump Width'  then 8
										when TRAIT ='Fore Udder Att' then 9
										when TRAIT ='Rear Udder Ht'  then 10
										when TRAIT ='Rear Udder Arch' then 11
										when TRAIT ='Udder Depth'  then 12
										when TRAIT ='Susp Lig'  then 13
										when TRAIT ='Teat Placement' then 14
										ELSE 999
										END with UR;
		 	OPEN cursor5;
	   	END;

	--DS6: GET DAU_HD, STATES, HERDS, DAUS, APPRAISAIS FOR TYPE SUMMARY
		BEGIN
			DECLARE cursor6 CURSOR WITH RETURN FOR
			
			SELECT	float2char(AVG_DAU_HERD*0.01,0.01) AS DAU_HD
					,NUM_STATES AS STATES
					,NUM_HERDS AS HERDS
					,NUM_DAU AS DAUS
					,NUM_APPRAISALS AS APPRAISAIS
			FROM SESSION.TMP_TYPE_BV
			WITH UR;
			
			OPEN cursor6;
		END;
END
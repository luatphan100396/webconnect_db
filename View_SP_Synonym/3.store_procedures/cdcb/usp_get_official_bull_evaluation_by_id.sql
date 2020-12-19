CREATE OR REPLACE PROCEDURE usp_Get_Official_Bull_Evaluation_By_ID
--========================================================================================================
--Author: Nghi Ta
--Created Date: 2020-16-12
--Description: Get official bull evaluation data: PTA, PA, Metrit, SCR,
--             country contribution... for one animal
--Output: 
--        +Ds1: Animal information linked to specific run: int_id, eval breed, run name
--              ped_comp, naab code, current status, entered AI date, cntrl stud, pecentile, genomic indicator
--        +Ds2: Metrit result: NM$, FM$, CM$, GM$
--        +Ds3: Pedigree and Genomic inbreeding 
--        +Ds4: Evaluation data for all publish trait: Milk, Fat, Pro, PL, SCS...
--        +Ds5: Type summary data: final score, stature, Strength...
--        +Ds6: Country contribution data for yield, PL, SCS, MAS... 
--        +Ds7: Sire conception rate (PTA, REL, Breedings)
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
        
	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_BULL_EVL_TABLE AS
	(
		SELECT 
		bv.*, 
		CAST(NULL AS CHAR(17)) AS ROOT_INT_ID,
		CAST(NULL AS INT) AS ROOT_ANIM_KEY 
		FROM BULL_EVL_TABLE_DECODE bv
	
	) DEFINITION ONLY 
	WITH REPLACE ON COMMIT PRESERVE ROWS;
 
	      
	 DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_Merit  
	(
		ROOT_INT_ID CHAR(17),
		TRAIT char(3),
		PTA smallint,
		REL smallint,
		PA smallint,
		RELPA smallint
	) with replace ON COMMIT PRESERVE ROWS;      
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_PTA -- drop table SESSION.TmpAnimalLists_BV_PTA
	(
		ROOT_INT_ID CHAR(17),
		TRAIT VARCHAR(5),
		PTA decimal(10,2),
		REL smallint,
		DAUS int,
		HERDS int,
		SRC char(1),
		PA decimal(10,2),
		RELPA smallint
	) with replace ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_country -- drop table SESSION.TmpAnimalLists_BV_country 
	(
		ROOT_INT_ID CHAR(17),
		COUNTRY char(3),
		YIELD_HERDS int,
		YIELD_DAUS int,
		PROD_LIFE_HERDS int,
		PROD_LIFE_DAUS int,
		SCS_HERDS int,
		SCS_DAUS int,
		MAS_HERDS int,
		MAS_DAUS int,
		DPR_HERDS int,
		DPR_DAUS int,
		SIRE_CE_HERDS int,
		SIRE_CE_CALV int,
		DAU_CE_HERDS int,
		DAU_CE_DAUS int,
		SIRE_SB_HERDS int,
		SIRE_SB_CALV int,
		DAU_SB_HERDS int,
		DAU_SB_DAUS int
	) with replace ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_indicator  --drop table SESSION.TmpAnimalLists_BV_indicator 
	(
		ROOT_INT_ID CHAR(17),
		PED_GEN varchar(10),
		INBRD smallint,
		EXP_FUT_INBRD smallint,
		DAU_INBRD smallint
	)with replace ON COMMIT PRESERVE ROWS;
	 
       
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
	SET v_EVAL_PDATE = (select PUBRUN_PDATE FROM ENV_VAR_TABLE LIMIT 1); 
                        
		                        
    --GET BULL_EVL_TABLE
	INSERT INTO  SESSION.tmp_BULL_EVL_TABLE
		SELECT bv.*,
		inp.INT_ID AS ROOT_INT_ID,
		inp.ANIM_KEY AS ROOT_ANIM_KEY
	FROM BULL_EVL_TABLE_DECODE bv
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
			REL,
			RELPA
		)
		SELECT 
			cEvl.ROOT_INT_ID
			,iTable.INDEX_SHORT_NAME AS TRAIT
			,CASE WHEN iTable.INDEX_SHORT_NAME = 'NM$' THEN cEvl.NM_AMT
				  WHEN iTable.INDEX_SHORT_NAME = 'FM$' THEN cEvl.FM_AMT
				  WHEN iTable.INDEX_SHORT_NAME = 'CM$' THEN cEvl.CM_AMT
				  WHEN iTable.INDEX_SHORT_NAME = 'GM$' THEN cEvl.GM_AMT
				  WHEN iTable.INDEX_SHORT_NAME = 'PA$' THEN cEvl.PA_NM_AMT
				  ELSE NULL
			 END AS PTA
			,cast(cEvl.NM_REL_PCT as varchar(5)) as NM_REL_PCT
		 	,case  when iTable.INDEX_SHORT_NAME ='NM$' then cast(cEvl.PA_NM_REL_PCT as varchar(5))
				  else null
		 	 end as PA_NM_REL_PCT
			
		FROM SESSION.tmp_BULL_EVL_TABLE cEvl,
			 INDEX_TABLE iTable 
		with UR;	 
	  
	  
	  
			
		 -- Get PTA from COW_EVL_TABLE
		 INSERT INTO SESSION.TmpAnimalLists_BV_PTA 
		(
			ROOT_INT_ID,
			TRAIT,
			PTA,
			REL,
			DAUS,
			HERDS,
			SRC,
			PA,
			RELPA
		) 
		SELECT 
			tCEvl.ROOT_INT_ID
			,trait.TRAIT_SHORT_NAME
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.PTA_MLK_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.PTA_FAT_QTY
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PTA_PRO_QTY
				  WHEN TRAIT_SHORT_NAME = 'CCR' THEN tCEvl.PTA_CCR_QTY
				  WHEN TRAIT_SHORT_NAME = 'DPR' THEN tCEvl.PTA_DPR_QTY
				  WHEN TRAIT_SHORT_NAME = 'HCR' THEN tCEvl.PTA_HCR_QTY
				  WHEN TRAIT_SHORT_NAME = 'LIV' THEN tCEvl.PTA_LIV_QTY
				  WHEN TRAIT_SHORT_NAME = 'PL' THEN tCEvl.PTA_PL_QTY
				  WHEN TRAIT_SHORT_NAME = 'SCS' THEN tCEvl.PTA_SCS_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat%' THEN tCEvl.PTA_FAT_PCT
				  WHEN TRAIT_SHORT_NAME = 'Pro%' THEN tCEvl.PTA_PRO_PCT
				  WHEN TRAIT_SHORT_NAME = 'GL' THEN tCEvl.PTA_GL_QTY
				  WHEN TRAIT_SHORT_NAME = 'MFV' THEN tCEvl.PTA_MFV_QTY
				  WHEN TRAIT_SHORT_NAME = 'DAB' THEN tCEvl.PTA_DAB_QTY
				  WHEN TRAIT_SHORT_NAME = 'KET' THEN tCEvl.PTA_KET_QTY
				  WHEN TRAIT_SHORT_NAME = 'MAS' THEN tCEvl.PTA_MAS_QTY
				  WHEN TRAIT_SHORT_NAME = 'MET' THEN tCEvl.PTA_MET_QTY
				  WHEN TRAIT_SHORT_NAME = 'RPL' THEN tCEvl.PTA_RPL_QTY
				  WHEN TRAIT_SHORT_NAME = 'EFC' THEN tCEvl.PTA_EFC_QTY
				  ELSE NULL
			 END AS PTA
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.PTA_MLK_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.PTA_FAT_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PTA_PRO_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'CCR' THEN tCEvl.PTA_CCR_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'DPR' THEN tCEvl.PTA_DPR_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'HCR' THEN tCEvl.PTA_HCR_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'LIV' THEN tCEvl.PTA_LIV_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'PL' THEN tCEvl.PTA_PL_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'SCS' THEN tCEvl.PTA_SCS_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'GL' THEN tCEvl.PTA_GL_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'MFV' THEN tCEvl.PTA_MFV_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'DAB' THEN tCEvl.PTA_DAB_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'KET' THEN tCEvl.PTA_KET_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'MAS' THEN tCEvl.PTA_MAS_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'MET' THEN tCEvl.PTA_MET_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'RPL' THEN tCEvl.PTA_RPL_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'EFC' THEN tCEvl.PTA_EFC_REL_PCT
				  ELSE NULL
			 END AS REL_PTA
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.MLK_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.FAT_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PRO_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'CCR' THEN tCEvl.CCR_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'DPR' THEN tCEvl.DPR_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'HCR' THEN tCEvl.HCR_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'LIV' THEN tCEvl.LIV_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'PL' THEN tCEvl.PL_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'SCS' THEN tCEvl.SCS_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'GL' THEN tCEvl.GL_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'MFV' THEN tCEvl.MFV_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'DAB' THEN tCEvl.DAB_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'KET' THEN tCEvl.KET_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'MAS' THEN tCEvl.MAS_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'MET' THEN tCEvl.MET_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'RPL' THEN tCEvl.RPL_DAUS_QTY
				  WHEN TRAIT_SHORT_NAME = 'EFC' THEN tCEvl.EFC_DAUS_QTY
				  ELSE NULL
			 END  AS DAUS
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.MLK_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.FAT_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PRO_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'CCR' THEN tCEvl.CCR_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'DPR' THEN tCEvl.DPR_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'HCR' THEN tCEvl.HCR_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'LIV' THEN tCEvl.LIV_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'PL' THEN tCEvl.PL_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'SCS' THEN tCEvl.SCS_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'GL' THEN tCEvl.GL_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'MFV' THEN tCEvl.MFV_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'DAB' THEN tCEvl.DAB_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'KET' THEN tCEvl.KET_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'MAS' THEN tCEvl.MAS_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'MET' THEN tCEvl.MET_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'RPL' THEN tCEvl.RPL_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'EFC' THEN tCEvl.EFC_HERDS_QTY
				  ELSE NULL
			 END AS HERDS
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.SRC_MLK
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.SRC_FAT
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.SRC_PRO
				  WHEN TRAIT_SHORT_NAME = 'CCR' THEN tCEvl.SRC_CCR
				  WHEN TRAIT_SHORT_NAME = 'DPR' THEN tCEvl.SRC_DPR
				  WHEN TRAIT_SHORT_NAME = 'HCR' THEN tCEvl.SRC_HCR
				  WHEN TRAIT_SHORT_NAME = 'LIV' THEN tCEvl.SRC_LIV
				  WHEN TRAIT_SHORT_NAME = 'PL' THEN tCEvl.SRC_PL
				  WHEN TRAIT_SHORT_NAME = 'SCS' THEN tCEvl.SRC_SCS
				  WHEN TRAIT_SHORT_NAME = 'GL' THEN tCEvl.SRC_GL
				  WHEN TRAIT_SHORT_NAME = 'MFV' THEN tCEvl.SRC_MFV
				  WHEN TRAIT_SHORT_NAME = 'DAB' THEN tCEvl.SRC_DAB
				  WHEN TRAIT_SHORT_NAME = 'KET' THEN tCEvl.SRC_KET
				  WHEN TRAIT_SHORT_NAME = 'MAS' THEN tCEvl.SRC_MAS
				  WHEN TRAIT_SHORT_NAME = 'MET' THEN tCEvl.SRC_MET
				  WHEN TRAIT_SHORT_NAME = 'RPL' THEN tCEvl.SRC_RPL
				  WHEN TRAIT_SHORT_NAME = 'EFC' THEN tCEvl.SRC_EFC
				  ELSE NULL
			 END AS SOURCE_CODE
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.PA_MLK_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.PA_FAT_QTY
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PA_PRO_QTY
				  WHEN TRAIT_SHORT_NAME = 'CCR' THEN tCEvl.PA_CCR_QTY
				  WHEN TRAIT_SHORT_NAME = 'DPR' THEN tCEvl.PA_DPR_QTY
				  WHEN TRAIT_SHORT_NAME = 'HCR' THEN tCEvl.PA_HCR_QTY
				  WHEN TRAIT_SHORT_NAME = 'LIV' THEN tCEvl.PA_LIV_QTY
				  WHEN TRAIT_SHORT_NAME = 'PL' THEN tCEvl.PA_PL_QTY
				  WHEN TRAIT_SHORT_NAME = 'SCS' THEN tCEvl.PA_SCS_QTY
				  WHEN TRAIT_SHORT_NAME = 'GL' THEN tCEvl.PA_GL_QTY
				  WHEN TRAIT_SHORT_NAME = 'MFV' THEN tCEvl.PA_MFV_QTY
				  WHEN TRAIT_SHORT_NAME = 'DAB' THEN tCEvl.PA_DAB_QTY
				  WHEN TRAIT_SHORT_NAME = 'KET' THEN tCEvl.PA_KET_QTY
				  WHEN TRAIT_SHORT_NAME = 'MAS' THEN tCEvl.PA_MAS_QTY
				  WHEN TRAIT_SHORT_NAME = 'MET' THEN tCEvl.PA_MET_QTY
				  WHEN TRAIT_SHORT_NAME = 'RPL' THEN tCEvl.PA_RPL_QTY
				  WHEN TRAIT_SHORT_NAME = 'EFC' THEN tCEvl.PA_EFC_QTY
				  ELSE NULL
			 END AS PA
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.PA_MLK_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.PA_FAT_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tCEvl.PA_PRO_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'CCR' THEN tCEvl.PA_CCR_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'DPR' THEN tCEvl.PA_DPR_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'HCR' THEN tCEvl.PA_HCR_REL_PCT 
				  WHEN TRAIT_SHORT_NAME = 'LIV' THEN tCEvl.PA_LIV_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'PL' THEN tCEvl.PA_PL_REL_PCT 
				  WHEN TRAIT_SHORT_NAME = 'SCS' THEN tCEvl.PA_SCS_REL_PCT 
				  WHEN TRAIT_SHORT_NAME = 'GL' THEN tCEvl.PA_GL_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'MFV' THEN tCEvl.PA_MFV_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'DAB' THEN tCEvl.PA_DAB_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'KET' THEN tCEvl.PA_KET_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'MAS' THEN tCEvl.PA_MAS_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'MET' THEN tCEvl.PA_MET_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'RPL' THEN tCEvl.PA_RPL_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'EFC' THEN tCEvl.PA_EFC_REL_PCT
				  ELSE NULL
			 END AS REL_PA
		FROM SESSION.tmp_BULL_EVL_TABLE tCEvl
		CROSS JOIN ( SELECT TRAIT_SHORT_NAME 
		             FROM TRAIT_TABLE
				     WHERE publish_pdate >0 and publish_pdate < days(now())
				     with UR
					)trait with UR;
					 
                        
         -- Insert data for Fat% and Pro%
        INSERT INTO SESSION.TmpAnimalLists_BV_PTA 
        (
                ROOT_INT_ID,
                TRAIT,
                PTA 
        ) 
        SELECT
                tbv.ROOT_INT_ID, 
                'Fat%' as TRAIT, 
                tbv.PTA_FAT_PCT  AS  PTA 
        FROM SESSION.tmp_BULL_EVL_TABLE tbv  
        UNION		
        SELECT
                tbv.ROOT_INT_ID, 
                'Pro%' as TRAIT, 
                tbv.PTA_PRO_PCT  AS  PTA 
        FROM  SESSION.tmp_BULL_EVL_TABLE tbv
        with UR;

            -- Get bull dtrs
            INSERT INTO SESSION.TmpAnimalLists_BV_country 
            (
                    ROOT_INT_ID,
                    COUNTRY,
                    YIELD_HERDS,
                    YIELD_DAUS,
                    PROD_LIFE_HERDS,
                    PROD_LIFE_DAUS,
                    SCS_HERDS,
                    SCS_DAUS,
                    MAS_HERDS,
                    MAS_DAUS,
                    DPR_HERDS,
                    DPR_DAUS,
                    SIRE_CE_HERDS,
                    SIRE_CE_CALV,
                    DAU_CE_HERDS,
                    DAU_CE_DAUS,
                    SIRE_SB_HERDS,
                    SIRE_SB_CALV,
                    DAU_SB_HERDS,
                    DAU_SB_DAUS
            ) 
            SELECT 
                    tbv.INT_ID AS ROOT_INT_ID,
                    bv.COUNTRY_CODE,
                    bv.MF_HERDS_QTY,
                    bv.MF_DAU_QTY,
                    bv.PL_HERDS_QTY,
                    bv.PL_DAU_QTY,
                    bv.SCS_HERDS_QTY,
                    bv.SCS_DAU_QTY,
                    bv.MAS_HERDS_QTY,
                    bv.MAS_DAU_QTY,
                    bv.DPR_HERDS_QTY,
                    bv.DPR_DAU_QTY,
                    bv.SCE_HERDS_QTY,
                    bv.SCE_CALVING_QTY,
                    bv.DCE_HERDS_QTY,
                    bv.DCE_DAU_QTY,
                    bv.SSB_HERDS_QTY,
                    bv.SSB_CALVING_QTY,
                    bv.DSB_HERDS_QTY,
                    bv.DSB_DAU_QTY      
            FROM  ITB_COUNTRY_TABLE bv
            INNER JOIN  SESSION.TMP_INPUT tbv
               ON bv.ANIM_KEY = tbv.ANIM_KEY and bv.EVAL_PDATE = v_EVAL_PDATE
            with UR; 	
             
           -- Get genomic indicator
            INSERT INTO SESSION.TmpAnimalLists_BV_indicator 
            (
                    ROOT_INT_ID,
                    PED_GEN,
                    INBRD,
                    EXP_FUT_INBRD,
                    DAU_INBRD
            ) 
            SELECT 
                    bv.ROOT_INT_ID,
                    'Pedigree', 
                    bv.INBRD_PCT,
                    bv.FUTURE_DAU_INBRD_PCT,
                    bv.DAU_INBRD_PCT 
            FROM SESSION.tmp_BULL_EVL_TABLE bv
            UNION
            SELECT 
            bv.ROOT_INT_ID,
            'Genomic', 
            bv.GENOMICS_INBRD_PCT,
            bv.FUTURE_GENOMICS_INBRD_PCT,
            NULL
            FROM SESSION.tmp_BULL_EVL_TABLE bv
            with UR
            ;  
   
        
        
      -- Update PA amount into PA filed of NM$ 
	 MERGE INTO SESSION.TmpAnimalLists_BV_Merit as A
	 using
	 (
	    SELECT ROOT_INT_ID, PTA AS PA
		 FROM  SESSION.TmpAnimalLists_BV_Merit 
		 WHERE TRAIT = 'PA$'
		 with UR
	 )AS B
	 ON A.ROOT_INT_ID = B.ROOT_INT_ID
	 AND A.TRAIT = 'NM$'
	 WHEN MATCHED THEN
	 UPDATE SET  
	 PA =  B.PA
	 ;
	 
	 DELETE FROM SESSION.TmpAnimalLists_BV_Merit WHERE TRAIT = 'PA$';
	
        
  	-- Get animal information
  
	     begin
		 	DECLARE cursor1 CURSOR WITH RETURN for 
		 	SELECT 
				animEvl.ROOT_INT_ID AS ROOT_ANIMAL_ID 
				,animEvl.BULL_ID AS PREFERED_ID
				,coalesce(animEvl.EVAL_BREED_CODE,'N/A') as EVAL_BREED
			 	,coalesce(VARCHAR_FORMAT(DEFAULT_DATE + animEvl.EVAL_PDATE,'Month YYYY'),'N/A') AS RUN_NAME
				,animEvl.PED_COMP_PCT AS  PED_COMP
				,case when length(animEvl.NAAB10_SEG) >=10 then substring(animEvl.NAAB10_SEG,1,10)
				      else null 
				  end  AS PRIMARY_STUD_CODE
				,animEvl.STATUS_CODE AS CURRENT_STATUS
				,VARCHAR_FORMAT(DEFAULT_DATE+animEvl.ENTER_AI_PDATE,'YYYY-MM-DD') as ENTERED_AI_YM
				,animEvl.CTRL_STUD_CODE AS CNTRL_STUD
				,COALESCE(animEvl.SAMP_CTRL_CODE,0) AS ORIG_STUD
				,animEvl.SAMP_STATUS_CODE as SAMPLING_STATUS
				,animEvl.NM_PCTL as PERCENTILE 
				,animEvl.GENOMICS_IND  AS GENOMICS_IND
				,animEvl.SIRE_ID AS SIRE_INT_ID
				,animEvl.DAM_ID AS DAM_INT_ID
				,VARCHAR_FORMAT(DEFAULT_DATE + animEvl.BIRTH_PDATE,'YYYY-MM-DD') AS BIRTH_DATE
				,animEvl.INTERNATIONAL_ID_IND 
				,trim(anim_name.ANIM_NAME) AS LONG_NAME 
				,trim(ai.BULL_SHORT_NAME) AS SHORT_NAME
				,trim(animEvl.REGIS_STATUS_CODE) AS  REG
				,trim(ressive.RECESSIVE_CODE_SEG) AS RECESSIVES 
				,animEvl.SOURCE_CODE AS SRC
				,animEvl.HERD_WITH_MOST_DAU
				,animEvl.MOST_DAU_HERD_QTY
				FROM SESSION.tmp_BULL_EVL_TABLE animEvl 
				LEFT JOIN ANIM_NAME_TABLE anim_name
					ON  anim_name.INT_ID = animEvl.BULL_ID
					AND anim_name.SPECIES_CODE ='0'
					AND anim_name.SEX_CODE ='M'
				LEFT JOIN RECESSIVES_TABLE ressive 
				   ON ressive.SPECIES_CODE='0'
				   AND ressive.ANIM_KEY = animEvl.ROOT_ANIM_KEY
				LEFT JOIN AI_CODES_TABLE ai
				  ON ai.ANIM_KEY = animEvl.ROOT_ANIM_KEY 
			    with UR 
	 ;
		 	 
		 	OPEN cursor1;
	   end;
	  
	   
     
 	   --DS5: Get animal BV Merit
	     begin
		 	DECLARE cursor2 CURSOR WITH RETURN for
		 		 
		 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID,
					tmp.TRAIT,
					traits.INDEX_FULL_NAME AS DESCRIPTION,
					traits.UNIT,
					PTA,
					cast(cast(REL as int) || (case when REL is not null then '%' else '' end ) as varchar(30)) as REL,
					PA,
					cast(cast(RELPA as int) || (case when RELPA is not null then '%' else '' end ) as varchar(30)) as RELPA 
					 
		 	FROM SESSION.TmpAnimalLists_BV_Merit tmp
		 	LEFT JOIN INDEX_TABLE traits on tmp.TRAIT = traits.INDEX_SHORT_NAME 
		 	 ORDER BY ROOT_INT_ID, CASE WHEN TRAIT = 	'NM$'	THEN	1
											WHEN TRAIT = 	'FM$'	THEN	2
											WHEN TRAIT = 	'CM$'	THEN	3
											WHEN TRAIT = 	'GM$'	THEN	4
									        ELSE 999
										END with UR ;
		 	OPEN cursor2;
	   end;
	 
	   --DS6: Get animal BV indicator
	     begin
		 	DECLARE cursor3 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID as ROOT_ANIMAL_ID,
				 	PED_GEN,
				 	float2char(INBRD*0.1,0.1) as INBRD,
				 	float2char(EXP_FUT_INBRD*0.1,0.1) as EXP_FUT_INBRD,
				 	float2char(DAU_INBRD*0.1,0.1) as DAU_INBRD 
		 	
		 	FROM SESSION.TmpAnimalLists_BV_indicator with UR;
		 	
		 	OPEN cursor3;
	   end;
	   
    --DS7: Get animal BV PIA
	     begin
	      
		 	DECLARE cursor4 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID,
			tmp.TRAIT,
			traits.TRAIT_FULL_NAME AS DESCRIPTION,
			traits.UNIT,
			case when tmp.TRAIT IN ('Mlk' ,'Fat','Pro') THEN float2char_thsnd_format(PTA,DECIMAL_ADJUST_CODE)
				 else  float2char_thsnd_format(PTA,DECIMAL_ADJUST_CODE) 
			end AS PTA,
			 
			float2char_thsnd_format(REL,1) || (case when REL is not null then '%' else '' end ) as REL,
			DAUS,
			HERDS,
			SRC, 
			case when tmp.TRAIT IN ('Mlk' ,'Fat','Pro') THEN float2char_thsnd_format(PA,DECIMAL_ADJUST_CODE)
				 else  float2char_thsnd_format(PA,DECIMAL_ADJUST_CODE) 
			end AS PA, 
			float2char_thsnd_format(RELPA,1) || (case when RELPA is not null then '%' else '' end ) as RELPA
			  
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
											WHEN tmp.TRAIT = 	'Fat%'	THEN	3
											WHEN tmp.TRAIT = 	'Pro'	THEN	4
											WHEN tmp.TRAIT = 	'Pro%'	THEN	5
											WHEN tmp.TRAIT = 	'PL'	THEN	6
											WHEN tmp.TRAIT = 	'SCS'	THEN	7
											WHEN tmp.TRAIT = 	'DPR'	THEN	8
											WHEN tmp.TRAIT = 	'HCR'	THEN	9
											WHEN tmp.TRAIT = 	'CCR'	THEN	10
											WHEN tmp.TRAIT = 	'LIV'	THEN	11
											WHEN tmp.TRAIT = 	'GL'	THEN	12
											WHEN tmp.TRAIT = 	'MFV'	THEN	13
											WHEN tmp.TRAIT = 	'DAB'	THEN	14
											WHEN tmp.TRAIT = 	'KET'	THEN	15
											WHEN tmp.TRAIT = 	'MAS'	THEN	16
											WHEN tmp.TRAIT = 	'MET'	THEN	17
											WHEN tmp.TRAIT = 	'RPL'	THEN	18
											WHEN tmp.TRAIT = 	'EFC'	THEN	19
											ELSE 999
										END with UR;
		 	
		 	OPEN cursor4;
	   end;
	   
	   
 	   
 	   --DS9: Get animal BV dtrs
	     begin
		 	DECLARE cursor6 CURSOR WITH RETURN for
		 		
		 	SELECT  
			ROOT_INT_ID AS ROOT_ANIMAL_ID,
			COUNTRY,
			YIELD_HERDS,
			YIELD_DAUS,
			PROD_LIFE_HERDS,
			PROD_LIFE_DAUS,
			SCS_HERDS,
			SCS_DAUS,
			MAS_HERDS,
			MAS_DAUS,
			DPR_HERDS,
			DPR_DAUS,
			SIRE_CE_HERDS,
			SIRE_CE_CALV,
			DAU_CE_HERDS,
			DAU_CE_DAUS,
			SIRE_SB_HERDS,
			SIRE_SB_CALV,
			DAU_SB_HERDS,
			DAU_SB_DAUS
		 	FROM SESSION.TmpAnimalLists_BV_country with UR;
		  
		 	OPEN cursor6;
	   end;
    
	    begin
		 	DECLARE cursor7 CURSOR WITH RETURN for 
		 	SELECT  
		 	    animEvl.ROOT_INT_ID as ROOT_ANIMAL_ID
				,float2char_thsnd_format(bFert.ERCR_QTY*0.1,0.1) as SCR_PA
				,cast(cast(bFert.ERCR_REL_PCT as int) || (case when bFert.ERCR_REL_PCT is not null then '%' else '' end ) as varchar(30)) as SCR_REL
				,bFert.BREEDINGS_QTY AS SCR_BREEDINGS 	
					
				FROM SESSION.tmp_BULL_EVL_TABLE animEvl   
				INNER JOIN BULL_FERT_TABLE bFert ON bFert.ANIM_KEY = animEvl.ANIM_KEY and bFert.EVAL_PDATE = animEvl.EVAL_PDATE
	 
				with UR
	 ;
		 	 
		 	OPEN cursor7;
	   end;
END
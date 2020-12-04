CREATE OR REPLACE PROCEDURE usp_Get_Animal_BV_Infor_By_ID
--========================================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get evaluation data: PTA, PA, Metrit, SCR,
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
DYNAMIC RESULT SETS 10
BEGIN
   
	DECLARE DEFAULT_DATE DATE;
	DECLARE v_EVAL_PDATE SMALLINT;
	 DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_COW_EVL_TABLE AS
	(
		SELECT  
		t.*,
		CAST(NULL AS CHAR(17)) AS ROOT_INT_ID
		FROM COW_EVL_TABLE t
	
	) DEFINITION ONLY 
	WITH REPLACE ON COMMIT PRESERVE ROWS;
 
 	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_BULL_EVL_TABLE AS
	(
		SELECT 
		bv.*, 
		CAST(NULL AS CHAR(17)) AS ROOT_INT_ID 
		FROM BULL_EVL_TABLE bv
	
	) DEFINITION ONLY 
	WITH REPLACE ON COMMIT PRESERVE ROWS;
      
       DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_type_traits
	   ( 
	   TRAIT VARCHAR(50)
        )with replace
      on commit preserve rows;

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
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_type_PIA -- drop table SESSION.TmpAnimalLists_BV_type_PIA 
	(
		ROOT_INT_ID CHAR(17),
		TRAIT varchar(128), 
		PTA decimal(10,2),
		REL smallint
	)with replace ON COMMIT PRESERVE ROWS;
	
       DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_type_bv
	   (
        INT_ID char(17),
        FS_DAU_QTY int,
        PTA1	smallint,
		PTA2	smallint,
		PTA3	smallint,
		PTA4	smallint,
		PTA5	smallint,
		PTA6	smallint,
		PTA7	smallint,
		PTA8	smallint,
		PTA9	smallint,
		PTA10	smallint,
		PTA11	smallint,
		PTA12	smallint,
		PTA13	smallint,
		PTA14	smallint,
		PTA15	smallint,
		PTA16	smallint,
		PTA17	smallint,
		REL1	smallint,
		REL2	smallint,
		REL3	smallint,
		REL4	smallint,
		REL5	smallint,
		REL6	smallint,
		REL7	smallint,
		REL8	smallint,
		REL9	smallint,
		REL10	smallint,
		REL11	smallint,
		REL12	smallint,
		REL13	smallint,
		REL14	smallint,
		REL15	smallint,
		REL16	smallint,
		REL17	smallint
        )with replace
      on commit preserve rows;
 
 	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_ANIM_EVL_TABLE  
 	( 
 	  ANIM_KEY int,
 	  EVAL_BREED_CODE char(2),
 	  EVAL_PDATE smallint,
 	  STATUS_CODE char(1),
 	  PED_COMP_PCT smallint,
	  NAAB10_SEG varchar(60),
	  ENTER_AI_PDATE smallint,
	  CTRL_STUD_CODE smallint,
	  SAMP_CTRL_CODE smallint,
	  SAMP_STATUS_CODE char(1),
	  NM_PCTL char(2),
	  GENOMICS_IND char(1),
	  ROOT_INT_ID char(17)
 	) 
	WITH REPLACE ON COMMIT PRESERVE ROWS;
	 
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
     
     
    IF @SEX_CODE = 'M' AND @SPECIES_CODE ='0' THEN
 
		     SET v_EVAL_PDATE = (select max(EVAL_PDATE) FROM BULL_EVL_TABLE where  ANIM_KEY = @ANIM_KEY with UR);
		    
		    -- Get common bv
		     INSERT INTO  SESSION.tmp_BULL_EVL_TABLE
		     SELECT bv.*,
		           @INT_ID AS ROOT_INT_ID
		            
		      FROM   BULL_EVL_TABLE bv  
		     WHERE bv.ANIM_KEY =  @ANIM_KEY 
			 and bv.EVAL_PDATE = v_EVAL_PDATE
			 and official_ind ='Y' with UR; 
			  
		     
		     INSERT INTO  SESSION.tmp_ANIM_EVL_TABLE
		     ( 
				 ANIM_KEY, 
				 EVAL_BREED_CODE,
				 EVAL_PDATE,
				 STATUS_CODE,
				 PED_COMP_PCT,
				 NAAB10_SEG,
				 ENTER_AI_PDATE,
				 CTRL_STUD_CODE,
				 SAMP_CTRL_CODE,
				 SAMP_STATUS_CODE,
				 NM_PCTL,
				 GENOMICS_IND,
				ROOT_INT_ID
		     )
		     SELECT  
				 animEvl.ANIM_KEY, 
				 animEvl.EVAL_BREED_CODE,
				 animEvl.EVAL_PDATE,
				 animEvl.STATUS_CODE,
				 animEvl.PED_COMP_PCT,
				 animEvl.NAAB10_SEG,
				 animEvl.ENTER_AI_PDATE,
				 animEvl.CTRL_STUD_CODE,
				 animEvl.SAMP_CTRL_CODE,
				 animEvl.SAMP_STATUS_CODE,
				 animEvl.NM_PCTL,
				 animEvl.GENOMICS_IND,
		         animEvl.ROOT_INT_ID
		     FROM   SESSION.tmp_BULL_EVL_TABLE animEvl with UR;
		     
		     
		     -- Get type bv
			 INSERT INTO  SESSION.tmp_type_bv
			 (
			       INT_ID,
			        FS_DAU_QTY,
		     		PTA1,
					PTA2,
					PTA3,
					PTA4,
					PTA5,
					PTA6,
					PTA7,
					PTA8,
					PTA9,
					PTA10,
					PTA11,
					PTA12,
					PTA13,
					PTA14,
					PTA15,
					PTA16,
					PTA17,
					REL1,
					REL2,
					REL3,
					REL4,
					REL5,
					REL6,
					REL7,
					REL8,
					REL9,
					REL10,
					REL11,
					REL12,
					REL13,
					REL14,
					REL15,
					REL16,
					REL17	
			 )
		      
		     SELECT  @INT_ID  AS INT_ID,
		            FS_DAU_QTY,
		     		PTA1,
					PTA2,
					PTA3,
					PTA4,
					PTA5,
					PTA6,
					PTA7,
					PTA8,
					PTA9,
					PTA10,
					PTA11,
					PTA12,
					PTA13,
					PTA14,
					PTA15,
					PTA16,
					PTA17,
					REL1,
					REL2,
					REL3,
					REL4,
					REL5,
					REL6,
					REL7,
					REL8,
					REL9,
					REL10,
					REL11,
					REL12,
					REL13,
					REL14,
					REL15,
					REL16,
					REL17	
		      FROM   SIRE_TYPE_TABLE bv  
			  WHERE bv.ANIM_KEY =  @ANIM_KEY 
			  AND bv.EVAL_PDATE = v_EVAL_PDATE
			  AND bv.SPECIES_CODE = @SPECIES_CODE with UR; 
			  
			 -- Get MERIT bv
			INSERT INTO SESSION.TmpAnimalLists_BV_Merit 
			(
				ROOT_INT_ID,
				TRAIT,
				PTA,
				REL,
				RELPA
			) 
		    SELECT 
			 	tbv.ROOT_INT_ID, 
			 	trait.TRAIT,
			 	str2int(substring(tbv.INDEX_AMT_SEG,TRAIT_FIRST_CHAR_2_BYTE,2)) PTA,
			 	
			 	tbv.NM_REL_PCT as NM_REL_PCT, 
			 	case  when trait.TRAIT ='NM$' then tbv.PA_NM_REL_PCT
					  else null
			 	end as PA_NM_REL_PCT
		
			FROM 
			   SESSION.tmp_BULL_EVL_TABLE tbv 
			   inner join
			   (
		         select INDEX_SHORT_NAME AS TRAIT,   
		         INDEX_NUM,
		         ((INDEX_NUM-1)*2)+1 AS TRAIT_FIRST_CHAR_2_BYTE 
		          from index_table  with UR
		        )trait
		       ON trait.INDEX_NUM <=tbv.INDEX_CNT with UR;
		       
		       
		       
			 --  Get PTA from bull eval table
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
				 	tbv.ROOT_INT_ID, 
				 	trait.TRAIT, 
				 	str2int(substring(tbv.TRAIT_PTA_QTY_SEG,TRAIT_FIRST_CHAR_2_BYTE,2)) AS  PTA,
				 	str2int(substring(tbv.TRAIT_PTA_REL_PCT_SEG,TRAIT_FIRST_CHAR_2_BYTE,2))  AS  REL_PTA,
				 	str2int(substring(tbv.TRAIT_DAU_QTY_SEG,TRAIT_FIRST_CHAR_4_BYTE,4)) AS DAUS,
				 	str2int(substring(tbv.TRAIT_HERDS_QTY_SEG,TRAIT_FIRST_CHAR_4_BYTE,4)) as HERDS,
				 	case when trait.TRAIT_NUM <=3 and substring(tbv.TRAIT_USABILITY_CODE_SEG,TRAIT_FIRST_CHAR_1_BYTE,1) between '1' and '8' then 'M'
				 	     when trait.TRAIT_NUM <=3 and not(substring(tbv.TRAIT_USABILITY_CODE_SEG,TRAIT_FIRST_CHAR_1_BYTE,1) between '1' and '8') then ''
				 		 when trait.TRAIT_NUM >3 and substring(tbv.TRAIT_USABILITY_CODE_SEG,TRAIT_FIRST_CHAR_1_BYTE,1) ='2' then 'M'
				 		 when trait.TRAIT_NUM >3 and substring(tbv.TRAIT_USABILITY_CODE_SEG,TRAIT_FIRST_CHAR_1_BYTE,1) <> '2' then ''
				 		 else null
				 	end as  SOURCE_CODE, 
				 	str2int(substring(tbv.TRAIT_PA_QTY_SEG,TRAIT_FIRST_CHAR_2_BYTE,2)) as PA, 
				 	str2int(substring(tbv.TRAIT_PA_REL_PCT_SEG,TRAIT_FIRST_CHAR_2_BYTE,2))  as REL_PA 
					 FROM 
					    SESSION.tmp_BULL_EVL_TABLE tbv
					    inner join
					    (
				          select TRAIT_SHORT_NAME AS TRAIT, 
				          TRAIT_NUM,
				          ((TRAIT_NUM-1)*4)+1 AS TRAIT_FIRST_CHAR_4_BYTE,  
				          ((TRAIT_NUM-1)*2)+1 AS TRAIT_FIRST_CHAR_2_BYTE,
				          ((TRAIT_NUM-1)*1)+1 AS TRAIT_FIRST_CHAR_1_BYTE
				          from TRAIT_TABLE
				          where publish_pdate >0 and publish_pdate < days(now())
				        ) trait 
				       on trait.TRAIT_NUM <=tbv.TRAIT_CNT with UR;
			
				       
			    	
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
				        FROM 
					   SESSION.tmp_BULL_EVL_TABLE tbv  
				UNION		
				SELECT
				       tbv.ROOT_INT_ID, 
					 	'Pro%' as TRAIT, 
					 	tbv.PTA_PRO_PCT  AS  PTA 
				        FROM 
					   SESSION.tmp_BULL_EVL_TABLE tbv
				with UR
				 ;
			 
		    -- Adjust decimal for PTA, PA (for bull) 
			 MERGE INTO SESSION.TmpAnimalLists_BV_PTA as A
			 using
			 (
			    SELECT tmp.ROOT_INT_ID, tmp.TRAIT, traits.DECIMAL_ADJUST
			    FROM SESSION.TmpAnimalLists_BV_PTA tmp
				JOIN ( 
		              select  TRAIT, 
				      cast(DECIMAL_ADJUST as float) DECIMAL_ADJUST
		             from table(fn_Get_List_traits()) 
		      ) traits on tmp.TRAIT = traits.TRAIT with UR
			 )AS B
			 ON A.ROOT_INT_ID = B.ROOT_INT_ID
			 AND A.TRAIT = B.TRAIT
			 WHEN MATCHED THEN
			 UPDATE SET 
			 PTA = PTA*DECIMAL_ADJUST,
			 PA = PA*DECIMAL_ADJUST,
			 RELPA = RELPA/10.0,
			 REL = REL/10.0,
			 DAUS = case when A.trait in ('Fat%', 'Pro%') then null 
			             else coalesce(DAUS,0)
			         end,
			 HERDS = case when A.trait in ('Fat%', 'Pro%') then null 
			             else coalesce(HERDS,0) 
			         end 
			 ;
		       
		       
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
				@INT_ID  AS INT_ID,
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
		     WHERE bv.ANIM_KEY =  @ANIM_KEY and bv.EVAL_PDATE = v_EVAL_PDATE with UR; 	
		     
		     	 
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
     
    ELSEIF @SEX_CODE ='F' AND @SPECIES_CODE ='0' THEN ---------COW----------
    
		    SET v_EVAL_PDATE = (select max(EVAL_PDATE) FROM COW_EVL_TABLE where  ANIM_KEY = @ANIM_KEY  );
		    
		    INSERT INTO  SESSION.tmp_COW_EVL_TABLE
		     SELECT  cowEvl.*,
		     		 @INT_ID AS ROOT_ID
		     FROM   COW_EVL_TABLE cowEvl  
		     WHERE cowEvl.ANIM_KEY =  @ANIM_KEY 
			 and cowEvl.EVAL_PDATE = v_EVAL_PDATE with UR;
			 
		     INSERT INTO  SESSION.tmp_ANIM_EVL_TABLE
		     ( 
				ANIM_KEY,
				EVAL_BREED_CODE,
				EVAL_PDATE,
				NM_PCTL,
				PED_COMP_PCT,
				GENOMICS_IND, 
				ROOT_INT_ID
		     )
		     SELECT 
				 cowEvl.ANIM_KEY, 
				 cowEvl.EVAL_BREED_CODE,
				 cowEvl.EVAL_PDATE, 
				 cowEvl.NM_PCTL,
				 cowEvl.PED_COMP_PCT,
				 cowEvl.GENOMICS_IND, 
		         cowEvl.ROOT_INT_ID
		     FROM   SESSION.tmp_COW_EVL_TABLE cowEvl with UR;
		     
		     -- Get type bv
		     INSERT INTO  SESSION.tmp_type_bv
		     (
		           INT_ID,
			        FS_DAU_QTY,
		     		PTA1,
					PTA2,
					PTA3,
					PTA4,
					PTA5,
					PTA6,
					PTA7,
					PTA8,
					PTA9,
					PTA10,
					PTA11,
					PTA12,
					PTA13,
					PTA14,
					PTA15,
					PTA16,
					PTA17,
					REL1,
					REL2,
					REL3,
					REL4,
					REL5,
					REL6,
					REL7,
					REL8,
					REL9,
					REL10,
					REL11,
					REL12,
					REL13,
					REL14,
					REL15,
					REL16,
					REL17	
		     )
		     
			 SELECT  @INT_ID  AS INT_ID,
			        0 as FS_DAU_QTY,
		     		PTA1,
					PTA2,
					PTA3,
					PTA4,
					PTA5,
					PTA6,
					PTA7,
					PTA8,
					PTA9,
					PTA10,
					PTA11,
					PTA12,
					PTA13,
					PTA14,
					PTA15,
					PTA16,
					PTA17,
					REL1,
					REL2,
					REL3,
					REL4,
					REL5,
					REL6,
					REL7,
					REL8,
					REL9,
					REL10,
					REL11,
					REL12,
					REL13,
					REL14,
					REL15,
					REL16,
					REL17	
		     FROM  COW_TYPE_TABLE bv  
			  WHERE bv.ANIM_KEY =  @ANIM_KEY 
			  AND bv.EVAL_PDATE = v_EVAL_PDATE
			  AND bv.SPECIES_CODE = @SPECIES_CODE with UR;
			  
		    
		    
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
				
			FROM SESSION.tmp_COW_EVL_TABLE cEvl,
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
				,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.PTA_MF_REL_PCT
					  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.PTA_MF_REL_PCT
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
				,NULL AS DAUS
				,NULL AS HERDS
				,'' AS SOURCE_CODE
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
				,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tCEvl.PA_MF_REL_PCT
					  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tCEvl.PA_MF_REL_PCT
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
			FROM SESSION.tmp_COW_EVL_TABLE tCEvl
			CROSS JOIN ( SELECT TRAIT_SHORT_NAME 
			             FROM TRAIT_TABLE
					     WHERE publish_pdate >0 and publish_pdate < days(now())
					     with UR
						)trait with UR;
						
	
					 
 	 -- Get genomic indicator
 
	 INSERT INTO SESSION.TmpAnimalLists_BV_indicator 
	(
		ROOT_INT_ID,
		PED_GEN,
		INBRD,
		EXP_FUT_INBRD 
	) 
	 SELECT 
	 bv.ROOT_INT_ID,
	 'Pedigree', 
	 bv.INBRD_PCT_1_DECIMAL,
	 bv.FUTURE_DAU_INBRD_PCT
	 FROM SESSION.tmp_COW_EVL_TABLE bv
	 UNION
	 SELECT 
	 bv.ROOT_INT_ID,
	 'Genomic', 
	 bv.GENOMICS_INBRD_PCT,
	 bv.FUTURE_GENOMICS_INBRD_PCT 
	 FROM SESSION.tmp_COW_EVL_TABLE bv
	 with UR
	 ;	
    END IF;  
 
     
    
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
	
	 
	 
 -- reset trait list by type PIA trait
	 
	 insert into SESSION.tmp_type_traits(TRAIT)
      values ('Final score'),
			('Stature'),
			('Strength'),
			('Dairy form'),
			('Foot angle'),
			('Rear legs (side view)'),
			('Body depth'),
			('Rump angle'),
			('Rump width'),
			('Fore udder attachment'),
			('Rear udder height'),
			('Rear udder width'),
			('Udder depth score'),
			('Udder cleft'),
			('Front teat placement'),
			('Teat length'),
			('Rear legs/Rear View');
     
    -- Get trait type PIA
	    INSERT INTO SESSION.TmpAnimalLists_BV_type_PIA 
		(
			ROOT_INT_ID,
			TRAIT,
			PTA,
			REL
		) 
 
		SELECT 
		@INT_ID AS INT_ID, 
		trait.TRAIT,
	 	case  when trait.TRAIT ='Final score'then tbv.PTA1
				 when trait.TRAIT ='Stature' then tbv.PTA2
				 when trait.TRAIT ='Strength' then tbv.PTA3
				 when trait.TRAIT ='Dairy form' then tbv.PTA4
				 when trait.TRAIT ='Foot angle'  then tbv.PTA5
				 when trait.TRAIT ='Rear legs (side view)'  then tbv.PTA6
				 when trait.TRAIT ='Body depth'  then tbv.PTA7
				 when trait.TRAIT ='Rump angle'  then tbv.PTA8
				 when trait.TRAIT ='Rump width' then tbv.PTA9
				 when trait.TRAIT ='Fore udder attachment'  then tbv.PTA10
				 when trait.TRAIT ='Rear udder height' then tbv.PTA11
				 when trait.TRAIT ='Rear udder width'  then tbv.PTA12
				 when trait.TRAIT ='Udder depth score'  then tbv.PTA13
				 when trait.TRAIT ='Udder cleft' then tbv.PTA14
				 when trait.TRAIT ='Front teat placement' then tbv.PTA15
				 when trait.TRAIT ='Teat length' then tbv.PTA16
				 when trait.TRAIT ='Rear legs/Rear View' then tbv.PTA17
				else null
		 	end as PTA,
		 	case  when trait.TRAIT ='Final score'then tbv.REL1
				 when trait.TRAIT ='Stature' then tbv.REL2
				 when trait.TRAIT ='Strength' then tbv.REL3
				 when trait.TRAIT ='Dairy form' then tbv.REL4
				 when trait.TRAIT ='Foot angle'  then tbv.REL5
				 when trait.TRAIT ='Rear legs (side view)'  then tbv.REL6
				 when trait.TRAIT ='Body depth'  then tbv.REL7
				 when trait.TRAIT ='Rump angle'  then tbv.REL8
				 when trait.TRAIT ='Rump width' then tbv.REL9
				 when trait.TRAIT ='Fore udder attachment'  then tbv.REL10
				 when trait.TRAIT ='Rear udder height' then tbv.REL11
				 when trait.TRAIT ='Rear udder width'  then tbv.REL12
				 when trait.TRAIT ='Udder depth score'  then tbv.REL13
				 when trait.TRAIT ='Udder cleft' then tbv.REL14
				 when trait.TRAIT ='Front teat placement' then tbv.REL15
				 when trait.TRAIT ='Teat length' then tbv.REL16
				 when trait.TRAIT ='Rear legs/Rear View' then tbv.REL17
				else null
		 	end as REL
	     FROM  SESSION.tmp_type_traits  trait
			  
		       INNER JOIN  
		       (
		        select t.*, row_number() over(partition by INT_ID order by FS_DAU_QTY desc) as RN
		        from SESSION.tmp_type_bv t
		       )
		       tbv 
		       ON tbv.INT_ID = @INT_ID and tbv.RN=1 with UR;
	 
	  
	  UPDATE SESSION.TmpAnimalLists_BV_type_PIA  SET PTA = PTA/10.0;
	   
       -- Retrive data
        
 	-- Get animal information
  
	     begin
		 	DECLARE cursor4 CURSOR WITH RETURN for 
		 	SELECT 
				animEvl.ROOT_INT_ID AS ROOT_ANIMAL_ID 
				,animEvl.EVAL_BREED_CODE as EVAL_BREED
			 	,VARCHAR_FORMAT(DEFAULT_DATE + animEvl.EVAL_PDATE,'Month YYYY') AS RUN_NAME
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
				FROM SESSION.tmp_ANIM_EVL_TABLE animEvl with UR 
	 ;
		 	 
		 	OPEN cursor4;
	   end;
	  
	   
     
	   --DS5: Get animal BV Merit
	     begin
		 	DECLARE cursor5 CURSOR WITH RETURN for
		 		 
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
		 	OPEN cursor5;
	   end;
	 
	   --DS6: Get animal BV indicator
	     begin
		 	DECLARE cursor6 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID as ROOT_ANIMAL_ID,
				 	PED_GEN,
				 	float2char(INBRD*0.1,0.1) as INBRD,
				 	float2char(EXP_FUT_INBRD*0.1,0.1) as EXP_FUT_INBRD,
				 	float2char(DAU_INBRD*0.1,0.1) as DAU_INBRD 
		 	
		 	FROM SESSION.TmpAnimalLists_BV_indicator with UR;
		 	
		 	OPEN cursor6;
	   end;
	   
	   --DS7: Get animal BV PIA
	     begin
	      
		 	DECLARE cursor7 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID,
			tmp.TRAIT,
			traits.TRAIT_FULL_NAME AS DESCRIPTION,
			traits.UNIT,
			case when tmp.TRAIT IN ('Mlk' ,'Fat','Pro') THEN float2char_thsnd_format(PTA,DECIMAL_ADJUST_CODE)
										ELSE  float2char_thsnd_format(PTA,DECIMAL_ADJUST_CODE) 
			end AS PTA,
			 
			float2char_thsnd_format(REL,1) || (case when REL is not null then '%' else '' end ) as REL,
			DAUS,
			HERDS,
			SRC, 
			case when tmp.TRAIT IN ('Mlk' ,'Fat','Pro') THEN float2char_thsnd_format(PA,DECIMAL_ADJUST_CODE)
										ELSE  float2char_thsnd_format(PA,DECIMAL_ADJUST_CODE) 
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
		 	
		 	OPEN cursor7;
	   end;
	   
	   
	   --DS8: Get animal BV type PIA
	     begin
		 	DECLARE cursor8 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID,
					TRAIT,
					PTA,
					cast(cast(REL as int) || (case when REL is not null then '%' else '' end ) as varchar(30)) as REL
		 	FROM SESSION.TmpAnimalLists_BV_type_PIA
		 	ORDER BY ROOT_INT_ID, CASE WHEN TRAIT = 	'Final score'	THEN	1
											WHEN TRAIT = 	'Stature'	THEN	2
											WHEN TRAIT = 	'Strength'	THEN	3
											WHEN TRAIT = 	'Dairy form'	THEN	4
											WHEN TRAIT = 	'Foot angle'	THEN	5
											WHEN TRAIT = 	'Rear legs (side view)'	THEN	6
											WHEN TRAIT = 	'Body depth'	THEN	7
											WHEN TRAIT = 	'Rump angle'	THEN	8
											WHEN TRAIT = 	'Rump width'	THEN	9
											WHEN TRAIT = 	'Fore udder attachment'	THEN	10
											WHEN TRAIT = 	'Rear udder height'	THEN	11
											WHEN TRAIT = 	'Rear udder width'	THEN	12
											WHEN TRAIT = 	'Udder depth score'	THEN	13
											WHEN TRAIT = 	'Udder cleft'	THEN	14
											WHEN TRAIT = 	'Front teat placement'	THEN	15
											WHEN TRAIT = 	'Teat length'	THEN	16
											WHEN TRAIT = 	'Rear legs/Rear View'	THEN	17 
									        ELSE 999
										END with UR;
		 	
		 
		 	OPEN cursor8;
	   end;
	   
	   --DS9: Get animal BV dtrs
	     begin
		 	DECLARE cursor9 CURSOR WITH RETURN for
		 		
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
		  
		 	OPEN cursor9;
	   end;
	   
	    begin
		 	DECLARE cursor10 CURSOR WITH RETURN for 
		 	SELECT  
		 	    animEvl.ROOT_INT_ID AS ROOT_ANIMAL_ID  
				,float2char_thsnd_format(bFert.ERCR_QTY*0.1,0.1) as SCR_PA
				,cast(cast(bFert.ERCR_REL_PCT as int) || (case when bFert.ERCR_REL_PCT is not null then '%' else '' end ) as varchar(30)) as SCR_REL
				,bFert.BREEDINGS_QTY AS SCR_BREEDINGS 	
					
				FROM SESSION.tmp_ANIM_EVL_TABLE animEvl   
				INNER JOIN BULL_FERT_TABLE bFert ON bFert.ANIM_KEY = animEvl.ANIM_KEY and bFert.EVAL_PDATE = animEvl.EVAL_PDATE
	 
				with UR
	 ;
		 	 
		 	OPEN cursor10;
	   end;
	   
END
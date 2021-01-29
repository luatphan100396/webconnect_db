CREATE OR REPLACE PROCEDURE usp_Get_Doe_Evaluation_By_ID
--========================================================================================================
--Author: Luat Phan
--Created Date: 2021-01-28
--Description: Get information of a doe: basic information, bv merit, bv indicator, evaluation, type summary
--Output: 
--        +Ds1: Goat information
--		  +Ds2: Get bv merit
--		  +Ds3: Get bv indicator
--		  +Ds4: Get evaluation
--		  +Ds5: Get type summary
--		  +Ds6: Get run, appraisals of type summary
--============================================================================================================
( 
	IN @INT_ID char(17)
	,IN @ANIM_KEY INT
	,IN @SPECIES_CODE char(1)
	,IN @SEX_CODE char(1)
	,IN @IS_DATA_EXCHANGE char(1)
	,IN @REQUEST_KEY BIGINT
	,IN @OPERATION_KEY BIGINT
)
DYNAMIC RESULT SETS 10
BEGIN
   	/*=======================
		Variable declaration
	=========================*/
	DECLARE DEFAULT_DATE DATE;
	DECLARE v_RUN_DATE SMALLINT;
	
	
	/*=======================
		Temp table creation
	=========================*/
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT(
	    INT_ID CHAR(17)
	    ,ANIM_KEY INT
	    ,SPECIES_CODE CHAR(1)
	    ,SEX_CODE CHAR(1)
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
        
        
	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_DOE_EVL_TABLE AS(
		SELECT  t.*
				,CAST(NULL AS CHAR(17)) AS ROOT_INT_ID
				,CAST(NULL AS INT) AS ROOT_ANIM_KEY 
		FROM DOE_EVL_TABLE t
	) DEFINITION ONLY 
	WITH REPLACE ON COMMIT PRESERVE ROWS;
 	
  	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_Merit(
		ROOT_INT_ID CHAR(17)
		,NM_PCTL SMALLINT
		,TRAIT CHAR(3)
		,PTA SMALLINT
		,REL SMALLINT
	)WITH REPLACE ON COMMIT PRESERVE ROWS; 
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_indicator(
		ROOT_INT_ID CHAR(17)
		,PED_GEN VARCHAR(10)
		,INBRD SMALLINT
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_PTA (
		ROOT_INT_ID CHAR(17)
		,TRAIT VARCHAR(5)
		,PTA DECIMAL(10,2)
		,REL SMALLINT
		,HERDS INT
		,LACT SMALLINT
		,PA DECIMAL(10,2)
		,PTA_PCT DECIMAL(10,2)
		,MEAN INT
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	--type summary 
	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_type_traits( 
		TRAIT VARCHAR(50)               
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
		
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_CV_type_PIA(
        ROOT_INT_ID CHAR(17)
        ,TRAIT VARCHAR(128)
       	,PTA DECIMAL(10,2)
       	,REL SMALLINT
    )WITH REPLACE ON COMMIT PRESERVE ROWS;
    
    DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_type_bv(
        INT_ID char(17)
        ,FS_DAU_QTY INT 
        ,NUM_APPRAISALS	SMALLINT		
		,PTA_FS_QTY	VARCHAR(10)				
		,PTA_STT_QTY VARCHAR(10)							
		,PTA_STR_QTY VARCHAR(10)							
		,PTA_DR_QTY	VARCHAR(10)						
		,PTA_TEAT_D_QTY	VARCHAR(10)				
		,PTA_RL_QTY	VARCHAR(10)							
		,PTA_RUMP_A_QTY	VARCHAR(10)						
		,PTA_RUMP_W_QTY	VARCHAR(10)						
		,PTA_FORE_U_ATT_QTY	VARCHAR(10)				
		,PTA_REAR_U_HT_QTY VARCHAR(10)					
		,PTA_REAR_U_ARCH_QTY VARCHAR(10)				
		,PTA_UDDER_D_QTY VARCHAR(10)						
		,PTA_SUSP_LIG_QTY VARCHAR(10)				
		,PTA_TEAT_P_QTY	VARCHAR(10)			
		,PTA_REL_FS_PCT	VARCHAR(10)	 ---
		,PTA_REL_STT_PCT VARCHAR(10)
		,PTA_REL_STR_PCT VARCHAR(10)
		,PTA_REL_DR_PCT	VARCHAR(10)	
		,PTA_REL_TEAT_D_PCT	VARCHAR(10)	
		,PTA_REL_RL_PCT	VARCHAR(10)	
		,PTA_REL_RUMP_A_PCT	VARCHAR(10)	
		,PTA_REL_RUMP_W_PCT	VARCHAR(10)	
		,PTA_REL_FORE_U_ATT_PCT	VARCHAR(10)	
		,PTA_REL_REAR_U_HT_PCT VARCHAR(10)	
		,PTA_REL_REAR_U_ARCH_PCT VARCHAR(10)	
		,PTA_REL_UDDER_D_PCT VARCHAR(10)
		,PTA_REL_SUSP_LIG_PCT VARCHAR(10)
		,PTA_REL_TEAT_P_PCT VARCHAR(10)	  	
    )WITH REPLACE ON COMMIT PRESERVE ROWS;

 	/*=======================
			Insert data 
	=========================*/
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
	
 	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR); 
	SET v_RUN_DATE = 21884;
	 
	 --basic doe data
 	INSERT INTO  SESSION.tmp_DOE_EVL_TABLE
    SELECT  bv.*,
     		 @INT_ID AS ROOT_ANIMAL_ID,
     		 inp.ANIM_KEY AS ROOT_ANIM_KEY
    FROM DOE_EVL_TABLE bv  
    INNER JOIN SESSION.TMP_INPUT inp ON bv.ANIM_KEY = inp.ANIM_KEY
									AND bv.EVAL_PDATE = v_RUN_DATE
    WITH UR;
	
	
	-- Get merit data
    INSERT INTO SESSION.TmpAnimalLists_BV_Merit 
			(ROOT_INT_ID
			,NM_PCTL
			,TRAIT
			,PTA
			,REL
			)
	SELECT	cEvl.ROOT_INT_ID
			,cEvl.NM_PCTL
			,iTable.INDEX_SHORT_NAME AS TRAIT
			,CASE WHEN iTable.INDEX_SHORT_NAME = 'NM$' THEN NULLIF(TRIM(cEvl.NM_AMT),'')
				  WHEN iTable.INDEX_SHORT_NAME = 'FM$' THEN NULLIF(TRIM(cEvl.FM_AMT),'')
				  WHEN iTable.INDEX_SHORT_NAME = 'CM$' THEN NULLIF(TRIM(cEvl.CM_AMT),'')
				  WHEN iTable.INDEX_SHORT_NAME = 'GM$' THEN NULLIF(TRIM(cEvl.GM_AMT),'')
				  WHEN iTable.INDEX_SHORT_NAME = 'PA$' THEN NULLIF(TRIM(cEvl.PA_NM_AMT),'')
				  ELSE NULL
			 END AS PTA
			,CAST(NULLIF(TRIM(cEvl.NM_REL_PCT),'') AS VARCHAR(5)) AS NM_REL_PCT
	FROM SESSION.tmp_DOE_EVL_TABLE cEvl,
		 INDEX_TABLE iTable 
	WITH UR;
	
	
	 --Get genomic indicator
	INSERT INTO SESSION.TmpAnimalLists_BV_indicator 
			(ROOT_INT_ID
			,PED_GEN
			,INBRD) 
	SELECT 	bv.ROOT_INT_ID
			,'Pedigree'
			,NULLIF(TRIM(bv.INBRD_PCT_1_DECIMAL),'')
	FROM SESSION.tmp_DOE_EVL_TABLE bv
	UNION
	SELECT 	bv.ROOT_INT_ID
			,'Genomic'
			,NULLIF(TRIM(bv.GENOMICS_INBRD_PCT),'')
	FROM SESSION.tmp_DOE_EVL_TABLE bv
	WITH UR;	
	
	
	--Get PTA from DOE_EVL_TABLE	
	INSERT INTO SESSION.TmpAnimalLists_BV_PTA 
			(ROOT_INT_ID
			,TRAIT
			,PTA
			,REL
			,HERDS
			,LACT
			,PA
			,PTA_PCT
			,MEAN) 
	SELECT 	tDEvl.ROOT_INT_ID
			,trait.TRAIT_SHORT_NAME
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tDEvl.PTA_MLK_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tDEvl.PTA_FAT_QTY
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tDEvl.PTA_PRO_QTY
				  ELSE NULL
			 END AS PTA
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tDEvl.PTA_MF_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tDEvl.PTA_MF_REL_PCT
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tDEvl.PTA_PRO_REL_PCT
				  ELSE NULL
			 END AS REL
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tDEvl.MF_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tDEvl.MF_HERDS_QTY
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tDEvl.PRO_HERDS_QTY
				  ELSE NULL
			 END AS HERDS
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tDEvl.LACT_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tDEvl.LACT_QTY
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tDEvl.PRO_LACT_QTY
			 END AS LACT
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tDEvl.PA_MLK_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tDEvl.PA_FAT_QTY
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tDEvl.PA_PRO_QTY
				  ELSE NULL
			 END AS PA
			,CASE WHEN TRAIT_SHORT_NAME = 'Fat' THEN tDEvl.PTA_FAT_PCT
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tDEvl.PTA_PRO_PCT
				  ELSE NULL
			 END AS PTA_PCT
			,CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN tDEvl.STD_MP_QTY
				  WHEN TRAIT_SHORT_NAME = 'Fat' THEN tDEvl.STD_FAT_QTY
				  WHEN TRAIT_SHORT_NAME = 'Pro' THEN tDEvl.STD_PRO_QTY
				  ELSE NULL
			 END AS MEAN
	FROM SESSION.tmp_DOE_EVL_TABLE tDEvl
	CROSS JOIN ( SELECT TRAIT_SHORT_NAME 
	             FROM TRAIT_TABLE
			     WHERE PUBLISH_PDATE >0 and PUBLISH_PDATE < DAYS(NOW())
			     WITH UR
				)trait WITH UR;	
	
	--get type summary
	 INSERT INTO SESSION.tmp_type_bv
	 		(INT_ID
	        ,FS_DAU_QTY
	        ,NUM_APPRAISALS	
			,PTA_FS_QTY					
			,PTA_STT_QTY 							
			,PTA_STR_QTY 							
			,PTA_DR_QTY							
			,PTA_TEAT_D_QTY					
			,PTA_RL_QTY								
			,PTA_RUMP_A_QTY							
			,PTA_RUMP_W_QTY							
			,PTA_FORE_U_ATT_QTY					
			,PTA_REAR_U_HT_QTY 					
			,PTA_REAR_U_ARCH_QTY 				
			,PTA_UDDER_D_QTY 						
			,PTA_SUSP_LIG_QTY 				
			,PTA_TEAT_P_QTY				
			,PTA_REL_FS_PCT		 ---
			,PTA_REL_STT_PCT 
			,PTA_REL_STR_PCT 
			,PTA_REL_DR_PCT		
			,PTA_REL_TEAT_D_PCT		
			,PTA_REL_RL_PCT		
			,PTA_REL_RUMP_A_PCT		
			,PTA_REL_RUMP_W_PCT		
			,PTA_REL_FORE_U_ATT_PCT		
			,PTA_REL_REAR_U_HT_PCT 	
			,PTA_REL_REAR_U_ARCH_PCT 	
			,PTA_REL_UDDER_D_PCT 
			,PTA_REL_SUSP_LIG_PCT 
			,PTA_REL_TEAT_P_PCT)
	SELECT 	tInput.INT_ID
	        ,0 AS FS_DAU_QTY
	        ,dTTable.NUM_APPRAISALS	
			,dTTable.PTA_FS_QTY					
			,dTTable.PTA_STT_QTY 							
			,dTTable.PTA_STR_QTY 							
			,dTTable.PTA_DR_QTY							
			,dTTable.PTA_TEAT_D_QTY					
			,dTTable.PTA_RL_QTY								
			,dTTable.PTA_RUMP_A_QTY							
			,dTTable.PTA_RUMP_W_QTY							
			,dTTable.PTA_FORE_U_ATT_QTY					
			,dTTable.PTA_REAR_U_HT_QTY 					
			,dTTable.PTA_REAR_U_ARCH_QTY 				
			,dTTable.PTA_UDDER_D_QTY 						
			,dTTable.PTA_SUSP_LIG_QTY 				
			,dTTable.PTA_TEAT_P_QTY				
			,dTTable.PTA_REL_FS_PCT		 ---
			,dTTable.PTA_REL_STT_PCT 
			,dTTable.PTA_REL_STR_PCT 
			,dTTable.PTA_REL_DR_PCT		
			,dTTable.PTA_REL_TEAT_D_PCT		
			,dTTable.PTA_REL_RL_PCT		
			,dTTable.PTA_REL_RUMP_A_PCT		
			,dTTable.PTA_REL_RUMP_W_PCT		
			,dTTable.PTA_REL_FORE_U_ATT_PCT		
			,dTTable.PTA_REL_REAR_U_HT_PCT 	
			,dTTable.PTA_REL_REAR_U_ARCH_PCT 	
			,dTTable.PTA_REL_UDDER_D_PCT 
			,dTTable.PTA_REL_SUSP_LIG_PCT 
			,dTTable.PTA_REL_TEAT_P_PCT
	FROM  DOE_TYPE_TABLE dTTable
    INNER JOIN SESSION.TMP_INPUT tInput ON dTTable.ANIM_KEY = tInput.ANIM_KEY 
								        AND dTTable.EVAL_PDATE = v_RUN_DATE
								        AND tInput.SPECIES_CODE='1'
	WITH UR;	  		
	
	-- reset trait list by type PIA trait
	 
	INSERT INTO SESSION.tmp_type_traits(TRAIT)
  	VALUES ('Final Score')
           ,('Stature')
           ,('Strength')
           ,('Dairyness')
           ,('Teat Diameter')
           ,('Rear Legs')
           ,('Rump Angle')
           ,('Rump Width')
           ,('Fore Udder Att')
           ,('Rear Udder Ht')
           ,('Rear Udder Arch')
           ,('Udder Depth')
           ,('Susp Lig')
           ,('Teat Placement');
	
	-- Get trait type PIA
        INSERT INTO SESSION.TmpAnimalLists_CV_type_PIA
				(ROOT_INT_ID
				,TRAIT
				,PTA
				,REL) 
        SELECT	tcv.INT_ID AS ROOT_INT_ID
		        ,trait.TRAIT
		        ,CASE WHEN trait.TRAIT ='Final score'THEN tcv.PTA_FS_QTY
                      WHEN trait.TRAIT ='Stature' THEN tcv.PTA_STT_QTY
                      WHEN trait.TRAIT ='Strength' THEN tcv.PTA_STR_QTY
                      WHEN trait.TRAIT ='Dairyness' THEN tcv.PTA_DR_QTY
                      WHEN trait.TRAIT ='Teat Diameter'  THEN tcv.PTA_TEAT_D_QTY
                      WHEN trait.TRAIT ='Rear Legs'  THEN tcv.PTA_RL_QTY
                      WHEN trait.TRAIT ='Rump Angle'  THEN tcv.PTA_RUMP_A_QTY
                      WHEN trait.TRAIT ='Rump Width' THEN tcv.PTA_RUMP_W_QTY
                      WHEN trait.TRAIT ='Fore Udder Att'  THEN tcv.PTA_FORE_U_ATT_QTY
                      WHEN trait.TRAIT ='Rear Udder Ht' THEN tcv.PTA_REAR_U_HT_QTY
                      WHEN trait.TRAIT ='Rear Udder Arch'  THEN tcv.PTA_REAR_U_ARCH_QTY
                      WHEN trait.TRAIT ='Udder Depth'  THEN tcv.PTA_UDDER_D_QTY
                      WHEN trait.TRAIT ='Susp Lig' THEN tcv.PTA_SUSP_LIG_QTY
                      WHEN trait.TRAIT ='Teat Placement' THEN tcv.PTA_TEAT_P_QTY
		              ELSE NULL
				 END AS PTA
                ,CASE WHEN trait.TRAIT ='Final score'THEN tcv.PTA_REL_FS_PCT
                      WHEN trait.TRAIT ='Stature' THEN tcv.PTA_REL_STT_PCT
                      WHEN trait.TRAIT ='Strength' THEN tcv.PTA_REL_STR_PCT
                      WHEN trait.TRAIT ='Dairyness' THEN tcv.PTA_REL_DR_PCT
                      WHEN trait.TRAIT ='Teat Diameter'  THEN tcv.PTA_REL_TEAT_D_PCT
                      WHEN trait.TRAIT ='Rear Legs'  THEN tcv.PTA_REL_RL_PCT
                      WHEN trait.TRAIT ='Rump Angle'  THEN tcv.PTA_REL_RUMP_A_PCT
                      WHEN trait.TRAIT ='Rump Width' THEN tcv.PTA_REL_RUMP_W_PCT
                      WHEN trait.TRAIT ='Fore Udder Att'  THEN tcv.PTA_REL_FORE_U_ATT_PCT
                      WHEN trait.TRAIT ='Rear Udder Ht' THEN tcv.PTA_REL_REAR_U_HT_PCT
                      WHEN trait.TRAIT ='Rear Udder Arch'  THEN tcv.PTA_REL_REAR_U_ARCH_PCT
                      WHEN trait.TRAIT ='Udder Depth'  THEN tcv.PTA_REL_UDDER_D_PCT
                      WHEN trait.TRAIT ='Susp Lig' THEN tcv.PTA_REL_SUSP_LIG_PCT
                      WHEN trait.TRAIT ='Teat Placement' THEN tcv.PTA_REL_TEAT_P_PCT
                      ELSE NULL
                 END AS REL
        FROM  SESSION.tmp_type_traits  trait
        INNER JOIN	(
	        			SELECT t.*, row_number() OVER(PARTITION BY INT_ID ORDER BY FS_DAU_QTY DESC) AS RN
	         			FROM SESSION.tmp_type_bv t
        			)tcv ON tcv.RN=1 
        WITH UR;
        
	/*=======================
			Datasets
	=========================*/
	
	--ds1: animal information
	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN FOR
		
		SELECT	animEvl.ROOT_INT_ID AS ROOT_ANIMAL_ID 
				,animEvl.INT_ID AS PREFERED_ID
				,COALESCE(VARCHAR_FORMAT(DEFAULT_DATE + v_RUN_DATE,'Month YYYY'),'N/A') AS RUN_NAME
				,VARCHAR_FORMAT(to_date(animEvl.BIRTH_DATE,'YYYYMMDD'),'YYYY-MM-DD') AS BIRTH_DATE
				,TRIM(anim_name.ANIM_NAME) AS LONG_NAME  
				,animEvl.LH_STATE_CODE||animEvl.LH_COUNTRY_CODE||animEvl.LH_HERD_NUMBER AS LAST_HERD_CODE 
		FROM SESSION.tmp_DOE_EVL_TABLE animEvl 
		LEFT JOIN ANIM_NAME_TABLE anim_name ON  anim_name.INT_ID = animEvl.INT_ID
											AND anim_name.SPECIES_CODE ='1'
											AND anim_name.SEX_CODE ='F'
		LEFT JOIN PEDIGREE_TABLE ped ON  ped.ANIM_KEY = animEvl.ROOT_ANIM_KEY
									AND ped.SPECIES_CODE ='1' 
	    WITH UR ;
	
		OPEN cursor1;
	END;     
	
	--ds2: get bv merit
	BEGIN
	 	DECLARE cursor2 CURSOR WITH RETURN for
	 	 		 
	 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID
	 			,tmp.NM_PCTL
				,tmp.TRAIT
				,TRIM(traits.INDEX_FULL_NAME) AS DESCRIPTION
				,traits.UNIT
				,PTA
				,CAST(cast(REL AS INT) || (CASE WHEN REL IS NOT NULL THEN '%' ELSE '' END ) AS VARCHAR(30)) AS REL 
	 	FROM SESSION.TmpAnimalLists_BV_Merit tmp
	 	LEFT JOIN INDEX_TABLE traits on tmp.TRAIT = traits.INDEX_SHORT_NAME 
	 	ORDER BY ROOT_INT_ID, CASE WHEN TRAIT = 'NM$'THEN 1
								   WHEN TRAIT = 'FM$'THEN 2
								   WHEN TRAIT = 'CM$'THEN 3
								   WHEN TRAIT = 'GM$'THEN 4
								   ELSE 999
							  END WITH UR;
	 	OPEN cursor2;
	END;   
	
	 --DS3: Get BV indicator
	BEGIN
	 	DECLARE cursor3 CURSOR WITH RETURN FOR
	 		
	 	SELECT	ROOT_INT_ID AS ROOT_ANIMAL_ID
			 	,PED_GEN
			 	,FLOAT2CHAR(NULLIF(TRIM(INBRD),'')*0.1,0.01) AS INBRD	 	
	 	FROM SESSION.TmpAnimalLists_BV_indicator 
	 	WITH UR;
	 	
	 	OPEN cursor3;
	END;   
	
	--DS4: Get Evaluation
	BEGIN
		DECLARE cursor4 CURSOR WITH RETURN FOR
		SELECT 	ROOT_INT_ID AS ROOT_ANIMAL_ID
				,tmp.TRAIT
				,TRIM(traits.TRAIT_FULL_NAME) AS DESCRIPTION
				,traits.UNIT
				,CASE WHEN tmp.TRAIT IN ('Mlk' ,'Fat','Pro') THEN FLOAT2CHAR_THSND_FORMAT(PTA,DECIMAL_ADJUST_CODE)
											ELSE  FLOAT2CHAR_THSND_FORMAT(PTA,DECIMAL_ADJUST_CODE) 
				 END AS PTA

				,FLOAT2CHAR_THSND_FORMAT(REL,1) || (CASE WHEN REL IS NOT NULL THEN '%' ELSE '' END ) AS REL
				,HERDS
				,LACT
				,FLOAT2CHAR_THSND_FORMAT(PTA_PCT,0.01) || (CASE WHEN PTA_PCT IS NOT NULL THEN '%' ELSE '' END) AS PTA_PCT
				,MEAN
	 	FROM SESSION.TmpAnimalLists_BV_PTA tmp
	 	LEFT JOIN  
	 	(SELECT TRAIT_FULL_NAME
	 	  		 ,TRAIT_SHORT_NAME
	 	 	     ,UNIT
	 	         ,CASE WHEN DECIMAL_ADJUST_CODE = 2 THEN 0.01
	 	               WHEN DECIMAL_ADJUST_CODE = 1 THEN 0.1
	 	               ELSE 1
	 	  END AS DECIMAL_ADJUST_CODE
	 	  FROM TRAIT_TABLE WITH UR)traits ON tmp.TRAIT = traits.TRAIT_SHORT_NAME
	 	  
	 	ORDER BY ROOT_INT_ID	
	 			 ,CASE WHEN tmp.TRAIT = 'Mlk' THEN 1
					   WHEN tmp.TRAIT = 'Fat' THEN 2
					   WHEN tmp.TRAIT = 'Pro' THEN 3
					   ELSE 999
				END with UR;
		OPEN cursor4;
	END;   
	
	
	--DS5: Get type summary
	BEGIN
	    DECLARE cursor5 CURSOR WITH RETURN FOR
	            
	    SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID
	            ,TRAIT
	            ,COALESCE(PTA,0) AS PTA
	            ,CAST(CAST(COALESCE(REL,0) AS INT) || (CASE WHEN REL IS NOT NULL THEN '%' ELSE '' END ) AS VARCHAR(30)) AS REL
	    FROM SESSION.TmpAnimalLists_CV_type_PIA
	    ORDER BY ROOT_INT_ID
	    		 ,CASE WHEN TRAIT = 'Final score' THEN 1
	                   WHEN TRAIT = 'Stature' THEN 2
	                   WHEN TRAIT = 'Strength' THEN 3
	                   WHEN TRAIT = 'Dairyness' THEN 4
	                   WHEN TRAIT = 'Teat Diameter' THEN 5
	                   WHEN TRAIT = 'Rear Legs' THEN 6
	                   WHEN TRAIT = 'Rump Angle' THEN 7
	                   WHEN TRAIT = 'Rump Width' THEN 8
	                   WHEN TRAIT = 'Fore Udder Att' THEN 9
	                   WHEN TRAIT = 'Rear Udder Ht' THEN 10
	                   WHEN TRAIT = 'Rear Udder Arch' THEN 11
	                   WHEN TRAIT = 'Udder Depth' THEN 12
	                   WHEN TRAIT = 'Susp Lig' THEN 13
	                   WHEN TRAIT = 'Teat Placement' THEN 14 
	                   ELSE 999
	                   END WITH UR;                            
	    OPEN cursor5;
	END;
	   
	--DS6: Get run, appraisal for type summary
	BEGIN
	    DECLARE cursor6 CURSOR WITH RETURN FOR
	    
	    SELECT	NUM_APPRAISALS AS APPRAISALS
	    	   	,COALESCE(VARCHAR_FORMAT(DEFAULT_DATE + v_RUN_DATE,'Month YYYY'),'N/A') AS RUN_NAME
	    FROM SESSION.tmp_type_bv
	    WITH UR;
	    
		OPEN cursor6;
	END;
	
END
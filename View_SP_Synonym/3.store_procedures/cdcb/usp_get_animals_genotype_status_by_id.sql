CREATE OR REPLACE PROCEDURE usp_Get_Animals_Genotype_Status_by_id
--===================================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get detail of animal genotype status
--for one animal
--Output:
--        +Ds1: Nomination status: group, hrc, fee, paid, nominator
--        +Ds2: Sample status: usability indicator, nomination date, sample id, bar code & position, chip name,
--              lab, requester, geno arrival date, snp read...
--        +Ds3: Genotype conflicts: conflict id, conflict bar code, confict position, error type, error code
--        +Ds4: Blend code
--===================================================================================================
(
IN @INT_ID char(17), 
IN @ANIM_KEY INT, 
IN @SPECIES_CODE char(1),
IN @SEX_CODE char(1)
)
dynamic result sets 10
 
BEGIN
 
 DECLARE DEFAULT_DATE DATE;
 DECLARE MAX_BBR DECIMAL(6,2);
	 
	 
	 DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
	(
	    INT_ID char(17), 
		ANIM_KEY INT, 
		SPECIES_CODE char(1),
		SEX_CODE char(1)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ANIMAL_BLEND_CODE  
	(
	    ANIM_KEY INT, 
	    INT_ID char(17), 
	    EVAL_BREED_CODE CHAR(2),
		BLEND_CODE CHAR(1) 
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS; 
		
	
      
 	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_GENOTYPE_TABLE AS
	(
		SELECT CAST('' AS CHAR(17)) AS INT_ID,
		t.*
		FROM GENOTYPE_TABLE t
	
	) DEFINITION ONLY 
	WITH REPLACE ON COMMIT PRESERVE ROWS;
      
      
     -- Declare tempory table contains GENOTYPE_SAMPLE_CONFLICT_ANIM_KEY
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_GENOTYPE_SAMPLE_CONFLICT_ANIM_KEY  
	(
	    ROOT_ANIM_KEY INT,
		CONFLICT_ANIM_KEY INT,
		CONFLICT_ID_NUM CHAR(18) 
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
		
	  
     DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ANIMAL_PEND
	   (
        ANIM_KEY INT NULL,
        GENOTYPE_ID_NUM CHAR(18), 
        PEND VARCHAR(2),
        PRIORITY SMALLINT
      )
      on commit preserve rows;
      
      
     DECLARE  GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_Geno_Sample_Conflict -- DROP TABLE SESSION.TmpAnimalLists_Geno_Sample_Conflict
	(ROOT_INT_ID CHAR(17),
	ROOT_ANIM_KEY INT,
	GENOTYPE_ID_NUM CHAR(18),
	PEDIGREE_CHANGED VARCHAR(128),
	CONFLICT_TYPE VARCHAR(100),
	CONFLICT_CODE CHAR(2),
	CONFLICT_BARCODE CHAR(12),
	CONFLICT_POSITION CHAR(6),
	CONFLICT_ID_NUM CHAR(18),
	CONFLICT_INT_ID VARCHAR(30),
	CONFLICT_SEX char(1),
	CONFLICT_ANIM_KEY  INT,
	INDICATOR_IN_USE CHAR(1), 
	ROOT_CONFLICT_CODE CHAR(1),
	YOUR_GENOTYPE varchar(20)
	
	) with replace on commit preserve rows;
	
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_Geno_Sample --DROP TABLE SESSION.TmpAnimalLists_Geno_Sample 
	(
	ROOT_INT_ID CHAR(17),
	ROOT_ANIM_KEY INT,
	USE_IND CHAR(1),
	NOM_DATE VARCHAR(10),
	SAMPLE_ID VARCHAR(20),
	BAR_CODE char(12),
	POSITION char(6),
	CHIP_NAME CHAR(4),
	PEND VARCHAR(128)
	,LAB VARCHAR(128),
	REQUESTOR CHAR(12),
	GNO_ARRIVAL_DATE VARCHAR(10),
	SNP_READ INT,
	BREED_SNP_CONFLICTS INT,
	EVAL_USE_DATE TIMESTAMP,
	HAS_CONFLICT VARCHAR(1),
	GENOTYPE_ID_NUM CHAR(18)
	)with replace  on commit preserve rows;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_Ped   
	(  
		ROOT_INT_ID char(17),
		SIRE_INT_ID char(17),	
		DAM_INT_ID char(17) 
		 
	) with replace ON COMMIT PRESERVE ROWS;
		
	
     DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
	(
	    INT_ID char(17), 
		ANIM_KEY INT, 
		SPECIES_CODE char(1),
		SEX_CODE char(1)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1);
	
	
	INSERT INTO SESSION.TMP_INPUT 
   (    INT_ID, 
		ANIM_KEY, 
		SPECIES_CODE,
		SEX_CODE 
	)
	VALUES (@INT_ID, 
			@ANIM_KEY, 
			@SPECIES_CODE,
			@SEX_CODE 
		);
	 
   -- Populate data for tempory GENOTYPE_TABLE
    INSERT INTO SESSION.TMP_GENOTYPE_TABLE
    SELECT t.INT_ID, gTable.*
    FROM  SESSION.TMP_INPUT t
    INNER JOIN   GENOTYPE_TABLE gTable
    	ON t.ANIM_KEY = gTable.ANIM_KEY ; 
	
	
	 
   INSERT INTO SESSION.TmpAnimalLists_Geno_Sample_Conflict
 (
	ROOT_INT_ID,
	ROOT_ANIM_KEY,
	GENOTYPE_ID_NUM,
	PEDIGREE_CHANGED,
	CONFLICT_TYPE,
	CONFLICT_CODE,
	CONFLICT_BARCODE,
	CONFLICT_POSITION, 
 	CONFLICT_ANIM_KEY,
	INDICATOR_IN_USE, 
	CONFLICT_ID_NUM,
	ROOT_CONFLICT_CODE,
	YOUR_GENOTYPE,
	CONFLICT_INT_ID,
	CONFLICT_SEX 
 )
 
 WITH cte AS
 (
 SELECT INT_ID, ANIM_KEY, GENOTYPE_ID_NUM, ROW_NUMBER()OVER(PARTITION BY ANIM_KEY ORDER BY coalesce(USE_WEEKLY_TIMESTAMP,'1900-01-01') desc, coalesce(SCAN_PDATE,-9999) DESC) as rn
 FROM SESSION.TMP_GENOTYPE_TABLE with UR

 )
   
 SELECT 
 	cte.INT_ID as ROOT_INT_ID,
 	cte.ANIM_KEY AS ROOT_ANIM_KEY, 
 	gCTable.GENOTYPE_ID_NUM,
	'' as PEDIGREE_CHANGED,
	gERTable.SHORT_DESC AS CONFLICT_TYPE,
	gERTable.ERROR_CODE AS CONFLICT_CODE,
	gTConflict.SENTRIX_BARCODE AS CONFLICT_BARCODE,
	gTConflict.SENTRIX_POSITION AS CONFLICT_POSITION, 
 	abs(gTConflict.ANIM_KEY),
	gTConflict.USE_IND AS INDICATOR_IN_USE, 
	gTConflict.GENOTYPE_ID_NUM,
	gCTable.CONFLICT_CODE AS ROOT_CONFLICT_CODE,
	gCTable.YourGenotype,
	aID_Conflict.INT_ID,
	aID_Conflict.SEX_CODE  
	 
	 
FROM  CTE 
INNER JOIN 
(
   SELECT GENOTYPE_ID_NUM, CONFLICT_ID_NUM, CONFLICT_CODE, 'GENOTYPE_ID_NUM' as YourGenotype
   FROM GENOTYPE_CONFLICTS_TABLE
   UNION
   SELECT CONFLICT_ID_NUM AS GENOTYPE_ID_NUM, GENOTYPE_ID_NUM AS CONFLICT_ID_NUM, CONFLICT_CODE, 'CONFLICT_ID_NUM' as YourGenotype
   FROM GENOTYPE_CONFLICTS_TABLE
   with UR
)gCTable ON CTE.GENOTYPE_ID_NUM =gCTable.GENOTYPE_ID_NUM and CTE.rn =1
INNER JOIN GENOTYPE_TABLE gTConflict ON gTConflict.GENOTYPE_ID_NUM = gCTable.CONFLICT_ID_NUM 
INNER  JOIN CONFLICT_TO_ERROR_CODE_XREF_TABLE cTECXTable ON   cTECXTable.CONFLICT_CODE = gCTable.CONFLICT_CODE
INNER JOIN GENOMIC_ERROR_REF_TABLE gERTable 
ON (gERTable.ERROR_CODE = cTECXTable.CONFLICT_ERROR_CODE and gCTable.YourGenotype ='CONFLICT_ID_NUM') 
or (gERTable.ERROR_CODE = cTECXTable.GENOTYPE_ERROR_CODE and gCTable.YourGenotype ='GENOTYPE_ID_NUM') 

INNER JOIN ID_XREF_TABLE aID_Conflict ON aID_Conflict.ANIM_KEY =  abs(gTConflict.ANIM_KEY) AND aID_Conflict.SPECIES_CODE =0 AND  aID_Conflict.PREFERRED_CODE =1
WITH UR;
 
 
	 
	 
	 -- Update conflict message

 
	 UPDATE SESSION.TmpAnimalLists_Geno_Sample_Conflict 
	 SET CONFLICT_TYPE =  case when CONFLICT_SEX ='M' 
					           AND ( (YOUR_GENOTYPE = 'GENOTYPE_ID_NUM' AND ROOT_CONFLICT_CODE IN ('R','T'))
					               OR (YOUR_GENOTYPE = 'CONFLICT_ID_NUM' AND ROOT_CONFLICT_CODE ='Y')
					               )then 'Discovered Sire'
						      when CONFLICT_SEX ='F' 
						           AND ( (YOUR_GENOTYPE = 'GENOTYPE_ID_NUM' AND ROOT_CONFLICT_CODE IN ('M','T'))
						               OR (YOUR_GENOTYPE = 'CONFLICT_ID_NUM' AND ROOT_CONFLICT_CODE ='Y')
						               )then 'Discovered Dam'
						      when ((YOUR_GENOTYPE = 'CONFLICT_ID_NUM' AND ROOT_CONFLICT_CODE IN ('R','M','T'))
						            OR (YOUR_GENOTYPE = 'GENOTYPE_ID_NUM' AND ROOT_CONFLICT_CODE IN ('Y'))
						      
						            )then 'Potential Progeny'
						       else CONFLICT_TYPE
					       
					    end;
	 
	 
	 
	
       
  -- Get genotype sample
  INSERT INTO SESSION.TmpAnimalLists_Geno_Sample
  (
  	ROOT_INT_ID,
  	ROOT_ANIM_KEY,
	USE_IND,
	NOM_DATE,
	SAMPLE_ID,
	BAR_CODE,
	POSITION,
	CHIP_NAME,
	PEND,
	LAB,
	REQUESTOR,
	GNO_ARRIVAL_DATE,
	SNP_READ,
	BREED_SNP_CONFLICTS,
	EVAL_USE_DATE,
	HAS_CONFLICT,
	GENOTYPE_ID_NUM
  )
  
	SELECT    
		gTable.INT_ID ,
		gTable.ANIM_KEY,
		gTable.USE_IND,
		VARCHAR_FORMAT(DEFAULT_DATE+gSTable.ENTRY_PDATE,'YYYY-MM-DD') AS NOM_DATE,
		gTable.SAMPLE_ID AS SAMPLE_ID,
		gTable.SENTRIX_BARCODE AS BAR_CODE,
		gTable.SENTRIX_POSITION AS POSITION,
		aCTable.SHORT_NAME AS CHIP_NAME,
		'' as PEND,
		gSOTable.SOURCE_NAME as LAB,
		gTable.REQUESTER_ID AS REQUESTOR,
		VARCHAR_FORMAT(DEFAULT_DATE+gTable.SCAN_PDATE,'YYYY-MM-DD') AS GNO_ARRIVAL_DATE,
		gTable.SNP_READ_QTY AS SNP_READ,
		CASE WHEN substring(gTable.INT_ID,1,2) = 'HO' THEN gTable.BAD_HO_SNP_QTY
			 WHEN substring(gTable.INT_ID,1,2) = 'AY' THEN gTable.BAD_AY_SNP_QTY
			 WHEN substring(gTable.INT_ID,1,2) = 'BS' THEN gTable.BAD_BS_SNP_QTY
			 WHEN substring(gTable.INT_ID,1,2) = 'JE' THEN gTable.BAD_JE_SNP_QTY
			 WHEN substring(gTable.INT_ID,1,2) = 'GU' THEN gTable.BAD_GU_SNP_QTY
			 ELSE null
			 END AS BREED_SNP_CONFLICTS,
		gTable.USE_WEEKLY_TIMESTAMP AS EVAL_USE_DATE,
	 
	CASE WHEN conflict.GENOTYPE_ID_NUM IS  NULL THEN 'N'
	      ELSE 'Y' 
	 END  AS HAS_CONFLICT,
	 gTable.GENOTYPE_ID_NUM
	  
	FROM SESSION.TMP_GENOTYPE_TABLE gTable 
	LEFT JOIN GENOTYPE_STATUS_TABLE gSTable ON gSTable.ANIM_KEY = gTable.ANIM_KEY and gSTable.SAMPLE_ID = gTable.SAMPLE_ID
	LEFT JOIN GENOTYPE_SOURCE_TABLE gSOTable ON gSOTable.SOURCE_KEY = gTable.LAB_SOURCE_KEY 
	LEFT JOIN ARS_CHIP_TABLE aCTable ON aCTable.CLOB_TYPE_NUM = gTable.CLOB_TYPE_NUM
	LEFT JOIN (SELECT DISTINCT GENOTYPE_ID_NUM FROM SESSION.TmpAnimalLists_Geno_Sample_Conflict) conflict on conflict.GENOTYPE_ID_NUM = gTable.GENOTYPE_ID_NUM	  	
	WITH UR;
	
	
	--Get sire/dam
	 
    
    INSERT INTO SESSION.TmpAnimalLists_Ped
    (    
	    ROOT_INT_ID,
	    SIRE_INT_ID,
	    DAM_INT_ID
    )
    SELECT a.INT_ID as ROOT_INT_ID,
	    sireID.INT_ID as SIRE_INT_ID,
	    damID.INT_ID as DAM_INT_ID
	FROM  
    (
    SELECT t.ANIM_KEY, t.INT_ID, t.SPECIES_CODE, p.SIRE_KEY, p.DAM_KEY 
    FROM SESSION.TMP_INPUT t
    INNER JOIN  PEDIGREE_TABLE  p
    	ON t.ANIM_KEY =  p.ANIM_KEY
    	AND t.SPECIES_CODE = p.SPECIES_CODE 
    )a
    LEFT JOIN ID_XREF_TABLE sireID 
    ON sireID.ANIM_KEY = a.SIRE_KEY
    AND sireID.SPECIES_CODE = a.SPECIES_CODE
    AND sireID.PREFERRED_CODE = 1
    LEFT JOIN ID_XREF_TABLE damID 
    ON damID.ANIM_KEY = a.DAM_KEY
    AND damID.SPECIES_CODE = a.SPECIES_CODE
    AND damID.PREFERRED_CODE = 1 with UR;
 
		
	-- Calculate PEND 
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ANIMAL_PEND
	   (
        ANIM_KEY INT NULL,
        GENOTYPE_ID_NUM CHAR(18), 
        PEND VARCHAR(2),
        PRIORITY SMALLINT
      )with replace
      on commit preserve rows;
      
    INSERT INTO  SESSION.TMP_ANIMAL_PEND
    (
    ANIM_KEY,
    GENOTYPE_ID_NUM,
    PEND,
    PRIORITY
    )
	SELECT 
	ROOT_ANIM_KEY,
	GENOTYPE_ID_NUM,
	PEND,
	1 AS PRIORITY
	FROM 
	(
	   SELECT gSample.ROOT_ANIM_KEY,
	          gSample.GENOTYPE_ID_NUM,
	            CASE WHEN coalesce(gInput.NEW_ANIM_KEY,-1) <> -1 AND gInput.NEW_ANIM_KEY <> gSample.ROOT_ANIM_KEY THEN 'M'
				     ELSE gInput.REC_TYPE_CODE 
				 END AS PEND,
				ROW_NUMBER()OVER(PARTITION BY  gSample.ROOT_ANIM_KEY, gSample.GENOTYPE_ID_NUM ORDER BY MODIFY_TIMESTAMP DESC) AS RN
			
		FROM 
		SESSION.TmpAnimalLists_Geno_Sample gSample
		INNER JOIN GENOTYPE_INPUT_TABLE gInput ON gSample.GENOTYPE_ID_NUM  = CONCAT(gInput.SENTRIX_BARCODE,gInput.SENTRIX_POSITION)
		with UR
		)i
	WHERE RN =1
		
    UNION
    
    SELECT 
    gSample.ROOT_ANIM_KEY,
    gSample.GENOTYPE_ID_NUM,     
    CASE WHEN fa.RECORD IS NOT NULL THEN 'PA'
	     WHEN fs.RECORD IS NOT NULL THEN 'PS'
	     WHEN fd.RECORD IS NOT NULL THEN 'PD'
	     ELSE NULL
	END  AS PEND,
	2 AS PRIORITY
	FROM
	SESSION.TmpAnimalLists_Geno_Sample gSample
	INNER JOIN SESSION.TmpAnimalLists_Ped ped ON ped.ROOT_INT_ID = gSample.ROOT_INT_ID
	LEFT JOIN FMT1_TABLE fa ON ped.ROOT_INT_ID = substring(fa.RECORD,3,17)
	LEFT JOIN FMT1_TABLE fs ON ped.SIRE_INT_ID = substring(fs.RECORD,3,17)
	LEFT JOIN FMT1_TABLE fd ON ped.DAM_INT_ID = substring(fd.RECORD,3,17) with UR;
	 
	 
  MERGE INTO SESSION.TmpAnimalLists_Geno_Sample as A
	 using
	 (
	   SELECT T.*, ROW_NUMBER()OVER(PARTITION BY T.ANIM_KEY, T.GENOTYPE_ID_NUM ORDER BY PRIORITY) AS RN
	   FROM SESSION.TMP_ANIMAL_PEND T with UR
	 ) AS B
	 ON A.ROOT_ANIM_KEY = B.ANIM_KEY 
	 AND A.GENOTYPE_ID_NUM = B.GENOTYPE_ID_NUM 
	 AND B.RN =1
	 WHEN MATCHED THEN
	 UPDATE SET 
	 PEND = B.PEND 
	 ;
	 
	 
	   
	-- BLEND CODE
	 INSERT INTO SESSION.TMP_ANIMAL_BLEND_CODE  
	 (
	    ANIM_KEY,
	    INT_ID,
	    EVAL_BREED_CODE,
		BLEND_CODE 
	 )
     SELECT DISTINCT 
	        ANIM_KEY,
		    INT_ID,
		    EVAL_BREED_CODE,
			'' AS BLEND_CODE  
    FROM SESSION.TMP_GENOTYPE_TABLE;
  
	 
	 /*
	 ***Step 1***
     If animal  has genotype and exist in BBR_EVAL_TABLE  with max (aypct,bspct,gupct,hopct,jepct)>= 89.5 then Blend Code = 'S' else  Blend_Code = 'M' 
	 */
	 
    MERGE INTO SESSION.TMP_ANIMAL_BLEND_CODE as A
		 using
		 ( 
			  SELECT t.ANIM_KEY,
		             case when  max(bbr.aypct,bbr.bspct,bbr.gupct,bbr.hopct,bbr.jepct) >= 89.5 then 'S'
		                  else 'M'
		             end as BLEND_CODE
			 FROM SESSION.TMP_ANIMAL_BLEND_CODE t
			 INNER JOIN BBR_EVAL_TABLE bbr
			 	ON t.ANIM_KEY = bbr.ANIM_KEY
		 )AS B 
		 ON  A.ANIM_KEY = B.ANIM_KEY 
		 WHEN MATCHED THEN 
		 UPDATE SET BLEND_CODE = B.BLEND_CODE
		 ;
		 
		
	 /*
	 ***Step 2***
	    For animal with blend_code  not been set from step 1 and thier eval_breed_code is not missing
	     If animal has no 'k' genotype conflict then Blend_Code = 'P' else  Blend_Code = 'X'
	 
	 */
     MERGE INTO SESSION.TMP_ANIMAL_BLEND_CODE   as A
	 USING
		 ( 
				 select   t.anim_key, 
					        case when max(gc.genotype_id_num) is null  then 'P'-- has no k conflict
					             else 'X'
					         end as blend_code
				 from  
				 (
					 select *
					 from SESSION.TMP_ANIMAL_BLEND_CODE
					 where blend_code =' ' and eval_breed_code <>'  '
				 )t
				 inner join SESSION.TMP_GENOTYPE_TABLE gt
				 	on t.anim_key = gt.anim_key
				 left join GENOTYPE_CONFLICTS_TABLE gc
				  	on gc.genotype_id_num = gt.genotype_id_num
				  	and gc.conflict_code='k'
				 group by t.anim_key
 
		 )AS B
		 ON  A.anim_key = B.anim_key 
		 WHEN MATCHED THEN 
		 UPDATE SET BLEND_CODE = B.BLEND_CODE
		 ; 
	   
	 
 -- Get genotype group
 BEGIN
 DECLARE cur0 CURSOR WITH RETURN FOR
 
	SELECT DISTINCT   
		t.INT_ID AS ROOT_ANIMAL_ID, 
		t.PARENTAGE_ONLY_IND AS PI, 
		t.GROUP_NAME AS GROUP,
		t.HERD_REASON_CODE AS HRC,
		t.CDCB_FEE_PAID_CODE AS FEE_CODE, 
		gBTable.CDCB_FEE_PAID_CODE AS PAID,
		t.REQUESTER_ID AS REQUESTOR 
	FROM  SESSION.TMP_GENOTYPE_TABLE t 
	LEFT JOIN GENOTYPE_BILLINGS_TABLE gBTable ON t.ANIM_KEY = gBTable.ANIM_KEY  
	with UR;
	 
 OPEN cur0; 
END;


-- Get genotype conflicts
 begin
		 	DECLARE cursor1 CURSOR WITH RETURN for
		 		
		 	SELECT 
			 	ROOT_INT_ID AS ROOT_ANIMAL_ID,
				PEDIGREE_CHANGED,
				CONFLICT_TYPE,
				CONFLICT_CODE,
				CONFLICT_BARCODE,
				CONFLICT_POSITION,
				CAST(CONFLICT_BARCODE ||'  '|| coalesce(CONFLICT_POSITION,'') AS VARCHAR(128)) AS BARCODE_POS,
				CAST(COALESCE(CONFLICT_INT_ID,'') || ' [' || COALESCE(CONFLICT_SEX,'') ||']' AS VARCHAR(128)) as CONFLICT_ANIMAL_ID,
				INDICATOR_IN_USE,
				CONFLICT_TYPE||'|'||CONFLICT_CODE as CONFLICT_GROUP 
		 	FROM SESSION.TmpAnimalLists_Geno_Sample_Conflict
		 	ORDER BY ROOT_INT_ID,CONFLICT_TYPE,CONFLICT_CODE with UR;
		 	
		 	OPEN cursor1;
	   end;

-- Get genotype samples	
	   begin
		 	DECLARE cursor11 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID,
					USE_IND,
					NOM_DATE,
					SAMPLE_ID,
					BAR_CODE,
					POSITION,
					cast(BAR_CODE ||'  '|| coalesce(POSITION,'') as varchar(100))AS BARCODE_POS,
					CHIP_NAME,
					PEND,
					LAB,
					REQUESTOR,
					GNO_ARRIVAL_DATE,
					SNP_READ,
					cast(BREED_SNP_CONFLICTS || (case when BREED_SNP_CONFLICTS is not null then '%' else '' end ) as varchar(10)) as BREED_SNP_CONFLICTS,
					EVAL_USE_DATE,
					HAS_CONFLICT
		 	FROM SESSION.TmpAnimalLists_Geno_Sample
		 	ORDER BY EVAL_USE_DATE,SAMPLE_ID with UR;
		 	
		 	OPEN cursor11;
	   end;

	  -- Get genotype blend code   
	 BEGIN
	      DECLARE cir5 CURSOR WITH RETURN FOR
	      SELECT INT_ID AS ROOT_ANIMAL_ID,
	             BLEND_CODE
	      FROM SESSION.TMP_ANIMAL_BLEND_CODE with UR;
	      OPEN cir5;
	 END;
 
 
	   
	  
END

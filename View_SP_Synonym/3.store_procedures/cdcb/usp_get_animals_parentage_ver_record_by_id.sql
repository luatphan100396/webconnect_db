CREATE OR REPLACE PROCEDURE usp_Get_Animals_Parentage_Ver_Record_By_id_test
--===================================================================================================
--Author: Trong Le
--Created Date: 2020-10-13
--Description: Get parentage verification record of an animal
--Output:
--        +Ds1: Nomination status: group, hrc, fee, paid, nominator
--===================================================================================================
(
	IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1), 
    IN @EXPORT_TYPE varchar(5) default 'CSV',
	IN @IS_DATA_EXCHANGE char(1),
	IN @REQUEST_KEY BIGINT,
	IN @OPERATION_KEY BIGINT
)
dynamic result sets 10
 
BEGIN
	-- Declare variables
	DECLARE v_DEFAULT_DATE 			DATE;
	DECLARE v_DAM_STATUS_CODE		CHAR(1);
	DECLARE v_SUGGESTED_SIRE		CHAR(18);
	DECLARE v_ERR_SEG_LENGTH		SMALLINT DEFAULT 54;
	DECLARE v_MAX_ERROR_SEG 		SMALLINT DEFAULT 8;
	DECLARE i						SMALLINT DEFAULT 1; 
	
	DECLARE EXPORT_FILE_NAME VARCHAR(300);
	DECLARE TEMPLATE_NAME			VARCHAR(200) ; 
	DECLARE LAST_ROW_ID 		    INT;
	
	DECLARE sql_query				VARCHAR(30000);
--    DECLARE EXPORT_FILE_NAME		VARCHAR(300);
--	DECLARE EXPORT_PATH				VARCHAR(200);
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
	(
		INT_ID char(17), 
	    ANIM_KEY INT, 
	    SPECIES_CODE char(1),
	    SEX_CODE char(1),
	    INT_ID_18 char(18),
	    ORDER int,
		INPUT varchar(128)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	-- Declare temp tables 
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_GENOTYPE_TABLE AS
	(
		SELECT  t.*, 
		        0 AS RN
		FROM GENOTYPE_TABLE t
	
	) DEFINITION ONLY 
	WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_GENOTYPE_CONFLICTS_TABLE AS
	(
		SELECT  t.* 
		FROM GENOTYPE_CONFLICTS_TABLE t
	
	) DEFINITION ONLY 
	WITH REPLACE ON COMMIT PRESERVE ROWS;
	
			
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_HAP_SUGG_MGS_TABLE AS
	(
		SELECT *
		FROM HAP_SUGG_MGS_TABLE t
	
	) DEFINITION ONLY 
	WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_KEYS
	(
		ANIM_KEY		INTEGER,
		SIRE_KEY		INTEGER,
		DAM_KEY			INTEGER,
		MGS_KEY			INTEGER,
		PGS_KEY			INTEGER
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	 DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_SIRE_DAM_INFO
	(
		ANIM_KEY			INTEGER,  
		SIRE_KEY			INTEGER,
		DAM_KEY				INTEGER,
		SIRE_ID				CHAR(18),
		DAM_ID				CHAR(18),
		SIRE_SOURCE_CODE	CHAR(1),
		DAM_SOURCE_CODE		CHAR(1),
		SIRE_STATUS_CODE CHAR(1),
		DAM_STATUS_CODE CHAR(1)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_MGS_INFO
	(
		ANIM_KEY	INTEGER,
		MGS_KEY		INTEGER,
		MGS_ID		CHAR(18),
		--PGS_KEY		INTEGER,
		MGS_STATUS_CODE	CHAR(1)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
 
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ERR_SEG_FORMAT   
	(
	  ERR_NUM					SMALLINT,
	  ERR_CODE_START_INDEX		SMALLINT,
	  ERR_CODE_LENGTH			SMALLINT,
	  PARENT_KEY_START_INDEX	SMALLINT,
	  PARENT_KEY_LENGTH			SMALLINT
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_GENOTYPE_ERROR_SEGMENT
	(
	  ANIM_KEY			INTEGER,
	  SENTRIX_BARCODE	CHAR(12),
	  SENTRIX_POSITION	CHAR(6),
	  ERR_SEGMENT		VARCHAR(400),
	  ERR_QTY_SEGMENT INT
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_SUGGESTED_PARENT_KEY
	(
	  ANIM_KEY		INT,
	  ERROR_CODE	CHAR(2),
	  PARENT_KEY	varchar(9)
	  
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_SUGGESTED_PARENT_ID   
	(
	  
	  ANIM_KEY				INT,
	  PARENT_KEY			INT,
	  SUGGESTED_PARENT_ID	CHAR(18),  
	  SEX_CODE				CHAR(1) 
	  
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
   
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_MGS_SUGG
	(
	  ANIM_KEY				INT,
	  MGS_KEY				INT, 
	  MGS_SUGG_ID			CHAR(18), 
	  MGS_STAT		FLOAT,
	  METHOD CHAR(3),
	  RN				SMALLINT
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_MGS_SUGG_PIVOT
	(
	  ANIM_KEY			INT,
	  MGS_SUGG_1_ID		CHAR(18),
	  MGS_SUGG_2_ID		CHAR(18),
	  MGS_SUGG_3_ID		CHAR(18),
	  MGS_SUGG_4_ID		CHAR(18),
	  MGS_STAT_1		FLOAT,
	  MGS_STAT_2		FLOAT,
	  MGS_STAT_3		FLOAT,
	  MGS_STAT_4		FLOAT
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
   
   
   DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_NOT_FIXABLE_FOR_GET_EVALS
	(
	  ANIM_KEY				INT 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_BBR_WRONG_BREED
	(
	  ANIM_KEY				INT 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
		-- Declare temp tables
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_RESULT
	(
		ANIMAL_ID			CHAR(18),
		ANIMAL_SOURCE_CODE	VARCHAR(20),		--CHAR(1),
		SAMPLE_ID			VARCHAR(20),
		REQUESTER_ID		CHAR(12),
		CHIP_TYPE			VARCHAR(10),			--CHAR(4),
		SIRE_ID				CHAR(18),
		SIRE_SOURCE_CODE	VARCHAR(20),			--CHAR(1),
		SIRE_STATUS_CODE	VARCHAR(20),			--CHAR(1),
		SUGGESTED_SIRE		CHAR(18),
		DAM_ID				CHAR(18),
		DAM_SOURCE_CODE		VARCHAR(20),			--CHAR(1),
		DAM_STATUS_CODE		VARCHAR(20),			--CHAR(1),
		SUGGESTED_DAM		CHAR(18),
		MGS_ID				CHAR(18),
		MGS_STATUS_CODE		VARCHAR(20),			--CHAR(1),
		MGS_SUGG_1			CHAR(18),
		MGS_STAT_1			VARCHAR(200),			--FLOAT,
		MGS_SUGG_2			CHAR(18),
		MGS_STAT_2			VARCHAR(200),			--FLOAT,
		MGS_SUGG_3			CHAR(18),
		MGS_STAT_3			VARCHAR(200),			--FLOAT,
		MGS_SUGG_4			CHAR(18),
		MGS_STAT_4			VARCHAR(200),			--FLOAT,
		USABILITY_INDICATOR	VARCHAR(20),			--CHAR(1),
		PARENTAGE_INDICATOR	VARCHAR(20),			--CHAR(1),
		FEE_CODE			VARCHAR(20),			--CHAR(1),
		DATE				VARCHAR(15),				--DATE,
		GETS_EVAL			VARCHAR(20),			--CHAR(1)  
		ROW_ID 			   INT GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1)  
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
--	
	IF @IS_DATA_EXCHANGE ='0' THEN
		INSERT INTO SESSION.TMP_INPUT
		(  	
			INT_ID,
			ANIM_KEY,
			SPECIES_CODE,
			SEX_CODE,
			INT_ID_18
		)
			
		VALUES
		(
			@INT_ID,
			@ANIM_KEY,
			@SPECIES_CODE,
			@SEX_CODE,
			LEFT(@INT_ID,5) ||@SEX_CODE|| RIGHT(@INT_ID,12)
		);
	ELSEIF @IS_DATA_EXCHANGE ='1' THEN
		INSERT INTO SESSION.TMP_INPUT
		(  
		   INT_ID,
		   ANIM_KEY,
		   SPECIES_CODE,
		   SEX_CODE,
		   INT_ID_18,
		   INPUT
	   )
	    SELECT id.INT_ID,
			   id.ANIM_KEY,
			   id.SPECIES_CODE,
			   id.SEX_CODE,
			   LEFT(id.INT_ID,5) ||id.SEX_CODE|| RIGHT(id.INT_ID,12),
			   dx.LINE
	   	FROM
		(
			select ROW_KEY, 
				   LINE 
			from DATA_EXCHANGE_INPUT_TABLE  
			where REQUEST_KEY = @REQUEST_KEY
		)dx
		INNER JOIN ID_XREF_TABLE id
				ON id.INT_ID = dx.LINE
				AND id.SPECIES_CODE ='0' 
		ORDER BY ROW_KEY
		;
	END IF;
	
	
  --  Test performance on 2000 animals
--   INSERT INTO SESSION.TMP_INPUT
--	(  INT_ID,
--	   ANIM_KEY,
--	   SPECIES_CODE,
--	   SEX_CODE,
--	   INT_ID_18,
--	   ORDER
--   )
--   SELECT INT_ID,
--		ANIM_KEY,
--		SPECIES_CODE,
--		SEX_CODE,
--		LEFT(INT_ID,5) ||SEX_CODE|| RIGHT(INT_ID,12),
--		ORDER
--   FROM TEST_2000_ANIMALS 
--   ; 
	
	
	SET v_DEFAULT_DATE = (SELECT STRING_VALUE FROM dbo.constants WHERE NAME ='Default_Date_Value' LIMIT 1);
  
	 
	-- Get all genotypes 
	INSERT INTO SESSION.TMP_GENOTYPE_TABLE
    
	SELECT t.*
	FROM 
	   (
		    SELECT  gTable.*, 
		            row_number()over(partition by t.ANIM_KEY order by replace(USE_IND,'U','A') desc ) as RN  --set U status to the bottom
		        
		    FROM  SESSION.TMP_INPUT t
		    INNER JOIN GENOTYPE_TABLE gTable
		    ON t.ANIM_KEY = gTable.ANIM_KEY 
	    )t
	 WHERE RN=1
	    ;  
     
    
    INSERT INTO SESSION.TMP_GENOTYPE_CONFLICTS_TABLE 
    SELECT gc.* 
    FROM SESSION.TMP_GENOTYPE_TABLE gt
    INNER JOIN  GENOTYPE_CONFLICTS_TABLE gc
    	ON gt.GENOTYPE_ID_NUM = gc.GENOTYPE_ID_NUM
    ;
    
     --Get HAP_SUGG_MGS_TABLE
    INSERT INTO SESSION.TMP_HAP_SUGG_MGS_TABLE
    SELECT hap.*
    FROM  SESSION.TMP_INPUT t
    INNER JOIN  HAP_SUGG_MGS_TABLE hap
    ON t.ANIM_KEY = hap.ANIM_KEY 
    ;
    
    
    
   --  Get Keys
    INSERT INTO SESSION.TMP_KEYS
	(
		ANIM_KEY,
		SIRE_KEY,
		DAM_KEY,
		MGS_KEY,
		PGS_KEY
	)
	SELECT	ped_ani.ANIM_KEY,
			ped_ani.SIRE_KEY,
			ped_ani.DAM_KEY,
			ped_mgs.SIRE_KEY,
			ped_pgs.SIRE_KEY
	FROM SESSION.TMP_INPUT t
	INNER JOIN 		
	(
	  SELECT DISTINCT ANIM_KEY
	  FROM SESSION.TMP_GENOTYPE_TABLE
	)g
		ON t.ANIM_KEY = g.ANIM_KEY
	INNER JOIN  PEDIGREE_TABLE ped_ani
		ON g.ANIM_KEY = ped_ani.ANIM_KEY
		AND ped_ani.SPECIES_CODE = t.SPECIES_CODE 
	LEFT JOIN PEDIGREE_TABLE ped_mgs
		ON ped_ani.DAM_KEY = ped_mgs.ANIM_KEY
		AND ped_mgs.SPECIES_CODE = t.SPECIES_CODE
	LEFT JOIN PEDIGREE_TABLE ped_pgs
		ON ped_ani.SIRE_KEY = ped_pgs.ANIM_KEY
		AND ped_pgs.SPECIES_CODE = t.SPECIES_CODE
	 
	;
 	
 /*Get Sire/Dam information and sire/dam status code from genotype table*/ 
	INSERT INTO SESSION.TMP_SIRE_DAM_INFO
	(
		ANIM_KEY,
		SIRE_KEY,
		DAM_KEY,
		SIRE_ID,
		DAM_ID,
		SIRE_SOURCE_CODE,
		DAM_SOURCE_CODE,
		SIRE_STATUS_CODE,
		DAM_STATUS_CODE
	)
 
	SELECT	keys.ANIM_KEY, 
			keys.SIRE_KEY,
			keys.DAM_KEY,
			(sire.BREED_CODE ||sire.COUNTRY_CODE || sire.SEX_CODE || sire.ANIM_ID_NUM) AS SIRE_ID_18,
			(dam.BREED_CODE ||dam.COUNTRY_CODE || dam.SEX_CODE || dam.ANIM_ID_NUM) AS DAM_ID_18,
			sisoco.SOURCE_CODE,
			dasoco.SOURCE_CODE,
			CASE WHEN gnt.SIRE_STATUS_CODE = '1' THEN 'U'
			     WHEN gnt.SIRE_STATUS_CODE = '2' THEN 'Y'
			     WHEN gnt.SIRE_STATUS_CODE = '3' THEN 'N'
			     ELSE '' 
			END AS SIRE_STATUS_CODE,
			CASE WHEN gnt.DAM_STATUS_CODE =  '1' THEN 'U'
				 WHEN gnt.DAM_STATUS_CODE =  '2' THEN 'Y'
				 WHEN gnt.DAM_STATUS_CODE =  '3' THEN 'N' 
				 ELSE ''
			END AS DAM_STATUS_CODE  
	FROM SESSION.TMP_INPUT t
	INNER JOIN SESSION.TMP_GENOTYPE_TABLE gnt
		ON t.ANIM_KEY = gnt.ANIM_KEY
	INNER JOIN  SESSION.TMP_KEYS keys
		ON t.ANIM_KEY = keys.ANIM_KEY
	LEFT JOIN ID_XREF_TABLE sire
		ON sire.ANIM_KEY = keys.SIRE_KEY
		AND sire.SPECIES_CODE = t.SPECIES_CODE 
	    AND sire.SEX_CODE = 'M'
	    AND sire.PREFERRED_CODE = '1'
	LEFT JOIN ID_XREF_TABLE dam
		ON dam.ANIM_KEY = keys.DAM_KEY
		AND dam.SPECIES_CODE = t.SPECIES_CODE 
	    AND dam.SEX_CODE = 'F'
	    AND dam.PREFERRED_CODE = '1'
	LEFT JOIN PEDIGREE_TABLE sisoco
		ON keys.SIRE_KEY = sisoco.ANIM_KEY
		AND sisoco.SPECIES_CODE = t.SPECIES_CODE
	LEFT JOIN PEDIGREE_TABLE dasoco
		ON keys.DAM_KEY = dasoco.ANIM_KEY
		AND dasoco.SPECIES_CODE = t.SPECIES_CODE 
	;
	 
	
 -- Update Dam status code base on HAP_SUGG_MGS_TABLE  
		MERGE INTO SESSION.TMP_SIRE_DAM_INFO as A
		 using
		 ( 
			 SELECT sd.ANIM_KEY, 
			        case when sd.DAM_STATUS_CODE IN ('U','N')  and hap.DAM_MGS_CONFLICT_CNT >1 and hap.DAM_PROGENY_CNT >1  and hap.DAM_PROGENY_CNT>hap.DAM_MGS_CONFLICT_CNT  then 'H' 
					     else sd.DAM_STATUS_CODE
					 end DAM_STATUS_CODE
					       
			 FROM SESSION.TMP_SIRE_DAM_INFO sd
			 INNER JOIN SESSION.TMP_HAP_SUGG_MGS_TABLE hap
			 ON sd.ANIM_KEY = hap.ANIM_KEY 
		 )AS B
		 ON  A.ANIM_KEY = B.ANIM_KEY 
		 WHEN MATCHED THEN UPDATE 
		 SET DAM_STATUS_CODE=B.DAM_STATUS_CODE 
		 ;
		 
	 /*Get MGS information and MGS status code from genotype table*/ 
  
 	--If mgs_key <0, then set status = U
             
	INSERT INTO SESSION.TMP_MGS_INFO
	(
		ANIM_KEY,
		MGS_KEY,
		MGS_ID,
		MGS_STATUS_CODE
	)
	 
	SELECT 	keys.ANIM_KEY, 
			keys.MGS_KEY, 	
			(xref_mgs.BREED_CODE || xref_mgs.COUNTRY_CODE || xref_mgs.SEX_CODE || xref_mgs.ANIM_ID_NUM) AS MGS_ID_18,
	        CASE WHEN  gs.MGS_STATUS_CODE = '1' or keys.MGS_KEY<0 THEN 'U'
			     WHEN gs.MGS_STATUS_CODE = '2' THEN 'Y'
			     WHEN gs.MGS_STATUS_CODE = '3' THEN 'N'
			     ELSE '' 
			END AS MGS_STATUS_CODE 
	FROM SESSION.TMP_KEYS keys
	INNER JOIN ID_XREF_TABLE xref_mgs
		ON keys.MGS_KEY = xref_mgs.ANIM_KEY
		AND xref_mgs.SEX_CODE = 'M'
		AND xref_mgs.SPECIES_CODE = '0'
		AND xref_mgs.PREFERRED_CODE = '1'
	LEFT JOIN GENOTYPE_GS_TABLE gs
		ON gs.ANIM_KEY = keys.ANIM_KEY
		AND gs.GS_KEY = keys.MGS_KEY
	;
	 
	 
 	-- Update MGS status code: From GENOTYPE_CONFLICTS_TABLE, if found K conflict, set status to N
		MERGE INTO SESSION.TMP_MGS_INFO as A
		 using
		 ( 
				SELECT gt.ANIM_KEY, 
		               'N' AS MGS_STATUS_CODE
				FROM 
				(
				    SELECT  gnt_ani.ANIM_KEY, 
				            gnt_ani.GENOTYPE_ID_NUM,
				            row_number()over(partition by gnt_ani.ANIM_KEY order by gnt_ani.USE_IND DESC, gnt_ani.SCAN_PDATE DESC) as RN
				    FROM SESSION.TMP_GENOTYPE_TABLE gnt_ani
				    WHERE USE_IND in ('Y','N') 
				)gt
				
				INNER JOIN GENOTYPE_CONFLICTS_TABLE gc
					ON gc.GENOTYPE_ID_NUM =  gt.GENOTYPE_ID_NUM 
					AND gc.CONFLICT_CODE ='K'
					AND gt.RN =1
		 )AS B
		 ON  A.ANIM_KEY = B.ANIM_KEY 
		 WHEN MATCHED THEN UPDATE 
		 SET MGS_STATUS_CODE=B.MGS_STATUS_CODE 
		 ;
		 
	
 
 	-- If mgs_key>0 and mgs_key does not have genotype, then set status = U, else set status = Y

		MERGE INTO SESSION.TMP_MGS_INFO as A
		 using
		 ( 
				SELECT  mgs.ANIM_KEY, 
		               case when  mgs.ANIM_KEY <0  or max(gt_mgs.ANIM_KEY) is null  then 'U'
		                    when  mgs.ANIM_KEY >0 and max(gt_mgs.ANIM_KEY) is not null then 'Y'  
		               end AS MGS_STATUS_CODE 
				FROM SESSION.TMP_MGS_INFO  mgs 
				LEFT JOIN GENOTYPE_TABLE gt_mgs
				  ON mgs.MGS_KEY = gt_mgs.ANIM_KEY 
				GROUP BY  mgs.ANIM_KEY 
				 
		 )AS B
		 ON  A.ANIM_KEY = B.ANIM_KEY 
		 WHEN MATCHED THEN UPDATE 
		 SET MGS_STATUS_CODE=B.MGS_STATUS_CODE 
		 ;
	 
 	/*if above mgs_status_code in ('N', 'U') then set Status as: 
       +'H' – Unlikely; MGS suggestion based on haplotype test if HAP_SUGG_MGS_TABLE.MGS_STATUS_CODE <> '1'
       +'S' – Unlikely; Dam’s sire is wrong based on haplotype test if HAP_SUGG_MGS_TABLE.DAM_MGS_CONFLICT_CNT >1 and HAP_SUGG_MGS_TABLE.DAM_PROGENY_CNT >1 and HAP_SUGG_MGS_TABLE.DAM_MGS_CONFLICT_CNT= HAP_SUGG_MGS_TABLE.DAM_PROGENY_CNT
       +'X' – Unlikely; No MGS suggestion if  HAP_SUGG_MGS_TABLE.MGS_STATUS_CODE in ('D','0')
       +'I' – Dam Incorrect if DAM_STATUS_CODE ='N' 
	*/
	MERGE INTO SESSION.TMP_MGS_INFO as A
		 using
		 ( 
				SELECT mgs.ANIM_KEY,
				       case when hap.MGS_STATUS_CODE <>'1' then 'H'
				            when hap.MGS_STATUS_CODE in ('D','0') then 'X'
				            when hap.DAM_MGS_CONFLICT_CNT >1 and hap.DAM_PROGENY_CNT >1 and hap.DAM_MGS_CONFLICT_CNT=hap.DAM_PROGENY_CNT  then 'S'
				            else hap.MGS_STATUS_CODE
				        end MGS_STATUS_CODE  
				FROM SESSION.TMP_MGS_INFO mgs
			    LEFT JOIN SESSION.TMP_HAP_SUGG_MGS_TABLE hap
			    	ON mgs.ANIM_KEY = hap.ANIM_KEY
				WHERE mgs.MGS_STATUS_CODE IN ('N','U')
				
				 
		 )AS B
		 ON  A.ANIM_KEY = B.ANIM_KEY 
		 WHEN MATCHED THEN UPDATE 
		 SET MGS_STATUS_CODE=B.MGS_STATUS_CODE 
		 ;
	
	 
	
 	-- Set MGS_STATUS_CODE = 'I' if DAM_STATUS_CODE = 'N'  Dam is incorrect 
	
	
	MERGE INTO SESSION.TMP_MGS_INFO as A
		 using
		 ( 
				SELECT  ANIM_KEY,
				        'I' AS MGS_STATUS_CODE  
				FROM SESSION.TMP_SIRE_DAM_INFO 
				WHERE DAM_STATUS_CODE ='N' 
				 
		 )AS B
		 ON  A.ANIM_KEY = B.ANIM_KEY 
		 WHEN MATCHED THEN UPDATE 
		 SET MGS_STATUS_CODE=B.MGS_STATUS_CODE 
		 ; 
		 
   
       /*Get Suggested sire/dam*/
    	
      --Populate start_index, length for each segment
    WHILE(i <= v_MAX_ERROR_SEG)
    DO
    	INSERT INTO SESSION.TMP_ERR_SEG_FORMAT
    	(
			ERR_NUM,
			ERR_CODE_START_INDEX,
			ERR_CODE_LENGTH,
			PARENT_KEY_START_INDEX,
			PARENT_KEY_LENGTH
    	)
    	VALUES
    	(
    		i,
    		(i-1)*v_ERR_SEG_LENGTH + 1,
    		2,
    		(i-1)*v_ERR_SEG_LENGTH + 5,
    		9
    	);
    	COMMIT WORK;
    	SET i = i+1;
    END WHILE;
    
     -- Get the last error genotype    
					    	
	INSERT INTO SESSION.TMP_GENOTYPE_ERROR_SEGMENT
	(
		ANIM_KEY,
		SENTRIX_BARCODE,
		SENTRIX_POSITION,
		ERR_SEGMENT,
		ERR_QTY_SEGMENT
	)
	 		
		SELECT ANIM_KEY,
			SENTRIX_BARCODE,
			SENTRIX_POSITION,
			ERR_SEGMENT_RECORD,
			ERR_QTY_SEGMENT
		FROM
		(
			SELECT	err_gnt.ANIM_KEY,
					err_gnt.SENTRIX_BARCODE,
					err_gnt.SENTRIX_POSITION,
					err_gnt.ERR_SEGMENT_RECORD, 
					ROUND(length(err_gnt.ERR_SEGMENT_RECORD)/v_ERR_SEG_LENGTH,0) AS ERR_QTY_SEGMENT,
				    ROW_NUMBER() OVER(PARTITION BY err_gnt.ANIM_KEY, err_gnt.SENTRIX_BARCODE, err_gnt.SENTRIX_POSITION  ORDER BY err_gnt.DATE_TIME DESC, err_gnt.RECORD_NUM DESC) as RN
			FROM ERROR_GENOTYPE_TABLE err_gnt
			INNER JOIN SESSION.TMP_GENOTYPE_TABLE temp_gnt
				ON  err_gnt.SENTRIX_BARCODE = temp_gnt.SENTRIX_BARCODE
				AND err_gnt.SENTRIX_POSITION = temp_gnt.SENTRIX_POSITION
				AND temp_gnt.USE_IND <> 'Y' 
 		 )t
 		 WHERE t.RN=1
	     ;
	 
 
--- Get Suggested parent key  from error segment	
	INSERT INTO SESSION.TMP_SUGGESTED_PARENT_KEY
    (
    	ANIM_KEY,
    	ERROR_CODE,
		PARENT_KEY
    )

	SELECT	t_err_seg.ANIM_KEY,
			SUBSTRING(t_err_seg.ERR_SEGMENT, t_err_seg_format.ERR_CODE_START_INDEX, t_err_seg_format.ERR_CODE_LENGTH) as ERROR_CODE,
			TRIM(SUBSTRING(t_err_seg.ERR_SEGMENT, t_err_seg_format.PARENT_KEY_START_INDEX, t_err_seg_format.PARENT_KEY_LENGTH)) AS PARENT_KEY 
    FROM SESSION.TMP_GENOTYPE_ERROR_SEGMENT t_err_seg
    CROSS JOIN SESSION.TMP_ERR_SEG_FORMAT t_err_seg_format
    WHERE SUBSTRING(t_err_seg.ERR_SEGMENT, t_err_seg_format.ERR_CODE_START_INDEX, t_err_seg_format.ERR_CODE_LENGTH) IN ('O0','O1','O3','O9')
    AND t_err_seg_format.ERR_NUM <= t_err_seg.ERR_QTY_SEGMENT 
    ;
  
      
   --  Get Suggested parent ID from parent key
    INSERT INTO SESSION.TMP_SUGGESTED_PARENT_ID
    (
    	ANIM_KEY,
    	PARENT_KEY, 
    	SUGGESTED_PARENT_ID,
    	SEX_CODE
    )

    SELECT 
    	ANIM_KEY,
    	PARENT_KEY, 
    	SUGGESTED_PARENT_ID,
    	SEX_CODE
    FROM
    (
	    SELECT  
	    		tpkey.ANIM_KEY,
	    		tpkey.PARENT_KEY AS PARENT_KEY,
	    		(xref_parent.BREED_CODE || xref_parent.COUNTRY_CODE || xref_parent.SEX_CODE || xref_parent.ANIM_ID_NUM) AS SUGGESTED_PARENT_ID, 
	    		ped_parent.SEX_CODE AS SEX_CODE,
	    		ROW_NUMBER()OVER(PARTITION BY xref_parent.SEX_CODE, tpkey.ANIM_KEY ORDER BY ped_parent.BIRTH_PDATE, tpkey.PARENT_KEY) AS RN
       FROM SESSION.TMP_SUGGESTED_PARENT_KEY tpkey
	    INNER JOIN PEDIGREE_TABLE ped
	    	ON  ped.ANIM_KEY = tpkey.ANIM_KEY 
	    	AND ped.SPECIES_CODE = '0' 
 	    INNER JOIN PEDIGREE_TABLE ped_parent
 	    	ON tpkey.PARENT_KEY = ped_parent.ANIM_KEY
 	    	AND ped_parent.SPECIES_CODE = '0'
 	    INNER JOIN ID_XREF_TABLE xref_parent
 	    	ON xref_parent.ANIM_KEY = tpkey.PARENT_KEY
 	    	AND xref_parent.SPECIES_CODE = ped_parent.SPECIES_CODE
 	    	AND xref_parent.SEX_CODE = ped_parent.SEX_CODE 
 	    	AND xref_parent.PREFERRED_CODE = '1'
	    WHERE ped_parent.BIRTH_PDATE < ped.BIRTH_PDATE
	    )
	  WHERE RN =1 
  ;
  
 
  
  /*  Get suggested MGS */
  
  -- Find MGS candidate from HAP_SUGG_MGS_TABLE and GENOTYPE_GS_TABLE. The one in HAP_SUGG_MGS_TABLE is higher priority
 	 
	INSERT INTO SESSION.TMP_MGS_SUGG
	(
		ANIM_KEY,
	  	MGS_KEY, 
	  	MGS_SUGG_ID,
	  	MGS_STAT,
	  	METHOD,
	  	RN
	)
	SELECT	gs.ANIM_KEY,
			gs.MGS_KEY,
			xref.BREED_CODE || xref.COUNTRY_CODE || xref.SEX_CODE || xref.ANIM_ID_NUM AS MGS_SUGG_ID,
			gs.MGS_STAT,
			gs.METHOD,
			ROW_NUMBER()OVER(PARTITION BY gs.ANIM_KEY ORDER BY gs.RN) AS RN
	FROM
	(
		SELECT	t.ANIM_KEY, 
				hap.MGS_KEY, 
				hap.HAP_MATCH_PCT AS MGS_STAT,
				'HAP' AS METHOD,
				1 as RN
		FROM SESSION.TMP_INPUT t
		INNER JOIN HAP_SUGG_MGS_TABLE hap
			ON t.ANIM_KEY = hap.ANIM_KEY 
		
		UNION ALL
		
		(
			SELECT	gnt_gs.ANIM_KEY AS ANIM_KEY,
					gnt_gs.GS_KEY AS GS_KEY,
					gnt_gs.SNP_CONFLICTS_PCT AS MGS_STAT,
					'SNP' AS METHOD,
					(ROW_NUMBER()OVER(PARTITION BY gnt_gs.ANIM_KEY ORDER BY gnt_gs.SNP_CONFLICTS_PCT) + 1) AS RN
			FROM SESSION.TMP_INPUT t
			INNER JOIN GENOTYPE_GS_TABLE gnt_gs
				ON t.ANIM_KEY = gnt_gs.ANIM_KEY 
				AND TYPE_CODE IN ('M','B')
		 
		)
	) gs
	INNER JOIN PEDIGREE_TABLE ped
			ON ped.ANIM_KEY = gs.MGS_KEY
			AND ped.SEX_CODE = 'M'
			AND SPECIES_CODE = '0'
	INNER JOIN ID_XREF_TABLE xref
			ON ped.ANIM_KEY = xref.ANIM_KEY
			AND xref.SPECIES_CODE = ped.SPECIES_CODE
		    AND ped.SEX_CODE = ped.SEX_CODE
		    AND xref.PREFERRED_CODE = 1
	    ;
	
   -- Only keep top 4 candidate     
   DELETE FROM SESSION.TMP_MGS_SUGG WHERE RN >4;
 	
	
	-- Pivot top 4 mgs candidate into columns
	INSERT INTO SESSION.TMP_MGS_SUGG_PIVOT
	(
		ANIM_KEY,
	  	MGS_SUGG_1_ID,
	 	MGS_SUGG_2_ID,
		MGS_SUGG_3_ID,
		MGS_SUGG_4_ID,
		MGS_STAT_1,
		MGS_STAT_2,
		MGS_STAT_3,
		MGS_STAT_4
	)
	SELECT	ANIM_KEY,
			MAX(CASE WHEN t.RN = '1' THEN t.MGS_SUGG_ID  ELSE NULL END) AS MGS_SUGG_1_ID,
			MAX(CASE WHEN t.RN = '2' THEN t.MGS_SUGG_ID  ELSE NULL END) AS MGS_SUGG_2_ID,
			MAX(CASE WHEN t.RN = '3' THEN t.MGS_SUGG_ID  ELSE NULL END) AS MGS_SUGG_3_ID,
			MAX(CASE WHEN t.RN = '4' THEN t.MGS_SUGG_ID  ELSE NULL END) AS MGS_SUGG_4_ID,
			MAX(CASE WHEN t.RN = '1' THEN t.MGS_STAT  ELSE NULL END) AS MGS_STAT_1,
			MAX(CASE WHEN t.RN = '2' THEN t.MGS_STAT  ELSE NULL END) AS MGS_STAT_2,
			MAX(CASE WHEN t.RN = '3' THEN t.MGS_STAT  ELSE NULL END) AS MGS_STAT_3,
			MAX(CASE WHEN t.RN = '4' THEN t.MGS_STAT  ELSE NULL END) AS MGS_STAT_4
	FROM SESSION.TMP_MGS_SUGG t
	GROUP BY t.ANIM_KEY
	;
	 
	/* Calculate gets_eval: checking whether the genotype is fixable for get evaluation. Set gets_eval = 'N' for following cases, else set to 'Y'
			- USE_ID not in ('Y','M')
			- Animal has wrong breed.  
Wrong breed if:
					 * Animal has k conflict
					 * eval_breed_code not in ('AY','BS','GU','HO','JE','XX','XD')
					 * Conflict on Breed base representation: animal has record in BBR_EVAL_TABLE and:
				     	      + eval_breed_code = 'HO' but HOpct < 89.5%
				     	      + eval_breed_code = 'JE' but JEpct < 89.5%
				     	      + eval_breed_code = 'BS' but BSpct < 89.5%
				      	     + eval_breed_code = 'AY' but AYpct < 89.5%
				      	     + eval_breed_code = 'GU' but GUpct < 89.5% 
				      	     + eval_breed_code = 'XX'  
			- USE_WEEKLY_TIMESTAMP is missing
			- Unlikely GS (the genotype has been detected conflicts: MGS is unlikely (code = 'K') or PGS is unlikely(code = 'J'))
	
	*/ 
	
	INSERT INTO SESSION.TMP_BBR_WRONG_BREED
	(
		ANIM_KEY 
	)
	 SELECT gt.ANIM_KEY  
	 FROM SESSION.TMP_GENOTYPE_TABLE gt
	 INNER JOIN BBR_EVAL_TABLE bbr
	    ON gt.ANIM_KEY = bbr.ANIM_KEY
	    AND max(bbr.AYpct,bbr.BSpct,bbr.GUpct,bbr.HOpct,bbr.JEpct) >=89.5
	    AND (gt.EVAL_BREED_CODE = 'HO' AND bbr.HOpct < 89.5
	         or gt.EVAL_BREED_CODE = 'JE' AND bbr.JEpct < 89.5
	         or gt.EVAL_BREED_CODE = 'BS' AND bbr.BSpct < 89.5
	         or gt.EVAL_BREED_CODE = 'AY' AND bbr.AYpct < 89.5
	         or gt.EVAL_BREED_CODE = 'GU' AND bbr.GUpct < 89.5
	         or gt.EVAL_BREED_CODE = 'XX' 
	    ) 
	;
	
	 
	 
	 INSERT INTO SESSION.TMP_NOT_FIXABLE_FOR_GET_EVALS
	 (
	 ANIM_KEY
	 )
	 SELECT g.ANIM_KEY 
	 FROM SESSION.TMP_GENOTYPE_TABLE g
	 LEFT JOIN SESSION.TMP_GENOTYPE_CONFLICTS_TABLE gc
	 	ON g.GENOTYPE_ID_NUM  = gc.GENOTYPE_ID_NUM
	 	AND gc.CONFLICT_CODE in ('k','K','J') -- breed conflict, gs unlikely 
	 LEFT JOIN SESSION.TMP_BBR_WRONG_BREED bbr
	    ON g.ANIM_KEY = bbr.ANIM_KEY
	 WHERE g.USE_IND not in ('Y','M') -- not usable 
	  	   OR gc.GENOTYPE_ID_NUM IS NOT NULL 
	  	   OR g.EVAL_BREED_CODE NOT IN ('AY','BS','GU','HO','JE','XX','XD')  
	  	   OR bbr.ANIM_KEY IS NOT NULL -- wrong breed base on BBR calculation
	  	   OR g.USE_WEEKLY_TIMESTAMP IS NULL 
	 ;
  
  /*Retrive output*/ 
   
	
 --Insert result	
 INSERT INTO SESSION.TMP_RESULT
 (
		ANIMAL_ID,
		ANIMAL_SOURCE_CODE,	
		SAMPLE_ID,
		REQUESTER_ID,
		CHIP_TYPE,
		SIRE_ID,
		SIRE_SOURCE_CODE,
		SIRE_STATUS_CODE,
		SUGGESTED_SIRE,
		DAM_ID,
		DAM_SOURCE_CODE,
		DAM_STATUS_CODE,
		SUGGESTED_DAM,
		MGS_ID,
		MGS_STATUS_CODE,
		MGS_SUGG_1,
		MGS_STAT_1,
		MGS_SUGG_2,
		MGS_STAT_2,
		MGS_SUGG_3,
		MGS_STAT_3,
		MGS_SUGG_4,
		MGS_STAT_4,
		USABILITY_INDICATOR,
		PARENTAGE_INDICATOR,
		FEE_CODE,
		DATE,
		GETS_EVAL
	)
  
	SELECT t.INT_ID_18 as INT_ID_18
		,ped.SOURCE_CODE AS ANIM_SOURCE_CODE
		,g.SAMPLE_ID
		,g.REQUESTER_ID
		,chip.SHORT_NAME AS CHIP_TYPE
		,parent.SIRE_ID
		,parent.SIRE_SOURCE_CODE
		,parent.SIRE_STATUS_CODE
		,sugg_sire.SUGGESTED_PARENT_ID as SUGG_SIRE_ID
		,parent.DAM_ID
		,parent.DAM_SOURCE_CODE
		,parent.DAM_STATUS_CODE
		,sugg_dam.SUGGESTED_PARENT_ID as SUGG_DAM_ID
		,mgs.MGS_ID
		,mgs.MGS_STATUS_CODE
		,sugg_mgs.MGS_SUGG_1_ID 
		,sugg_mgs.MGS_STAT_1 
		,sugg_mgs.MGS_SUGG_2_ID
		,sugg_mgs.MGS_STAT_2
		,sugg_mgs.MGS_SUGG_3_ID
		,sugg_mgs.MGS_STAT_3
		,sugg_mgs.MGS_SUGG_4_ID
		,sugg_mgs.MGS_STAT_4
		,g.USE_IND
		,g.PARENTAGE_ONLY_IND 
		,g.CDCB_FEE_PAID_CODE  
		,VARCHAR_FORMAT(g.SCAN_PDATE +  v_DEFAULT_DATE,'YYYY-MM-DD') AS DATE
		,CASE WHEN no_fix_eval.ANIM_KEY IS NOT NULL THEN 'N'  ELSE 'Y' END AS gets_eval   
		FROM SESSION.TMP_INPUT t
		INNER JOIN PEDIGREE_TABLE ped
			ON ped.ANIM_KEY =t.ANIM_KEY 
			AND ped.SPECIES_CODE = t.SPECIES_CODE 
		INNER JOIN SESSION.TMP_GENOTYPE_TABLE g
			ON g.ANIM_KEY = t.ANIM_KEY
		INNER JOIN ARS_CHIP_TABLE chip
			ON chip.CLOB_TYPE_NUM = g.CLOB_TYPE_NUM
		LEFT JOIN SESSION.TMP_SIRE_DAM_INFO parent
			ON parent.ANIM_KEY =t.ANIM_KEY
	    LEFT JOIN SESSION.TMP_MGS_INFO mgs
	    	ON  mgs.ANIM_KEY = t.ANIM_KEY
	    LEFT JOIN SESSION.TMP_SUGGESTED_PARENT_ID sugg_sire
	    	ON sugg_sire.ANIM_KEY = t.ANIM_KEY
	    	AND sugg_sire.SEX_CODE='M'
	    LEFT JOIN SESSION.TMP_SUGGESTED_PARENT_ID sugg_dam
	    	ON sugg_sire.ANIM_KEY = t.ANIM_KEY 
	    	AND sugg_dam.SEX_CODE='F' 
	    LEFT JOIN SESSION.TMP_MGS_SUGG_PIVOT sugg_mgs
	    	ON t.ANIM_KEY = sugg_mgs.ANIM_KEY
	    LEFT JOIN SESSION.TMP_NOT_FIXABLE_FOR_GET_EVALS no_fix_eval
	    	ON t.ANIM_KEY = no_fix_eval.ANIM_KEY 
		ORDER BY t.ORDER 
	; 
	 
	SET LAST_ROW_ID = (SELECT MAX(ROW_ID) FROM SESSION.TMP_RESULT); 
	 
	IF @IS_DATA_EXCHANGE = '0' THEN
	  
		IF @EXPORT_TYPE ='CSV' THEN
			SET TEMPLATE_NAME 	='ANIM_PARENTAGE_VERIF_RECORD_CSV'; 
			call usp_common_export_csv_by_template('SESSION.TMP_RESULT',TEMPLATE_NAME,EXPORT_FILE_NAME); 
		
		ELSEIF @EXPORT_TYPE ='JSON' THEN
		
			SET TEMPLATE_NAME 	='ANIM_PARENTAGE_VERIF_RECORD'; 
			call usp_common_export_json_by_template('SESSION.TMP_RESULT',TEMPLATE_NAME,LAST_ROW_ID,EXPORT_FILE_NAME);
		
		END IF; 
    
    
		begin
			declare c1 cursor with return for
			select EXPORT_FILE_NAME from sysibm.sysdummy1;
		
		open c1;
		
		end;
	ELSEIF @IS_DATA_EXCHANGE = '1' THEN
 
			SET TEMPLATE_NAME 	='ANIM_PARENTAGE_VERIF_RECORD'; 
			call usp_common_export_json_by_template('SESSION.TMP_RESULT',TEMPLATE_NAME,LAST_ROW_ID,EXPORT_FILE_NAME);

			--validate output
			IF EXPORT_FILE_NAME IS NULL THEN 
					SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Export failed'; 
			END IF;

			UPDATE DATA_EXCHANGE_OPERATION_TABLE SET OUTPUT_PATH = EXPORT_FILE_NAME 
		   	WHERE OPERATION_KEY = @OPERATION_KEY;
		   
	       
			begin
				declare c1 cursor with return for
				select EXPORT_FILE_NAME from sysibm.sysdummy1;
		
				open c1;
	
			end;
	  
   END IF;
END
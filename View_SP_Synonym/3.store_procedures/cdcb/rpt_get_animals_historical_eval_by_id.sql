CREATE OR REPLACE PROCEDURE rpt_Get_Animals_Historical_Eval_By_ID
--======================================================================================
--Author: Trong Le
--Created Date: 2020-10-19
--Description: Get animal historical evaluation (bull only).
--			   For showing data, the list is shown with paging.
--			   For exporting file, the list is exported with header.
--Output: 
--		+Ds1: List of animals for historical evaluation
--		+DS2: The total row of the list 
--======================================================================================
( 
	IN @INT_ID 			CHAR(17), 
	IN @ANIM_KEY		INT, 
	IN @SPECIES_CODE	CHAR(1),
	IN @SEX_CODE		CHAR(1),
	IN @page_number		SMALLINT DEFAULT 1, 
	IN @row_per_page	SMALLINT DEFAULT 50,
	IN @is_export		SMALLINT DEFAULT 0,
	IN @export_type		VARCHAR(5) DEFAULT 'CSV'
)
 
 dynamic result sets  10
BEGIN
	
	-- Declaration variables
	DECLARE v_DEFAULT_DATE		DATE;
	DECLARE TOTAL_ROWS			INTEGER;
	DECLARE EXPORT_FILE_NAME	VARCHAR(300);
	DECLARE EXPORT_PATH			VARCHAR(200);
 
	DECLARE sql_query			VARCHAR(30000);
	  
	-- Declaration temp tables
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT_ANIMALS
	(
		INT_ID			CHAR(17),
		ANIM_KEY		INTEGER,
		SPECIES_CODE	CHAR(1),
		SEX_CODE		CHAR(1)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_RESULT
	(
		EVAL_DATE	VARCHAR(15),
		NM_PTA		VARCHAR(15),
		NM_REL		VARCHAR(15),
		MACE		VARCHAR(5),
		GEN_IND		VARCHAR(10),
		DAUS		VARCHAR(15),
		HERDS		VARCHAR(15),
		US_DAU_PCT	VARCHAR(15),
		PTA_MLK		VARCHAR(15),
		PTA_FAT		VARCHAR(15),
		PTA_PRO		VARCHAR(15),
		PTA_PL		VARCHAR(15),
		PTA_SCS		VARCHAR(15),
		PTA_DPR		VARCHAR(15),
		PTA_HCR		VARCHAR(15),
		PTA_CCR		VARCHAR(15),
		PTA_LIV		VARCHAR(15),
		PTA_GL		VARCHAR(15),
		PTA_MFV		VARCHAR(15),
		PTA_DAB		VARCHAR(15),
		PTA_KET		VARCHAR(15),
		PTA_MAS		VARCHAR(15),
		PTA_MET		VARCHAR(15),
		PTA_RPL		VARCHAR(15),
		PTA_EFC		VARCHAR(15),
		EVAL_DATE_SORT	DATE
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	INSERT INTO SESSION.TMP_INPUT_ANIMALS
	(
		INT_ID,
		ANIM_KEY,
		SPECIES_CODE,
		SEX_CODE
	)
	SELECT	@INT_ID,
			@ANIM_KEY,
			@SPECIES_CODE,
			@SEX_CODE
	FROM SYSIBM.SYSDUMMY1
	WHERE @SPECIES_CODE = '0'
	AND @SEX_CODE = 'M'
	;
	        
	
	SET v_DEFAULT_DATE = (SELECT STRING_VALUE FROM dbo.CONSTANTS WHERE NAME = 'Default_Date_Value' LIMIT 1);
	
	SET @page_number = @page_number - 1;
	

	INSERT INTO SESSION.TMP_RESULT
	(
		EVAL_DATE,
		NM_PTA,
		NM_REL,
		MACE,
		GEN_IND,
		DAUS,
		HERDS,
		US_DAU_PCT,
		PTA_MLK,
		PTA_FAT,
		PTA_PRO,
		PTA_PL,
		PTA_SCS,
		PTA_DPR,
		PTA_HCR,
		PTA_CCR,
		PTA_LIV,
		PTA_GL,
		PTA_MFV,
		PTA_DAB,
		PTA_KET,
		PTA_MAS,
		PTA_MET,
		PTA_RPL,
		PTA_EFC,
		EVAL_DATE_SORT
	)
	SELECT	VARCHAR_FORMAT((DATE(v_DEFAULT_DATE) + betdh.EVAL_PDATE), 'YYYY-MM') AS EVAL_DATE,
			betdh.NM_PTA,
			betdh.NM_REL,
			betdh.MACE AS MACE,
  			betdh.GEN_IND AS Gen_Ind,
  			betdh.DAUS AS DAUS,
  			betdh.HERDS AS HERDS,
  			betdh.US_DAU_PCT AS US_DAU_PCT,
  			betdh.PTA_MLK,
  			betdh.PTA_FAT,
  			betdh.PTA_PRO,
  			betdh.PTA_PL,
  			betdh.PTA_SCS,
  			betdh.PTA_DPR,
  			betdh.PTA_HCR,
  			betdh.PTA_CCR,
  			betdh.PTA_LIV,
  			betdh.PTA_GL,
  			betdh.PTA_MFV,
  			betdh.PTA_DAB,
  			betdh.PTA_KET,
  			betdh.PTA_MAS,
  			betdh.PTA_MET,
  			betdh.PTA_RPL,
  			betdh.PTA_EFC,
  			DATE(v_DEFAULT_DATE) + betdh.EVAL_PDATE
	FROM BULL_EVL_TABLE_DECODE_HISTORY betdh
	INNER JOIN SESSION.TMP_INPUT_ANIMALS tia
		ON betdh.ANIM_KEY = tia.ANIM_KEY
		AND betdh.BULL_ID = tia.INT_ID
	;
		
	SET TOTAL_ROWS = (SELECT COUNT(EVAL_DATE_SORT) FROM SESSION.TMP_RESULT);
	
	
	IF @is_export = 0 THEN		-- For showing data - not for exporting
	
		-- Ds1: List of animals for historical evaluation 
		BEGIN
			
			DECLARE CUR1 CURSOR WITH RETURN FOR
				SELECT	EVAL_DATE,
						NM_PTA,
						NM_REL,
						MACE,
						GEN_IND,
						DAUS,
						HERDS,
						US_DAU_PCT,
						PTA_MLK,
						PTA_FAT,
						PTA_PRO,
						PTA_PL,
						PTA_SCS,
						PTA_DPR,
						PTA_HCR,
						PTA_CCR,
						PTA_LIV,
						PTA_GL,
						PTA_MFV,
						PTA_DAB,
						PTA_KET,
						PTA_MAS,
						PTA_MET,
						PTA_RPL,
						PTA_EFC
				FROM SESSION.TMP_RESULT
				ORDER BY EVAL_DATE_SORT DESC
				LIMIT @row_per_page
				OFFSET @page_number*@row_per_page
				WITH UR;
			OPEN CUR1;
		END;
			
		-- DS2: The total row of the list
		BEGIN
			DECLARE CUR2 CURSOR WITH RETURN FOR
				SELECT TOTAL_ROWS AS TOTAL_ROWS
				FROM SYSIBM.SYSDUMMY1
				WITH UR;
			OPEN CUR2;
		END;
			
  	-- For exporting into file
  	ELSE
	  	SET sql_query = 'SELECT EVAL_DATE,
							NM_PTA,
							NM_REL,
							MACE,
							GEN_IND,
							DAUS,
							HERDS,
							US_DAU_PCT,
							PTA_MLK,
							PTA_FAT,
							PTA_PRO,
							PTA_PL,
							PTA_SCS,
							PTA_DPR,
							PTA_HCR,
							PTA_CCR,
							PTA_LIV,
							PTA_GL,
							PTA_MFV,
							PTA_DAB,
							PTA_KET,
							PTA_MAS,
							PTA_MET,
							PTA_RPL,
							PTA_EFC
					FROM SESSION.TMP_RESULT
					ORDER BY EVAL_DATE_SORT DESC';   
		
		SET EXPORT_PATH = (SELECT STRING_VALUE FROM dbo.CONSTANTS WHERE NAME = 'Export_Folder');
		
		SET EXPORT_FILE_NAME = 'Bull_Historical_Evaluation_' || REPLACE(REPLACE(REPLACE(CAST(current timestamp AS VARCHAR(26)), '.', ''), ':' , ''), '-', '');
		
		SET EXPORT_FILE_NAME = EXPORT_PATH || '/' || EXPORT_FILE_NAME || '.csv';
		
		
  		-- Create the header for exporting file
  		INSERT INTO SESSION.TMP_RESULT
		VALUES
		(
			'Eval Date',
			'NM$ PTA',
			'NM% REL',
			'MACE',
			'Gen Ind',
			'DAUS',
			'HERDS',
			'%US',
			'Mlk',
			'Fat',
			'Pro',
			'PL',
			'SCS',
			'DPR',
			'HCR',
			'CCR',
			'LIV',
			'GL',
			'MFV',
			'DAB',
			'KET',
			'MAS',
			'MET',
			'RPL',
			'EFC',
			'9999-12-31'
		)
		;
	
		CALL SYSPROC.ADMIN_CMD( 'export to '||EXPORT_FILE_NAME||' of DEL modified by NOCHARDEL '||sql_query);
	
		BEGIN
			DECLARE CUR3 CURSOR WITH RETURN FOR
			SELECT EXPORT_FILE_NAME FROM SYSIBM.SYSDUMMY1;
			OPEN CUR3;
		END;
  	END IF;
	  
END 
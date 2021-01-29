CREATE OR REPLACE PROCEDURE usp_Get_Historical_Official_Buck_Evaluation_By_ID
--======================================================================================
--Author: Luat Phan
--Created Date: 2021-01-29
--Description: Get goat historical evaluation (buck only).
--			   For showing data, the list is shown with paging.
--			   For exporting file, the list is exported with header.
--Output: 
--		+Ds1: List of goats for historical evaluation
--		+DS2: The total row of the list 

--======================================================================================
( 
	IN @INT_ID CHAR(17) 
	,IN @ANIM_KEY INT
	,IN @SPECIES_CODE CHAR(1)
	,IN @SEX_CODE CHAR(1)
	,IN @page_number SMALLINT DEFAULT 1
	,IN @row_per_page SMALLINT DEFAULT 50
	,IN @is_export SMALLINT DEFAULT 0
	,IN @export_type VARCHAR(5) DEFAULT 'CSV'
	,IN @IS_DATA_EXCHANGE CHAR(1) --0: common flow, 1: dataexchange
	,IN @REQUEST_KEY BIGINT
	,IN @OPERATION_KEY BIGINT
)
 
dynamic result sets  10
BEGIN
	
	-- Declaration variables
	DECLARE v_DEFAULT_DATE DATE;
	DECLARE TOTAL_ROWS INTEGER;
	DECLARE EXPORT_PATH	VARCHAR(200);
 
	DECLARE sql_query VARCHAR(30000);
	
	DECLARE EXPORT_FILE_NAME VARCHAR(300);
	DECLARE TEMPLATE_NAME VARCHAR(200) ; 
	DECLARE LAST_ROW_ID INT;
	
	DECLARE SQLCODE INTEGER DEFAULT 0; 
    DECLARE retcode_Operation INTEGER DEFAULT 0;
    DECLARE err_message VARCHAR(300);
	  
	--DECLARE TEMPORARY TABLE
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT(
		ROW_KEY INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1),  
		INT_ID CHAR(17),
		ANIM_KEY INT,
		SPECIES_CODE CHAR(1),
		SEX_CODE CHAR(1),
		INPUT varchar(128)
	)WITH REPLACE ON COMMIT PRESERVE ROWS;

	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_RESULT(
		EVAL_DATE VARCHAR(15)
		,PTA_MFP_QTY VARCHAR(15)
		,PTA_MFP_REL_PCT VARCHAR(15)
		,MF_DAU_QTY VARCHAR(15)
		,PRO_DAU_QTY VARCHAR(15)
		,MF_HERDS_QTY VARCHAR(15)
		,PRO_HERDS_QTY VARCHAR(15)
		,PTA_MLK_QTY VARCHAR(15)
		,PTA_FAT_QTY VARCHAR(15)
		,PTA_PRO_QTY VARCHAR(15)
		,EVAL_DATE_SORT	DATE
		,ROW_ID INT GENERATED BY DEFAULT AS IDENTITY (START WITH 1 INCREMENT BY 1)
		,INPUT VARCHAR(128)
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	IF @IS_DATA_EXCHANGE ='0' THEN
		INSERT INTO SESSION.TMP_INPUT
				(INT_ID
				,ANIM_KEY
				,SPECIES_CODE
				,SEX_CODE)		
					
		SELECT	@INT_ID
				,@ANIM_KEY
				,@SPECIES_CODE
				,@SEX_CODE
		FROM SYSIBM.SYSDUMMY1
		WHERE @SPECIES_CODE = '1'
		AND @SEX_CODE = 'M'
		;
		
	ELSEIF @IS_DATA_EXCHANGE ='1' THEN 
		INSERT INTO SESSION.TMP_INPUT
				(INT_ID
			   	,ANIM_KEY
			   	,SPECIES_CODE
			   	,SEX_CODE
			   	,INPUT)	  
			   	
	   SELECT 	id.INT_ID
				,id.ANIM_KEY
				,id.SPECIES_CODE
				,id.SEX_CODE
				,dx.LINE
	   FROM
	   (
	      SELECT ROW_KEY
	          	 ,LINE 
		   FROM DATA_EXCHANGE_INPUT_TABLE  
		   WHERE REQUEST_KEY = @REQUEST_KEY
	   )dx
	   INNER JOIN ID_XREF_TABLE id ON id.INT_ID = dx.LINE
	   							   AND id.SPECIES_CODE ='0' 
	   ORDER BY ROW_KEY;  
   	END IF;      
	
	SET v_DEFAULT_DATE = (SELECT STRING_VALUE FROM dbo.CONSTANTS WHERE NAME = 'Default_Date_Value' LIMIT 1);
	
	SET @page_number = @page_number - 1;
	

	INSERT INTO SESSION.TMP_RESULT
			(EVAL_DATE 
			,PTA_MFP_QTY 
			,PTA_MFP_REL_PCT 
			,MF_DAU_QTY 
			,PRO_DAU_QTY 
			,MF_HERDS_QTY 
			,PRO_HERDS_QTY 
			,PTA_MLK_QTY 
			,PTA_FAT_QTY 
			,PTA_PRO_QTY 
			,EVAL_DATE_SORT
			,INPUT)
		
	SELECT	VARCHAR_FORMAT((DATE(v_DEFAULT_DATE) + bETable.EVAL_PDATE), 'YYYY-MM') AS EVAL_DATE
			,bETable.PTA_MFP_QTY 
			,bETable.PTA_MFP_REL_PCT 
			,bETable.MF_DAU_QTY 
			,bETable.PRO_DAU_QTY 
			,bETable.MF_HERDS_QTY 
			,bETable.PRO_HERDS_QTY 
			,bETable.PTA_MLK_QTY 
			,bETable.PTA_FAT_QTY 
			,bETable.PTA_PRO_QTY
  			,DATE(v_DEFAULT_DATE) + bETable.EVAL_PDATE
			,tInput.INPUT
	FROM BUCK_EVL_TABLE bETable INNER JOIN SESSION.TMP_INPUT tInput ON bETable.ANIM_KEY = tInput.ANIM_KEY
																	AND bETable.INT_ID = tInput.INT_ID
	;
		
	SET TOTAL_ROWS = (SELECT COUNT(EVAL_DATE_SORT) FROM SESSION.TMP_RESULT);
	
	IF @IS_DATA_EXCHANGE ='0' THEN
		IF @is_export = 0 THEN		-- For showing data - not for exporting
	
			-- Ds1: List of animals for historical evaluation 
			BEGIN
				DECLARE cursor1 CURSOR WITH RETURN FOR
				
				SELECT	EVAL_DATE 
						,PTA_MFP_QTY 
						,PTA_MFP_REL_PCT 
						,MF_DAU_QTY 
						,PRO_DAU_QTY 
						,MF_HERDS_QTY 
						,PRO_HERDS_QTY 
						,PTA_MLK_QTY 
						,PTA_FAT_QTY 
						,PTA_PRO_QTY
				FROM SESSION.TMP_RESULT
				ORDER BY EVAL_DATE_SORT DESC
				LIMIT @row_per_page
				OFFSET @page_number*@row_per_page
				WITH UR;
				
				OPEN cursor1;
			END;
			
			-- DS2: The total row of the list
			BEGIN
				DECLARE cursor2 CURSOR WITH RETURN FOR
				
				SELECT TOTAL_ROWS AS TOTAL_ROWS
				FROM SYSIBM.SYSDUMMY1
				WITH UR;
				
				OPEN cursor2;
			END;
			
  	-- For exporting into file
	  	ELSE
		  	SET sql_query = 'SELECT	EVAL_DATE
									,PTA_MFP_QTY 
									,PTA_MFP_REL_PCT 
									,MF_DAU_QTY 
									,PRO_DAU_QTY 
									,MF_HERDS_QTY 
									,PRO_HERDS_QTY 
									,PTA_MLK_QTY 
									,PTA_FAT_QTY 
									,PTA_PRO_QTY
							FROM SESSION.TMP_RESULT
							ORDER BY EVAL_DATE_SORT DESC';   
			
			SET EXPORT_PATH = (SELECT STRING_VALUE FROM dbo.CONSTANTS WHERE NAME = 'Export_Folder');
			
			SET EXPORT_FILE_NAME = 'Buck_Historical_Evaluation_' || REPLACE(REPLACE(REPLACE(CAST(current timestamp AS VARCHAR(26)), '.', ''), ':' , ''), '-', '');
			
			SET EXPORT_FILE_NAME = EXPORT_PATH || '/' || EXPORT_FILE_NAME || '.csv';
			
			
	  		-- Create the header for exporting file
	  		INSERT INTO SESSION.TMP_RESULT
			VALUES	('EVAL_DATE'
					,'PTA_MFP_QTY'
					,'PTA_MFP_REL_PCT' 
					,'MF_DAU_QTY' 
					,'PRO_DAU_QTY' 
					,'MF_HERDS_QTY' 
					,'PRO_HERDS_QTY' 
					,'PTA_MLK_QTY' 
					,'PTA_FAT_QTY' 
					,'PTA_PRO_QTY'
					,'9999-12-31'
					,1
					,'INPUT')
			;
		
			CALL SYSPROC.ADMIN_CMD( 'export to '||EXPORT_FILE_NAME||' of DEL modified by NOCHARDEL '||sql_query);
		
			BEGIN
				DECLARE cursor3 CURSOR WITH RETURN FOR
				
				SELECT EXPORT_FILE_NAME FROM SYSIBM.SYSDUMMY1;
				
				OPEN cursor3;
			END;
	  	END IF;
	  	
  	ELSEIF @IS_DATA_EXCHANGE ='1' THEN
		SET LAST_ROW_ID = (SELECT MAX(ROW_ID) FROM SESSION.TMP_RESULT); 
		SET TEMPLATE_NAME 	='GET_HISTORICAL_OFFICIAL_BUCK_EVALUATION'; 
		BEGIN
	     	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	     	SET retcode_Operation = SQLCODE;
	        
         	CALL usp_common_export_json_by_template('SESSION.TMP_RESULT',TEMPLATE_NAME,LAST_ROW_ID,EXPORT_FILE_NAME);
     
     	END;
   
   	--validate output
		IF EXPORT_FILE_NAME IS NULL THEN 
	 	     SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Export failed'; 
		END IF;
		   
	UPDATE DATA_EXCHANGE_OPERATION_TABLE SET OUTPUT_PATH = EXPORT_FILE_NAME 
	WHERE OPERATION_KEY = @OPERATION_KEY;
		    
	BEGIN
		DECLARE cursor4 CURSOR WITH RETURN FOR
        
		SELECT EXPORT_FILE_NAME from sysibm.sysdummy1;
   
		OPEN cursor4;
	END;
	  
	END IF;
	
	
END 
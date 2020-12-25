CREATE OR REPLACE PROCEDURE usp_Get_Format4_Error_Records_By_Cow_ID
--==========================================================================================
--Author: Linh Pham
--Created Date: 2020-05-12
--Description: Get detail input and error of format 4
-- per one animal
--Output:
--        +Ds1: Table with animal id, sire id, dam id, alias id, birth date, source, proc date,
--              affil, herd, ctrl number, lact type, lact verrification, calving date, dim, dry...
--        +Ds2: Test day detail: dim, supvison code, status code, milking preg, milking weight....
--        +Ds3: Error detail: err code, description, action, conflict id, proc date, herd, source 
--==========================================================================================
(
	IN @INT_ID CHAR(17),
	@CALV_PDATE INT,
	@DIM_QTY INT
)

DYNAMIC RESULT SETS 4
BEGIN

	DECLARE v_ERR_SEG_LENGTH SMALLINT DEFAULT 37;
	DECLARE v_MAX_ERROR_CNT SMALLINT DEFAULT 6;
	DECLARE i SMALLINT DEFAULT 1;
	
	DECLARE v_TD_SEG_LENGTH SMALLINT DEFAULT 23;
	DECLARE v_MAX_TD_CNT SMALLINT DEFAULT 20; 
	DECLARE DEFAULT_DATE DATE;
	
	DECLARE v_empty_date varchar(8) default '00000000';
	--DECLARE TABLE
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT --INPUT VALUE
	(
	    INT_ID char(17),
	    CALV_PDATE INT,
		DIM_QTY INT
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
 
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ERROR4_COMMON
 	(
 		 ANIMAL_ID VARCHAR(17)
	 	,SIRE_ID VARCHAR(17)
	 	,DAM_ID VARCHAR(17)
	 	,ALIAS_ID VARCHAR(17)
	 	,BIRTH_DATE VARCHAR(8)
	 	,SRC VARCHAR(1)
	 	,PROC_DATE VARCHAR(8)
	 	,REC_TYPE VARCHAR(1)
	 	,VER VARCHAR(1)
	 	,MBC VARCHAR(1) 
	 	,ID_CHG VARCHAR(1) 
	 	,PNT_CHG VARCHAR(1)  
	 	,DRPC VARCHAR(2)   
	 	,AFFIL VARCHAR(3)
	 	,HERD VARCHAR(8)
	 	,CTRL int
	 	,LAC_TYPE VARCHAR(1)
	 	,LAC_VER VARCHAR(1)
	 	,CALVING_DATE VARCHAR(10)
	 	,DIM smallint
	 	,DRY VARCHAR(10)
	 	,LACT_NUM VARCHAR(2)
	 	,TERMINATION_CODE VARCHAR(1)
	 	,MILK VARCHAR(5)
	 	,FAT VARCHAR(4)
	 	,PROTEIN VARCHAR(4)
	 	,SCS VARCHAR(4)
	 	,DAYS3X VARCHAR(3) 	
	 	,TOT VARCHAR(2) 	
	 	,BREED_DT VARCHAR(8) 	
	 	,LACT_INIT_CODE VARCHAR(1) 	
	 	,NUM_PROG VARCHAR(1) 	 
	 	,ERR_SEGMENT_QTY SMALLINT	
	 	,ERR_SEGMENT_RECORD VARCHAR(222) 
	 	,TD_SEGMENT_QTY SMALLINT
	 	,TD_SEGMENT_RECORD VARCHAR(460)
	 	,SOURCE_FILE_NAME VARCHAR(15)
 	) WITH REPLACE ON COMMIT PRESERVE ROWS;
 		
 			      
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ERROR4_ERR_SEG_FORMAT   
	(
	   ERR_NUM SMALLINT
	  ,ERR_CODE_START_INDEX SMALLINT
	  ,ERR_CODE_LENGTH SMALLINT
	  ,ID_START_INDEX SMALLINT
	  ,ID_LENGTH SMALLINT
	  ,PROC_DATE_START_INDEX SMALLINT
	  ,PROC_DATE_LENGTH SMALLINT
	  ,HERD_START_INDEX SMALLINT
	  ,HERD_LENGTH SMALLINT
	  ,SOURCE_START_INDEX SMALLINT
	  ,SOURCE_LENGTH SMALLINT  
   )WITH REPLACE ON COMMIT PRESERVE ROWS;	
 							
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ERROR4_TD_SEG_FORMAT
	(
		TD_NUM SMALLINT 
		,DIM_START_INDEX SMALLINT
		,DIM_LENGTH SMALLINT
		,SUPV_CODE_START_INDEX SMALLINT
		,SUPV_CODE_LENGTH SMALLINT
		,STATUS_CODE_START_INDEX SMALLINT
		,STATUS_CODE_LENGTH SMALLINT
		,MILKING_FREG_START_INDEX SMALLINT
		,MILKING_FREG_LENGTH SMALLINT
		,NUM_MILKING_WEIGHT_START_INDEX SMALLINT
		,NUM_MILKING_WEIGHT_LENGTH SMALLINT
		,NUM_MILKING_SAMPLE_START_INDEX SMALLINT
		,NUM_MILKING_SAMPLE_LENGTH SMALLINT
		,MRD_START_INDEX SMALLINT
		,MRD_LENGTH SMALLINT
		,SHIPPED_PCT_START_INDEX SMALLINT
		,SHIPPED_PCT_LENGTH SMALLINT
		,MILK_START_INDEX SMALLINT
		,MILK_LENGTH SMALLINT
		,FAT_PCT_START_INDEX SMALLINT
		,FAT_PCT_LENGTH SMALLINT
		,PRO_PCT_START_INDEX SMALLINT
		,PRO_PCT_LENGTH SMALLINT
		,SCS_START_INDEX SMALLINT
		,SCS_LENGTH SMALLINT
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
      
  SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
	  INSERT INTO SESSION.TMP_INPUT
		(
			INT_ID,
			CALV_PDATE,
			DIM_QTY
		)
		VALUES
		(
			@INT_ID,
			@CALV_PDATE,
			@DIM_QTY
		);
  -- Building format for error seg, used for cutting data from error seg into columns
  WHILE (i<= v_MAX_ERROR_CNT) 
  DO
	   INSERT INTO SESSION.TMP_ERROR4_ERR_SEG_FORMAT
	   (
		   ERR_NUM
		   ,ERR_CODE_START_INDEX
		   ,ERR_CODE_LENGTH
		   ,ID_START_INDEX
		   ,ID_LENGTH
		   ,PROC_DATE_START_INDEX
		   ,PROC_DATE_LENGTH
		   ,HERD_START_INDEX
		   ,HERD_LENGTH
		   ,SOURCE_START_INDEX
		   ,SOURCE_LENGTH 
	   ) 
        VALUES 
        (
	        i
	        ,(i-1)*v_ERR_SEG_LENGTH + 1
	        ,3
	        ,(i-1)*v_ERR_SEG_LENGTH + 4
	        ,17
	        ,(i-1)*v_ERR_SEG_LENGTH + 21
	        ,8
	        ,(i-1)*v_ERR_SEG_LENGTH + 29
	        ,8
	        ,(i-1)*v_ERR_SEG_LENGTH + 37
	        ,1 
        );
		 COMMIT WORK;
		 SET i = i+1;
		 
  END WHILE;
  
  SET i = 1;	
   
  -- Building format for test day seg, used for cutting data from test day seg into columns
  WHILE (i <= v_MAX_TD_CNT)
  DO
  	INSERT INTO SESSION.TMP_ERROR4_TD_SEG_FORMAT
  	(
  		 TD_NUM  
		,DIM_START_INDEX 
		,DIM_LENGTH 
		,SUPV_CODE_START_INDEX 
		,SUPV_CODE_LENGTH 
		,STATUS_CODE_START_INDEX 
		,STATUS_CODE_LENGTH 
		,MILKING_FREG_START_INDEX 
		,MILKING_FREG_LENGTH 
		,NUM_MILKING_WEIGHT_START_INDEX 
		,NUM_MILKING_WEIGHT_LENGTH 
		,NUM_MILKING_SAMPLE_START_INDEX 
		,NUM_MILKING_SAMPLE_LENGTH 
		,MRD_START_INDEX 
		,MRD_LENGTH 
		,SHIPPED_PCT_START_INDEX 
		,SHIPPED_PCT_LENGTH 
		,MILK_START_INDEX 
		,MILK_LENGTH 
		,FAT_PCT_START_INDEX 
		,FAT_PCT_LENGTH 
		,PRO_PCT_START_INDEX 
		,PRO_PCT_LENGTH 
		,SCS_START_INDEX 
		,SCS_LENGTH 
  	)
  	VALUES
  	(
  		i
  		,(i-1)*v_TD_SEG_LENGTH + 1
  		,3
  		,(i-1)*v_TD_SEG_LENGTH + 4
  		,1
  		,(i-1)*v_TD_SEG_LENGTH + 5
  		,1
  		,(i-1)*v_TD_SEG_LENGTH + 6
  		,1
  		,(i-1)*v_TD_SEG_LENGTH + 7
  		,1
  		,(i-1)*v_TD_SEG_LENGTH + 8
  		,1
  		,(i-1)*v_TD_SEG_LENGTH + 9
  		,2
  		,(i-1)*v_TD_SEG_LENGTH + 11
  		,3
  		,(i-1)*v_TD_SEG_LENGTH + 14
  		,4
  		,(i-1)*v_TD_SEG_LENGTH + 18
  		,2
  		,(i-1)*v_TD_SEG_LENGTH + 20
  		,2
  		,(i-1)*v_TD_SEG_LENGTH + 22
  		,2 
  	);
  	COMMIT WORK;
    SET i = i+1;
    
  END WHILE;
  
 	INSERT INTO SESSION.TMP_ERROR4_COMMON
 	(
        ANIMAL_ID 
	 	,SIRE_ID 
	 	,DAM_ID
	 	,ALIAS_ID
	 	,BIRTH_DATE
	 	,SRC
	 	,PROC_DATE
	 	,REC_TYPE
	 	,VER
	 	,MBC
	 	,ID_CHG
	 	,PNT_CHG
	 	,DRPC 
	 	,AFFIL
	 	,HERD
	 	,CTRL
	 	,LAC_TYPE
	 	,LAC_VER
	 	,CALVING_DATE
	 	,DIM
	 	,DRY
	 	,LACT_NUM
	 	,TERMINATION_CODE
	 	,MILK
	 	,FAT
	 	,PROTEIN
	 	,SCS
	 	,DAYS3X
	 	,TOT
	 	,BREED_DT
	 	,LACT_INIT_CODE
	 	,NUM_PROG	 
	 	,ERR_SEGMENT_QTY
	 	,ERR_SEGMENT_RECORD
	 	,TD_SEGMENT_QTY
	 	,TD_SEGMENT_RECORD
	 	,SOURCE_FILE_NAME
 	)
 	SELECT
 	  SUBSTRING(e4Table.BASE_RECORD,3,17) AS ANIMAL_ID 
	 	,SUBSTRING(e4Table.BASE_RECORD,20,17) AS SIRE_ID 
	 	,SUBSTRING(e4Table.BASE_RECORD,37,17) AS DAM_ID
	 	,SUBSTRING(e4Table.BASE_RECORD,54,17) AS ALIAS_ID
	 	,trim(NULLIF(SUBSTRING(e4Table.BASE_RECORD,71,8),v_empty_date)) AS BIRTH_DATE
	 	,SUBSTRING(e4Table.BASE_RECORD,79,1) AS SRC
	 	,trim(NULLIF(SUBSTRING(e4Table.BASE_RECORD,80,8),v_empty_date)) AS PROC_DATE
	 	,SUBSTRING(e4Table.BASE_RECORD,88,1) AS REC_TYPE
	 	,SUBSTRING(e4Table.BASE_RECORD,89,1) AS VER 
	 	,SUBSTRING(e4Table.BASE_RECORD,91,1) AS MBC
	 	,SUBSTRING(e4Table.BASE_RECORD,100,1) AS ID_CHG
	 	,SUBSTRING(e4Table.BASE_RECORD,101,1) AS PNT_CHG
	 	,SUBSTRING(e4Table.BASE_RECORD,102,2) AS DRPC 
	 	,SUBSTRING(e4Table.BASE_RECORD,104,3) AS AFFIL
	 	,CAST(e4Table.HERD_CODE AS VARCHAR(10)) AS HERD_CODE
	 	,e4Table.CTRL_NUM AS CTRL_NUM 
	 	,SUBSTRING(e4Table.BASE_RECORD,126,1) AS LAC_TYPE
	 	,SUBSTRING(e4Table.BASE_RECORD,127,1) AS LAC_VER
		,VARCHAR_FORMAT(DEFAULT_DATE + e4Table.CALV_PDATE,'YYYY-MM-DD') AS CALVING_DATE 
	 	,e4Table.DIM_QTY AS DIM
	 	,NULLIF(trim(SUBSTRING(e4Table.BASE_RECORD,139,3)),'') AS DRY
	 	,NULLIF(trim(SUBSTRING(e4Table.BASE_RECORD,159,2)),'') AS LACT_NUM -- should be LACT_NUM
	 	,SUBSTRING(e4Table.BASE_RECORD,161,1) AS TERMINATION_CODE
	 	,NULLIF(trim(SUBSTRING(e4Table.BASE_RECORD,147,4)),'') AS MILK
	 	,NULLIF(trim(SUBSTRING(e4Table.BASE_RECORD,151,4)),'') AS FAT
	 	,NULLIF(trim(SUBSTRING(e4Table.BASE_RECORD,155,4)),'') AS PROTEIN
	 	,NULLIF(trim(SUBSTRING(e4Table.BASE_RECORD,179,3)),'') AS SCS
	 	,NULLIF(trim(SUBSTRING(e4Table.BASE_RECORD,144,3)),'') AS DAYS3X
	 	,NULLIF(trim(SUBSTRING(e4Table.BASE_RECORD,176,2)),'') AS TOT
	 	,trim(NULLIF(SUBSTRING(e4Table.BASE_RECORD,162,8),v_empty_date)) AS BREED_DT
	 	,SUBSTRING(e4Table.BASE_RECORD,174,1) AS LACT_INIT_CODE
	 	,NULLIF(SUBSTRING(e4Table.BASE_RECORD,243,1),'') AS NUM_PROG	 
	 	,ASCII(e4Table.ERR_SEGMENT_QTY) AS ERR_SEGMENT_QTY
	 	,e4Table.ERR_SEGMENT_RECORD
	 	,ASCII(e4Table.TD_SEGMENT_QTY) AS TD_SEGMENT_QTY
	 	,e4Table.TD_SEGMENT_RECORD 
	 	,e4Table.SOURCE_FILE_NAME
	FROM ERROR4_TABLE e4Table
	INNER JOIN SESSION.TMP_INPUT inp
		ON e4Table.BREED_CODE||e4Table.COUNTRY_CODE||e4Table.ANIM_ID_NUM  = inp.INT_ID
			AND e4Table.CALV_PDATE =inp.CALV_PDATE 
			AND e4Table.DIM_QTY =inp.DIM_QTY  
    WITH UR
	 ;
	 
	-- DS: animal pedigree and lactation common info
	BEGIN
		 	DECLARE cursor0 CURSOR WITH RETURN for
		 		
		 	SELECT  ANIMAL_ID 
			 	,SIRE_ID 
			 	,DAM_ID
			 	,ALIAS_ID
			 	,case when length(BIRTH_DATE)=8 then substring(BIRTH_DATE,1,4)||'-'||substring(BIRTH_DATE,5,2)||'-'||substring(BIRTH_DATE,7,2) else BIRTH_DATE end as BIRTH_DATE
			 	,SRC
			 	,case when length(PROC_DATE)=8 then substring(PROC_DATE,1,4)||'-'||substring(PROC_DATE,5,2)||'-'||substring(PROC_DATE,7,2) else PROC_DATE end as PROC_DATE
			 	,REC_TYPE
			 	,VER
			 	,MBC
			 	,ID_CHG
			 	,PNT_CHG
			 	,DRPC 
			 	,AFFIL
			 	,HERD
			 	,CTRL
			 	,LAC_TYPE
			 	,LAC_VER
			 	,CALVING_DATE 
			 	,DIM
			 	,FLOAT2CHAR_STR_INPUT(DRY,1,1) AS DRY  
			 	,LACT_NUM AS LACT_NUM 
			 	,TERMINATION_CODE   
			 	,TRIM(LEFT(SOURCE_FILE_NAME,8)) ||'.4'||TRIM(RIGHT(SOURCE_FILE_NAME,1))  as SOURCE_FILE_NAME  
		 	FROM SESSION.TMP_ERROR4_COMMON with UR;
		 	
		 	OPEN cursor0;
		 	 
	END;
	
	-- DS: Test days segment
	BEGIN
		 	DECLARE cursor2 CURSOR WITH RETURN for
		 
		 SELECT 
	      TD_NUM
	     ,FLOAT2CHAR_STR_INPUT(DIM,1,1) AS DIM
		 ,SUPV_CODE
		 ,STATUS_CODE
		 ,MILKING_FREG
		 ,NUM_MILKING_WEIGHT
		 ,NUM_MILKING_SAMPLE  
		 ,FLOAT2CHAR_STR_INPUT(MRD,1,1) AS MRD
		 ,FLOAT2CHAR_STR_INPUT(SHIPPED_PCT,1,1) AS SHIPPED_PCT
		 ,FLOAT2CHAR_STR_INPUT(MILK,0.1,0.1) AS MILK
		 ,FLOAT2CHAR_STR_INPUT(FAT_PCT,0.1,0.1) AS FAT_PCT
		 ,FLOAT2CHAR_STR_INPUT(PRO_PCT,0.1,0.1) AS PRO_PCT
		 ,FLOAT2CHAR_STR_INPUT(SCS,0.1,0.1) AS SCS
		 
		 FROM		
		 (
		 	SELECT
		 	      f.TD_NUM 
		 		 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.DIM_START_INDEX,f.DIM_LENGTH)),'') AS DIM
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.SUPV_CODE_START_INDEX,f.SUPV_CODE_LENGTH)),'') AS SUPV_CODE
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.STATUS_CODE_START_INDEX,f.STATUS_CODE_LENGTH)),'') AS STATUS_CODE 
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.MILKING_FREG_START_INDEX,f.MILKING_FREG_LENGTH)),'') AS MILKING_FREG
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.NUM_MILKING_WEIGHT_START_INDEX,f.NUM_MILKING_WEIGHT_LENGTH)),'') AS NUM_MILKING_WEIGHT
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.NUM_MILKING_SAMPLE_START_INDEX,f.NUM_MILKING_SAMPLE_LENGTH)),'') AS NUM_MILKING_SAMPLE
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.MRD_START_INDEX,f.MRD_LENGTH)),'') AS MRD
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.SHIPPED_PCT_START_INDEX,f.SHIPPED_PCT_LENGTH)),'') AS SHIPPED_PCT
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.MILK_START_INDEX,f.MILK_LENGTH)),'') AS MILK
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.FAT_PCT_START_INDEX,f.FAT_PCT_LENGTH)),'') AS FAT_PCT
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.PRO_PCT_START_INDEX,f.PRO_PCT_LENGTH)),'') AS PRO_PCT
				 ,NULLIF(TRIM(SUBSTRING(td.TD_SEGMENT_RECORD,f.SCS_START_INDEX,f.SCS_LENGTH)),'') AS SCS
  
			FROM SESSION.TMP_ERROR4_COMMON td
			CROSS JOIN SESSION.TMP_ERROR4_TD_SEG_FORMAT f
			WHERE f.TD_NUM <= td.TD_SEGMENT_QTY
			WITH UR
			)t 
			WHERE DIM IS NOT NULL with UR;
			
			 
		 	
       OPEN cursor2;
		 	 
		 	 
	END;
	-- DS: Error segment
	BEGIN
		 	DECLARE cursor1 CURSOR WITH RETURN for
		 	
		 	SELECT  
		 	 err.ERR_CODE
				 	,refDesc.DESCRIPTION as ACTION_CODE
				 	,ref.LONG_DESC AS DESCRIPTION
				 	,err.ID
				 	,case when length(err.PROC_DATE)=8 then substring(err.PROC_DATE,1,4)||'-'||substring(err.PROC_DATE,5,2)||'-'||substring(err.PROC_DATE,7,2) else err.PROC_DATE end as PROC_DATE
				 	,err.HERD
				 	,err.SOURCE 
		 	FROM	
		 	(SELECT 
		 	 	 SUBSTRING(err.ERR_SEGMENT_RECORD,f.ERR_CODE_START_INDEX,f.ERR_CODE_LENGTH) AS ERR_CODE
			    ,SUBSTRING(err.ERR_SEGMENT_RECORD,f.ID_START_INDEX,f.ID_LENGTH) AS ID
			    ,trim(NULLIF(SUBSTRING(err.ERR_SEGMENT_RECORD,f.PROC_DATE_START_INDEX,f.PROC_DATE_LENGTH),v_empty_date)) AS PROC_DATE
			    ,SUBSTRING(err.ERR_SEGMENT_RECORD,f.HERD_START_INDEX,f.HERD_LENGTH) AS HERD
			    ,SUBSTRING(err.ERR_SEGMENT_RECORD,f.SOURCE_START_INDEX,f.SOURCE_LENGTH) AS SOURCE
		        ,f.ERR_NUM
			FROM SESSION.TMP_ERROR4_COMMON err
			CROSS JOIN SESSION.TMP_ERROR4_ERR_SEG_FORMAT f
			WHERE f.ERR_NUM <= err.ERR_SEGMENT_QTY
			WITH UR
			)err
			LEFT JOIN ERROR_REF_TABLE ref 
				ON err.ERR_CODE = ref.NUMERIC_PART1_NUM||ref.UPPERCASE_PART2_CODE||ref.LOWERCASE_PART3_CODE
			LEFT JOIN
			(
			   SELECT CODE, DESCRIPTION
			   FROM REFERENCE_TABLE
			   WHERE TYPE = 'ERROR_ACTION_CODE'
			)refDesc
				ON refDesc.CODE = ref.ACTION_CODE
			
				WHERE err.ERR_CODE IS NOT NULL
				ORDER BY err.ERR_NUM
				with UR;
		 	OPEN cursor1;
		 	 
	END; 
	-- DS: Lactation Detail
	BEGIN
		 	DECLARE cursor5 CURSOR WITH RETURN for
		 		
		 	SELECT   
			 	 FLOAT2CHAR_STR_INPUT(MILK,10,1) AS MILK 
			 	,FLOAT2CHAR_STR_INPUT(FAT,1,1) AS FAT 
			 	,FLOAT2CHAR_STR_INPUT(PROTEIN,1,1) AS PROTEIN 
			 	,FLOAT2CHAR_STR_INPUT(SCS,0.01,0.01) AS SCS 
			 	,FLOAT2CHAR_STR_INPUT(DAYS3X,1,1) AS DAYS3X 
			 	,FLOAT2CHAR_STR_INPUT(TOT,1,1) AS TOT  
			    ,case when length(BREED_DT)=8 then substring(BREED_DT,1,4)||'-'||substring(BREED_DT,5,2)||'-'||substring(BREED_DT,7,2) else BREED_DT end as BREED_DT 
			 	,LACT_INIT_CODE
			 	,NUM_PROG	  
			 	
		 	FROM SESSION.TMP_ERROR4_COMMON 
		 	WHERE MILK IS NOT NULL
			 	OR FAT IS NOT NULL
			 	OR PROTEIN IS NOT NULL
			 	OR SCS IS NOT NULL
			 	OR DAYS3X IS NOT NULL
			 	OR TOT IS NOT NULL
			 	OR BREED_DT <> ''
		 	with UR;
		 	
		 	OPEN cursor5;
		 	 
	END;
	 
END
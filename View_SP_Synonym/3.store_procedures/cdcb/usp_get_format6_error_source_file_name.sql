CREATE OR REPLACE PROCEDURE usp_Get_Format6_Error_Records_By_Cow_ID
--======================================================
--Author: Linh Pham
--Created Date: 2020-24-12
--Description: Get detail input and error of format 6
-- per one animal
--Output:
--        +Ds1: Table with animal id, sire id, dam id, alias id, birth date, source, proc date,
--              affil, herd, ctrl number, lact type, lact verrification, calving date, dim, dry...
--        +Ds2: PHEuction detail: type, date, event code, seq, naab code, id
--        +Ds3: Error detail: err code, description, action, conflict id, proc date, herd, source 
--======================================================
(
	IN @INT_ID CHAR(17)
	,@SPECIES_CODE char(1)
    ,@CALV_PDATE smallint
	,@HERD_CODE integer
	,@PROC_PDATE smallint
)

DYNAMIC RESULT SETS 4
BEGIN


	DECLARE DEFAULT_DATE DATE;
 
	
	DECLARE v_ERR_SEG_LENGTH SMALLINT DEFAULT 37;
	DECLARE v_MAX_ERROR_CNT SMALLINT DEFAULT 6;
	DECLARE i SMALLINT DEFAULT 1;
	
	DECLARE v_HE_SEG_LENGTH SMALLINT DEFAULT 19;
	DECLARE v_MAX_HE_CNT SMALLINT DEFAULT 20;
    DECLARE v_empty_date varchar(8) default '00000000';
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT --INPUT VALUE
	(
	    INT_ID char(17),
		SPECIES_CODE char(1),
    	CALV_PDATE smallint,
		HERD_CODE integer,
		PROC_PDATE smallint
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
 
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ERROR6_COMMON
 	(
 		 ANIMAL_ID VARCHAR(17)
	 	,SIRE_ID VARCHAR(17)
	 	,DAM_ID VARCHAR(17)
	 	,ALIAS_ID VARCHAR(17)
	 	,BIRTH_DATE VARCHAR(8)
	 	,SRC VARCHAR(1)
	 	,PROC_DATE VARCHAR(10)
	 	,REC_TYPE VARCHAR(1)
	 	,VER VARCHAR(1)
	 	,MBC VARCHAR(1) 
	 	,ID_CHG VARCHAR(1)
	 	,PNT_CHG VARCHAR(1) 
	 	,DRPC VARCHAR(2)  
	 	,AFFIL VARCHAR(3)
	 	,HERD int
	 	,CTRL int
	 	,LAC_TYPE VARCHAR(1)
	 	,LAC_VER VARCHAR(1)
	 	,CALVING_DATE VARCHAR(10) 	
	 	,ERR_SEGMENT_QTY INT	
	 	,ERR_SEGMENT_RECORD VARCHAR(222) 
	 	,HE_EVT_CNT INT
	 	,HE_EVT_SEG VARCHAR(600)
	 	,SOURCE_FILE_NAME VARCHAR(15)
 	) WITH REPLACE ON COMMIT PRESERVE ROWS;
 		
 			      
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ERROR6_ERR_SEG_FORMAT   
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
 							
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ERROR6_HE_SEG_FORMAT
	(
		HE_NUM SMALLINT 
		,HE_CODE_START_INDEX SMALLINT
		,HE_CODE_LENGTH SMALLINT
		,HE_DATE_START_INDEX SMALLINT
		,HE_DATE_LENGTH SMALLINT
		,HE_DETAIL_START_INDEX SMALLINT
		,HE_DETAIL_LENGTH SMALLINT 
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
      
   SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
   INSERT INTO SESSION.TMP_INPUT
	(
		INT_ID,
		SPECIES_CODE,
    	CALV_PDATE,
		HERD_CODE,
		PROC_PDATE
	)
	VALUES
	(
		@INT_ID,
		@SPECIES_CODE,
    	@CALV_PDATE,
		@HERD_CODE ,
		@PROC_PDATE
	);
   
   -- Building format for test day seg, used for cutting data from test day seg into columns
  WHILE (i<= v_MAX_ERROR_CNT) 
  DO
	   INSERT INTO SESSION.TMP_ERROR6_ERR_SEG_FORMAT
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
		
  -- Building format for pHEuctive seg, used for cutting data from Health event seg into columns
  SET i = 1;
  WHILE (i <= v_MAX_HE_CNT)
  DO
  	INSERT INTO SESSION.TMP_ERROR6_HE_SEG_FORMAT
  	(
  		HE_NUM 
		,HE_CODE_START_INDEX 
		,HE_CODE_LENGTH 
		,HE_DATE_START_INDEX 
		,HE_DATE_LENGTH 
		,HE_DETAIL_START_INDEX 
		,HE_DETAIL_LENGTH 
  	)
  	VALUES
  	(
  		i
  		,(i-1)*v_HE_SEG_LENGTH + 1
  		,4
  		,(i-1)*v_HE_SEG_LENGTH + 5
  		,8
  		,(i-1)*v_HE_SEG_LENGTH + 14
  		,6 
  	);
  	COMMIT WORK;
    SET i = i+1;
    
  END WHILE;
  
 	INSERT INTO SESSION.TMP_ERROR6_COMMON
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
	 	,ERR_SEGMENT_QTY 	
	 	,ERR_SEGMENT_RECORD
	 	,HE_EVT_CNT
	 	,HE_EVT_SEG
	 	,SOURCE_FILE_NAME
 	)
 	SELECT
	SUBSTRING(e6Table.BASE_RECORD,1,17) AS ANIMAL_ID
		,SUBSTRING(e6Table.BASE_RECORD,18,17) AS SIRE_ID
		,SUBSTRING(e6Table.BASE_RECORD,35,17) AS DAM_ID
		,SUBSTRING(e6Table.BASE_RECORD,52,17) AS ALIAS_ID
		,trim(nullif(SUBSTRING(e6Table.BASE_RECORD,69,8),v_empty_date)) AS BIRTH_DATE
		,SUBSTRING(e6Table.BASE_RECORD,77,1) AS SRC
		,VARCHAR_FORMAT(DEFAULT_DATE + e6Table.PROC_PDATE,'YYYY-MM-DD') AS PROC_DATE 
		,SUBSTRING(e6Table.BASE_RECORD,86,1) AS REC_TYPE
		,SUBSTRING(e6Table.BASE_RECORD,87,1) AS VER
		,SUBSTRING(e6Table.BASE_RECORD,89,1) AS MBC
		,SUBSTRING(e6Table.BASE_RECORD,98,1) AS ID_CHG
		,SUBSTRING(e6Table.BASE_RECORD,99,1) AS PNT_CHG
		,SUBSTRING(e6Table.BASE_RECORD,100,2) AS DRPC 
		,SUBSTRING(e6Table.BASE_RECORD,102,3) AS AFFIL
		,e6Table.HERD_CODE AS HERD
		,e6Table.CTRL_NUM AS CTRL
		,SUBSTRING(e6Table.BASE_RECORD,124,1) AS LAC_TYPE
		,SUBSTRING(e6Table.BASE_RECORD,125,1) AS LAC_VER
		,VARCHAR_FORMAT(DEFAULT_DATE + e6Table.CALV_PDATE,'YYYY-MM-DD') AS CALVING_DATE
		,ASCII(e6Table.ERR_SEGMENT_QTY) AS ERR_SEGMENT_QTY
		,e6Table.ERR_SEGMENT_RECORD
		,ASCII(e6Table.HEALTH_EVT_CNT) AS HE_EVT_CNT
		,e6Table.HEALTH_EVT_SEG AS HE_EVT_SEG
		,e6Table.SOURCE_FILE_NAME
	FROM ERROR6_TABLE e6Table
	INNER JOIN SESSION.TMP_INPUT inp
		ON e6Table.BREED_CODE||e6Table.COUNTRY_CODE||e6Table.ANIM_ID_NUM  =  inp.INT_ID
		AND e6Table.SPECIES_CODE= inp.SPECIES_CODE
		AND e6Table.CALV_PDATE = inp.CALV_PDATE
		AND e6Table.HERD_CODE = inp.HERD_CODE
		AND e6Table.PROC_PDATE =inp.PROC_PDATE 
		with UR; 
 	
	-- DS: Animal pedigree and lactation detail
	BEGIN
		 	DECLARE cursor0 CURSOR WITH RETURN for
		 		
		 	SELECT 
		 		 ANIMAL_ID
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
		 		,case when length(CALVING_DATE)=8 then substring(CALVING_DATE,1,4)||'-'||substring(CALVING_DATE,5,2)||'-'||substring(CALVING_DATE,7,2) else CALVING_DATE end as CALVING_DATE
		 		,TRIM(LEFT(SOURCE_FILE_NAME,8)) ||'.6'||TRIM(RIGHT(SOURCE_FILE_NAME,1))  as SOURCE_FILE_NAME
		 	FROM SESSION.TMP_ERROR6_COMMON with UR;
		 	
		 	OPEN cursor0;
		 	 
	END; 
	 
	 -- DS: Health event segment detail
 
		
	BEGIN
		 	DECLARE cursor2 CURSOR WITH RETURN for
		 		
		 	SELECT
		 	HE_NUM
		 	,HE_CODE 
		 	,case when length(HE_DATE)=8 then substring(HE_DATE,1,4)||'-'||substring(HE_DATE,5,2)||'-'||substring(HE_DATE,7,2) else HE_DATE end as HE_DATE  
		 	,SEQ
		  
		 	FROM
		 	(
		 	SELECT 
		 		 f.HE_NUM
		 		 ,SUBSTRING(err.HE_EVT_SEG,f.HE_CODE_START_INDEX,f.HE_CODE_START_INDEX) AS HE_CODE 
			    ,TRIM(nullif(SUBSTRING(err.HE_EVT_SEG,f.HE_DATE_START_INDEX,f.HE_DATE_LENGTH),v_empty_date)) AS HE_DATE
			    ,SUBSTRING(err.HE_EVT_SEG,f.HE_DETAIL_START_INDEX,f.HE_DETAIL_LENGTH) AS SEQ 
		   
			FROM SESSION.TMP_ERROR6_COMMON err
			CROSS JOIN SESSION.TMP_ERROR6_HE_SEG_FORMAT f
				WHERE f.HE_NUM <= err.HE_EVT_CNT
			)t
			with UR;
 
		 	OPEN cursor2;
		 	 
	END;
	
	 --DS: Error segment detail
	BEGIN
		 	DECLARE cursor1 CURSOR WITH RETURN for
		 	
		 	SELECT err.ERR_CODE
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
			    ,trim(nullif(SUBSTRING(err.ERR_SEGMENT_RECORD,f.PROC_DATE_START_INDEX,f.PROC_DATE_LENGTH),v_empty_date)) AS PROC_DATE
			    ,SUBSTRING(err.ERR_SEGMENT_RECORD,f.HERD_START_INDEX,f.HERD_LENGTH) AS HERD
			    ,SUBSTRING(err.ERR_SEGMENT_RECORD,f.SOURCE_START_INDEX,f.SOURCE_LENGTH) AS SOURCE
		        ,f.ERR_NUM
			FROM SESSION.TMP_ERROR6_COMMON err
			CROSS JOIN SESSION.TMP_ERROR6_ERR_SEG_FORMAT f
				WHERE f.ERR_NUM <= err.ERR_SEGMENT_QTY 
			with UR
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
			ORDER BY err.ERR_NUM
			with UR;
		 	
		 	OPEN cursor1;
		 	 
	END; 
	 
	
END
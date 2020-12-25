CREATE OR REPLACE PROCEDURE usp_Get_Format1_Error_Records_By_Cow_ID
--============================================================================================
--Author: Linh Pham
--Created Date: 2020-12-24
--Description: Get detail input and error of format 1 
-- per one animal
--Output: 
--        +Ds1: Table with animal id, sire id, dam id, alias id, birth date, source, proc date....
--        +Ds2: Error detail: err code, description, action, conflict id, proc date, herd, source 
--============================================================================================
( 
    IN @INT_ID char(17) 
)
DYNAMIC RESULT SETS 5
    
BEGIN
 
	DECLARE v_ERR_SEGMENT_QTY int;
	DECLARE v_ERR_SEGMENT_RECORD varchar(300);
	DECLARE v_ERR_SEG_LENGTH smallint default 37;
	DECLARE v_MAX_ERROR_CNT smallint default 6;
	DECLARE i smallint default 1;
	DECLARE v_empty_date varchar(8) default '00000000';

--DECLARE TABLE
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT --INPUT VALUE
	(
	    INT_ID char(17)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;

	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ERROR1_COMMON
		   (
	        INT_ID CHAR(17) 
	        ,SIRE_ID CHAR(17)
	        ,DAM_ID CHAR(17)
			,ALIAS_ID CHAR(17)
			,BIRTH_DATE VARCHAR(8)
			,SOURCE CHAR(1)
			,PROC_DATE VARCHAR(8)
			,REC_TYPE CHAR(1)
			,VERR CHAR(1)
			,MBC CHAR(1)
			,REGIS_STATUS CHAR(2)    
			,ERR_SEGMENT_QTY INT
			,ERR_SEGMENT_RECORD varchar(300)  
			,SOURCE_FILE_NAME varchar(15)
	      )
	      with replace on commit preserve rows;
	      
	       
	      
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ERROR1_ERR_SEG_FORMAT   
	(
		ERR_NUM smallint, 
		ERR_CODE_START_INDEX smallint,
		ERR_CODE_LENGTH smallint,
		ID_START_INDEX smallint,
		ID_LENGTH smallint,
		PROC_DATE_START_INDEX smallint,
		PROC_DATE_LENGTH smallint,
		HERD_START_INDEX smallint,
		HERD_LENGTH smallint,
		SOURCE_START_INDEX smallint,
		SOURCE_LENGTH smallint  
	) with replace on commit preserve rows;
	      
	      --INSERT TO TEMP TABLE
	INSERT INTO SESSION.TMP_INPUT
	(
		INT_ID
	)
	VALUES
	(
		@INT_ID
	);
	      
	  -- Building format for error seg, used for cutting data from error seg into columns     
	  WHILE (i<= v_MAX_ERROR_CNT) DO
		   INSERT INTO SESSION.TMP_ERROR1_ERR_SEG_FORMAT(
		   ERR_NUM,
		   ERR_CODE_START_INDEX,
		   ERR_CODE_LENGTH,
		   ID_START_INDEX,
		   ID_LENGTH,
		   PROC_DATE_START_INDEX,
		   PROC_DATE_LENGTH,
		   HERD_START_INDEX,
		   HERD_LENGTH,
		   SOURCE_START_INDEX,
		   SOURCE_LENGTH 
		   
		   ) 
	        VALUES (i,
	        (i-1)*v_ERR_SEG_LENGTH + 1,
	        3,
	        (i-1)*v_ERR_SEG_LENGTH + 4,
	        17,
	        (i-1)*v_ERR_SEG_LENGTH + 21,
	        8,
	        (i-1)*v_ERR_SEG_LENGTH + 29,
	        8,
	        (i-1)*v_ERR_SEG_LENGTH + 37,
	        1 
	        )
	        ;
	   
			 commit work;
			 
			 SET i =i+1;
	  END WHILE;
	  
	
	   
	 
	 INSERT INTO SESSION.TMP_ERROR1_COMMON
	 (
	  		INT_ID  
	        ,SIRE_ID 
	        ,DAM_ID 
			,ALIAS_ID
			,BIRTH_DATE
			,SOURCE
			,PROC_DATE
			,REC_TYPE
			,VERR
			,MBC
			,REGIS_STATUS 
			,ERR_SEGMENT_QTY
			,ERR_SEGMENT_RECORD
			,SOURCE_FILE_NAME
	 )
	  SELECT 
			 BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM AS INT_ID
			,SUBSTRING(BASE_RECORD,20,17)AS SIRE_ID
			,SUBSTRING(BASE_RECORD,37,17)AS DAM_ID
			,SUBSTRING(BASE_RECORD,54,17)AS ALIAS_ID
			,trim(nullif(SUBSTRING(BASE_RECORD,71,8),v_empty_date)) AS BIRTH_DATE
			,SUBSTRING(BASE_RECORD,79,1)AS SOURCE
			,trim(nullif(SUBSTRING(BASE_RECORD,80,8),v_empty_date))AS PROC_DATE
			,SUBSTRING(BASE_RECORD,88,1)AS REC_TYPE
			,SUBSTRING(BASE_RECORD,89,1)AS VERR
			,SUBSTRING(BASE_RECORD,91,1)AS MBC
			,SUBSTRING(BASE_RECORD,92,2)AS REGIS_STATUS 
			,ASCII(ERR_SEGMENT_QTY) AS ERR_SEGMENT_QTY
			,ERR_SEGMENT_RECORD
			,SOURCE_FILE_NAME
	FROM ERROR1_TABLE
	INNER JOIN SESSION.TMP_INPUT inp
		ON BREED_CODE||COUNTRY_CODE||ANIM_ID_NUM  =  inp.INT_ID with UR;
		 
	  
	    -- DS: animal pedigree
	  BEGIN
		DECLARE cursor1 CURSOR WITH RETURN FOR 	
		    SELECT  
		         INT_ID  AS ANIMAL_ID 
		        ,SIRE_ID 
		        ,DAM_ID 
				,ALIAS_ID 
				,case when length(BIRTH_DATE)=8 then substring(BIRTH_DATE,1,4)||'-'||substring(BIRTH_DATE,5,2)||'-'||substring(BIRTH_DATE,7,2) else BIRTH_DATE end as BIRTH_DATE
				,SOURCE
				,case when length(PROC_DATE)=8 then substring(PROC_DATE,1,4)||'-'||substring(PROC_DATE,5,2)||'-'||substring(PROC_DATE,7,2) else PROC_DATE end as PROC_DATE
				,REC_TYPE
				,VERR
				,MBC
				,REGIS_STATUS 
				,TRIM(LEFT(SOURCE_FILE_NAME,8)) ||'.1'||TRIM(RIGHT(SOURCE_FILE_NAME,1))  as SOURCE_FILE_NAME
		    FROM  SESSION.TMP_ERROR1_COMMON with UR;
			    
		 OPEN cursor1;
	   END;
		   
	   -- DS: Error seg detail
	   BEGIN
			 	DECLARE cursor1 CURSOR WITH RETURN for
			 	
			 	SELECT 
			 		err.ERR_CODE
					 ,ref.ACTION_CODE
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
				FROM SESSION.TMP_ERROR1_COMMON err
				CROSS JOIN SESSION.TMP_ERROR1_ERR_SEG_FORMAT f
				 	WHERE f.ERR_NUM <= err.ERR_SEGMENT_QTY with UR
				)err
				LEFT JOIN ERROR_REF_TABLE ref 
					ON err.ERR_CODE = ref.NUMERIC_PART1_NUM||ref.UPPERCASE_PART2_CODE||ref.LOWERCASE_PART3_CODE
					ORDER BY err.ERR_NUM with UR
					;
			 	
			 	OPEN cursor1;
			 	 
		END; 
	    
		   
	END
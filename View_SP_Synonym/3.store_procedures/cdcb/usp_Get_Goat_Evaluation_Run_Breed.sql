CREATE OR REPLACE PROCEDURE usp_Get_Goat_Evaluation_Run_Breed
--========================================================================================================
--Author: Luat Phan
--Created Date: 2021-01-28
--Description: Get evaluation data and type summary for goat
--Output: 
--        +Ds1: Run Name, Eval Breed Code, Breed Name
--============================================================================================================
( 
	IN @INT_ID CHAR(17)
	,IN @ANIM_KEY INT
	,IN @SPECIES_CODE CHAR(1)
	,IN @SEX_CODE CHAR(1)
)
DYNAMIC RESULT SETS 10
BEGIN
   	/*=======================
		Variable declaration
	=========================*/
	DECLARE DEFAULT_DATE DATE;
	DECLARE RUN_DATE SMALLINT;
	
	
	/*=======================
		Temp table creation
	=========================*/
	
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT(
		INT_ID CHAR(17)
		,ANIM_KEY INT
		,SPECIES_CODE CHAR(1)
		,SEX_CODE CHAR(1)
    )WITH REPLACE ON COMMIT PRESERVE ROWS;
        
    SET DEFAULT_DATE = (SELECT STRING_VALUE FROM dbo.constants WHERE NAME ='Default_Date_Value' LIMIT 1 WITH UR);
	SET RUN_DATE = 21884;
    
  	-- get run, breed   
	
	IF @SEX_CODE = 'M' THEN
		BEGIN 
			DECLARE cursor1 CURSOR WITH RETURN FOR
			SELECT  COALESCE(VARCHAR_FORMAT(DEFAULT_DATE + RUN_DATE,'Month YYYY'),'N/A') AS RUN_NAME 
			 	    ,COALESCE(animEvl.EVAL_BREED_CODE,'N/A') AS EVAL_BREED
			 	    ,COALESCE(breed.BREED_NAME,'N/A') AS BREED_NAME
			FROM BUCK_EVL_TABLE animEvl 
			LEFT JOIN BREED_TABLE breed ON animEvl.EVAL_BREED_CODE = breed.BREED_CODE
			WHERE animEvl.ANIM_KEY = @ANIM_KEY AND EVAL_PDATE = RUN_DATE
			;
			OPEN cursor1;
		END;  
	
	ELSEIF @SEX_CODE = 'F' THEN
		BEGIN 
			DECLARE cursor1 CURSOR WITH RETURN FOR
			SELECT  COALESCE(VARCHAR_FORMAT(DEFAULT_DATE + RUN_DATE,'Month YYYY'),'N/A') AS RUN_NAME 
			 	    ,COALESCE(animEvl.EVAL_BREED_CODE,'N/A') AS EVAL_BREED
			 	    ,COALESCE(breed.BREED_NAME,'N/A') AS BREED_NAME
			FROM DOE_EVL_TABLE animEvl 
			LEFT JOIN BREED_TABLE breed ON animEvl.EVAL_BREED_CODE = breed.BREED_CODE
			WHERE animEvl.ANIM_KEY = @ANIM_KEY AND EVAL_PDATE = RUN_DATE
			;
			OPEN cursor1;
		END;  
	
	END IF;
	
END
CREATE OR REPLACE PROCEDURE usp_Get_Current_Evaluation_Run_Breed
--========================================================================================================
--Author: Nghi Ta
--Created Date: 2020-12-21
--Description: Get Current evaluation run/breed of animal
--Output: 
--        +Ds1: Run Name, Eval Breed code, Breed Name
 
--============================================================================================================
(
	IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1)
)
	DYNAMIC RESULT SETS 7
 BEGIN
 
 	--DECLEAR VARIABLE
 	DECLARE DEFAULT_DATE DATE;
	DECLARE v_EVAL_PDATE SMALLINT;
	
	--DECLEAR TABLE
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
        (
                INT_ID CHAR(17),
                ANIM_KEY INT,
                SPECIES_CODE CHAR(1),
                SEX_CODE CHAR(1)
        )WITH REPLACE ON COMMIT PRESERVE ROWS; 

    SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
	SET v_EVAL_PDATE = (select PUBRUN_PDATE FROM ENV_VAR_TABLE LIMIT 1); 
	
    IF @SEX_CODE ='M' THEN
	     begin
		 	DECLARE cursor1 CURSOR WITH RETURN for 
		 	SELECT  
		 	    coalesce(VARCHAR_FORMAT(DEFAULT_DATE + v_EVAL_PDATE,'Month YYYY'),'N/A') AS RUN_NAME 
		 	    ,coalesce(animEvl.EVAL_BREED_CODE,'N/A') as EVAL_BREED
		 	    ,coalesce(breed.BREED_NAME,'N/A') as BREED_NAME
				FROM  (
				     select  EVAL_BREED_CODE
				     from BULL_EVL_TABLE_DECODE
				     where ANIM_KEY = @ANIM_KEY
				     and EVAL_PDATE = v_EVAL_PDATE
				)   animEvl 
				LEFT JOIN BREED_TABLE breed  
					ON  animEvl.EVAL_BREED_CODE = breed.BREED_CODE  
	    ;
		 	 
		 	OPEN cursor1;
	   end;
	ELSEIF @SEX_CODE ='F' THEN
	
	   begin
		 	DECLARE cursor1 CURSOR WITH RETURN for 
		 	SELECT  
		 	    coalesce(VARCHAR_FORMAT(DEFAULT_DATE + v_EVAL_PDATE,'Month YYYY'),'N/A') AS RUN_NAME 
		 	    ,coalesce(animEvl.EVAL_BREED_CODE,'N/A') as EVAL_BREED
		 	    ,coalesce(breed.BREED_NAME,'N/A') as BREED_NAME
				FROM  (
				     select  EVAL_BREED_CODE
				     from COW_EVL_TABLE
				     where ANIM_KEY = @ANIM_KEY
				     and EVAL_PDATE = v_EVAL_PDATE
				)   animEvl 
				LEFT JOIN BREED_TABLE breed  
					ON  animEvl.EVAL_BREED_CODE = breed.BREED_CODE  
	    ;
		 	 
		 	OPEN cursor1;
	   end;
    END IF;
	 
END
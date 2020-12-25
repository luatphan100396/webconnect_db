CREATE OR REPLACE FUNCTION fn_Check_Has_Evaluation_Data
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-19
--Description: Check whether the input animal has evaluation data
--======================================================
(
	@INT_ID			CHAR(17), 
	@ANIM_KEY		INT, 
	@SPECIES_CODE	CHAR(1),
	@SEX_CODE		CHAR(1)
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE HAS_EVL SMALLINT DEFAULT 0;
	DECLARE v_EVAL_PDATE SMALLINT;
	SET v_EVAL_PDATE = (select PUBRUN_PDATE FROM ENV_VAR_TABLE LIMIT 1); 
    
	
	IF @SEX_CODE ='M' AND @SPECIES_CODE ='0' THEN
	
	   SET HAS_EVL = (
			   SELECT case when COUNT(1) >1 then 1 else 0 end
			   FROM BULL_EVL_TABLE_DECODE 
			   WHERE BULL_ID = @INT_ID
			         AND EVAL_PDATE = v_EVAL_PDATE  
	   );
	   
	   IF HAS_EVL =1 THEN 
	     RETURN HAS_EVL ;
	   END IF;
	      
	   SET HAS_EVL = (
			   SELECT case when COUNT(1) >1 then 1 else 0 end FROM SIRE_TYPE_TABLE 
			   WHERE ANIM_KEY = @ANIM_KEY
			         AND EVAL_PDATE = v_EVAL_PDATE  
	   );   
	    IF HAS_EVL =1 THEN 
	    RETURN HAS_EVL ;
	    END IF;
	      
	ELSEIF @SEX_CODE ='F' THEN
	
	   SET HAS_EVL = (
			   SELECT case when COUNT(1) >1 then 1 else 0 end FROM COW_EVL_TABLE 
			   WHERE INT_ID = @INT_ID
			         AND EVAL_PDATE = v_EVAL_PDATE  
	   );
	   
	   IF HAS_EVL =1 THEN 
	     RETURN HAS_EVL ;
	   END IF;
	      
	   SET HAS_EVL = (
			   SELECT case when COUNT(1) >1 then 1 else 0 end FROM COW_TYPE_TABLE 
			   WHERE ANIM_KEY = @ANIM_KEY
			         AND EVAL_PDATE = v_EVAL_PDATE  
	   );   
	    IF HAS_EVL =1 THEN 
	    RETURN HAS_EVL ;
	    END IF;
	
	END IF;  
	
	RETURN HAS_EVL;
END
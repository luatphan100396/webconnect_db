CREATE OR REPLACE PROCEDURE usp_Get_Herd_Testing_Characteristic_By_ID
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-18
--Description: Get herd owner information: INT_ID, name, 
--birth date, cross reference...
--Output: 
--        +Ds1: herd general information: INT ID, name, birth date, sex, MBC, REG, SRC...
--        +Ds2: Cross reference data 
--======================================================
( 
   IN @HERD_CODE INT
)
DYNAMIC RESULT SETS 1
    
BEGIN
   
	DECLARE DEFAULT_DATE DATE;
	DECLARE v_MAX_SAMPL_PDATE SMALLINT;
	DECLARE v_EVAL_BREED_CODE char(2);
	  
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
     
    SET v_MAX_SAMPL_PDATE = (SELECT MAX(SAMPL_PDATE) FROM HERD_TD_TABLE WHERE HERD_CODE = @HERD_CODE);
    -- Get alias
    
     begin
		 	DECLARE cursor3 CURSOR WITH RETURN for
		 	
				select varchar_format(DEFAULT_DATE + SAMPL_PDATE,'YYYY-MM-DD') AS TEST_DATE,
				CTR_CODE as CENTER,
				SERVICE_AFFL_CODE AS DHI,
				COWS_IN_MLK_QTY,
				ASCII(MLK_FREQ_QTY) AS MLK_FREQ_QTY,
				ASCII(MILKINGS_WEIGH_QTY) AS MILKINGS_WEIGH_QTY,
				ASCII(MILKINGS_SAMPL_QTY) AS MILKINGS_SAMPL_QTY,
				ASCII(MLK_REC_DAYS_QTY) AS MLK_REC_DAYS_QTY,
				SUPVS_CODE,
				SPECIES_CODE,
				BREED_CODE,
				
				varchar_format(DEFAULT_DATE + UPDATE_PDATE,'YYYY-MM-DD') AS UPDATE_DATE,
				TESTING_PLAN_CODE,
				TESTING_MTHD_CODE,
				MLK_SHIPPED_PCT,
				ASCII(GOOD_ID_PCT) AS GOOD_ID_PCT,
				HA_MLK_QTY,
				HA_FAT_QTY,
				HA_PRO_QTY,
				float2char(HA_SCS_QTY*0.1,0.1) AS HA_SCS_QTY,
				HA_CALV_AGE_QTY,
				QC_CODE,
				REC_IN_FILE_QTY 
				FROM HERD_TD_TABLE
				WHERE HERD_CODE = @HERD_CODE
				AND  SAMPL_PDATE = v_MAX_SAMPL_PDATE
				 
				ORDER BY MLK_FREQ_QTY  
		 	with UR;
		    
		    OPEN cursor3;
	   end;
	   
     
END

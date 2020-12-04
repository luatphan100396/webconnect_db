CREATE OR REPLACE PROCEDURE usp_Get_Herd_Test_Day
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-18
--Description: Get herd owner information: INT_ID, name, 
--birth date, cross reference...
--Output: 
--        +Ds1: herd test date information
--======================================================
( 
   IN @HERD_CODE INT
)
DYNAMIC RESULT SETS 2
    
BEGIN
   
	DECLARE DEFAULT_DATE DATE; 
	DECLARE v_EVAL_BREED_CODE char(2);
	  
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
      
    -- Get alias
    
     begin
		 	DECLARE cursor3 CURSOR WITH RETURN for
		 	
				select varchar_format(DEFAULT_DATE + SAMPL_PDATE,'YYYY-MM-DD') AS TEST_DATE,
				CTR_CODE as CENTER,
				SERVICE_AFFL_CODE AS DHI,
				LAB_CODE,
				METER_CODE,
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
				QC_CODE,
				MLK_SHIPPED_PCT,
				ASCII(GOOD_ID_PCT) AS GOOD_ID_PCT,
				HA_MLK_QTY,
				HA_FAT_QTY,
				HA_PRO_QTY,
				float2char(HA_SCS_QTY*0.1,0.1) AS HA_SCS_QTY,
				HA_CALV_AGE_QTY,
				REC_IN_FILE_QTY 
				FROM HERD_TD_TABLE
				WHERE HERD_CODE = @HERD_CODE
				ORDER BY SAMPL_PDATE DESC LIMIT 10
		 	with UR;
		    
		    OPEN cursor3;
	   end;
	   
     
     -- Get herd owner sampler error 
     begin
		 	DECLARE cursor4 CURSOR WITH RETURN for
				 	
			select case when NUM_GOOD >0 then 'Herd '||@HERD_CODE||' had '||NUM_GOOD||' "Good ID < 40%" errors'||chr(10) else '' end
			        ||case when NUM_MLK_SHIPPED >0 then 'Herd '||@HERD_CODE||' had '||NUM_MLK_SHIPPED||' Milk shipped not between 81% and 117%" errors'||chr(10) else '' end
			        ||case when NUM_OUTLIIER >0 then 'Herd '||@HERD_CODE||' had '||NUM_OUTLIIER||' "Outlier animal" errors'||chr(10) else '' end
			        ||case when NUM_MANY_OUTLIIER >0 then  'Herd '||@HERD_CODE||' had '||NUM_MANY_OUTLIIER||' "Too many outliers" errors'||chr(10) else '' end
			        || 'Herd '||@HERD_CODE||' had '||NUM_ALL||' cow'||case when NUM_ALL >0 then 's' else '' end|| ' not receiving evaluations due to owner-sampler edits imposed'||chr(10) 
			        as OSErrorMessage
			from 
			(
			select sum(case when right(LINE,2) = '7L' then 1 else 0 end) AS NUM_GOOD,
				  sum(case when right(LINE,2) = '7M' then 1 else 0 end) AS NUM_MLK_SHIPPED,
				  sum(case when right(LINE,2) = '7N' then 1 else 0 end) AS NUM_OUTLIIER,
				  sum(case when right(LINE,2) = '7O' then 1 else 0 end) AS NUM_MANY_OUTLIIER,
				  count(1) as NUM_ALL
			
			from OSERR_1912 
			where LINE like @HERD_CODE||'%'
			      and right(LINE,2) IN ('7L','7M','7N','7O')
			 )os
		 	with UR;
		    
		    OPEN cursor4;
	   end;
     
END

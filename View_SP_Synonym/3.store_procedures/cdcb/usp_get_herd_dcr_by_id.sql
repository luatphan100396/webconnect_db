CREATE OR REPLACE PROCEDURE usp_Get_Herd_DCR_By_ID
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-18
--Description: Get herd data collection rate
--birth date, cross reference...
--Output: 
--        +Ds1: herd test date information: test date, dim, Freq, supervision, Weighted, Sampled Rect days, num animals
--        +Ds2: Num test included, num test excluded, DCR for Milk, DCR for component
--======================================================
( 
   IN @HERD_CODE INT
)
DYNAMIC RESULT SETS 5
    
BEGIN
   
	DECLARE DEFAULT_DATE DATE;
	DECLARE v_MAX_SAMPL_PDATE SMALLINT; 
	 
	 
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpHerdTD 
	(
	HERD_CODE integer ,
    SAMPL_PDATE smallint,
    MLK_FREQ_QTY  char(1)  for bit data,
    SUPVS_CODE    char(1),
    MILKINGS_WEIGH_QTY  char(1)  for bit data,
    MILKINGS_SAMPL_QTY char(1)  for bit data,
    MLK_REC_DAYS_QTY char(1)  for bit data,
    COWS_IN_MLK_QTY integer,
    QC_CODE char(1)
	) with replace ON COMMIT PRESERVE ROWS;
	 
	 
	  
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
     
    SET v_MAX_SAMPL_PDATE =  (select max(SAMPL_PDATE) from HERD_TD_TABLE where HERD_CODE = @HERD_CODE);
    
    INSERT INTO SESSION.TmpHerdTD
    (
    HERD_CODE,
    SAMPL_PDATE,
    MLK_FREQ_QTY,
    SUPVS_CODE,
    MILKINGS_WEIGH_QTY,
    MILKINGS_SAMPL_QTY,
    MLK_REC_DAYS_QTY,
    COWS_IN_MLK_QTY,
    QC_CODE
    )
    SELECT HERD_CODE,
    SAMPL_PDATE,
    MLK_FREQ_QTY,
    SUPVS_CODE,
    MILKINGS_WEIGH_QTY,
    MILKINGS_SAMPL_QTY,
    MLK_REC_DAYS_QTY,
    COWS_IN_MLK_QTY,
    QC_CODE
    FROM 
	(
		 select  HERD_CODE,
			    SAMPL_PDATE,
			    MLK_FREQ_QTY,
			    SUPVS_CODE,
			    MILKINGS_WEIGH_QTY,
			    MILKINGS_SAMPL_QTY,
			    MLK_REC_DAYS_QTY,
			    COWS_IN_MLK_QTY,
			    QC_CODE,
		        row_number()over(partition by h.HERD_CODE, h.SAMPL_PDATE order by  ASCII(h.MLK_FREQ_QTY) desc) as rn
		from HERD_TD_TABLE h
		where HERD_CODE = @HERD_CODE
		and SAMPL_PDATE >= v_MAX_SAMPL_PDATE-306 -- include 305 days
	)where rn = 1;
    
    -- Get alias
    
     begin
		 	DECLARE cursor3 CURSOR WITH RETURN for
		 	
				SELECT varchar_format(DEFAULT_DATE + SAMPL_PDATE,'YYYY-MM-DD') AS TEST_DATE,
				305 - (v_MAX_SAMPL_PDATE-SAMPL_PDATE) as DIM, 
				ASCII(MLK_FREQ_QTY) AS MLK_FREQ_QTY,
				SUPVS_CODE,
				ASCII(MILKINGS_WEIGH_QTY) AS MILKINGS_WEIGH_QTY,
				ASCII(MILKINGS_SAMPL_QTY) AS MILKINGS_SAMPL_QTY,
				ASCII(MLK_REC_DAYS_QTY) AS MLK_REC_DAYS_QTY,
				COWS_IN_MLK_QTY   
				FROM 
				SESSION.TmpHerdTD 
				ORDER BY SAMPL_PDATE  
		 	with UR;
		    
		    OPEN cursor3;
	   end;
	   
	   begin
		 	DECLARE cursor31 CURSOR WITH RETURN for
		 	
				SELECT  
				 sum(case when QC_CODE =1 then 1 else 0 end) NUM_TEST_INCLUDE,
				 sum(case when QC_CODE <>1 then 1 else 0 end) NUM_TEST_EXCLUDE
				FROM 
				SESSION.TmpHerdTD  
		 	with UR;
		    
		    OPEN cursor31;
	   end;
	   
     
END
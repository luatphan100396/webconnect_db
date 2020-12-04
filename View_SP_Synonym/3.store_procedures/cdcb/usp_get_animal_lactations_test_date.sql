CREATE OR REPLACE PROCEDURE usp_Get_Animal_Lactations_Test_Date
--======================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get test date data for animal 
--Output: 
--        +Ds1: STD, DCR and Act for yield trait
--        +Ds1: detail test date
--======================================================
(  
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @CALV_PDATE smallint,
	IN @HERD_CODE integer 
)
DYNAMIC RESULT SETS 10
    
BEGIN
   
	DECLARE DEFAULT_DATE DATE;
	DECLARE v_TD_SEG_LENGTH SMALLINT DEFAULT 8;
	DECLARE v_MAX_TD_CNT SMALLINT DEFAULT 50; 
	DECLARE i SMALLINT DEFAULT 1;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_TD_SEG_FORMAT
	(
		TD_NUM  SMALLINT
		,DIM_START_INDEX SMALLINT
		,DIM_LENGTH  SMALLINT
		,MILK_START_INDEX SMALLINT
		,MILK_LENGTH SMALLINT
		,FAT_PCT_START_INDEX SMALLINT
		,FAT_PCT_LENGTH SMALLINT
		,PRO_PCT_START_INDEX SMALLINT
		,PRO_PCT_LENGTH SMALLINT
		,SCS_START_INDEX SMALLINT
		,SCS_LENGTH SMALLINT
		,REQ_START_INDEX SMALLINT
		,REQ_LENGTH SMALLINT
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
       
	  
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_LACT_COMMON
 	(    CALV_PDATE smallint
 		 ,ME_MLK_QTY integer
 		 ,ME_FAT_QTY smallint
 		 ,ME_PRO_QTY smallint
 		 ,ME_SCS_QTY smallint
 		 ,DCR_MLK_QTY char(1)
 		 ,DCR_FAT_QTY char(1)
 		 ,DCR_PRO_QTY char(1)
 		 ,DCR_SCS_QTY char(1)
 		 ,ACT_MLK_QTY integer
 		 ,ACT_FAT_QTY smallint
 		 ,ACT_PRO_QTY smallint
 		 ,ACT_SCS_QTY smallint
	 	 ,TESTDAY_CNT char(1)
	 	 ,TESTDAY_SEG VARCHAR(400) 
 	) WITH REPLACE ON COMMIT PRESERVE ROWS;
 		
  SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
  	  
	
  -- Building format for test day seg, used for cutting data from test day seg into columns
  WHILE (i <= v_MAX_TD_CNT)
  DO
  	INSERT INTO SESSION.TMP_TD_SEG_FORMAT
  	(
  		 TD_NUM  
		,DIM_START_INDEX 
		,DIM_LENGTH  
		,MILK_START_INDEX 
		,MILK_LENGTH 
		,FAT_PCT_START_INDEX 
		,FAT_PCT_LENGTH 
		,PRO_PCT_START_INDEX 
		,PRO_PCT_LENGTH 
		,SCS_START_INDEX 
		,SCS_LENGTH 
		,REQ_START_INDEX 
		,REQ_LENGTH 
  	)
  	VALUES
  	(
  		i
  		,(i-1)*v_TD_SEG_LENGTH + 1
  		,2
  		,(i-1)*v_TD_SEG_LENGTH + 3
  		,2
  		,(i-1)*v_TD_SEG_LENGTH + 5
  		,1
  		,(i-1)*v_TD_SEG_LENGTH + 6
  		,1
  		,(i-1)*v_TD_SEG_LENGTH + 7
  		,1
  		,(i-1)*v_TD_SEG_LENGTH + 8
  		,1
  		 
  	);
  	COMMIT WORK;
    SET i = i+1;
    
  END WHILE;
  
  INSERT INTO SESSION.TMP_LACT_COMMON
  ( CALV_PDATE
    ,ME_MLK_QTY
	,ME_FAT_QTY 
	,ME_PRO_QTY 
	,ME_SCS_QTY 
	,DCR_MLK_QTY 
	,DCR_FAT_QTY 
	,DCR_PRO_QTY 
	,DCR_SCS_QTY 
	,ACT_MLK_QTY 
	,ACT_FAT_QTY 
	,ACT_PRO_QTY 
	,ACT_SCS_QTY 
	,TESTDAY_CNT 
	,TESTDAY_SEG 
   )
  
  SELECT 
    CALV_PDATE
    ,ME_MLK_QTY
	,ME_FAT_QTY 
	,ME_PRO_QTY 
	,ME_SCS_QTY 
	,DCR_MLK_QTY 
	,DCR_FAT_QTY 
	,DCR_PRO_QTY 
	,DCR_SCS_QTY 
	,ACT_MLK_QTY 
	,ACT_FAT_QTY 
	,ACT_PRO_QTY 
	,ACT_SCS_QTY 
	,TESTDAY_CNT 
	,TESTDAY_SEG
  FROM   lacta90_table lact
  WHERE lact.anim_key = @ANIM_KEY
			and lact.species_code = @SPECIES_CODE
			and lact.calv_pdate =@CALV_PDATE
			and lact.herd_code =@HERD_CODE
  
  ;
  
 
	
  
  -- DS for STD, DCR and Actual
	begin
  		declare cir cursor with return for
  		
		select t.TYPE_NAME,
		case when t.type ='Std' then lact.ME_MLK_QTY 
		     when t.type ='DCR' then lact.DCR_MLK_QTY
		     when t.type ='Act' then lact.ACT_MLK_QTY 
		end as Mlk,
		case when t.type ='Std' then lact.ME_FAT_QTY 
		     when t.type ='DCR' then lact.DCR_FAT_QTY
		     when t.type ='Act' then lact.ACT_FAT_QTY 
		end as FAT,
		case when t.type ='Std' then lact.ME_PRO_QTY 
		     when t.type ='DCR' then lact.DCR_PRO_QTY
		     when t.type ='Act' then lact.ACT_PRO_QTY 
		end as PRO,
		case when t.type ='Std' then lact.ME_SCS_QTY 
		     when t.type ='DCR' then lact.DCR_SCS_QTY
		     when t.type ='Act' then lact.ACT_SCS_QTY 
		end as SCS
		
		from 
		(
		   select  type, type_name
		    from (
		    values('Std', 'Standard'),
				  ('DCR','DCR'),
				  ('Act', 'Actual')
		    )t (type, type_name)
		)t
		cross join
		(
		 select  
		lact.ME_MLK_QTY,
		lact.ME_FAT_QTY,
		lact.ME_PRO_QTY,
		float2char(lact.ME_SCS_QTY*0.01,0.01) as ME_SCS_QTY,
		uchar2schar(lact.DCR_MLK_QTY) AS DCR_MLK_QTY,
		uchar2schar(lact.DCR_FAT_QTY) AS DCR_FAT_QTY,
		uchar2schar(lact.DCR_PRO_QTY) AS DCR_PRO_QTY,
		uchar2schar(lact.DCR_SCS_QTY) AS DCR_SCS_QTY,
		lact.ACT_MLK_QTY,
		lact.ACT_FAT_QTY,
		lact.ACT_PRO_QTY, 
		float2char(lact.ACT_SCS_QTY*0.01,0.01) as ACT_SCS_QTY 
		from SESSION.TMP_LACT_COMMON lact
		with ur
		)lact;
			 
  	    open cir;
    end;
 	      
	-- DS: Test days segment
	BEGIN
		 	DECLARE cursor2 CURSOR WITH RETURN for
		 
		 SELECT 
	      TD_NUM
	     ,FLOAT2CHAR_STR_INPUT(DIM,1,1) AS DIM
		 ,FLOAT2CHAR_STR_INPUT(MLK,0.1,0.1) AS MLK
		 ,FLOAT2CHAR_STR_INPUT(FAT_PCT,0.1,0.1) AS FAT_PCT
		 ,FLOAT2CHAR_STR_INPUT(PRO_PCT,0.1,0.1) AS PRO_PCT
		 ,FLOAT2CHAR_STR_INPUT(SCS,0.1,0.1) AS SCS
		 ,REQ 
		 ,varchar_format(DEFAULT_DATE+ (calv_pdate+ DIM-1), 'YYYY-MM-DD') AS TEST_DATE 
		 FROM		
		 (
		 	SELECT 
				 f.TD_NUM
				 ,AGILSMALL(substring(TESTDAY_SEG,DIM_START_INDEX,DIM_LENGTH)) as DIM
				 ,AGILSMALL(substring(TESTDAY_SEG,MILK_START_INDEX, MILK_LENGTH)) as MLK
				 ,AGILSMALL(substring(TESTDAY_SEG,FAT_PCT_START_INDEX,FAT_PCT_LENGTH)) as FAT_PCT
				 ,AGILSMALL(substring(TESTDAY_SEG,PRO_PCT_START_INDEX,PRO_PCT_LENGTH)) as PRO_PCT
				 ,AGILSMALL(substring(TESTDAY_SEG,SCS_START_INDEX,SCS_LENGTH)) as SCS
				 ,AGILSMALL(substring(TESTDAY_SEG,REQ_START_INDEX,REQ_LENGTH)) as REQ
				 ,calv_pdate 
			FROM SESSION.TMP_LACT_COMMON td
			CROSS JOIN SESSION.TMP_TD_SEG_FORMAT f
			WHERE f.TD_NUM <= ascii(td.TESTDAY_CNT)
			WITH UR
			)t 
			WHERE DIM IS NOT NULL
			ORDER BY TD_NUM with UR; 
		 	
       OPEN cursor2;
		 	 
		 	 
	END;
	
	
 
        
END
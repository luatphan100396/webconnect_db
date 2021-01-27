CREATE OR REPLACE PROCEDURE Usp_Get_Animal_Type_Composite_Information_For_Ay_Bs_Gu_Ms
--=================================================================
--Author: Tuyen Nguyen
--Created Date: 2021-01-27
--Description: Get animal type-composite information for AY, BS, GU, and MS
--Output: 
--        +Ds1: Animal information(ANIMAL_ID,ANIM_KEY,SPECIES_CODE,SEX_CODE,SOURCE_CODE,SOURCE,BREED_CODE,SIRE_PTA,SIRE_REL,UDDER_PTA,UDDER_REL,FEET_PTA,FEET_REL)
--=================================================================
(
    IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1), 
	IN @IS_DATA_EXCHANGE char(1),
	IN @REQUEST_KEY BIGINT,
	IN @OPERATION_KEY BIGINT
)
DYNAMIC RESULT SETS 3
 
BEGIN
		DECLARE EXPORT_FILE_NAME VARCHAR(300);
		DECLARE TEMPLATE_NAME	 VARCHAR(200) ; 
		DECLARE LAST_ROW_ID 	 INT;
		DECLARE DEFAULT_DATE     DATE;
		DECLARE v_EVAL_PDATE     SMALLINT;
			  
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1);
	-- Get list animal id
    SET v_EVAL_PDATE = (SELECT RUN_PDATE FROM ENV_VAR_TABLE LIMIT 1);
 	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
	(   
	    ROW_KEY INT GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1),
		INT_ID char(17), 
	    ANIM_KEY INT, 
	    SPECIES_CODE char(1),
	    SEX_CODE char(1),
	    INPUT varchar(128)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	  DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_RESULT
	(  
		ANIMAL_ID              CHAR(17),
		ANIM_KEY               INT,
		SPECIES_CODE           CHAR(1),
		SEX_CODE               CHAR(1),
		SOURCE_CODE            CHAR(1),
		SOURCE                 CHAR(20),
		BREED_CODE             CHAR(2),
		SIRE_PTA               VARCHAR(10),		 
		SIRE_REL	           VARCHAR(10),	
		UDDER_PTA              VARCHAR(10),	
		UDDER_REL              VARCHAR(10),
		FEET_PTA               VARCHAR(10),
		FEET_REL               VARCHAR(10),
		ROW_ID 			       INT GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1),
		INPUT                  varchar(128)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;

 
	 IF @IS_DATA_EXCHANGE ='0' THEN 
      	
   INSERT INTO SESSION.TMP_INPUT
	(  INT_ID,
	   ANIM_KEY,
	   SPECIES_CODE,
	   SEX_CODE 
   )
    
   VALUES (
	   @INT_ID,
	   @ANIM_KEY,
	   @SPECIES_CODE,
	   @SEX_CODE 
   ); 
   ELSEIF @IS_DATA_EXCHANGE ='1' THEN
	
		INSERT INTO SESSION.TMP_INPUT
		(  
		   INT_ID,
		   ANIM_KEY,
		   SPECIES_CODE,
		   SEX_CODE,
		   INPUT
	   )
	   SELECT id.INT_ID,
			id.ANIM_KEY,
			id.SPECIES_CODE,
			id.SEX_CODE,
			dx.LINE
	   FROM
	   (
	      select ROW_KEY, 
	          LINE 
		   from DATA_EXCHANGE_INPUT_TABLE  -----
		   where REQUEST_KEY = @REQUEST_KEY
	   )dx
	   INNER JOIN ID_XREF_TABLE id
	   		ON id.INT_ID = dx.LINE
	   		AND id.SPECIES_CODE ='0' 
	   ORDER BY ROW_KEY
	   ; 
	  
   END IF;
   
   
   
 INSERT INTO SESSION.TMP_RESULT
	(
	    ANIMAL_ID,
		ANIM_KEY,
		SPECIES_CODE,
		SEX_CODE,
		SOURCE_CODE,
		SOURCE,
		BREED_CODE,
		SIRE_PTA,              		 
		SIRE_REL,	           
		UDDER_PTA,              
		UDDER_REL,          
		FEET_PTA,            
		FEET_REL,
		INPUT
	)
	SELECT   DISTINCT    i.INT_ID AS ANIMAL_ID, 
                 i.ANIM_KEY,
				 i.SPECIES_CODE ,
				 i.SEX_CODE,
				 t.SOURCE_CODE,
				 CASE WHEN t.SOURCE_CODE='D' THEN 'US Only'
		    		  ELSE 'Offical' 
				 END AS SOURCE,
				 id.BREED_CODE,
				 ROUND(CAST(t.SIZE_CPST AS VARCHAR(10)),2)              AS SIRE_PTA,
				 ROUND(CAST(t.SIZE_CPST_REL_PCT AS VARCHAR(10)),2)      AS SIRE_REL,
				 ROUND(CAST(t.UDDER_CPST AS VARCHAR(10)),2)             AS UDDER_PTA,
				 ROUND(CAST(t.UDDER_CPST_REL_PCT AS VARCHAR(10)),2)     AS UDDER_REL,
				 ROUND(CAST(t.FEET_LEGS_CPST AS VARCHAR(10)),2)         AS FEET_PTA,            
		         ROUND(CAST(t.FEET_LEGS_CPST_REL_PCT AS VARCHAR(10)),2) AS FEET_REL,
				 i.INPUT
		 FROM SESSION.TMP_INPUT i
		 INNER JOIN TYPE_CPST_TABLE t   
		    ON t.ANIM_KEY = i.ANIM_KEY
		 INNER JOIN ID_XREF_TABLE id
		 ON id.ANIM_KEY=i.ANIM_KEY
		    AND id.ANIM_KEY = i.ANIM_KEY
		    AND id.SEX_CODE = i.SEX_CODE
		    AND id.SPECIES_CODE = i.SPECIES_CODE
		 WHERE  t.SOURCE_CODE IN ('D','I')
		    AND id.BREED_CODE IN ('AY','BS','GU','MS')
		    AND t.EVAL_PDATE=v_EVAL_PDATE
		with UR;
		 


   BEGIN
  
    IF @IS_DATA_EXCHANGE ='0' THEN
		 BEGIN
			DECLARE cursor1  CURSOR WITH RETURN for
			
			 SELECT 
					t.ANIMAL_ID,
					t.ANIM_KEY,
					t.SPECIES_CODE,
					t.SEX_CODE,
					t.SOURCE_CODE,
					case when cnt.CNT = 1 and SOURCE_CODE='D' then 'US only is official for type composite evaluations.'
					      else null
					end as MESSAGE,
					t.SOURCE,
					t.BREED_CODE,
					t.SIRE_PTA,              		 
					t.SIRE_REL,	           
					t.UDDER_PTA,              
					t.UDDER_REL,          
					t.FEET_PTA,            
					t.FEET_REL
					FROM SESSION.TMP_RESULT t
					inner join (
					
					select  ANIMAL_ID,
							ANIM_KEY,
							SPECIES_CODE,
							SEX_CODE,
							count(1) AS CNT 
					from SESSION.TMP_RESULT 
--					where SOURCE_CODE ='D'
					group by ANIMAL_ID,
							ANIM_KEY,
							SPECIES_CODE,
							SEX_CODE
					)  cnt
					on cnt.ANIMAL_ID=t.ANIMAL_ID
					AND cnt.ANIM_KEY=t.ANIM_KEY
					AND cnt.SPECIES_CODE=t.SPECIES_CODE
					AND cnt.SEX_CODE=t.SEX_CODE
					
				    
					;
				   
			OPEN cursor1;
		  
	    END;
	    
	    --- Data exchange
   ELSEIF @IS_DATA_EXCHANGE ='1' THEN
	
		   SET LAST_ROW_ID = (SELECT MAX(ROW_ID) FROM SESSION.TMP_RESULT); 
           SET TEMPLATE_NAME 	='ANIM_FORMATTED_TYPE_COMPOSITE_INFORMATION_FOR_AY_BS_GU_MS'; 
	       call usp_common_export_json_by_template('SESSION.TMP_RESULT',TEMPLATE_NAME,LAST_ROW_ID,EXPORT_FILE_NAME);
	       
	       --validate output
	       IF  EXPORT_FILE_NAME IS NULL THEN 
	 	     SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Export failed'; 
		   END IF;
		   
		   UPDATE DATA_EXCHANGE_OPERATION_TABLE SET OUTPUT_PATH = EXPORT_FILE_NAME 
		   WHERE OPERATION_KEY = @OPERATION_KEY;
		   
	       
	       begin
	        declare c1 cursor with return for
	          select EXPORT_FILE_NAME from sysibm.sysdummy1;
       
              open c1;
    
            end;
	  
   END IF;

     END;
	
END
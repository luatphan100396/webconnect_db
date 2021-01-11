CREATE OR REPLACE PROCEDURE usp_DataExchange_Get_Animal_Formatted_Pedigree_Info
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-14
--Description: Get animal information: INT_ID, name, 
--birth date, cross reference...
--Output: 
--        +Ds Animal information: INT ID, name, birth date, sex, MBC, REG, SRC...
--======================================================
(
	IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1),
	IN @IS_DATA_EXCHANGE char(1),
	IN @REQUEST_KEY BIGINT,
	IN @OPERATION_KEY BIGINT
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
	--DECLARE VARIABLES
	DECLARE v_DEFAULT_DATE DATE; 
	
	DECLARE EXPORT_FILE_NAME VARCHAR(300);
	DECLARE TEMPLATE_NAME			VARCHAR(200) ; 
	DECLARE LAST_ROW_ID 		    INT;
	
	
	--DECLARE TEMPORARY TABLE
        DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
		(
			ROW_KEY INT GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1),  
			INT_ID CHAR(17),
			ANIM_KEY INT,
			SPECIES_CODE CHAR(1),
			SEX_CODE CHAR(1),
			INPUT varchar(128)
		)WITH REPLACE ON COMMIT PRESERVE ROWS;

    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_Alias --DROP TABLE SESSION.TmpAnimalLists_Alias
	(
		 
		ANIM_KEY int,
		INT_ID CHAR(17),  
		MODIFY_DATE VARCHAR(10),
		REGIS_STATUS_CODE VARCHAR(128),
		SPECIES_CODE CHAR(1),
		SEX_CODE CHAR(1),
		PREFERRED_CODE char(1)
		 
	)WITH REPLACE  ON COMMIT PRESERVE ROWS;

		-- Declare temp tables
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_RESULT
	(
		ANIMAL_ID           CHAR(17),
		SEX_CODE            CHAR(1),		 
		SIRE_ID			    CHAR(17),
		DAM_ID		        CHAR(17),
		PREFERED_ID			CHAR(17),
		ALIAS_ID			CHAR(17),		 
		BIRTH_DATE			CHAR(10),
		SRC             	CHAR(1),	
		MODIFY_DATE 	    CHAR(10),
		MBC                 CHAR(1),
		REG                 CHAR(2),   
		CODES            	VARCHAR(128),
		RHA            	    VARCHAR(128),	 
		RECESSIVES		    VARCHAR(100),
		LONG_NAME           VARCHAR(30),
		SRC_DESC            VARCHAR(128),
		ROW_ID 			   INT GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1),
		INPUT               varchar(128)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
--		  
		 
		 
	---SET VARIABLES
	SET v_DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);

	--INSERT INTO TABLE
	
	IF @IS_DATA_EXCHANGE ='0' THEN
		INSERT INTO SESSION.TMP_INPUT
		(
			INT_ID,
			ANIM_KEY,
			SPECIES_CODE,
			SEX_CODE
		)
		VALUES
		(
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
		   from DATA_EXCHANGE_INPUT_TABLE  
		   where REQUEST_KEY = @REQUEST_KEY
	   )dx
	   INNER JOIN ID_XREF_TABLE id
	   		ON id.INT_ID = dx.LINE
	   		AND id.SPECIES_CODE ='0' 
	   ORDER BY ROW_KEY
	   ; 
	  
   END IF;

	INSERT INTO SESSION.TmpAnimalLists_Alias
	( 
	ANIM_KEY,
	INT_ID, 
	MODIFY_DATE,
	REGIS_STATUS_CODE,
	SPECIES_CODE,
	SEX_CODE,
	PREFERRED_CODE
	)
	SELECT  
		 id.ANIM_KEY,
		 id.INT_ID, 
		 id.MODIFY_PDATE,
		 id.REGIS_STATUS_CODE,
		 id.SPECIES_CODE,
		 id.SEX_CODE,
		 id.PREFERRED_CODE
		 FROM SESSION.TMP_INPUT t
		  INNER JOIN ID_XREF_TABLE id
			  ON t.ANIM_KEY = id.ANIM_KEY
			  AND t.SEX_CODE = id.SEX_CODE
			  AND t.SPECIES_CODE = id.SPECIES_CODE
		 ; 
		  
 
	
	INSERT INTO SESSION.TMP_RESULT
	(
	    ANIMAL_ID,
		SEX_CODE,
		SIRE_ID,
		DAM_ID,
		PREFERED_ID,
		ALIAS_ID,	 
		BIRTH_DATE,
		SRC,
		MODIFY_DATE,
		MBC,
		REG, 
		CODES,
		RHA,
		RECESSIVES,
		LONG_NAME,
		SRC_DESC,
		INPUT
	)
	SELECT 
				 t.INT_ID AS ANIMAL_ID
				 ,ped.SEX_CODE AS SEX
				 ,sire.INT_ID AS SIRE_ID
				 ,dam.INT_ID AS DAM_ID
				 ,pre_id.INT_ID AS PREFERED_ID
				 ,case when t.INT_ID <> pre_id.INT_ID then t.INT_ID
				       else ''
				  end as ALIAS_ID 
				 ,VARCHAR_FORMAT(v_DEFAULT_DATE + ped.BIRTH_PDATE,'YYYY-MM-DD') AS BIRTH_PDATE
				  ,ped.SOURCE_CODE AS SRC
				 ,VARCHAR_FORMAT(v_DEFAULT_DATE+ped.MODIFY_PDATE,'YYYY-MM-DD') as MODIFY_DATE 
				 ,ped.MULTI_BIRTH_CODE AS MBC
				 ,trim(id.REGIS_STATUS_CODE) AS REG
				 ,NULL AS CODES
				 ,NULL AS RHA
				 ,trim(ressive.RECESSIVE_CODE_SEG) AS RECESSIVES 
				 ,trim(anim.ANIM_NAME) AS LONG_NAME 
				 ,trim(ref_src.DESCRIPTION)  AS SRC_DESC
				 ,t.INPUT
			FROM SESSION.TMP_INPUT t
			INNER JOIN  SESSION.TmpAnimalLists_Alias id
			    ON t.ANIM_KEY = id.ANIM_KEY
				AND t.SEX_CODE = id.SEX_CODE
				AND t.SPECIES_CODE = id.SPECIES_CODE
				AND t.INT_ID = id.INT_ID 
			LEFT JOIN SESSION.TmpAnimalLists_Alias pre_id
			   	ON  t.ANIM_KEY = pre_id.ANIM_KEY
				AND t.SEX_CODE = pre_id.SEX_CODE
				AND t.SPECIES_CODE = pre_id.SPECIES_CODE
				AND pre_id.PREFERRED_CODE='1' 
			LEFT JOIN ANIM_NAME_TABLE anim
				ON anim.INT_ID=t.INT_ID
				AND anim.SPECIES_CODE=t.SPECIES_CODE
				AND anim.SEX_CODE=t.SEX_CODE 
			LEFT JOIN PEDIGREE_TABLE ped
			    ON ped.ANIM_KEY = t.ANIM_KEY
			    AND  ped.SPECIES_CODE = t.SPECIES_CODE
			LEFT JOIN ID_XREF_TABLE sire
				ON ped.SIRE_KEY= sire.ANIM_KEY
				AND ped.SPECIES_CODE = sire.SPECIES_CODE
				AND sire.PREFERRED_CODE='1'
			LEFT JOIN ID_XREF_TABLE dam
				ON ped.DAM_KEY= dam.ANIM_KEY
				AND ped.SPECIES_CODE = dam.SPECIES_CODE
				AND dam.PREFERRED_CODE='1'
			LEFT JOIN RECESSIVES_TABLE ressive 
			ON ressive.ANIM_KEY = t.ANIM_KEY 
			AND ressive.SPECIES_CODE = t.SPECIES_CODE 
			LEFT JOIN REFERENCE_TABLE ref_src
			ON ref_src.CODE = ped.SOURCE_CODE
			AND ref_src.TYPE = 'SOURCE_CODE'
			with ur;
			
			
	IF @IS_DATA_EXCHANGE ='0' THEN
		 BEGIN
			DECLARE cursor1  CURSOR WITH RETURN for
			
			  SELECT  ANIMAL_ID,
					SEX_CODE AS SEX,
					SIRE_ID,
					DAM_ID,
					PREFERED_ID,	 
					BIRTH_DATE AS BIRTH_PDATE,
					SRC,
					MODIFY_DATE,
					MBC,
					REG, 
					CODES,
					RHA,
					RECESSIVES,
					LONG_NAME,
					SRC_DESC
		     FROM SESSION.TMP_RESULT;
				   
			OPEN cursor1;
		  
	    END;
   ELSEIF @IS_DATA_EXCHANGE ='1' THEN
	
		   SET LAST_ROW_ID = (SELECT MAX(ROW_ID) FROM SESSION.TMP_RESULT); 
           SET TEMPLATE_NAME 	='ANIM_FORMATTED_PEDIGREE'; 
	       call usp_common_export_json_by_template('SESSION.TMP_RESULT',TEMPLATE_NAME,LAST_ROW_ID,EXPORT_FILE_NAME);
	       
	       
	       UPDATE  DATA_EXCHANGE_OPERATION_TABLE SET OUTPUT_PATH = EXPORT_FILE_NAME
	       WHERE OPERATION_KEY = @OPERATION_KEY;
	       
	       
	       begin
	        declare c1 cursor with return for
	          select 1 AS RESULT from sysibm.sysdummy1;
       
              open c1;
    
            end;
	  
   END IF;
	
	
	
END P1
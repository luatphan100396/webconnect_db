CREATE OR REPLACE PROCEDURE usp_Get_Animal_Common_Info_By_ID
--======================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get animal common information: INT_ID, name, 
--birth date, cross reference...
--Output: 
--        +Ds1: Animal general information: INT ID, name, birth date, sex, MBC, REG, SRC...
--        +Ds2: Cross reference data 
--======================================================
( 
    IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1)
)
DYNAMIC RESULT SETS 10
    
BEGIN
   
	DECLARE DEFAULT_DATE DATE;
	DECLARE v_EVAL_PDATE SMALLINT;
	DECLARE v_EVAL_BREED_CODE char(2);
	DECLARE v_ROOT_ANIM_ID char(17);
	 
   DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_Alias --DROP TABLE SESSION.TmpAnimalLists_Alias
	(
		ROOT_INT_ID CHAR(17),
		INT_ID CHAR(17),
		ALIAS_ID VARCHAR(17),
		ALIAS_NAME VARCHAR(200),
		MODIFY_DATE VARCHAR(10),
		REG_CODES VARCHAR(128),
		SEX CHAR(1),
		PREFERRED_CODE char(1)
		 
	)WITH REPLACE  ON COMMIT PRESERVE ROWS;

	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
     
    -- Get alias
    
    
	INSERT INTO SESSION.TmpAnimalLists_Alias
	(
	ROOT_INT_ID,
	INT_ID,
	ALIAS_ID,
	ALIAS_NAME,
	MODIFY_DATE,
	REG_CODES,
	SEX,
	PREFERRED_CODE
	)
	SELECT 
		 t.INT_ID AS ROOT_INT_ID,
		 t.INT_ID,
		 t.ALIAS_ID, 
		 aname.ANIM_NAME AS ALIAS_NAME,
		 VARCHAR_FORMAT(DEFAULT_DATE + t.MODIFY_PDATE,'YYYY-MM-DD') AS MODIFY_DATE,
		 t.REGIS_STATUS_CODE as REG_CODES,
		 aname.SEX_CODE as SEX,
		 t.PREFERRED_CODE 
		 from
		 (
		 SELECT @INT_ID AS INT_ID, 
			 xref.INT_ID as ALIAS_ID,
			 xref.MODIFY_PDATE,
			 xref.REGIS_STATUS_CODE,
			 xref.SPECIES_CODE,
			 xref.SEX_CODE,
			 xref.PREFERRED_CODE 
		 FROM   ID_XREF_TABLE xref 
		 WHERE  xref.ANIM_KEY = @ANIM_KEY
		 AND  xref.SPECIES_CODE = @SPECIES_CODE
		 AND  xref.SEX_CODE = @SEX_CODE with UR
		 )t 
		LEFT JOIN ANIM_NAME_TABLE aname 
		ON aname.INT_ID = t.ALIAS_ID 
		AND aname.SEX_CODE  = t.SEX_CODE 
		AND aname.SPECIES_CODE  = t.SPECIES_CODE 
	
		 with UR;
	
	SET v_ROOT_ANIM_ID = 	@INT_ID;   
	SET @INT_ID = (SELECT ALIAS_ID FROM SESSION.TmpAnimalLists_Alias where PREFERRED_CODE = '1' limit 1);
		   
    -- Get eval date
    IF @SEX_CODE ='M' THEN 
      
      SET v_EVAL_PDATE = (select max(EVAL_PDATE) FROM BULL_EVL_TABLE where  ANIM_KEY = @ANIM_KEY with UR);
      SET v_EVAL_BREED_CODE = (SELECT EVAL_BREED_CODE  FROM BULL_EVL_TABLE where  ANIM_KEY = @ANIM_KEY AND EVAL_PDATE = v_EVAL_PDATE with UR);
      
      
    ELSEIF  @SEX_CODE ='F' THEN 
      SET v_EVAL_PDATE = (select max(EVAL_PDATE) FROM COW_EVL_TABLE where  ANIM_KEY = @ANIM_KEY with UR );
      SET v_EVAL_BREED_CODE = (SELECT EVAL_BREED_CODE  FROM COW_EVL_TABLE where  ANIM_KEY = @ANIM_KEY AND EVAL_PDATE = v_EVAL_PDATE with UR);
    END IF;
	
 	-- Get animal information
     

  BEGIN
	
	DECLARE cur0 CURSOR WITH RETURN FOR
		SELECT 
		v_ROOT_ANIM_ID as ROOT_ANIMAL_ID
		,v_ROOT_ANIM_ID  AS ANIMAL_ID
	    ,@INT_ID AS PREFERED_ID
		,trim(aname.ANIM_NAME) AS LONG_NAME
		,aiCode.BULL_SHORT_NAME AS SHORT_NAME
		,VARCHAR_FORMAT(DEFAULT_DATE+ ped.BIRTH_PDATE,'YYYY-MM-DD')  as BIRTH_DATE
		,ped.SEX_CODE AS SEX
		,ped.MULTI_BIRTH_CODE AS MBC
		,id.REGIS_STATUS_CODE AS  REG
		,ped.SOURCE_CODE AS SRC
		,VARCHAR_FORMAT(DEFAULT_DATE+ped.MODIFY_PDATE,'YYYY-MM-DD') as MODIFY_DATE
		,ressive.RECESSIVE_CODE_SEG AS RECESSIVES
		,CASE WHEN animalAlias.INT_ID IS NULL THEN 'N'
		      ELSE 'Y' 
		 END  AS HAS_CROSS_REFERENCE 
		,coalesce(v_EVAL_BREED_CODE,'N/A') as EVAL_BREED
		,coalesce(VARCHAR_FORMAT(DEFAULT_DATE + v_EVAL_PDATE,'Month YYYY'),'N/A') AS RUN_NAME
		FROM   
		(
		  SELECT * 
		  FROM ID_XREF_TABLE 
		  WHERE ANIM_KEY = @ANIM_KEY
		  AND SPECIES_CODE = @SPECIES_CODE
		  AND INT_ID = @INT_ID
		  with UR
		)id
		  
		LEFT JOIN ANIM_NAME_TABLE aname 
			ON aname.INT_ID = @INT_ID 
			AND aname.SEX_CODE  = @SEX_CODE
			AND aname.SPECIES_CODE  = @SPECIES_CODE
		LEFT JOIN AI_CODES_TABLE aiCode 
			ON aiCode.ANIM_KEY = @ANIM_KEY
		LEFT JOIN (SELECT DISTINCT INT_ID FROM SESSION.TmpAnimalLists_Alias WHERE INT_ID <> ALIAS_ID) animalAlias 
			ON animalAlias.INT_ID = @INT_ID  
	 	LEFT JOIN RECESSIVES_TABLE ressive 
		 	ON ressive.ANIM_KEY = @ANIM_KEY 
		 	and  ressive.SPECIES_CODE = @SPECIES_CODE 
		LEFT JOIN PEDIGREE_TABLE ped 
		  on  ped.ANIM_KEY = @ANIM_KEY
		  AND ped.SPECIES_CODE = @SPECIES_CODE 
		  with UR
	   ;
   OPEN cur0;
    
    END;
 
 
  begin
		 	DECLARE cursor3 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID ,
					INT_ID AS ANIMAL_ID,
					ALIAS_ID,
					ALIAS_NAME,
					MODIFY_DATE,
					REG_CODES,
					SEX
		 	FROM SESSION.TmpAnimalLists_Alias
		 	WHERE INT_ID <> ALIAS_ID
		 	with UR;
		    
		    OPEN cursor3;
	   end;
	   
     
END

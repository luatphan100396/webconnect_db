CREATE OR REPLACE PROCEDURE usp_Get_5first_Generation_Pedigrees
--=================================================================
--Author: Tuyen Nguyen
--Created Date: 2021-01-21
--Description: Get information of ancestor( 3 generations)
--Output: 
--        +Ds1: Ancestor information(ROOT_ANIMAL_ID,ANIMAL_ID,SIRE_INT_ID,DAM_INT_ID,SEX_CODE,GENERATION,BIRTH_DATE,LONG_NAME,GENOTYPED,SRC,IS_EXIST,INPUT)
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
	DECLARE TEMPLATE_NAME			VARCHAR(200) ; 
	DECLARE LAST_ROW_ID 		    INT;
    DECLARE DEFAULT_DATE DATE;
	  
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1);
	-- Get list animal id
 
 	
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
	    ROOT_ANIMAL_ID     CHAR(17),
		ANIMAL_ID          CHAR(17),
		SIRE_INT_ID        CHAR(17),		 
		DAM_INT_ID		   CHAR(17),	
		SEX_CODE           CHAR(1),	
		GENERATION 	       INT NULL,
		BIRTH_DATE         CHAR(10),
		LONG_NAME          CHAR(30), 
		Genotyped          CHAR(1),  
		IS_EXIST           CHAR(1),
		SRC                CHAR(1),
		ROW_ID 			   INT GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1),
		INPUT               varchar(128)
	
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.animals
	   (
         ANIM_KEY INT NULL
        ,SEX_CODE CHAR(1)
        ,SPECIES_CODE CHAR(1)
		,SIRE_KEY INT NULL
		,DAM_KEY INT NULL	
		,GENERATION INT NULL 
		,ROOT_ANIMAL_ID CHAR(17)
       
      )with replace
      on commit preserve rows;
      
      DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_ID_XREF_TABLE_CLEAN_DUP
	   (
        ANIM_KEY INT NULL
        ,INT_ID CHAR(17)
		,SOURCE_CODE CHAR(1)
		  
      )with replace
      on commit preserve rows;
      
      
     
	DECLARE GLOBAL TEMPORARY TABLE SESSION.animal_0
	   (
        ANIM_KEY INT NULL
        ,SEX_CODE CHAR(1)
        ,SPECIES_CODE CHAR(1)
		,SIRE_KEY INT NULL
		,DAM_KEY INT NULL	
		,GENERATION INT NULL 
		,ROOT_ANIMAL_ID CHAR(17)
       
      )with replace
      on commit preserve rows;
      
      
      
	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmpPedGenotype
	   (
        ANIM_KEY INT NULL 
       
      )with replace
      on commit preserve rows;
      
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
 
	 
      --========================== Get first generation for export pedigree ==========================
INSERT INTO SESSION.animal_0 					
	SELECT a.ANIM_KEY
	    ,a.SEX_CODE
	    ,a.SPECIES_CODE
		,a.SIRE_KEY
		,a.DAM_KEY
		,0   
		,t.INT_ID				
	FROM  SESSION.TMP_INPUT t
	INNER JOIN PEDIGREE_TABLE  a
	ON t.ANIM_KEY = a.ANIM_KEY
	AND t.SPECIES_CODE = a.SPECIES_CODE 
	with UR;
	
  
	  call usp_Get_Animal_Pedigree();
	 
	 
	 INSERT INTO SESSION.tmpPedGenotype(ANIM_KEY)
	 SELECT DISTINCT t.ANIM_KEY
	 FROM SESSION.animals t
	 INNER JOIN GENOTYPE_TABLE geno ON t.ANIM_KEY = geno.ANIM_KEY  with UR ;
  
 
 
		
 INSERT INTO SESSION.TMP_ID_XREF_TABLE_CLEAN_DUP
 (ANIM_KEY,
 INT_ID,
 SOURCE_CODE
 )
 
 SELECT aID.ANIM_KEY,
	    aID.INT_ID,
	    aID.SOURCE_CODE 
 FROM
 	(
 	SELECT DISTINCT ANIM_KEY,SPECIES_CODE FROM SESSION.animals
 	UNION
 	SELECT DISTINCT SIRE_KEY,SPECIES_CODE FROM SESSION.animals
 	UNION
 	SELECT DISTINCT DAM_KEY,SPECIES_CODE FROM SESSION.animals
 	) t
	INNER JOIN ID_XREF_TABLE aID ON aID.ANIM_KEY = t.ANIM_KEY and aID.PREFERRED_CODE=1  AND aID.SPECIES_CODE = t.SPECIES_CODE
	with UR
	;
 
 
 INSERT INTO SESSION.TMP_RESULT
	(
	    ROOT_ANIMAL_ID,
	    ANIMAL_ID,
	    SIRE_INT_ID,
	    DAM_INT_ID,
		SEX_CODE,
		GENERATION,
		BIRTH_DATE,
		LONG_NAME,
		Genotyped,
		SRC,
		IS_EXIST,
		INPUT
	)
	SELECT     t.ROOT_ANIMAL_ID, 
                case when t.GENERATION =0 then t.ROOT_ANIMAL_ID 
                     else aID.INT_ID
                end as ANIMAL_ID,
				 sID.INT_ID as SIRE_INT_ID,
				 dID.INT_ID as DAM_INT_ID,
				 t.SEX_CODE,
				 t.GENERATION, 
			     VARCHAR_FORMAT(DEFAULT_DATE + a.BIRTH_PDATE,'YYYY-MM-DD') as BIRTH_DATE, 
			     trim(aname.ANIM_NAME) AS LONG_NAME, 
			     CASE WHEN geno.ANIM_KEY IS NULL THEN 'N'
		    		  ELSE 'Y' 
				 END  AS Genotyped,
	         	 a.SOURCE_CODE AS SRC,
				 CASE WHEN a.ANIM_KEY IS NULL THEN 'N'
		    		  ELSE 'Y' 
				 END  AS IS_EXIST,
				 i.INPUT
		 FROM SESSION.animals t
		 LEFT JOIN SESSION.TMP_INPUT i  
		 ON t.ANIM_KEY = i.ANIM_KEY
				AND t.SEX_CODE = i.SEX_CODE
				AND t.SPECIES_CODE = i.SPECIES_CODE
		 LEFT JOIN PEDIGREE_TABLE a ON t.ANIM_KEY = a.ANIM_KEY and t.SPECIES_CODE = a.SPECIES_CODE
		 LEFT JOIN SESSION.TMP_ID_XREF_TABLE_CLEAN_DUP aID ON aID.ANIM_KEY = t.ANIM_KEY  
		 LEFT JOIN SESSION.TMP_ID_XREF_TABLE_CLEAN_DUP sID ON sID.ANIM_KEY = t.SIRE_KEY  AND LENGTH(TRIM(sID.INT_ID))=17
		 LEFT JOIN SESSION.TMP_ID_XREF_TABLE_CLEAN_DUP dID ON dID.ANIM_KEY = t.DAM_KEY AND LENGTH(TRIM(dID.INT_ID))=17
		 LEFT JOIN ANIM_NAME_TABLE aname ON aname.INT_ID = aID.INT_ID AND t.SEX_CODE =aname.SEX_CODE
		 LEFT JOIN SESSION.tmpPedGenotype geno ON t.ANIM_KEY = geno.ANIM_KEY 
		 WHERE LENGTH(TRIM(aID.INT_ID))=17 
		 order by t.GENERATION with UR;
 
   BEGIN
  
    IF @IS_DATA_EXCHANGE ='0' THEN
		 BEGIN
			DECLARE cursor1  CURSOR WITH RETURN for
			
			 SELECT 
					
					    ROOT_ANIMAL_ID,
					    ANIMAL_ID,
					    SIRE_INT_ID,
					    DAM_INT_ID,
						SEX_CODE,
						GENERATION,
						BIRTH_DATE,
						LONG_NAME,
						Genotyped,
						SRC,
						IS_EXIST,
						INPUT
					
					FROM SESSION.TMP_RESULT;
				   
			OPEN cursor1;
		  
	    END;
	    
	    --- Data exchange
   ELSEIF @IS_DATA_EXCHANGE ='1' THEN
	
		   SET LAST_ROW_ID = (SELECT MAX(ROW_ID) FROM SESSION.TMP_RESULT); 
           SET TEMPLATE_NAME 	='ANIM_FORMATTED_5FIRST_GENERATION'; 
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
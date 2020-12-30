CREATE OR REPLACE PROCEDURE usp_get_5first_generation_of_one_animal
--=================================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get information of ancestor( 3 generations)
--Output: 
--        +Ds1: Ancestor information(id, name, sex, src, genotyped)
--=================================================================
(
    IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1) 
)
DYNAMIC RESULT SETS 3
 
BEGIN
    
    DECLARE DEFAULT_DATE DATE;
	  
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1);
	-- Get list animal id
 
 	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT
	(
		INT_ID char(17), 
	    ANIM_KEY INT, 
	    SPECIES_CODE char(1),
	    SEX_CODE char(1),
	    INT_ID_18 char(18),
	    ORDER int
	
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
--	
--	 --  Test performance on 2000 animals: note: need to revisit performance issue
--   INSERT INTO SESSION.TMP_INPUT
--	(  INT_ID,
--	   ANIM_KEY,
--	   SPECIES_CODE,
--	   SEX_CODE 
--   )
--   SELECT INT_ID,
--		ANIM_KEY,
--		SPECIES_CODE,
--		SEX_CODE 
--   FROM TEST_2000_ANIMALS 
--   ; 
	
	
	 
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
 
   BEGIN
  
    
    DECLARE cur0 CURSOR WITH RETURN FOR
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
	         	 a.SOURCE_CODE AS SRC ,
				 CASE WHEN a.ANIM_KEY IS NULL THEN 'N'
		    		  ELSE 'Y' 
				 END  AS IS_EXIST 
		 FROM SESSION.animals t 
		 LEFT JOIN PEDIGREE_TABLE a ON t.ANIM_KEY = a.ANIM_KEY and t.SPECIES_CODE = a.SPECIES_CODE
		 LEFT JOIN SESSION.TMP_ID_XREF_TABLE_CLEAN_DUP aID ON aID.ANIM_KEY = t.ANIM_KEY  
		 LEFT JOIN SESSION.TMP_ID_XREF_TABLE_CLEAN_DUP sID ON sID.ANIM_KEY = t.SIRE_KEY  AND LENGTH(TRIM(sID.INT_ID))=17
		 LEFT JOIN SESSION.TMP_ID_XREF_TABLE_CLEAN_DUP dID ON dID.ANIM_KEY = t.DAM_KEY AND LENGTH(TRIM(dID.INT_ID))=17
		 LEFT JOIN ANIM_NAME_TABLE aname ON aname.INT_ID = aID.INT_ID AND t.SEX_CODE =aname.SEX_CODE
		 LEFT JOIN SESSION.tmpPedGenotype geno ON t.ANIM_KEY = geno.ANIM_KEY 
		 WHERE LENGTH(TRIM(aID.INT_ID))=17 
		 order by t.GENERATION with UR;
	 OPEN cur0;
     END;
   
END

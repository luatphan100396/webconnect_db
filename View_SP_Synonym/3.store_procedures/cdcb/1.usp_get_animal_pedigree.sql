CREATE OR REPLACE PROCEDURE usp_Get_Animal_Pedigree
--=============================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-13
--Description: Get ancestor of animal (sire,dam) for 3 generations
--Output: 
--       +Ds1: Tempory table SESSION.animals which contains animal key, sex, species code, sire key, dam key
--==============================================================================================
()
BEGIN
 DECLARE GLOBAL TEMPORARY TABLE SESSION.animal_1(
							ANIM_KEY int NOT NULL
							,SEX_CODE CHAR(1)
							,SPECIES_CODE CHAR(1)
							,SIRE_KEY  int NULL
							,DAM_KEY int NULL	
							,GENERATION INT NULL
							,ROOT_ANIMAL_ID CHAR(17)
						)with replace
    				  on commit preserve rows;
    				   DECLARE GLOBAL TEMPORARY TABLE SESSION.animal_2(
							ANIM_KEY int NOT NULL
							,SEX_CODE CHAR(1)
							,SPECIES_CODE CHAR(1)
							,SIRE_KEY  int NULL
							,DAM_KEY int NULL	
							,GENERATION INT NULL
							,ROOT_ANIMAL_ID CHAR(17)
						)with replace
    				  on commit preserve rows;
    				  DECLARE GLOBAL TEMPORARY TABLE SESSION.animal_3(
							ANIM_KEY int NOT NULL
							,SEX_CODE CHAR(1)
							,SPECIES_CODE CHAR(1)
							,SIRE_KEY  int NULL
							,DAM_KEY int NULL	
							,GENERATION INT NULL
							,ROOT_ANIMAL_ID CHAR(17)
						)with replace
    				  on commit preserve rows;
    				  DECLARE GLOBAL TEMPORARY TABLE SESSION.animal_4(
							ANIM_KEY int NOT NULL
							,SEX_CODE CHAR(1)
							,SPECIES_CODE CHAR(1)
							,SIRE_KEY  int NULL
							,DAM_KEY int NULL	
							,GENERATION INT NULL
							,ROOT_ANIMAL_ID CHAR(17)
						)with replace
    				  on commit preserve rows;
    				   DECLARE GLOBAL TEMPORARY TABLE SESSION.animal_0_Parent(
							ANIM_KEY int NOT NULL,
							SEX_CODE CHAR(1),
							SPECIES_CODE CHAR(1),
							ROOT_ANIMAL_ID CHAR(17)
						)with replace
    				    on commit preserve rows;
							
						 DECLARE GLOBAL TEMPORARY TABLE SESSION.animal_1_Parent(
							ANIM_KEY int NOT NULL,
							SEX_CODE CHAR(1),
							SPECIES_CODE CHAR(1),
							ROOT_ANIMAL_ID CHAR(17)
						)with replace
    				    on commit preserve rows;
    				     DECLARE GLOBAL TEMPORARY TABLE SESSION.animal_2_Parent(
							ANIM_KEY int NOT NULL,
							SEX_CODE CHAR(1),
							SPECIES_CODE CHAR(1),
							ROOT_ANIMAL_ID CHAR(17)
						)with replace
    				    on commit preserve rows;
    				     DECLARE GLOBAL TEMPORARY TABLE SESSION.animal_3_Parent(
							ANIM_KEY int NOT NULL,
							SEX_CODE CHAR(1),
							SPECIES_CODE CHAR(1),
							ROOT_ANIMAL_ID CHAR(17)
						)with replace
    				    on commit preserve rows;
							
						  
	                	INSERT INTO SESSION.animal_0_Parent
						SELECT SIRE_KEY,'M',SPECIES_CODE, ROOT_ANIMAL_ID
						FROM SESSION.animal_0
						WHERE SIRE_KEY IS NOT NULL
						UNION
						SELECT DAM_KEY,'F',SPECIES_CODE,  ROOT_ANIMAL_ID
						FROM SESSION.animal_0
						WHERE DAM_KEY IS NOT NULL;
							
					 
						INSERT INTO SESSION.animal_1
						SELECT t.ANIM_KEY
					         	,a.SEX_CODE
					         	,a.SPECIES_CODE
								,SIRE_KEY
								,DAM_KEY
								,1 AS GENERATION  
								,ROOT_ANIMAL_ID
						FROM  SESSION.animal_0_Parent t
						LEFT JOIN PEDIGREE_TABLE a ON a.ANIM_KEY = t.ANIM_KEY and a.SPECIES_CODE = t.SPECIES_CODE;
						
						  
	                	INSERT INTO SESSION.animal_1_Parent
						SELECT SIRE_KEY, 'M',SPECIES_CODE,ROOT_ANIMAL_ID
						FROM SESSION.animal_1
						WHERE SIRE_KEY IS NOT NULL
						UNION
						SELECT DAM_KEY,'F' , SPECIES_CODE, ROOT_ANIMAL_ID
						FROM SESSION.animal_1
						WHERE DAM_KEY IS NOT NULL;
							
					 
						INSERT INTO SESSION.animal_2
						SELECT t.ANIM_KEY
								,a.SEX_CODE
								,a.SPECIES_CODE
								,SIRE_KEY
								,DAM_KEY
								,2 AS GENERATION  
								,ROOT_ANIMAL_ID
						FROM  SESSION.animal_1_Parent t
						LEFT JOIN PEDIGREE_TABLE a ON a.ANIM_KEY = t.ANIM_KEY 
						 and a.SPECIES_CODE = t.SPECIES_CODE
						with UR;
						
						INSERT INTO SESSION.animal_2_Parent
						SELECT SIRE_KEY, 'M',SPECIES_CODE,ROOT_ANIMAL_ID
						FROM SESSION.animal_2
						WHERE SIRE_KEY IS NOT NULL
						UNION
						SELECT DAM_KEY,'F' , SPECIES_CODE, ROOT_ANIMAL_ID
						FROM SESSION.animal_2
						WHERE DAM_KEY IS NOT NULL;
						
						INSERT INTO SESSION.animal_3
						SELECT t.ANIM_KEY
								,a.SEX_CODE
								,a.SPECIES_CODE
								,SIRE_KEY
								,DAM_KEY
								,3 AS GENERATION  
								,ROOT_ANIMAL_ID
						FROM  SESSION.animal_2_Parent t
						LEFT JOIN PEDIGREE_TABLE a ON a.ANIM_KEY = t.ANIM_KEY 
						 and a.SPECIES_CODE = t.SPECIES_CODE
						with UR;
						
						INSERT INTO SESSION.animal_3_Parent
						SELECT SIRE_KEY, 'M',SPECIES_CODE,ROOT_ANIMAL_ID
						FROM SESSION.animal_3
						WHERE SIRE_KEY IS NOT NULL
						UNION
						SELECT DAM_KEY,'F' , SPECIES_CODE, ROOT_ANIMAL_ID
						FROM SESSION.animal_3
						WHERE DAM_KEY IS NOT NULL;
						
						INSERT INTO SESSION.animal_4
						SELECT t.ANIM_KEY
								,a.SEX_CODE
								,a.SPECIES_CODE
								,SIRE_KEY
								,DAM_KEY
								,4 AS GENERATION  
								,ROOT_ANIMAL_ID
						FROM  SESSION.animal_3_Parent t
						LEFT JOIN PEDIGREE_TABLE a ON a.ANIM_KEY = t.ANIM_KEY 
						 and a.SPECIES_CODE = t.SPECIES_CODE
						with UR;
						
						
						 INSERT INTO SESSION.animals
						SELECT aGCurrent.ANIM_KEY, aGCurrent.SEX_CODE,aGCurrent.SPECIES_CODE, aGCurrent.SIRE_KEY, aGCurrent.DAM_KEY, aGCurrent.GENERATION, aGCurrent.ROOT_ANIMAL_ID 
						FROM SESSION.animal_1 aGCurrent
						LEFT JOIN SESSION.animal_0 rootAnimal on rootAnimal.ANIM_KEY = aGCurrent.ANIM_KEY;
						 
						 INSERT INTO SESSION.animals
						SELECT aGCurrent.ANIM_KEY, aGCurrent.SEX_CODE,aGCurrent.SPECIES_CODE, aGCurrent.SIRE_KEY, aGCurrent.DAM_KEY, aGCurrent.GENERATION, aGCurrent.ROOT_ANIMAL_ID 
						FROM SESSION.animal_2 aGCurrent
						LEFT JOIN SESSION.animal_0 rootAnimal on rootAnimal.ANIM_KEY = aGCurrent.ANIM_KEY;
						 
						  INSERT INTO SESSION.animals
						SELECT aGCurrent.ANIM_KEY, aGCurrent.SEX_CODE,aGCurrent.SPECIES_CODE, aGCurrent.SIRE_KEY, aGCurrent.DAM_KEY, aGCurrent.GENERATION, aGCurrent.ROOT_ANIMAL_ID 
						FROM SESSION.animal_3 aGCurrent
						LEFT JOIN SESSION.animal_0 rootAnimal on rootAnimal.ANIM_KEY = aGCurrent.ANIM_KEY;
						 
						  INSERT INTO SESSION.animals
						SELECT aGCurrent.ANIM_KEY, aGCurrent.SEX_CODE,aGCurrent.SPECIES_CODE, aGCurrent.SIRE_KEY, aGCurrent.DAM_KEY, aGCurrent.GENERATION, aGCurrent.ROOT_ANIMAL_ID 
						FROM SESSION.animal_4 aGCurrent
						LEFT JOIN SESSION.animal_0 rootAnimal on rootAnimal.ANIM_KEY = aGCurrent.ANIM_KEY;
						 
						 INSERT INTO SESSION.animals
						 
						SELECT ANIM_KEY, SEX_CODE, SPECIES_CODE, SIRE_KEY, DAM_KEY, 0,ROOT_ANIMAL_ID 
						FROM SESSION.animal_0;
						
			 
			 
 
END




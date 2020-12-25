CREATE OR REPLACE PROCEDURE usp_Get_Bull_Type_Evaluations
--========================================================================================================
--Author: Linh Pham
--Created Date: 2020-12-19
--Description: Get official bull evaluation data: type for one animal
--Output: 
--        +Ds: Type summary data: final score, stature, Strength...
--============================================================================================================
(
	IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1)
)
	DYNAMIC RESULT SETS 1
	
P1: BEGIN

		-- DECLARE VARIABLE
		DECLARE v_EVAL_PDATE SMALLINT;
		
		--DECLARE TEMP TABLE
		DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_INPUT --INPUT ALL PARAMETER TO TEMP TABLE
        (
                INT_ID CHAR(17),
                ANIM_KEY INT,
                SPECIES_CODE CHAR(1),
                SEX_CODE CHAR(1)
        )WITH REPLACE ON COMMIT PRESERVE ROWS;
        
        DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_type_traits
	   ( 
	   		TRAIT VARCHAR(50)
	   		
        )WITH REPLACE
		ON COMMIT PRESERVE ROWS;
		
		DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAnimalLists_BV_type_PIA -- drop table SESSION.TmpAnimalLists_BV_type_PIA 
	(
		ROOT_INT_ID CHAR(17),
		TRAIT varchar(128), 
		PTA decimal(10,2),
		REL smallint
	)with replace ON COMMIT PRESERVE ROWS;
		
		DECLARE GLOBAL TEMPORARY TABLE SESSION.tmp_type_bv
	   	(
	        INT_ID char(17),
	        FS_DAU_QTY int,
	        PTA1	smallint,
			PTA2	smallint,
			PTA3	smallint,
			PTA4	smallint,
			PTA5	smallint,
			PTA6	smallint,
			PTA7	smallint,
			PTA8	smallint,
			PTA9	smallint,
			PTA10	smallint,
			PTA11	smallint,
			PTA12	smallint,
			PTA13	smallint,
			PTA14	smallint,
			PTA15	smallint,
			PTA16	smallint,
			PTA17	smallint,
			REL1	smallint,
			REL2	smallint,
			REL3	smallint,
			REL4	smallint,
			REL5	smallint,
			REL6	smallint,
			REL7	smallint,
			REL8	smallint,
			REL9	smallint,
			REL10	smallint,
			REL11	smallint,
			REL12	smallint,
			REL13	smallint,
			REL14	smallint,
			REL15	smallint,
			REL16	smallint,
			REL17	smallint
        )with replace
      	on commit preserve rows;
      	
      	-- reset trait list by type PIA trait
      	
      	INSERT INTO SESSION.tmp_type_traits(TRAIT)
      	VALUES ('Final score'),
				('Stature'),
				('Strength'),
				('Dairy form'),
				('Foot angle'),
				('Rear legs (side view)'),
				('Body depth'),
				('Rump angle'),
				('Rump width'),
				('Fore udder attachment'),
				('Rear udder height'),
				('Rear udder width'),
				('Udder depth score'),
				('Udder cleft'),
				('Front teat placement'),
				('Teat length'),
				('Rear legs/Rear View');
		--SET VARIABLES
		SET v_EVAL_PDATE = (select PUBRUN_PDATE FROM ENV_VAR_TABLE LIMIT 1); 
		
		--INSERT TEMP TABLE
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
		
		--INSERT 200 animals
		
--		INSERT INTO SESSION.TMP_INPUT
--		(  
--			INT_ID,
--		   ANIM_KEY,
--		   SPECIES_CODE,
--		   SEX_CODE
--	   )
--	   SELECT INT_ID,
--			ANIM_KEY,
--			SPECIES_CODE,
--			SEX_CODE
--	   FROM TEST_2000_ANIMALS 
--	   ; 
		-- Get type bv
		
		--GET BULL_EVL_TABLE
		--INSERT TYPE
		INSERT INTO  SESSION.tmp_type_bv
		(
			       INT_ID,
			        FS_DAU_QTY,
		     		PTA1,
					PTA2,
					PTA3,
					PTA4,
					PTA5,
					PTA6,
					PTA7,
					PTA8,
					PTA9,
					PTA10,
					PTA11,
					PTA12,
					PTA13,
					PTA14,
					PTA15,
					PTA16,
					PTA17,
					REL1,
					REL2,
					REL3,
					REL4,
					REL5,
					REL6,
					REL7,
					REL8,
					REL9,
					REL10,
					REL11,
					REL12,
					REL13,
					REL14,
					REL15,
					REL16,
					REL17	
		)
			SELECT  
		     	inp.INT_ID,
				0 as FS_DAU_QTY,
			    bv.PTA1,
				bv.PTA2,
				bv.PTA3,
				bv.PTA4,
				bv.PTA5,
				bv.PTA6,
				bv.PTA7,
				bv.PTA8,
				bv.PTA9,
				bv.PTA10,
				bv.PTA11,
				bv.PTA12,
				bv.PTA13,
				bv.PTA14,
				bv.PTA15,
				bv.PTA16,
				bv.PTA17,
				bv.REL1,
				bv.REL2,
				bv.REL3,
				bv.REL4,
				bv.REL5,
				bv.REL6,
				bv.REL7,
				bv.REL8,
				bv.REL9,
				bv.REL10,
				bv.REL11,
				bv.REL12,
				bv.REL13,
				bv.REL14,
				bv.REL15,
				bv.REL16,
				bv.REL17		 
			FROM  SIRE_TYPE_TABLE bv
			INNER JOIN SESSION.TMP_INPUT inp
        	ON bv.ANIM_KEY = inp.ANIM_KEY 
        	AND bv.EVAL_PDATE = v_EVAL_PDATE
        	AND bv.SPECIES_CODE = inp.SPECIES_CODE
        	AND inp.SPECIES_CODE='0'
			WITH UR;
			
		INSERT INTO SESSION.TmpAnimalLists_BV_type_PIA 
		(
			ROOT_INT_ID,
			TRAIT,
			PTA,
			REL
		) 
		SELECT 
		tcv.INT_ID AS ROOT_INT_ID, 
		trait.TRAIT,
	 	case  when trait.TRAIT ='Final score'then tcv.PTA1
				 when trait.TRAIT ='Stature' then tcv.PTA2
				 when trait.TRAIT ='Strength' then tcv.PTA3
				 when trait.TRAIT ='Dairy form' then tcv.PTA4
				 when trait.TRAIT ='Foot angle'  then tcv.PTA5
				 when trait.TRAIT ='Rear legs (side view)'  then tcv.PTA6
				 when trait.TRAIT ='Body depth'  then tcv.PTA7
				 when trait.TRAIT ='Rump angle'  then tcv.PTA8
				 when trait.TRAIT ='Rump width' then tcv.PTA9
				 when trait.TRAIT ='Fore udder attachment'  then tcv.PTA10
				 when trait.TRAIT ='Rear udder height' then tcv.PTA11
				 when trait.TRAIT ='Rear udder width'  then tcv.PTA12
				 when trait.TRAIT ='Udder depth score'  then tcv.PTA13
				 when trait.TRAIT ='Udder cleft' then tcv.PTA14
				 when trait.TRAIT ='Front teat placement' then tcv.PTA15
				 when trait.TRAIT ='Teat length' then tcv.PTA16
				 when trait.TRAIT ='Rear legs/Rear View' then tcv.PTA17
				else null
		 	end as PTA,
		 	case  when trait.TRAIT ='Final score'then tcv.REL1
				 when trait.TRAIT ='Stature' then tcv.REL2
				 when trait.TRAIT ='Strength' then tcv.REL3
				 when trait.TRAIT ='Dairy form' then tcv.REL4
				 when trait.TRAIT ='Foot angle'  then tcv.REL5
				 when trait.TRAIT ='Rear legs (side view)'  then tcv.REL6
				 when trait.TRAIT ='Body depth'  then tcv.REL7
				 when trait.TRAIT ='Rump angle'  then tcv.REL8
				 when trait.TRAIT ='Rump width' then tcv.REL9
				 when trait.TRAIT ='Fore udder attachment'  then tcv.REL10
				 when trait.TRAIT ='Rear udder height' then tcv.REL11
				 when trait.TRAIT ='Rear udder width'  then tcv.REL12
				 when trait.TRAIT ='Udder depth score'  then tcv.REL13
				 when trait.TRAIT ='Udder cleft' then tcv.REL14
				 when trait.TRAIT ='Front teat placement' then tcv.REL15
				 when trait.TRAIT ='Teat length' then tcv.REL16
				 when trait.TRAIT ='Rear legs/Rear View' then tcv.REL17
				else null
		 	end as REL
	     FROM  SESSION.tmp_type_traits  trait
			  
		       INNER JOIN  
		       (
		        select t.*, row_number() over(partition by INT_ID order by FS_DAU_QTY desc) as RN
		        from SESSION.tmp_type_bv t
		       )
		       tcv 
		       ON tcv.RN=1 with UR;
	 
	  
	  UPDATE SESSION.TmpAnimalLists_BV_type_PIA  SET PTA = PTA/10.0;
	  
	  
	 --DS: Get animal BV type PIA
	     begin
		 	DECLARE cursor8 CURSOR WITH RETURN for
		 		
		 	SELECT ROOT_INT_ID AS ROOT_ANIMAL_ID,
					TRAIT,
					PTA,
					cast(cast(REL as int) || (case when REL is not null then '%' else '' end ) as varchar(30)) as REL
		 	FROM SESSION.TmpAnimalLists_BV_type_PIA 
		 	ORDER BY ROOT_INT_ID, CASE WHEN TRAIT = 	'Final score'	THEN	1
											WHEN TRAIT = 	'Stature'	THEN	2
											WHEN TRAIT = 	'Strength'	THEN	3
											WHEN TRAIT = 	'Dairy form'	THEN	4
											WHEN TRAIT = 	'Foot angle'	THEN	5
											WHEN TRAIT = 	'Rear legs (side view)'	THEN	6
											WHEN TRAIT = 	'Body depth'	THEN	7
											WHEN TRAIT = 	'Rump angle'	THEN	8
											WHEN TRAIT = 	'Rump width'	THEN	9
											WHEN TRAIT = 	'Fore udder attachment'	THEN	10
											WHEN TRAIT = 	'Rear udder height'	THEN	11
											WHEN TRAIT = 	'Rear udder width'	THEN	12
											WHEN TRAIT = 	'Udder depth score'	THEN	13
											WHEN TRAIT = 	'Udder cleft'	THEN	14
											WHEN TRAIT = 	'Front teat placement'	THEN	15
											WHEN TRAIT = 	'Teat length'	THEN	16
											WHEN TRAIT = 	'Rear legs/Rear View'	THEN	17 
									        ELSE 999
										END with UR;
		 	
		 	
		 
		 	OPEN cursor8;
	   end;
	   
END P1
CREATE OR REPLACE PROCEDURE usp_Get_Animal_Progeny_List
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
	IN @SEX_CODE char(1),
	in @is_export smallint default 0 
)
DYNAMIC RESULT SETS 10
    
BEGIN
   
	DECLARE DEFAULT_DATE varchar(10);  
	DECLARE EXPORT_PATH varchar(200);
    DECLARE EXPORT_FILE_NAME varchar(300); 
    DECLARE v_NUM_ROW int default 50; 
    
	DECLARE sql_query varchar(30000) default '';
	DECLARE C1 CURSOR WITH RETURN FOR D1; 
	  
	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmpProgenyList
	   (
        ANIM_KEY INT,
        SPECIES_CODE CHAR(1),
        BIRTH_PDATE smallint,
        SIRE_KEY INT,
        DAM_KEY INT,
        PGS_KEY INT,
        MGS_KEY INT,
        SOURCE_CODE char(1),
        MULTI_BIRTH_CODE char(1)
      )with replace
      on commit preserve rows;
      
      
	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmpProgenyGenotype
	   (
        ANIM_KEY INT NULL,
        GENOTYPE_ID_NUM char(18)
       
      )with replace
      on commit preserve rows;
      
    
	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmpProgenyGSstatus
	   (
        ANIM_KEY INT NULL,
        GS varchar(20)
       
      )with replace
      on commit preserve rows; 
      
	DECLARE GLOBAL TEMPORARY TABLE SESSION.tmpProgenyLactation
	   (
        ANIM_KEY INT NULL,
        HERD_CODE INT,
        CALV_PDATE smallint,
        LACT_NUM CHAR(1) 
      )with replace
      on commit preserve rows;
       
     SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
     
     set v_NUM_ROW = case when @is_export = 1 then 999999 else 50 end;  
		 
    -- Get progeny list      
		INSERT INTO SESSION.tmpProgenyList
		(
		 ANIM_KEY,
        SPECIES_CODE,
        BIRTH_PDATE,
        SIRE_KEY,
        DAM_KEY,
        MGS_KEY,
        PGS_KEY,
        SOURCE_CODE,
        MULTI_BIRTH_CODE
		)
		
		SELECT
			ped.ANIM_KEY,
	        ped.SPECIES_CODE,
	        ped.BIRTH_PDATE,
	        ped.SIRE_KEY,
	        ped.DAM_KEY,
	        pgs.SIRE_KEY AS PGS_KEY,
	        mgs.SIRE_KEY AS MGS_KEY,
	        ped.SOURCE_CODE,
	        ped.MULTI_BIRTH_CODE
		FROM
		(
			SELECT  ANIM_KEY,
	        SPECIES_CODE,
	        BIRTH_PDATE,
	        SIRE_KEY,
	        DAM_KEY,
	        SOURCE_CODE,
	        MULTI_BIRTH_CODE
			FROM PEDIGREE_TABLE 
			WHERE ( ( SIRE_KEY = @ANIM_KEY AND @SEX_CODE ='M') 
			      OR  ( DAM_KEY = @ANIM_KEY AND @SEX_CODE ='F') 
			      )
			      AND SPECIES_CODE = @SPECIES_CODE
			  
			ORDER BY BIRTH_PDATE limit v_NUM_ROW
		)ped
		LEFT JOIN PEDIGREE_TABLE pgs 
		    ON pgs.anim_key = ped.sire_key 
		    AND  pgs.SPECIES_CODE=0
		LEFT JOIN PEDIGREE_TABLE mgs 
		    ON mgs.anim_key = ped.dam_key 
		    AND  mgs.SPECIES_CODE=0
		WITH UR
		;
		
		
		
		-- Get progeny genotype
		 INSERT INTO SESSION.tmpProgenyGenotype(ANIM_KEY,GENOTYPE_ID_NUM)
		 SELECT DISTINCT t.ANIM_KEY, geno.GENOTYPE_ID_NUM
		 FROM  
		 (
		     SELECT ANIM_KEY
		     FROM SESSION.tmpProgenyList  
		     UNION
		     SELECT PGS_KEY
		     FROM SESSION.tmpProgenyList 
		     UNION
		     SELECT MGS_KEY
		     FROM SESSION.tmpProgenyList 
		 ) t
		 INNER JOIN GENOTYPE_TABLE geno ON t.ANIM_KEY = geno.ANIM_KEY  with UR ;
	  
 
		-- Get Grand sire status   
		 
		 INSERT INTO SESSION.tmpProgenyGSstatus
		 (ANIM_KEY,
		  GS
		 )
		   
		SELECT distinct tp.anim_key, 'Unlikely' as GS
		FROM SESSION.tmpProgenyList tp
		INNER JOIN SESSION.tmpProgenyGenotype tgeno 
			ON tp.ANIM_KEY = tgeno.ANIM_KEY
		INNER JOIN
		(
		   SELECT GENOTYPE_ID_NUM, CONFLICT_ID_NUM, CONFLICT_CODE, 'GENOTYPE_ID_NUM' as YourGenotype
		   FROM GENOTYPE_CONFLICTS_TABLE
		   UNION
		   SELECT CONFLICT_ID_NUM AS GENOTYPE_ID_NUM, GENOTYPE_ID_NUM AS CONFLICT_ID_NUM, CONFLICT_CODE, 'CONFLICT_ID_NUM' as YourGenotype
		   FROM GENOTYPE_CONFLICTS_TABLE
		   with UR
		)gCTable ON tgeno.GENOTYPE_ID_NUM =gCTable.GENOTYPE_ID_NUM   
		INNER  JOIN CONFLICT_TO_ERROR_CODE_XREF_TABLE cTECXTable ON   cTECXTable.CONFLICT_CODE = gCTable.CONFLICT_CODE
		INNER JOIN GENOMIC_ERROR_REF_TABLE gERTable 
		ON (gERTable.ERROR_CODE = cTECXTable.CONFLICT_ERROR_CODE and gCTable.YourGenotype ='CONFLICT_ID_NUM') 
		or (gERTable.ERROR_CODE = cTECXTable.GENOTYPE_ERROR_CODE and gCTable.YourGenotype ='GENOTYPE_ID_NUM') 
		WHERE gERTable.ERROR_CODE IN ('O6','O7')   ; -- MGS unlikely
		
		
		MERGE INTO SESSION.tmpProgenyGSstatus as A
		USING
		(
		   SELECT DISTINCT tp.ANIM_KEY
		   FROM SESSION.tmpProgenyList tp
		   INNER JOIN SESSION.tmpProgenyGenotype tgeno 
				ON tp.MGS_KEY = tgeno.ANIM_KEY
				OR tp.PGS_KEY = tgeno.ANIM_KEY
		) AS B
		ON A.ANIM_KEY = B.ANIM_KEY
		WHEN NOT MATCHED THEN
		INSERT
	    (
			ANIM_KEY,
			GS
		)
		VALUES
		(
			B.ANIM_KEY,
			'Likely' 
		) 
		;
		 
		 -- Get lactation detail for female progeny
		 
  
	INSERT INTO SESSION.tmpProgenyLactation
	(
		ANIM_KEY,
		HERD_CODE,
		CALV_PDATE,
		LACT_NUM 
	)  
	SELECT ANIM_KEY,
		HERD_CODE,
		CALV_PDATE,
		LACT_NUM 
	FROM
      (
      SELECT lact.ANIM_KEY,
	      lact.HERD_CODE,
	      lact.CALV_PDATE,
	      lact.LACT_NUM,
	      ROW_NUMBER()OVER(PARTITION BY lact.ANIM_KEY ORDER BY lact.CALV_PDATE DESC) AS RN
      
      FROM SESSION.tmpProgenyList prog_ped
      INNER JOIN LACTA90_TABLE lact
      ON lact.ANIM_KEY = prog_ped.ANIM_KEY
      WITH UR
      )lact
      WHERE RN=1
      ;
        
       set sql_query = '
      
                  SELECT 
						id.INT_ID, 
						'||case when @is_export = 0 then 'case when id.SEX_CODE =''M'' then ''Male''
															   when id.SEX_CODE =''F'' then ''Female''
														  end as SEX_DESC,' 
						        else ''
						   end
						||' 
						id.SEX_CODE,
						VARCHAR_FORMAT(cast('''||DEFAULT_DATE||''' as date) + prog_ped.BIRTH_PDATE,''YYYY-MM-DD'') as BIRTH_DATE,
						'||case when @SEX_CODE='M' then 'dam_id.INT_ID' else 'sire_id.INT_ID' end ||' as PARENT_ID,
						prog_ped.SOURCE_CODE,
						prog_ped.MULTI_BIRTH_CODE,
						CASE WHEN geno.ANIM_KEY IS NULL THEN ''N''    ELSE ''Y'' END  AS Genotyped,
						CASE WHEN tpMSstatus.ANIM_KEY IS NULL THEN ''Blanked''   ELSE tpMSstatus.GS   END  AS GS_Status,
						cast(lact.HERD_CODE as varchar(20)) AS HERD_CODE,
						VARCHAR_FORMAT(cast('''||DEFAULT_DATE||''' as date) + lact.CALV_PDATE,''YYYY-MM-DD'') as FRESH_DATE,
						cast(ASCII(lact.LACT_NUM) as varchar(5)) AS LACT_NUM
						
						'||case when @is_export =0 then '
						,ref_scr.DESCRIPTION as SOURCE_CODE_DESC
						,ref_mbc.DESCRIPTION as MULTI_BIRTH_CODE_DESC'
						        else ''
						   end     
						||'
						FROM SESSION.tmpProgenyList prog_ped
 					    INNER JOIN  id_xref_table id 
 							ON prog_ped.anim_key = id.anim_key
 							AND id.species_code= prog_ped.species_code
 							AND id.PREFERRED_CODE=1
 					    LEFT JOIN SESSION.tmpProgenyGSstatus tpMSstatus 
 					       	 ON tpMSstatus.ANIM_KEY = prog_ped.anim_key
 				    	LEFT JOIN
 				    	(
 				    	    SELECT DISTINCT ANIM_KEY
 				    	    FROM SESSION.tmpProgenyGenotype 
 				    	) geno
 						    ON geno.anim_key = prog_ped.anim_key
 						LEFT JOIN  SESSION.tmpProgenyLactation lact
 							ON lact.anim_key = prog_ped.anim_key 
 						'||
 						case when @is_export=0 then 
 						'LEFT JOIN REFERENCE_TABLE ref_scr
 						    ON ref_scr.type =''SOURCE_CODE'' 
 						    and ref_scr.CODE = prog_ped.SOURCE_CODE
 						 LEFT JOIN REFERENCE_TABLE ref_mbc
 						    ON ref_mbc.type =''MBC'' 
 						    and ref_mbc.CODE = prog_ped.MULTI_BIRTH_CODE'
 						     else ''
 						end
 						     
 						||'
 						'||case when @SEX_CODE='M' then '
 						LEFT JOIN  id_xref_table dam_id 
							ON prog_ped.dam_key = dam_id.anim_key
							AND dam_id.species_code=0
							AND length(trim(dam_id.int_id))=17
							AND dam_id.PREFERRED_CODE=1 ' 
							   else '
						LEFT JOIN  id_xref_table sire_id 
 							ON prog_ped.sire_key = sire_id.anim_key
 							AND sire_id.species_code=0
 							AND length(trim(sire_id.int_id))=17 
 							AND sire_id.PREFERRED_CODE=1' 
						  end ||' 
						
						order by  SEX_CODE DESC,  BIRTH_DATE  WITH UR

      ';
  	        
      -- Select Mode
  	  IF @is_export = 0 THEN 
  	  
  	     PREPARE D1 FROM  sql_query;
   	     OPEN C1;
   	     
   	  ELSE -- Export mode
  	        
        set sql_query = '  select ''Progeny ID'' as INT_ID,
								''Sex'' as SEX_CODE,
								''DOB'' as BIRTH_DATE, 
								'||case when @SEX_CODE='M' then '''Dam ID''' else '''Sire ID''' end ||'as PARENT_ID,
								''Source Code'' as SOURCE_CODE,
								''Multi-Birth Code'' as MULTI_BIRTH_CODE,
								''Genotyped'' as GENOTYPED,
								''Grandsire Status'' as GS_STATUS,
								''Herd code'' as HERD_CODE,
								''Fresh Date'' as FRESH_DATE,
								''Lactation Number'' as LACT_NUM 
						from sysibm.sysdummy1
						union all ' ||sql_query;
						
		   set EXPORT_PATH = (select string_value from dbo.constants where name ='Export_Folder');
		   set EXPORT_FILE_NAME =   'ProgenyList_'  ||(select varchar_format(current date,'YYYYMMDD') || replace(cast(current time as varchar(10)),':','') from sysibm.sysdummy1);
		   
		 
		  set EXPORT_FILE_NAME =  EXPORT_PATH||'/'||EXPORT_FILE_NAME||'.csv';
      
           call SYSPROC.ADMIN_CMD( 'export to '||EXPORT_FILE_NAME||' of DEL modified by NOCHARDEL 
  	  			 '||sql_query);
	  		
  		    begin
  		        declare cir cursor with return for
  		        select EXPORT_FILE_NAME from sysibm.sysdummy1;
  		        open cir;
  		    end;
      END IF; 
 	      
 
        
END
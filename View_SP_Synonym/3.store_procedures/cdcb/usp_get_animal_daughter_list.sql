CREATE OR REPLACE PROCEDURE usp_Get_Animal_Daughter_List
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-04
--Description: Get top 50 animal daughter 
--birth date, cross reference...
--Output: 
--        +Ds1: Daughter with eval breed, int_id, birht date, herds, heterosis%, calving, DIM, TC, Codes, Trl, Lact, Milk
--              Comp, MgtGp, YDm...

 
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
	    INT_ID CHAR(17),
        ANIM_KEY INT,
        SPECIES_CODE CHAR(1),
        SEX_CODE CHAR(1),
        BIRTH_PDATE int
      )with replace
      on commit preserve rows;
       
      -- Get constant value
      SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
      set v_NUM_ROW = case when @is_export = 1 then 999999 else 50 end;    
		 
    -- Get progeny list      
		INSERT INTO SESSION.tmpProgenyList
		(
		INT_ID,
        ANIM_KEY,
        SPECIES_CODE,
        SEX_CODE,
        BIRTH_PDATE
		)
		
		SELECT 
			id.INT_ID,
			id.ANIM_KEY,
			id.SPECIES_CODE,
			id.SEX_CODE,
			prog_ped.BIRTH_PDATE	 
		FROM 
		(
		SELECT
			ANIM_KEY,
	        SPECIES_CODE,
	        BIRTH_PDATE
		FROM PEDIGREE_TABLE 
			WHERE SIRE_KEY = @ANIM_KEY 
			      AND SPECIES_CODE = @SPECIES_CODE  
		WITH UR
		) prog_ped
		INNER JOIN  ID_XREF_TABLE id 
	 			ON prog_ped.anim_key = id.anim_key
	 			AND prog_ped.species_code = id.species_code  
	 			AND id.PREFERRED_CODE=1
	 			AND SEX_CODE ='F'
	 	ORDER BY BIRTH_PDATE limit v_NUM_ROW
 					 
		;
		 
		 -- Get lactation detail for female progeny
		 
		 set sql_query ='
		 SELECT 
								cow_bv.EVAL_BREED,   
								cow_bv.INT_ID,  
								VARCHAR_FORMAT(cast('''||DEFAULT_DATE||''' as date)+ cow_bv.BIRTH_PDATE,''YYYY-MM-DD'')  as BIRTH_DATE,
								case when trait.trait =''Fat'' then cow_bv.FIRST_HERD_CODE
 								     when trait.trait =''Prot'' and cow_bv.FIRST_HERD_CODE <> cow_bv.LAST_HERD_CODE then cow_bv.LAST_HERD_CODE
 								end  HERD_CODE,   
								float2char(nullif(trim(substring(cow_bv.line,366,3)),''''),1) as HETEROSIS_PCT,  
								VARCHAR_FORMAT(to_date(trim(nullif(nullif(substring(cow_bv.line,95,8),''''),''00000000'')),''YYYYMMDD''),''YYYY-MM-DD'') AS CALV_DATE,  
								float2char(nullif(trim(substring(cow_bv.line,103,3)),''''),1) as DIM,
								substring(cow_bv.line,106,1) as TERMINATION_CODE,
								TRIM( 
									CASE WHEN substring(cow_bv.line,113,1) =''1'' THEN ''R'' ELSE '''' END 
									||CASE WHEN substring(cow_bv.line,111,1) in (''0'',''2'') THEN '' '' 
									       WHEN  cow_bv.line is not null THEN ''A''
									       ELSE ''''
									   END 
									||CASE WHEN substring(cow_bv.line,107,1) <> ''0'' OR  substring(cow_bv.line,108,1) <> ''4'' THEN ''*'' ELSE '''' END 
								) as REC_CODE,
								substring(cow_bv.line,198,1) as NUM_LACT, 
 								float2char(nullif(trim(substring(cow_bv.line,214,5)),''''),1) as AVG_COMPOSITION_MILK, --AVG_STD_MILK
 								float2char(nullif(trim(substring(cow_bv.line,244,6)),''''),1) as YIELD_DEV_MILK, 
 								float2char(nullif(trim(substring(cow_bv.line,324,5)),''''),1) as CONTRIBUTE_TO_SIRE_MILK, 
 								float2char(nullif(trim(substring(cow_bv.line,123,5)),''''),1) as PTA_MILK,
 								trait.trait, 
 								case when trait.trait =''Fat'' then float2char(nullif(trim(substring(cow_bv.line,228,4)),''''),1)
 								     when trait.trait =''Prot'' then float2char(nullif(trim(substring(cow_bv.line,219,4)),''''),1)
 								end AVG_COMPOSITION_C, -- AVG_STD_FAT, AVG_STD_PROT
 								case when trait.trait =''Fat'' then float2char(nullif(trim(substring(cow_bv.line,203,3)),''''),1) 
 								     when trait.trait =''Prot'' then float2char(nullif(trim(substring(cow_bv.line,206,3)),''''),1)
 								end MGT_GRP,  
 								case when trait.trait =''Fat'' then float2char(nullif(trim(substring(cow_bv.line,250,5)),''''),1)
 								     when trait.trait =''Prot'' then float2char(nullif(trim(substring(cow_bv.line,261,5)),''''),1)
 								end YIELD_DEV_C,  
 								case when trait.trait =''Fat'' then FLOAT2CHAR(nullif(trim(substring(cow_bv.line,191,2)),'''')*0.1,0.1)
 								     when trait.trait =''Prot'' then FLOAT2CHAR(nullif(trim(substring(cow_bv.line,193,2)),'''')*0.1,0.1)
 								end WEIGHT,    
								case when trait.trait =''Fat'' then float2char(nullif(trim(substring(cow_bv.line,329,4)),''''),1)
 								     when trait.trait =''Prot'' then float2char(nullif(trim(substring(cow_bv.line,333,4)),''''),1)
 								end CONTRIBUTE_TO_SIRE_C,      
								case when trait.trait =''Fat'' then float2char(nullif(trim(substring(cow_bv.line,130,4)),''''),1)
 								     when trait.trait =''Prot'' then float2char(nullif(trim(substring(cow_bv.line,139,4)),''''),1)
 								end PTA_C 
 								'||case when @is_export =0 then '
 								,ref_termcode.DESCRIPTION AS TERM_CODE_DESCRIPTION
 								,ref_reccode.DESCRIPTION AS REC_CODE_DESCRIPTION'
 								        else ''
 								   end 
 								||'
 								'||case when @is_export =1 then ',2 as OrderBy'
 								        else ''
 								   end 
 								||'
								FROM
								(SELECT *
								 FROM (VALUES (''Fat'')
								             , (''Prot'')
								       ) t1 (trait)
                                )trait
								cross join
								(
									SELECT prog_ped.*,
									       substring(cow_bv.line,369,2)as EVAL_BREED,   
									       NULLIF(substring(cow_bv.line,87,8),''00000000'') as LAST_HERD_CODE, 
									       NULLIF(substring(cow_bv.line,167,8),''00000000'') as FIRST_HERD_CODE, 
									       case when substring(cow_bv.line,87,8) =''00000000'' then null 
									            else cow_bv.line
									        end as line
									FROM SESSION.tmpProgenyList prog_ped
			 					    LEFT JOIN  C19_eliteflat cow_bv ON prog_ped.INT_ID = substring(cow_bv.LINE,1,17) 
 					  
 					             )cow_bv
 					             
 					             '||
		 						case when @is_export=0 then 
		 						'LEFT JOIN REFERENCE_TABLE ref_termcode
		 						    ON ref_termcode.type =''TERM_CODE'' 
		 						    and ref_termcode.CODE = substring(cow_bv.line,106,1)
		 						 LEFT JOIN REFERENCE_TABLE ref_reccode
		 						    ON ref_reccode.type =''REC_CODE'' 
		 						    and ref_reccode.CODE = CASE WHEN substring(cow_bv.line,113,1) =''1'' THEN ''R'' ELSE '''' END'
		 						     else ''
		 						end
 						     
 								||'
 					    order by BIRTH_DATE, INT_ID,  trait 
 					   WITH UR
		 ';
		  
		  -- Select Mode
  	  IF @is_export = 0 THEN 
  	  
  	     PREPARE D1 FROM  sql_query;
    	     OPEN C1;
   	     
   	     
--   	      begin
--  		        declare cir1 cursor with return for
--  		        select sql_query from sysibm.sysdummy1;
--  		        open cir1;
--  		    end;
  		    
  		    
   	  ELSE -- Export mode
  	        
        set sql_query = '
        select 
						EVAL_BREED,
						INT_ID,
						BIRTH_DATE,
						HERD_CODE,
						HETEROSIS_PCT,
						CALV_DATE,
						DIM,
						TERMINATION_CODE,
						REC_CODE,
						NUM_LACT,
						AVG_COMPOSITION_MILK,
						YIELD_DEV_MILK,
						CONTRIBUTE_TO_SIRE_MILK,
						PTA_MILK,
						TRAIT,
						AVG_COMPOSITION_C,
						MGT_GRP,
						YIELD_DEV_C,
						WEIGHT,
						CONTRIBUTE_TO_SIRE_C,
						PTA_C
					from 
					(
						  
						select 
								''Eval Breed'' as EVAL_BREED,
								''Daughter ID'' as INT_ID,
								''DOB'' as BIRTH_DATE,
								''Herd'' as HERD_CODE,
								''Heterosis %'' as HETEROSIS_PCT,
								''Calving Date'' as CALV_DATE,
								''DIM'' as DIM,
								''Termination Code'' as TERMINATION_CODE,
								''Record Status Code'' as REC_CODE,
								''Lactation'' as NUM_LACT,
								''Milk'' as AVG_COMPOSITION_MILK,
								''YDm'' as YIELD_DEV_MILK,
								''ContBm'' as CONTRIBUTE_TO_SIRE_MILK,
								''PTAm'' as PTA_MILK,
								''Trait'' as TRAIT,
								''Composition'' as AVG_COMPOSITION_C,
								''Management Group'' as MGT_GRP,
								''YDc'' as YIELD_DEV_C,
								''Wt'' as WEIGHT,
								''ContBC'' as CONTRIBUTE_TO_SIRE_C,
								''PTAc'' as PTA_C,
								1 as OrderBy
						from sysibm.sysdummy1
						union all ' ||sql_query||'
						
				 ) 
 				order by  OrderBy, BIRTH_DATE, INT_ID,  trait 
 			   WITH UR
						';
		 
		 			
		   set EXPORT_PATH = (select string_value from dbo.constants where name ='Export_Folder');
		   set EXPORT_FILE_NAME =   'DaughterList_'  ||(select varchar_format(current date,'YYYYMMDD') || replace(cast(current time as varchar(10)),':','') from sysibm.sysdummy1);
		   
		 
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

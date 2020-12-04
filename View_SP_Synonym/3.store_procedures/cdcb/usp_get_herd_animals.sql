CREATE OR REPLACE PROCEDURE usp_Get_Herd_Animals
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-18
--Description: Get herd animals 
--Output: 
--        +Ds1: animal 17 chars, sex, birth date
--======================================================
( 
   IN @HERD_CODE INT
)
DYNAMIC RESULT SETS 2
    
BEGIN
   
	DECLARE DEFAULT_DATE DATE;
	DECLARE v_MIN_SAMPL_PDATE SMALLINT; 
	  
	  
	SET DEFAULT_DATE = (select STRING_VALUE FROM dbo.constants where name ='Default_Date_Value' LIMIT 1 with UR);
      
    
    -- Get alias
    
     begin
		 	DECLARE cursor3 CURSOR WITH RETURN for
		 	
				select  
						id.INT_ID,
						id.SEX_CODE,
						varchar_format(DEFAULT_DATE + ped.birth_pdate,'YYYY-MM-DD') as BIRTH_DATE 
				from anim_herd_current ahCur
				inner join id_xref_table id
					on ahCur.anim_key = id.anim_key
					and ahCur.species_code = id.species_code
					and id.preferred_code =1
					and ahCur.HERD_CODE = @HERD_CODE
				inner join pedigree_table ped
					on ped.anim_key = ahCur.anim_key
					and ped.species_code = ahCur.species_code
			    order by ped.birth_pdate
				with ur;
		    
		    OPEN cursor3;
	   end;
	   
	    
END
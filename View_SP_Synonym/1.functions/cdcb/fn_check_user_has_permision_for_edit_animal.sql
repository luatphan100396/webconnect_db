CREATE OR REPLACE FUNCTION fn_check_user_has_permision_for_edit_animal
--======================================================
--Author: Nghi Ta
--Created Date: 2021-01-12
--Description: Check whether login user has permission for edit animal
--======================================================
(	 
    IN @INT_ID char(17), 
	IN @ANIM_KEY INT, 
	IN @SPECIES_CODE char(1),
	IN @SEX_CODE char(1),
    IN @USER_NAME VARCHAR(128)
) 
RETURNS INTEGER

LANGUAGE SQL
BEGIN 
	DECLARE IS_EDITABLE SMALLINT DEFAULT 0;  
	DECLARE v_GROUP varchar(100);
	DECLARE v_SOURCE_CODE char(1);
 
	 
    select GROUP_SHORT_NAME
    into v_GROUP
    from 
    (
	    select USER_KEY from USER_ACCOUNT_TABLE 
	    WHERE lower(USER_NAME) = lower(@USER_NAME) limit 1
    )u
    INNER JOIN  USER_GROUP_TABLE ug
      on ug.USER_KEY = u.USER_KEY
    INNER JOIN GROUP_TABLE g
      on g.GROUP_KEY = ug.GROUP_KEY
    LIMIT 1; 
	
	select source_code
	into v_SOURCE_CODE
	from pedigree_table 
	where anim_key =  @ANIM_KEY
	      and species_code = @SPECIES_CODE limit 1;
	 
	
	select case when v_GROUP in ('BREED','CDCB') then 1
	            when v_GROUP ='NAAB' and v_SOURCE_CODE in ('N','R','I','H','D','C','A') then 1
	            when v_GROUP ='DRPC' and v_SOURCE_CODE in ('D','C','A')  then 1 
	            else 0
	       end
	into IS_EDITABLE
	from sysibm.sysdummy1;
	
	
	if IS_EDITABLE = 1 then
	
	    select fn_Check_Status_Changing_Animal(@INT_ID,@ANIM_KEY,@SPECIES_CODE,@SEX_CODE)
	    into  IS_EDITABLE from sysibm.sysdummy1;
	end if;
	 
	 
	RETURN IS_EDITABLE;
END
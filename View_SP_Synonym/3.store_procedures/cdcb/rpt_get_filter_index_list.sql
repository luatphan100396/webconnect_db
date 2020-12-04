CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Index_List
--================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-13
--Description: Get index list(defined by user)  
--Output: 
--       +Ds1: table with options used for filter animals
--=================================================================================
( )
  
  dynamic result sets 1
BEGIN
BEGIN 
			DECLARE cursor4  CURSOR WITH RETURN for
			    select INDEX_SHORT_NAME AS INDEX
				from index_table
				where index_short_name in ('NM$','FM$','CM$','GM$');
			OPEN cursor4;
			  
		END;
	  
END



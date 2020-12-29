 
CREATE OR REPLACE PROCEDURE usp_common_export_long_text (IN @text clob(2M), in export_file_name varchar(200))
--======================================================================================
--Author: Nghi Ta
--Created Date: 2020-06-25
--Description: Export long text
--Output: File location
--====================================================================================== 
BEGIN
	  
        call SYSPROC.ADMIN_CMD( 'export to '||export_file_name||' of DEL modified by NOCHARDEL 
      	  		                   select item from table (fn_Split_String_Into_Line('''||@text||'''))' );
 	  
END
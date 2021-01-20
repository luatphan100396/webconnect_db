CREATE OR REPLACE PROCEDURE usp_Get_Common_Component_Features
--====================================================================================
--Author: Linh Pham
--Created Date: 2020-01-07
--Description: Get Component Features use for add group administration
--Output: 
--       +Ds1: table with Component feature
--=======================================================================================
(
IN @SEARCH_BY varchar(10) -- 'Group,Role'
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
    set @SEARCH_BY = upper(@SEARCH_BY);
	
	begin
		-- Declare cursor
		DECLARE cursor1 CURSOR WITH RETURN for
		SELECT
			f.FEATURE_KEY, 
			fc.COMPONENT_KEY, 
			f.FEATURE_NAME, 
			fc.COMPONENT_NAME
		from FEATURE_COMPONENT_TABLE fc
		inner join TABLE(fn_Get_List_Feature(@SEARCH_BY)) f
			on fc.FEATURE_KEY = f.FEATURE_KEY 
		where (@SEARCH_BY ='GROUP' AND f.FEATURE_NAME ='Queries >> Cattle - Herd - Herd Info' AND fc.COMPONENT_NAME <>'Get Fee')
		      or (@SEARCH_BY ='GROUP' AND f.FEATURE_NAME <>'Queries >> Cattle - Herd - Herd Info')
		      or (@SEARCH_BY ='ROLE' AND f.FEATURE_NAME ='Queries >> Cattle - Herd - Herd Info' AND fc.COMPONENT_NAME ='Get Fee')
		      or (@SEARCH_BY ='ROLE' AND f.FEATURE_NAME <>'Queries >> Cattle - Herd - Herd Info' )
		order by f.FEATURE_NAME, fc.COMPONENT_NAME
		WITH UR; 
	
		-- Cursor left open for client application
		OPEN cursor1;
		
	end;
END P1
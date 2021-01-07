CREATE OR REPLACE PROCEDURE usp_Role_Search_Role 
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2020-01-05
--Description: Search_Role  
--Output: 
--       +Ds1: table with List Role
--=================================================================================
(
  IN @ROLE_NAME VARCHAR(100)
)

    
	DYNAMIC RESULT SETS 1
P1: BEGIN

	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
		SELECT 
		        row_number()over(order by ROLE_NAME) as No,
		        ROLE_SHORT_NAME,
				ROLE_NAME,
				ref.DESCRIPTION as STATUS
		FROM ROLE_TABLE r
		LEFT JOIN REFERENCE_TABLE ref
			on r.STATUS_CODE = ref.CODE
			and ref.TYPE ='STATUS_CODE'
		WHERE LOWER(ROLE_NAME) LIKE '%'||LOWER(@ROLE_NAME)||'%'
		ORDER BY ROLE_NAME
		WITH UR;
		OPEN cursor1;
	END;
	-- Cursor left open for client application
	

END P1
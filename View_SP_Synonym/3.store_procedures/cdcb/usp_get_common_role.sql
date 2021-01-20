CREATE OR REPLACE PROCEDURE usp_Get_Common_Role
--================================================================================
--Author: Linh Pham
--Created Date: 2020-01-06
--Description: Get List role  
--Output: 
--       +Ds1: table with options used for Management account
--=================================================================================
(
	@STATUS_CODE VARCHAR(1)
)
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT  
		trim(ROLE_SHORT_NAME) as ROLE_SHORT_NAME
		,trim(ROLE_NAME) as ROLE_NAME
		,ref.DESCRIPTION as STATUS
	FROM  ROLE_TABLE
	INNER JOIN REFERENCE_TABLE ref
			ON STATUS_CODE = ref.CODE
			AND ref.TYPE ='STATUS_CODE'
			AND (@STATUS_CODE IS NULL OR LOWER(@STATUS_CODE) = LOWER(STATUS_CODE))
	ORDER BY ROLE_SHORT_NAME
	WITH UR;
	OPEN cursor1;
END
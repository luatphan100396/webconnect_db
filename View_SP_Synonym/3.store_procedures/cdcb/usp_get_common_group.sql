CREATE OR REPLACE PROCEDURE usp_Get_Common_Group
--================================================================================
--Author: Linh Pham
--Created Date: 2020-01-06
--Description: Get List GROUP   
--Output: 
--       +Ds1: table with options used for search option, ACCOUNT MANAGEMENT
--=================================================================================
(
	@STATUS_CODE VARCHAR(1)
)
	DYNAMIC RESULT SETS 1
BEGIN
	DECLARE cursor1 CURSOR WITH RETURN for

	SELECT  
		trim(GROUP_SHORT_NAME) AS GROUP_SHORT_NAME
		,trim(GROUP_NAME) AS GROUP_NAME
		,ref.DESCRIPTION as STATUS
	FROM  GROUP_TABLE
	INNER JOIN REFERENCE_TABLE ref
			ON STATUS_CODE = ref.CODE
			AND ref.TYPE ='STATUS_CODE' 
	WHERE GROUP_SHORT_NAME NOT IN ('ADMIN','PUBLIC') 
	and (nullif(trim(@STATUS_CODE),'') IS NULL OR LOWER(@STATUS_CODE) = LOWER(STATUS_CODE))
	ORDER BY GROUP_SHORT_NAME
	WITH UR;
	OPEN cursor1; 
END
CREATE OR REPLACE PROCEDURE usp_Group_Search_Group
--================================================================================
--Author: Linh Pham
--Created Date: 2020-01-12
--Description: Get group list
--Output: 
--       +Ds1: table with group list use for Administration
--=================================================================================
(
	IN @GROUP_NAME VARCHAR(100)
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
	SELECT 
		 	row_number()over(order by GROUP_NAME) as No,
		        GROUP_SHORT_NAME,
				GROUP_NAME AS DESCRIPTION,
				ref.DESCRIPTION as STATUS
		FROM GROUP_TABLE gr
		LEFT JOIN REFERENCE_TABLE ref
		on gr.STATUS_CODE = ref.CODE
			and ref.TYPE ='STATUS_CODE'  
			WHERE LOWER(GROUP_NAME) LIKE '%'||LOWER(@GROUP_NAME)||'%'
		ORDER BY GROUP_NAME
		WITH UR;

	-- Cursor left open for client application
	OPEN cursor1;
END P1
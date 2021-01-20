CREATE OR REPLACE PROCEDURE usp_DRPC_Search_DRPC
--================================================================================
--Author: Tri Do
--Created Date: 2021-01-08
--Description: Search DRPC
--Output: 
--       +Ds1: list from search option
--       +Ds2: total records
--=================================================================================
(
	IN @name VARCHAR(40),
	IN @page_number INT,
	IN @row_per_page INT
)
	DYNAMIC RESULT SETS 10
P1: BEGIN

	BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for

		SELECT
		
			dSTable.DATA_SOURCE_KEY AS DATA_SOURCE_KEY
			,row_number()over(order by SOURCE_NAME) as No
			,trim(dSTable.SOURCE_SHORT_NAME) AS SOURCE_SHORT_NAME
			,trim(dSTable.SOURCE_NAME) AS SOURCE_NAME
			,trim(dSTable.STATUS_CODE) AS STATUS_CODE
			,ref.DESCRIPTION as STATUS
			,CASE WHEN uATable.DATA_SOURCE_KEY IS NOT NULL THEN '0'
					ELSE '1'
			END AS IS_DELETE
		FROM DATA_SOURCE_TABLE dSTable
		LEFT JOIN REFERENCE_TABLE ref
			ON dSTable.STATUS_CODE = ref.CODE
			AND ref.TYPE ='STATUS_CODE'
		LEFT JOIN 
		(
			SELECT DISTINCT DATA_SOURCE_KEY
			FROM USER_AFFILIATION_TABLE
		) uATable
				ON trim(uATable.DATA_SOURCE_KEY) = dSTable.DATA_SOURCE_KEY
		WHERE CLASS_CODE = 'D' AND STATUS_CODE IN ('A', 'S', 'I')
					AND (@name IS NULL
					 OR LOWER(trim(dSTable.SOURCE_SHORT_NAME)) LIKE '%'||LOWER(@name)||'%'
					 OR LOWER(trim(dSTable.SOURCE_NAME)) LIKE '%'||LOWER(@name)||'%')
		ORDER BY dSTable.SOURCE_NAME ASC
		LIMIT @row_per_page
		OFFSET (@page_number-1)*@row_per_page
		WITH UR;
		    
	-- Cursor left open for client application
	OPEN cursor1;
	END;

	BEGIN
		DECLARE cursor2 CURSOR WITH RETURN FOR 	
		SELECT count(1) as Num_Recs
		FROM DATA_SOURCE_TABLE dSTable
		WHERE CLASS_CODE = 'D' AND STATUS_CODE IN ('A', 'S', 'I')
					AND (@name IS NULL 
					OR LOWER(trim(dSTable.SOURCE_SHORT_NAME)) LIKE '%'||LOWER(@name)||'%'
					 OR LOWER(trim(dSTable.SOURCE_NAME)) LIKE '%'||LOWER(@name)||'%')
		WITH UR; 
	
	OPEN cursor2;
   	END;
END P1
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
	,IN @page_number int
	,IN @row_per_page int
)
	DYNAMIC RESULT SETS 2
P1: BEGIN
	BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
	SELECT 
		 	row_number()over(order by GROUP_NAME) as No,
		 	gr.GROUP_KEY,
	        gr.GROUP_SHORT_NAME,
			gr.GROUP_NAME AS DESCRIPTION,
			ref.DESCRIPTION as STATUS,
			case when ugr.GROUP_KEY IS NOT NULL then '0'
				 else '1'
		    end AS IS_DELETE
		FROM GROUP_TABLE gr
		LEFT JOIN REFERENCE_TABLE ref
			on gr.STATUS_CODE = ref.CODE
			and ref.TYPE ='STATUS_CODE'  
		LEFT JOIN  
		(
			select distinct GROUP_KEY
			from USER_GROUP_TABLE
		) ugr
			ON ugr.GROUP_KEY=gr.GROUP_KEY
			WHERE LOWER(GROUP_SHORT_NAME) LIKE '%'||LOWER(@GROUP_NAME)||'%'
		ORDER BY GROUP_NAME
		LIMIT @row_per_page
		OFFSET (@page_number-1)*@row_per_page
		WITH UR;

	-- Cursor left open for client application
	OPEN cursor1;
	END;
	
	BEGIN
	-- Declare cursor
	DECLARE cursor2 CURSOR WITH RETURN for
	SELECT 
		 	count(1) AS Num_Recs
		FROM GROUP_TABLE gr
		LEFT JOIN REFERENCE_TABLE ref
			on gr.STATUS_CODE = ref.CODE
			and ref.TYPE ='STATUS_CODE'  
		LEFT JOIN  
		(
			select distinct GROUP_KEY
			from USER_GROUP_TABLE
		) ugr
			ON ugr.GROUP_KEY=gr.GROUP_KEY
			WHERE LOWER(GROUP_SHORT_NAME) LIKE '%'||LOWER(@GROUP_NAME)||'%'
		WITH UR;
	-- Cursor left open for client application
	OPEN cursor2;
	END;
END P1
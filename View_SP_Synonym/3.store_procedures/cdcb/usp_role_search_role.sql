CREATE OR REPLACE PROCEDURE usp_Role_Search_Role 
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2021-01-05
--Description: Get List Role  
--Output: 
--       +Ds1: table with list role
--=================================================================================
(
  	IN @ROLE_NAME VARCHAR(100)
  	,IN @page_number int
	,IN @row_per_page int
)

    
	DYNAMIC RESULT SETS 3
P1: BEGIN
    
	
	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
		SELECT 
		        row_number()over(order by ROLE_NAME) as No,
				r.ROLE_KEY,
		        r.ROLE_SHORT_NAME,
				r.ROLE_NAME  AS DESCRIPTION,
				ref.DESCRIPTION as STATUS,
				case when ur.ROLE_KEY IS NOT NULL then '0' 
				     else '1'
				end as IS_DELETE 
		FROM ROLE_TABLE r
		LEFT JOIN REFERENCE_TABLE ref
			on r.STATUS_CODE = ref.CODE
			and ref.TYPE ='STATUS_CODE'
		LEFT JOIN (
		     select distinct ROLE_KEY
		     from USER_ROLE_TABLE  
		)ur
		    on ur.ROLE_KEY = r.ROLE_KEY
		WHERE LOWER(ROLE_SHORT_NAME) LIKE '%'||LOWER(@ROLE_NAME)||'%'
			OR LOWER(ROLE_NAME) LIKE '%'||LOWER(@ROLE_NAME)||'%'
		ORDER BY ROLE_NAME
		LIMIT @row_per_page
		OFFSET (@page_number-1)*@row_per_page
		WITH UR;
		OPEN cursor1;
	END;
	-- Cursor left open for client application
	BEGIN
		DECLARE cursor2 CURSOR WITH RETURN for
		SELECT 
		    count(1) AS Num_Recs
		FROM ROLE_TABLE r
		LEFT JOIN REFERENCE_TABLE ref
			on r.STATUS_CODE = ref.CODE
			and ref.TYPE ='STATUS_CODE'
		LEFT JOIN (
		     select distinct ROLE_KEY
		     from USER_ROLE_TABLE  
		)ur
		    on ur.ROLE_KEY = r.ROLE_KEY
		WHERE LOWER(ROLE_SHORT_NAME) LIKE '%'||LOWER(@ROLE_NAME)||'%'
			OR LOWER(ROLE_NAME) LIKE '%'||LOWER(@ROLE_NAME)||'%'
		WITH UR;
		OPEN cursor2;
	END;
	

END P1 
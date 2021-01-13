CREATE OR REPLACE PROCEDURE usp_Role_Search_Role 
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2021-01-05
--Description: Get List Role  
--Output: 
--       +Ds1: table with list role
--=================================================================================
(
  IN @ROLE_NAME VARCHAR(100),
  IN @page_number INT,
  IN @row_per_page INT
)

    
	DYNAMIC RESULT SETS 1
P1: BEGIN
    
	
	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
		SELECT 
		        row_number()over(order by ROLE_NAME) as No,
		        ROLE_SHORT_NAME,
				ROLE_NAME,
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
		WHERE LOWER(ROLE_NAME) LIKE '%'||LOWER(@ROLE_NAME)||'%'
		ORDER BY ROLE_NAME
		LIMIT @row_per_page
		OFFSET (@page_number-1)*@row_per_page
		WITH UR;
		OPEN cursor1;
	END;
	-- Cursor left open for client application
	

END P1 
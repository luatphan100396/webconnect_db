CREATE OR REPLACE PROCEDURE usp_Search_Animal_By_Herd_ID 
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2021-01-14
--Description: Get list herd id from string input
--Output:
--        +Ds1: invalid herd code
--        +Ds2: valid herd code
--=================================================================================
(
	IN @INPUT_VALUE VARCHAR(10000) 
	,@DELIMITER VARCHAR(1) default ','
)
	DYNAMIC RESULT SETS 3
	LANGUAGE SQL
BEGIN
	    
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInputs
	(	
		INPUT_VALUE VARCHAR(128),
		ORDER INT  GENERATED BY DEFAULT AS IDENTITY 
      (START WITH 1 INCREMENT BY 1)
	
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpHerdCodeLists   
	(   
	    HERD_CODE INT,
		ORDER INT
	) WITH REPLACE  ON COMMIT PRESERVE ROWS;
  
     
	   DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInputValid 
	(
		INPUT_VALUE varchar(128) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	INSERT INTO SESSION.TmpInputs(INPUT_VALUE)
	SELECT  ITEM FROM table(fn_Split_String (@INPUT_VALUE,@DELIMITER));
	
	-- Remove duplicate input
	MERGE INTO SESSION.TmpInputs as A
	 using
	 (
  
		 SELECT INPUT_VALUE, MIN(ORDER) AS MIN_ORDER
		 FROM SESSION.TmpInputs t	
		 GROUP BY INPUT_VALUE
		 with UR
	 )AS B
	 ON  A.INPUT_VALUE = B.INPUT_VALUE and A.ORDER <> B.MIN_ORDER 
	 WHEN MATCHED THEN
	 DELETE
	 ;
	  
	     -- Find matching animal id in id_xref_table
		INSERT INTO SESSION.TmpHerdCodeLists
		(
		    HERD_CODE,
			ORDER
		)
		  
		 SELECT 
		 ai.HERD_CODE,
		 t.ORDER
		 FROM  SESSION.TmpInputs t
		 INNER JOIN HERDOWNER_TABLE ai
		 on upper(t.INPUT_VALUE) = cast(ai.HERD_CODE as varchar(10))
		 ORDER BY ORDER
		 with UR;
		 
	-- DS1: output list
     	begin
		 	DECLARE cursor1 CURSOR WITH RETURN for
		 		
		 	SELECT 
		 	HERD_CODE,
		 	ORDER
		 	FROM SESSION.TmpHerdCodeLists 
		 	  
			ORDER BY ORDER with UR;
		  
		 	OPEN cursor1;
		 	 
	   end; 
	   
	  	-- DS2: invalid list
     	begin
		 	DECLARE cursor1_1 CURSOR WITH RETURN for
		 		
		 	SELECT DISTINCT i.INPUT_VALUE
		 	FROM SESSION.TmpInputs i
		 	LEFT JOIN SESSION.TmpInputValid valid
		 	ON i.INPUT_VALUE = valid.INPUT_VALUE
		 	WHERE valid.INPUT_VALUE IS NULL
		 	AND i.INPUT_VALUE <> '' with UR;
		 	OPEN cursor1_1;
		 	 
	   end;
	    
END 
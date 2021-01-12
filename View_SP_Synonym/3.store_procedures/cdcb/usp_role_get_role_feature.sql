CREATE OR REPLACE PROCEDURE usp_Role_Get_Role_Feature 
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2020-01-05
--Description: Clone Role  
--Output: 
--       +Ds1: Role Table
--       +Ds1: List Feature_Name
--       +Ds1: List Component_Name
--=================================================================================
(
   @v_ROLE_KEY INT
)
	DYNAMIC RESULT SETS 10
	

P1: BEGIN
    
    DECLARE err_message varchar(300);
    IF  @v_ROLE_KEY IS NULL 
	THEN 
	   set err_message = 'The role "'||@v_ROLE_KEY||'" does not exist';
 	   SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = err_message; 
	END IF;
	
	 BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
		
		SELECT DISTINCT f.FEATURE_KEY, 
		        f.FEATURE_NAME
		FROM ROLE_FEATURE_COMPONENT_TABLE rf
		INNER JOIN FEATURE_COMPONENT_TABLE fc
		    ON rf.COMPONENT_KEY = fc.COMPONENT_KEY
		    AND rf.ROLE_KEY = @v_ROLE_KEY
		INNER JOIN FEATURE_TABLE f
		    ON f.FEATURE_KEY = fc.FEATURE_KEY
		ORDER BY f.FEATURE_NAME
		  
			WITH UR;
			
			
		OPEN cursor1;
	END;
	
	BEGIN
		DECLARE cursor2 CURSOR WITH RETURN for
		
		SELECT DISTINCT fc.COMPONENT_KEY, 
		        fc.COMPONENT_NAME,
		        'All Field(s)' as TOTAL_FIELD
		FROM ROLE_FEATURE_COMPONENT_TABLE rf
		INNER JOIN FEATURE_COMPONENT_TABLE fc
		    ON rf.COMPONENT_KEY = fc.COMPONENT_KEY
		    AND rf.ROLE_KEY = @v_ROLE_KEY 
		 ORDER BY   fc.COMPONENT_NAME
			WITH UR;
		OPEN cursor2;
	END;
	
		
END P1 
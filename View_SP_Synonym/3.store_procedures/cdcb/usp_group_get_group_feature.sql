CREATE OR REPLACE PROCEDURE usp_Group_Get_Group_Feature 
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2020-01-13
--Description: Clone Group  
--Output: 
--       +Ds1: List Feature_Name
--       +Ds2: List Component_Name
--=================================================================================
(
   @v_GROUP_KEY INT
)
	DYNAMIC RESULT SETS 10
	

P1: BEGIN
    
    DECLARE err_message varchar(300);
    IF  @v_GROUP_KEY IS NULL 
	THEN 
	   set err_message = 'The group "'||@v_GROUP_KEY||'" does not exist';
 	   SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = err_message; 
	END IF;
	
	 BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
		
		SELECT DISTINCT f.GROUP_KEY, 
		        f.GROUP_NAME
		FROM GROUP_FEATURE_COMPONENT_TABLE rf
		INNER JOIN FEATURE_COMPONENT_TABLE fc
		    ON rf.COMPONENT_KEY = fc.COMPONENT_KEY
		    AND rf.GROUP_KEY = @v_GROUP_KEY
		INNER JOIN GROUP_TABLE f
		    ON f.GROUP_KEY = rf.GROUP_KEY
		ORDER BY f.GROUP_NAME
		  
			WITH UR;
			
			
		OPEN cursor1;
	END;
	
	BEGIN
		DECLARE cursor2 CURSOR WITH RETURN for
		
		SELECT DISTINCT fc.COMPONENT_KEY, 
		        fc.COMPONENT_NAME,
		        'All Field(s)' as TOTAL_FIELD
		FROM GROUP_FEATURE_COMPONENT_TABLE rf
		INNER JOIN FEATURE_COMPONENT_TABLE fc
		    ON rf.COMPONENT_KEY = fc.COMPONENT_KEY
		    AND rf.GROUP_KEY = @v_GROUP_KEY 
		 ORDER BY   fc.COMPONENT_NAME
			WITH UR;
		OPEN cursor2;
	END;
	
		
END P1 
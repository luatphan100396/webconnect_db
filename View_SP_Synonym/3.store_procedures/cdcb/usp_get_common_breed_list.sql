 
CREATE OR REPLACE PROCEDURE usp_Get_Common_Breed_List
--=================================================================================================
--Author: Linh Pham
--Created Date: 2020-12-14
--Description: Get breed list
--Output: 
--       +Ds1: Breed table with breed code and breed name for following breeds: AY,WW,JE,HO,MS,GU,BS
--================================================================================================
()
  
  dynamic result sets 1
BEGIN
    
	 -- breed list   
	BEGIN
		DECLARE cursor2  CURSOR WITH RETURN for
	    SELECT DISTINCT 
	    BREED_CODE, 
	    trim(BREED_NAME) as BREED_NAME
	    
	    FROM BREED_TABLE
	    WHERE BREED_CODE IN ('AY','WW','JE','HO','MS','GU','BS')
	    ORDER BY  BREED_CODE with UR;
	    
		OPEN cursor2;
		  
	END;
	 
END 
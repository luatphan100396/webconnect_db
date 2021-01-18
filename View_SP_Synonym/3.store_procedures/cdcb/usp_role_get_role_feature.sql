CREATE OR REPLACE PROCEDURE usp_Role_Get_Role_Feature 
--================================================================================
--Author: Tuyen Nguyen
--Created Date: 2020-01-13
--Description: Clone ROLE  
--Output: 
--       +Ds1: List Feature_Name
--       +Ds2: List Component_Name
--=================================================================================
(
   @v_ROLE_KEY INT
)
	DYNAMIC RESULT SETS 10
	

P1: BEGIN
    
    DECLARE err_message varchar(300);
    
    DECLARE GLOBAL TEMPORARY TABLE SESSION.Tmp_NON_RESTRICTED_FIELD_TOTAL 
	(
		ROLE_KEY INT,
		COMPONENT_KEY INT,
		NON_RESTRICTED_FIELD_TOTAL INT 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	 
    IF  @v_ROLE_KEY IS NULL 
	THEN 
	   set err_message = 'The Role "'||@v_ROLE_KEY||'" does not exist';
 	   SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = err_message; 
	END IF;
	
	INSERT INTO  SESSION.Tmp_NON_RESTRICTED_FIELD_TOTAL
	(  ROLE_KEY,
	   COMPONENT_KEY,
	   NON_RESTRICTED_FIELD_TOTAL 
	)
	select  c.ROLE_KEY,
		    f.COMPONENT_KEY, 
		    count(1) as NON_RESTRICTED_FIELD_TOTAL 
    from 
    (
	    select distinct f.COMPONENT_KEY, 
	                    gr.ROLE_KEY
	                     
	    from ROLE_RESTRICTED_FIELD_TABLE gr
	    inner join FIELD_TABLE f
	    on gr.FIELD_KEY = f.FIELD_KEY 
    )c
    inner join FIELD_TABLE f
        on f.COMPONENT_KEY = c.COMPONENT_KEY
    left join ROLE_RESTRICTED_FIELD_TABLE gr
        on gr.FIELD_KEY = f.FIELD_KEY
        AND gr.ROLE_KEY = c.ROLE_KEY
    where  gr.FIELD_KEY is null
    GROUP by c.ROLE_KEY, f.COMPONENT_KEY ;
	
	
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
		
		SELECT DISTINCT 
		        fc.FEATURE_KEY,
		        fc.COMPONENT_KEY, 
		        fc.COMPONENT_NAME,
		        case when nrf.ROLE_KEY is null then 'All Field(s)' 
		             else cast(coalesce(nrf.NON_RESTRICTED_FIELD_TOTAL,0) as varchar(10))||' Field(s)'
		        end as TOTAL_FIELD
		FROM ROLE_FEATURE_COMPONENT_TABLE rf
		INNER JOIN FEATURE_COMPONENT_TABLE fc
		    ON rf.COMPONENT_KEY = fc.COMPONENT_KEY
		    AND rf.ROLE_KEY = @v_ROLE_KEY 
		LEFT JOIN SESSION.Tmp_NON_RESTRICTED_FIELD_TOTAL nrf
		    ON nrf.ROLE_KEY =  rf.ROLE_KEY
		    AND rf.COMPONENT_KEY =  nrf.COMPONENT_KEY
		    
		    
		 ORDER BY   fc.COMPONENT_NAME
			WITH UR;
		OPEN cursor2;
	END;
	
	 BEGIN
		DECLARE cursor3 CURSOR WITH RETURN for
	  
		 
		SELECT field.COMPONENT_KEY,  
		       field.FIELD_KEY,
		       field.FIELD_NAME  
		FROM ROLE_FEATURE_COMPONENT_TABLE rf
		INNER JOIN FIELD_TABLE field 
		     ON rf.COMPONENT_KEY = field.COMPONENT_KEY
		     AND rf.ROLE_KEY = @v_ROLE_KEY 
		LEFT JOIN ROLE_RESTRICTED_FIELD_TABLE grf
		     ON grf.FIELD_KEY = field.FIELD_KEY
		     AND grf.ROLE_KEY = rf.ROLE_KEY
		 WHERE grf.FIELD_KEY IS NULL
		WITH UR;
			
			
		OPEN cursor3;
	END;
	
		
END P1 
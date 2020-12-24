CREATE OR REPLACE PROCEDURE usp_Get_Common_Reference_List
--====================================================================================
--Author: Linh Pham
--Created Date: 2020-12-14
--Description: Get code, description for SOURCE_CODE, MBC, TERM_CODE...
--Output: 
--       +Ds1: TYPE, CODE, DESCRIPTION
--=======================================================================================
(
  @MULTI_TYPE varchar(1000)
  ,@DELIMITER VARCHAR(1) default ','
)
  
  dynamic result sets 1
BEGIN

   	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInputs
	(	
		TYPE VARCHAR(128)  
	
	)WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
		
	INSERT INTO SESSION.TmpInputs(TYPE)
	SELECT  ITEM FROM table(fn_Split_String (@MULTI_TYPE,@DELIMITER));
    
	-- TRAIT list   
	BEGIN
		DECLARE cursor5  CURSOR WITH RETURN for
		
		select 
			r.TYPE, 
			r.CODE,
			trim(r.DESCRIPTION) as DESCRIPTION
		from SESSION.TmpInputs t
		inner join REFERENCE_TABLE r
		on t.type = r.type 
        order by TYPE, CODE;
		OPEN cursor5;
		  
	END;
END
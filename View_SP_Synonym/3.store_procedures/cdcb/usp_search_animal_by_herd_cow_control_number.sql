CREATE OR REPLACE PROCEDURE usp_Search_Animal_By_Herd_Cow_Control_Number
--=================================================================================================
--Author: Nghi Ta
--Created Date: 2020-05-12
--Description: Get list INT_ID from string input
--Output:
--        +Ds1: Table with animal id, animal key, species code, sex code, herd code, ctrl num, has error, 
--              is linked to animal 
--        +Ds2: Invalid item 
--=================================================================================================
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
	
	 
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpHerd_CtrlNum_List   
	(
		ANIM_KEY INT,
		INT_ID CHAR(17), 
		SEX_CODE char(1),
		SPECIES_CODE char(1),
		HERD_CODE int,
		CTRL_NUM int,
		ORDER INT
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
  
	   DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpInputValid 
	(
		INPUT_VALUE varchar(128) 
	)  WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
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
	  
		INSERT INTO SESSION.TmpHerd_CtrlNum_List
		(
			ANIM_KEY,
			INT_ID, 
			SEX_CODE,
			SPECIES_CODE, 
			HERD_CODE,
			CTRL_NUM, 
			ORDER
		)
		  
		 SELECT 
		 a.ANIM_KEY, 
		 a.INT_ID,  
		 a.SEX_CODE,
		 a.SPECIES_CODE, 
		 a.HERD_CODE,
		 a.CTRL_NUM, 
		 t.ORDER
		 FROM  SESSION.TmpInputs t
		 JOIN ANIM_KEY_HERD_CTRL_NUM a 
		     on upper(t.INPUT_VALUE) =  a.HERD_CODE ||' '|| a.CTRL_NUM
		     and length(replace(trim(a.INT_ID),' ',''))=17
		 LEFT JOIN ANIM_KEY_HAS_ERROR aHasErr 
		     on aHasErr.INT_ID = a.INT_ID 
		     and aHasErr.SPECIES_CODE = a.SPECIES_CODE 
		 with UR; 
		 
		 
		 INSERT INTO SESSION.TmpInputValid 
		 (
		 INPUT_VALUE
		 )
		 SELECT a.HERD_CODE ||' '|| a.CTRL_NUM as INPUT_VALUE
		 FROM SESSION.TmpHerd_CtrlNum_List a with UR;
		 
		 
		 --DS1: retrive data
     	begin
		 	DECLARE cursor0 CURSOR WITH RETURN for
		 		
		 	SELECT  
			a.INT_ID AS ANIMAL_ID,
		 	a.ANIM_KEY,
		 	a.SPECIES_CODE,
		 	a.SEX_CODE,
		 	a.HERD_CODE,
		 	a.CTRL_NUM,
		 	a.HERD_CODE||' '|| a.CTRL_NUM as HERD_CTRL_NUM,
			case when  aHasErr.INT_ID is not null then '1'
		      else '0' 
		    end as HAS_ERROR,
			case when  a.ANIM_KEY is not null then '1'
			      else '0' 
			end as IS_LINK_TO_ANIMAL, 
			a.ORDER
		 	FROM  SESSION.TmpHerd_CtrlNum_List a
		 	LEFT JOIN ANIM_KEY_HAS_ERROR aHasErr 
		     on aHasErr.INT_ID = a.INT_ID 
		     and aHasErr.SPECIES_CODE = a.SPECIES_CODE 
			ORDER BY a.ORDER, a.INT_ID
			 with UR;
		  
		 	OPEN cursor0;
		 	 
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


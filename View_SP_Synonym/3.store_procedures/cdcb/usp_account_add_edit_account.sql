 
CREATE OR REPLACE PROCEDURE usp_Account_Add_Edit_Account
--======================================================
--Author: Nghi Ta
--Created Date: 2020-12-30
--Description: Add new account
--Output:
--        +Ds1: 1 if success. Failed will raise exception
--======================================================
(
	@inputs VARCHAR(30000)
)
	DYNAMIC RESULT SETS 10
	LANGUAGE SQL
P1: BEGIN
	DECLARE input_xml XML;
	
	DECLARE v_FIRST_NAME VARCHAR(30);
	DECLARE v_LAST_NAME VARCHAR(50);
	DECLARE v_ORGANIZATION VARCHAR(200);
	DECLARE v_TITLE VARCHAR(200);
	DECLARE v_EMAIL_ADDRESS CHAR(200);
	DECLARE v_PHONE VARCHAR(30);
	DECLARE v_EMAIL_USE_IND VARCHAR(1);
	DECLARE v_USER_NAME VARCHAR(128);
	DECLARE v_PASSWORD VARCHAR(300) default '$2b$12$8msO26s5I97jouiWfxD2w.ani20E2NilK6yYqZBDP2E6Cp6gPn0qq'; 
	DECLARE v_STATUS_CODE CHAR(1);
	
	DECLARE v_USER_KEY int;
	
	--PERMISSION
	DECLARE v_GROUP VARCHAR(30); 
	
	
	DECLARE v_CURRENT_TIME TIMESTAMP; 
	DECLARE SQLCODE INTEGER DEFAULT 0; 
    DECLARE retcode INTEGER DEFAULT 0;
    DECLARE err_message varchar(300);
  
     
     
     
  --  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  --  SET retcode = SQLCODE; 
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpGetinputs 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(3000)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
 	
 	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFilterinputsMultiSelect 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(128),
		Order  smallint  GENERATED BY DEFAULT AS IDENTITY  (START WITH 1 INCREMENT BY 1)  
	) WITH REPLACE ON COMMIT PRESERVE ROWS; 
	
    DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpRoles
	(
		ROLE      VARCHAR(30)  
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
 	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAffiliates
	(
		SOURCE_SHORT_NAME      VARCHAR(30) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS; 
	 
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpAffiliatePermission 
	(
		SOURCE_SHORT_NAME   VARCHAR(30),
		PERMISSION CHAR(1)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.Tmp_DATA_SOURCE_TABLE
	(
		DATA_SOURCE_KEY INT,
		CLASS_CODE CHAR(1), 
		SOURCE_SHORT_NAME   varchar(30),
		STATUS_CODE char(1) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	 
	
    --- RETRIEVE INPUT
	SET input_xml =  xmlparse(document @inputs);
 
    INSERT INTO SESSION.TmpGetinputs 
		(    
			Field,
			Value
		)
		 SELECT  
				 nullif(trim(XML_BOOKS.Field),''),
				 nullif(trim(XML_BOOKS.Value),'')	 
		FROM  
			XMLTABLE(
				'$doc/inputs/item' 
				PASSING input_xml AS "doc"
				COLUMNS 
				 
				Field      VARCHAR(128)  PATH 'field',
				Value       VARCHAR(1000)  PATH 'value' 
				) AS XML_BOOKS;
			
	INSERT INTO SESSION.TmpFilterinputsMultiSelect 
		(    
			Field,
			Value
		)
	SELECT  
			 nullif(trim(XML_BOOKS.Field),'') as Field,
			 nullif(trim(XML_BOOKS.Value),'') as Value 
	FROM  
		XMLTABLE(
			'$doc/inputs/permission_info/multi_item/item' 
			PASSING input_xml AS "doc"
			COLUMNS 
			 
			Field      VARCHAR(128)  PATH 'field',
			Value       VARCHAR(1000)  PATH 'value' 
			) AS XML_BOOKS;
			
			
			
	SET v_FIRST_NAME = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='FRIST_NAME' LIMIT 1 with UR);
	SET v_LAST_NAME = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='LAST_NAME' LIMIT 1 with UR);
	SET v_ORGANIZATION = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='ORGANIZATION' LIMIT 1 with UR);
	SET v_TITLE = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='TITLE' LIMIT 1 with UR);
	SET v_EMAIL_ADDRESS = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='EMAIL_ADDRESS' LIMIT 1 with UR);
	SET v_PHONE = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='PHONE' LIMIT 1 with UR);
	SET v_EMAIL_USE_IND = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='INCLUDE_EMAIL' LIMIT 1 with UR);
 	SET v_USER_NAME = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='USER_NAME' LIMIT 1 with UR); 
 	SET v_STATUS_CODE = (SELECT VALUE FROM SESSION.TmpGetinputs WHERE UPPER(Field) ='STATUS_CODE' LIMIT 1 with UR); 
	
	SET v_CURRENT_TIME=(SELECT current timestamp  from sysibm.sysdummy1); 
	
	
	SET v_GROUP =  (   select value
	                   from 
							( SELECT  
										 nullif(trim(XML_BOOKS.Field),'') as Field,
										 nullif(trim(XML_BOOKS.Value),'') as Value 
								FROM  
									XMLTABLE(
										'$doc/inputs/permission_info/item' 
										PASSING input_xml AS "doc"
										COLUMNS 
										 
										Field      VARCHAR(128)  PATH 'field',
										Value       VARCHAR(1000)  PATH 'value' 
										) AS XML_BOOKS
							)a
						where upper(field) ='GROUP'
						limit 1
	);
	
	 INSERT INTO  SESSION.TmpRoles(ROLE)
	 select value 
	 from SESSION.TmpFilterinputsMultiSelect 
	 where upper(field) ='ROLE';
	 
	
	 INSERT INTO  SESSION.TmpAffiliates(SOURCE_SHORT_NAME)
	 select value 
	 from SESSION.TmpFilterinputsMultiSelect 
	 where upper(field) IN('DRPC','NOMINATOR','LAB');
						
	 	
		
     insert into SESSION.TmpAffiliatePermission 
     (
	     SOURCE_SHORT_NAME,
	     PERMISSION
     )				 
	 SELECT  
			 nullif(trim(XML_BOOKS.Field),'') as Field,
			 nullif(trim(XML_BOOKS.Value),'') as Value 
	 FROM  
		XMLTABLE(
			'$doc/inputs/permission_info/multi_item/item/permission/item' 
			PASSING input_xml AS "doc"
			COLUMNS 
			 
			Field      VARCHAR(128)  PATH 'field',
			Value       VARCHAR(1000)  PATH 'value' 
			) AS XML_BOOKS;
	   
	-- Clean duplicate on DATA_SOURCE_TABLE and insert data into temporary table
	DECLARE GLOBAL TEMPORARY TABLE SESSION.Tmp_DATA_SOURCE_TABLE
	(
		DATA_SOURCE_KEY INT,
		CLASS_CODE CHAR(1), 
		SOURCE_SHORT_NAME   varchar(30),
		STATUS_CODE char(1) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	    
	INSERT INTO SESSION.Tmp_DATA_SOURCE_TABLE
	(
		DATA_SOURCE_KEY,
		CLASS_CODE,
		SOURCE_SHORT_NAME,
		STATUS_CODE 
	)
	
	select DATA_SOURCE_KEY,
			CLASS_CODE,
			SOURCE_SHORT_NAME,
			STATUS_CODE
     from
	    (    select 
			        DATA_SOURCE_KEY,
					CLASS_CODE,
					SOURCE_SHORT_NAME,
					STATUS_CODE, 
					row_number()over(partition by SOURCE_SHORT_NAME order by  case when STATUS_CODE ='A' then 1
																			when STATUS_CODE ='S' then 2
																			when STATUS_CODE ='I' then 3
																			when STATUS_CODE ='D' then 4
																			else 999
																	   end)
			  as RN
    	  from DATA_SOURCE_TABLE 
    	)
    where RN=1;
	   
	   -- INPUT VALIDATION
		IF  v_FIRST_NAME IS NULL
			OR v_LAST_NAME IS NULL
			OR v_EMAIL_ADDRESS IS NULL
			OR v_USER_NAME IS NULL  
			OR v_GROUP IS NULL
			OR v_STATUS_CODE IS NULL
		THEN
		 
	 	 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = 'Input is not valid';
		
		END IF;
	  
	  
	-- Add/Edit user information
	set v_USER_KEY = ( select USER_KEY
                      from USER_ACCOUNT_TABLE 
                      where  lower(v_USER_NAME) = lower(USER_NAME)
                      limit 1 
                      ); 
 
	 --BEGIN work:
 
 BEGIN  
 
 
     DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
     SET retcode = SQLCODE;
     
		  MERGE INTO USER_INFO_TABLE as A
			 using
			 ( 
				 SELECT coalesce(v_USER_KEY,-999999) as USER_KEY
				 FROM sysibm.sysdummy1 
			 )AS B
			 ON  A.USER_KEY = B.USER_KEY 
			 WHEN NOT MATCHED THEN
			 INSERT
			(  
				 FIRST_NAME,
				 LAST_NAME,
				 EMAIL_ADDR,
				 ORGANIZATION,
				 STATUS_CODE,
				 TITLE,
				 PHONE,
				 EMAIL_USE_IND, 
				 CREATED_TIME,
				 MODIFIED_TIME  
			) 
			VALUES (
			     v_FIRST_NAME,
				 v_LAST_NAME,
				 v_EMAIL_ADDRESS,
				 v_ORGANIZATION,
				 v_STATUS_CODE,
				 v_TITLE,
				 v_PHONE,
				 v_EMAIL_USE_IND, 
				 v_CURRENT_TIME,
				 v_CURRENT_TIME  
			)
			WHEN MATCHED THEN UPDATE
			SET FIRST_NAME = 	v_FIRST_NAME,
				LAST_NAME = 	v_LAST_NAME,
				EMAIL_ADDR = 	v_EMAIL_ADDRESS,
				ORGANIZATION = 	v_ORGANIZATION,
				STATUS_CODE = 	v_STATUS_CODE,
				TITLE = 	v_TITLE,
				PHONE = 	v_PHONE,
				EMAIL_USE_IND = 	v_EMAIL_USE_IND, 
				MODIFIED_TIME = v_CURRENT_TIME
		;
			 
		   set v_USER_KEY = (select coalesce(max(user_key),v_USER_KEY) 
		                     from USER_INFO_TABLE 
						     where FIRST_NAME = v_FIRST_NAME 
						          and LAST_NAME = v_LAST_NAME
						          and EMAIL_ADDR = v_EMAIL_ADDRESS
						          and CREATED_TIME =  v_CURRENT_TIME  
			     );
			       
		   
		  MERGE INTO USER_ACCOUNT_TABLE as A
			 using
			 ( 
				 SELECT coalesce(v_USER_KEY,-999999) as USER_KEY
				 FROM sysibm.sysdummy1 
			 )AS B
			 ON  A.USER_KEY = B.USER_KEY 
			 WHEN NOT MATCHED THEN
			 INSERT
			(  
				 USER_KEY,
				USER_NAME,
				PASSWORD,
				CREATED_TIME,
				MODIFIED_TIME  
			) 
			VALUES (
			    v_USER_KEY,
				v_USER_NAME,
				v_PASSWORD,
				-- NULL,
			    v_CURRENT_TIME,
				v_CURRENT_TIME
			)
			WHEN MATCHED THEN UPDATE
			SET  
				USER_NAME = 	v_USER_NAME,
				PASSWORD = 	v_PASSWORD, 
				MODIFIED_TIME = v_CURRENT_TIME  
		;
			 
			 
		   /* Set user into group */
		    
		     MERGE INTO USER_GROUP_TABLE as A
			 using
			 ( 
				 select
		         v_USER_KEY AS USER_KEY,
		         g.GROUP_KEY 
			  from  GROUP_TABLE g
			  where upper(GROUP_SHORT_NAME) = v_GROUP limit 1  
			 )AS B
			 ON  A.USER_KEY = B.USER_KEY 
			 WHEN NOT MATCHED THEN
			 INSERT
			(  
				USER_KEY,
				GROUP_KEY,
				CREATED_TIME,
				MODIFIED_TIME 
			) 
			VALUES (
			    B.USER_KEY,
				B.GROUP_KEY, 
				v_CURRENT_TIME,
				v_CURRENT_TIME
			)
			WHEN MATCHED THEN UPDATE
			SET  
				GROUP_KEY = B.GROUP_KEY, 
				MODIFIED_TIME = v_CURRENT_TIME  
		;
		  
			 
		   
		         
		 DELETE FROM USER_ROLE_TABLE u 
		 WHERE ROLE_KEY NOT IN (select r.ROLE_KEY  
								from SESSION.TmpRoles t
								inner join ROLE_TABLE r
							        on t.ROLE = r.ROLE_SHORT_NAME 
		                     ) 
		        and u.USER_KEY = v_USER_KEY;
		 
		  
			MERGE INTO USER_ROLE_TABLE as A
			 using
			 ( 
				   select
			         v_USER_KEY AS USER_KEY,
			         r.ROLE_KEY 
				  from SESSION.TmpRoles t
				  inner join ROLE_TABLE r
				      on t.ROLE = r.ROLE_SHORT_NAME
			 )AS B
			 ON  A.USER_KEY = B.USER_KEY AND A.ROLE_KEY = B.ROLE_KEY 
			 WHEN NOT MATCHED THEN
			 INSERT
			(  
				USER_KEY,
				ROLE_KEY,
				CREATED_TIME,
				MODIFIED_TIME 
			) 
			VALUES (
			    B.USER_KEY,
				B.ROLE_KEY, 
				v_CURRENT_TIME,
				v_CURRENT_TIME
			)
			WHEN MATCHED THEN UPDATE
			SET    
				MODIFIED_TIME = v_CURRENT_TIME  
		    ;
			  
			   
			 
			/*  Update user affiliations  */
			  
			DELETE FROM USER_AFFILIATION_TABLE u 
		    WHERE DATA_SOURCE_KEY NOT IN (select r.DATA_SOURCE_KEY  
										  from SESSION.TmpAffiliates t
										  inner join SESSION.Tmp_DATA_SOURCE_TABLE r
									      on t.SOURCE_SHORT_NAME = r.SOURCE_SHORT_NAME 
		                     ) 
		        and u.USER_KEY = v_USER_KEY;
		    
					
					
		        
			 MERGE INTO USER_AFFILIATION_TABLE as A
				 using
				 ( 
					  SELECT v_USER_KEY AS USER_KEY
					       ,s.DATA_SOURCE_KEY
						  ,max(case when  p.PERMISSION='R' then 1
						            else 0 
						   end) as READ_PERMISSION
					      ,max(case when  p.PERMISSION='W' then 1
						            else 0 
						   end) as WRITE_PERMISSION 
				 
					FROM SESSION.TmpAffiliates a
					inner join SESSION.Tmp_DATA_SOURCE_TABLE s
					   on a.SOURCE_SHORT_NAME = s.SOURCE_SHORT_NAME
					left JOIN SESSION.TmpAffiliatePermission p
					   on a.source_short_name = p.source_short_name 
					group by s.DATA_SOURCE_KEY
					
				 )AS B
				 ON  A.USER_KEY = B.USER_KEY  AND A.DATA_SOURCE_KEY = B.DATA_SOURCE_KEY 
				 WHEN NOT MATCHED THEN
				 INSERT
				(  
					  USER_KEY,
					  DATA_SOURCE_KEY,
					  READ_PERMISSION,
					  WRITE_PERMISSION,
					  CREATED_TIME,
					  MODIFIED_TIME 
				) 
				VALUES (
					   B.USER_KEY,
					   B.DATA_SOURCE_KEY,
					   B.READ_PERMISSION,
					   B.WRITE_PERMISSION, 
					   v_CURRENT_TIME,
					   v_CURRENT_TIME
				)
				WHEN MATCHED THEN UPDATE
				SET   
					READ_PERMISSION = 	B.READ_PERMISSION,
					WRITE_PERMISSION = 	B.WRITE_PERMISSION,  
					MODIFIED_TIME = v_CURRENT_TIME 
			;
			 
			   
		END;
			 
	  	     IF retcode < 0 THEN 
				ROLLBACK  ;  
				
				 SET err_message = (SELECT SYSPROC.SQLERRM (cast(retcode as varchar(20))) FROM SYSIBM.SYSDUMMY1); 
				 SIGNAL SQLSTATE '65000' SET MESSAGE_TEXT = err_message;
				 
			 ELSE 
				COMMIT ; 
				
				     
					
					BEGIN
						DECLARE cursor1 CURSOR WITH RETURN for
						SELECT  1 AS RESULT 
						FROM sysibm.sysdummy1;
					 
						OPEN cursor1;
					END;
					
					
			 END IF ;  
END P1 

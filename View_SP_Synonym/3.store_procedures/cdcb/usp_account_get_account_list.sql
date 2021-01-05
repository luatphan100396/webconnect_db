CREATE OR REPLACE PROCEDURE usp_Account_Get_Account_List
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-31
--Description: Get Account list
--Output:
--        +Ds1: list from search option
--======================================================
(
	@Inputs VARCHAR(30000)
	,IN @page_number int
	,IN @row_per_page int
)
	DYNAMIC RESULT SETS 10
P1: BEGIN
	DECLARE input_xml XML;
	DECLARE v_SEARCH_BY VARCHAR(128);
	DECLARE v_GROUP VARCHAR(128);
	DECLARE v_COUNT_ROLE INT;
	DECLARE v_COUNT_NOMINATOR INT;
	DECLARE LAST_LOGIN INT;
	
	--DECLARE TEMPLATE
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpGetInputs 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(3000)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	 DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpFilterInputsMultiSelect 
	(
		Field      VARCHAR(128),
		Value       VARCHAR(128) 
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpRoles 
	(
		ROLE  VARCHAR(50)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpNominator 
	(
		NOMINATOR  VARCHAR(50)
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpListUser 
	( 
		USER_KEY INT 
		
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpListRoleUser 
	( 
		USER_KEY INT,
		ROLE VARCHAR(1000) 
		
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpListNominatorUser 
	( 
		USER_KEY INT,
		NOMINATOR VARCHAR(1000) 
		
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpListLabUser 
	( 
		USER_KEY INT,
		LAB VARCHAR(1000) 
		
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	
	
	DECLARE GLOBAL TEMPORARY TABLE SESSION.TmpListDRPCUser 
	( 
		USER_KEY INT,
		DRPC VARCHAR(1000) 
		
	) WITH REPLACE ON COMMIT PRESERVE ROWS;
	--INSERT TEMP TABLE
	SET input_xml =  xmlparse(document @Inputs);
	SET LAST_LOGIN= (SELECT  MAX(ID) FROM USER_VISIT_HISTORY_TABLE WHERE ID>1);
		
		
	----- insert
	INSERT INTO SESSION.TmpGetInputs 
	(    
		Field,
		Value
	)
	 SELECT  
	 		nullif(trim(XML_BOOKS.field),''),
	 		nullif(trim(XML_BOOKS.value),'')	 
	FROM  
		XMLTABLE(
				'$doc/inputs/item' 
				PASSING input_xml AS "doc"
				COLUMNS 
				 
				Field      VARCHAR(128)  PATH 'field',
				Value       VARCHAR(3000)  PATH 'value' 
				) AS XML_BOOKS;
	
	INSERT INTO SESSION.TmpFilterInputsMultiSelect 
	(    
		Field,
		Value 
	)
	  SELECT  
			nullif(trim(XML_BOOKS.field),''),
		    nullif(trim(XML_BOOKS.value),'')	 	 
			FROM  
			XMLTABLE(
			'$doc/inputs/multi_item/item' 
			PASSING input_xml AS "doc"
			COLUMNS 
			 
			Field      VARCHAR(128)  PATH 'field',
			Value       VARCHAR(3000)  PATH 'value' 
			) AS XML_BOOKS;  
     --SET VARIABLES
     
     SET v_SEARCH_BY= (SELECT lower(VALUE) FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='SEARCH_BY' LIMIT 1 with UR);
     SET v_GROUP = (SELECT VALUE FROM SESSION.TmpGetInputs WHERE UPPER(Field) ='GROUP' LIMIT 1 with UR);

	
	INSERT INTO SESSION.TmpRoles
	(
		ROLE
	)
	SELECT VALUE
   FROM SESSION.TmpFilterInputsMultiSelect
   WHERE FIELD ='ROLE';
   

   
   
   INSERT INTO SESSION.TmpNominator 
	(
		NOMINATOR
	)
	SELECT VALUE
   FROM SESSION.TmpFilterInputsMultiSelect
   WHERE FIELD ='NOMINATOR';
   
   SET v_COUNT_ROLE = (SELECT COUNT(1) FROM SESSION.TmpRoles);
   SET v_COUNT_NOMINATOR = (SELECT COUNT(1) FROM SESSION.TmpNominator);
 
	
	INSERT INTO SESSION.TmpListUser 
	(     
		USER_KEY 
	)
	 SELECT  
	 		uAccTable.USER_KEY 
	 		
	 	FROM USER_INFO_TABLE uInfoTable 
	 	INNER JOIN USER_ACCOUNT_TABLE uAccTable
	 		ON uAccTable.USER_KEY = uInfoTable.USER_KEY
		LEFT JOIN USER_GROUP_TABLE uGrTable
			ON uInfoTable.USER_KEY = uGrTable.USER_KEY 
		LEFT JOIN GROUP_TABLE gr
			ON	uGrTable.GROUP_KEY=gr.GROUP_KEY
		LEFT JOIN	
		(
		    select distinct ur.USER_KEY
		    from SESSION.TmpRoles t
		    inner join ROLE_TABLE r 
		   		 on lower(t.ROLE) = lower(trim(r.ROLE_SHORT_NAME))
		    inner join USER_ROLE_TABLE ur
		         on ur.ROLE_KEY = r.ROLE_KEY
		)ur
			ON ur.USER_KEY = uInfoTable.USER_KEY
		LEFT JOIN	
		(
		    select distinct ur.USER_KEY
		    from SESSION.TmpNominator t
		    inner join DATA_SOURCE_TABLE r 
		   		 on lower(t.NOMINATOR) = lower(trim(r.SOURCE_SHORT_NAME))
		    inner join USER_AFFILIATION_TABLE ur
		         on ur.DATA_SOURCE_KEY = r.DATA_SOURCE_KEY
		)uN
			ON uN.USER_KEY = uInfoTable.USER_KEY
		
		
		WHERE 	
		(v_SEARCH_BY IS NULL 
			  OR ( lower(trim(uAccTable.USER_NAME)) LIKE '%'||v_SEARCH_BY||'%'
					OR lower(trim(uInfoTable.EMAIL_ADDR)) LIKE '%'||v_SEARCH_BY||'%'
					OR lower(trim(uInfoTable.FIRST_NAME)) LIKE '%'||v_SEARCH_BY||'%'
					OR lower(trim(uInfoTable.ORGANIZATION)) LIKE '%'||v_SEARCH_BY||'%'
				)
		)
		AND (v_GROUP is null or lower(trim(gr.GROUP_SHORT_NAME))= lower(v_GROUP))
		AND (v_COUNT_ROLE = 0 or ur.USER_KEY is not null)
		AND (v_COUNT_NOMINATOR = 0 or uN.USER_KEY is not null)
 
		  
		WITH UR;	
		
		--SEARCH ROLE
	
	   INSERT INTO SESSION.TmpListRoleUser
	(    
		USER_KEY,
		ROLE
	)
	SELECT
		t.USER_KEY, 
		substr(xmlserialize(xmlagg(xmltext (chr(10)||trim(rl.ROLE_SHORT_NAME) ) order by rl.ROLE_SHORT_NAME) as VARCHAR(1000)),2)  as ROLE
	FROM SESSION.TmpListUser  t
	left JOIN USER_ROLE_TABLE uRTable
			ON t.USER_KEY = uRTable.USER_KEY 
		left JOIN ROLE_TABLE rl
			ON	uRTable.ROLE_KEY=rl.ROLE_KEY
		group by t.USER_KEY
		
		WITH UR;
		
	INSERT INTO SESSION.TmpListNominatorUser
	(    
		USER_KEY,
		NOMINATOR
	)
	SELECT
		t.USER_KEY, 
		substr(xmlserialize(xmlagg(xmltext (chr(10)||trim(r.SOURCE_NAME) ) order by r.SOURCE_NAME) as VARCHAR(1000)),2)  as NOMINATOR
	FROM SESSION.TmpListUser  t
	LEFT JOIN USER_AFFILIATION_TABLE ur
			ON t.USER_KEY = ur.USER_KEY 
	LEFT JOIN DATA_SOURCE_TABLE r 
		 	ON ur.DATA_SOURCE_KEY = r.DATA_SOURCE_KEY
	WHERE CLASS_CODE  = 'R'
		group by t.USER_KEY
		
		WITH UR;
		
	INSERT INTO SESSION.TmpListLabUser
	(    
		USER_KEY,
		LAB
	)
	SELECT
		t.USER_KEY, 
		substr(xmlserialize(xmlagg(xmltext (chr(10)||trim(r.SOURCE_NAME)) order by r.SOURCE_NAME) as VARCHAR(1000)),2)  as LAB
	FROM SESSION.TmpListUser  t
	LEFT JOIN USER_AFFILIATION_TABLE ur
			ON t.USER_KEY = ur.USER_KEY 
	LEFT JOIN DATA_SOURCE_TABLE r 
		 	ON ur.DATA_SOURCE_KEY = r.DATA_SOURCE_KEY
	WHERE CLASS_CODE  = 'L'
		group by t.USER_KEY
		
		WITH UR;
	INSERT INTO SESSION.TmpListDRPCUser
	(    
		USER_KEY,
		DRPC
	)
	SELECT
		t.USER_KEY, 
		substr(xmlserialize(xmlagg(xmltext (chr(10)||trim(r.SOURCE_NAME)) order by r.SOURCE_NAME) as VARCHAR(1000)),2)  as LAB
	FROM SESSION.TmpListUser  t
	LEFT JOIN USER_AFFILIATION_TABLE ur
			ON t.USER_KEY = ur.USER_KEY 
	LEFT JOIN DATA_SOURCE_TABLE r 
		 	ON ur.DATA_SOURCE_KEY = r.DATA_SOURCE_KEY
	WHERE upper(trim(SOURCE_SHORT_NAME)) in ('CA','WI','NC','UT') 
		group by t.USER_KEY
		
		WITH UR;
		
		
	
	BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
		
		SELECT 
			uAcc.USER_NAME,
			uInfo.FIRST_NAME,
			uInfo.LAST_NAME,
			uInfo.EMAIL_ADDR,
			uInfo.ORGANIZATION,
			gr.GROUP_SHORT_NAME,
			lRol.ROLE,
			lLab.LAB,
			lDRPC.DRPC,
			lNom.NOMINATOR,
			uInfo.STATUS_CODE,
			uvh.ACCESS_TIME
		FROM
		SESSION.TmpListUser t
		LEFT JOIN SESSION.TmpListRoleUser lRol
			ON t.USER_KEY= lRol.USER_KEY
		LEFT JOIN SESSION.TmpListNominatorUser lNom
			ON t.USER_KEY= lNom.USER_KEY
		LEFT JOIN SESSION.TmpListLabUser lLab
			ON t.USER_KEY= lLab.USER_KEY
		LEFT JOIN SESSION.TmpListDRPCUser lDRPC
			ON t.USER_KEY= lDRPC.USER_KEY
		LEFT JOIN USER_INFO_TABLE uInfo
			ON t.USER_KEY=uInfo.USER_KEY
		INNER JOIN USER_ACCOUNT_TABLE uAcc
			ON t.USER_KEY=uAcc.USER_KEY
		LEFT JOIN USER_GROUP_TABLE uG
			ON t.USER_KEY=uG.USER_KEY
		LEFT JOIN GROUP_TABLE gr
			ON uG.GROUP_KEY= gr.GROUP_KEY
		LEFT JOIN USER_VISIT_HISTORY_TABLE uvh
			ON uAcc.USER_KEY=uvh.USER_KEY
			AND uvh.ID=LAST_LOGIN
		LIMIT @row_per_page
		OFFSET (@page_number-1)*@row_per_page
		 
		WITH UR;
	-- Cursor left open for client application
	OPEN cursor1;
	END;
	BEGIN
	-- Declare cursor
	DECLARE cursor2 CURSOR WITH RETURN for
		SELECT 
			count(1) AS Num_Recs
		FROM
		SESSION.TmpListUser t
		LEFT JOIN SESSION.TmpListRoleUser lRol
			ON t.USER_KEY= lRol.USER_KEY
		LEFT JOIN SESSION.TmpListNominatorUser lNom
			ON t.USER_KEY= lNom.USER_KEY
		LEFT JOIN SESSION.TmpListLabUser lLab
			ON t.USER_KEY= lLab.USER_KEY
		LEFT JOIN SESSION.TmpListDRPCUser lDRPC
			ON t.USER_KEY= lDRPC.USER_KEY
		LEFT JOIN USER_INFO_TABLE uInfo
			ON t.USER_KEY=uInfo.USER_KEY
		INNER JOIN USER_ACCOUNT_TABLE uAcc
			ON t.USER_KEY=uAcc.USER_KEY
		LEFT JOIN USER_GROUP_TABLE uG
			ON t.USER_KEY=uG.USER_KEY
		LEFT JOIN GROUP_TABLE gr
			ON uG.GROUP_KEY= gr.GROUP_KEY
		LEFT JOIN USER_VISIT_HISTORY_TABLE uvh
			ON uAcc.USER_KEY=uvh.USER_KEY
			AND uvh.ID=LAST_LOGIN
		WITH UR;
		    
	-- Cursor left open for client application
	OPEN cursor2;
	END;
END P1

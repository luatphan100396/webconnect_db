CREATE OR REPLACE FUNCTION fn_Get_List_traits
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-15
--Description: Get list traits
--list of value
--======================================================
(
  
) 
RETURNS TABLE (
	TRAIT varchar(10),
	TRAIT_FULL_NAME varchar(30),
	TYPE varchar(30),
	UNIT varchar(30),
	DECIMAL_ADJUST_CODE char(1),
	DECIMAL_ADJUST varchar(5),
	OrderBy smallint
 )

LANGUAGE SQL

RETURN

  SELECT trim(TRAIT) as TRAIT 
		       ,trim(TRAIT_FULL_NAME) AS TRAIT_FULL_NAME
		       ,TYPE
			   ,coalesce(CASE WHEN UNIT = 'Pounds' THEN 'lbs'
					 WHEN UNIT = 'Percent' THEN '%'
					 WHEN UNIT = 'Log Base 2 Units' THEN 'lg(2)'
					 ELSE UNIT 
				END,'') as UNIT
				,DECIMAL_ADJUST_CODE
				,case  when  DECIMAL_ADJUST_CODE = '0' then '1'
		               when  DECIMAL_ADJUST_CODE = '1' then '0.1' 
		               when  DECIMAL_ADJUST_CODE = '2' or TYPE ='TYPE_TRAIT' then '0.01'
		               else '1'
		          end as DECIMAL_ADJUST 
				,OrderBy
		FROM 
		(
	     SELECT  TRAIT_SHORT_NAME AS TRAIT
	             ,TRAIT_FULL_NAME 
	             ,'TRAIT' AS TYPE
	     		 ,UNIT 
	     		 ,DECIMAL_ADJUST_CODE 
			     ,CASE  WHEN TRAIT_SHORT_NAME = 	'Mlk'	THEN	1
						WHEN TRAIT_SHORT_NAME = 	'Fat'	THEN	2
						WHEN TRAIT_SHORT_NAME = 	'Fat%'	THEN	3
						WHEN TRAIT_SHORT_NAME = 	'Pro'	THEN	4
						WHEN TRAIT_SHORT_NAME = 	'Pro%'	THEN	5
						WHEN TRAIT_SHORT_NAME = 	'PL'	THEN	6
						WHEN TRAIT_SHORT_NAME = 	'SCS'	THEN	7
						WHEN TRAIT_SHORT_NAME = 	'DPR'	THEN	8
						WHEN TRAIT_SHORT_NAME = 	'HCR'	THEN	9
						WHEN TRAIT_SHORT_NAME = 	'CCR'	THEN	10
						WHEN TRAIT_SHORT_NAME = 	'LIV'	THEN	11
						WHEN TRAIT_SHORT_NAME = 	'GL'	THEN	12
						WHEN TRAIT_SHORT_NAME = 	'MFV'	THEN	13
						WHEN TRAIT_SHORT_NAME = 	'DAB'	THEN	14
						WHEN TRAIT_SHORT_NAME = 	'KET'	THEN	15
						WHEN TRAIT_SHORT_NAME = 	'MAS'	THEN	16
						WHEN TRAIT_SHORT_NAME = 	'MET'	THEN	17
						WHEN TRAIT_SHORT_NAME = 	'RPL'	THEN	18
						WHEN TRAIT_SHORT_NAME = 	'EFC'	THEN	19
						ELSE 999
				END as OrderBy
	   FROM TRAIT_TABLE
	   WHERE publish_pdate >0 and publish_pdate < days(now()) 
			
	   UNION
	   SELECT INDEX_SHORT_NAME AS TRAIT
	     ,INDEX_FULL_NAME
	     ,'INDEX' AS TYPE
	     ,UNIT
	     ,0 AS DECIMAL_ADJUST_CODE 
	     ,CASE  WHEN INDEX_SHORT_NAME = 	'NM$'	THEN	-41
	            WHEN INDEX_SHORT_NAME = 	'FM$'	THEN	-39
				WHEN INDEX_SHORT_NAME = 	'CM$'	THEN	-38
				WHEN INDEX_SHORT_NAME = 	'GM$'	THEN	-37
			    ELSE 999
		 END as OrderBy
	 
	   FROM INDEX_TABLE
	   WHERE INDEX_SHORT_NAME IN ('NM$','FM$','CM$','GM$')
	   
	   UNION
	   SELECT INDEX_SHORT_NAME AS TRAIT
	     ,INDEX_FULL_NAME
	     ,'INDEX_PA' AS TYPE
	     ,UNIT
	     ,0 AS DECIMAL_ADJUST_CODE 
	     ,-40 OrderBy
	 
	   FROM INDEX_TABLE
	   WHERE INDEX_SHORT_NAME IN ('PA$' )
	   UNION
	   SELECT TRAIT, TRAIT_FULL_NAME, TYPE, UNIT, DECIMAL_ADJUST_CODE, OrderBy
	   FROM  (
		    VALUES 
		    ('SCR','Sire Conception Rate','TRAIT',null,1,(select string_value from dbo.CONSTANTS where name = 'COMPARISON_THRESHOLD_SCR'),-31),
		    ('REL','Reliablity','YIELD_IDTRS',null,1,(select string_value from dbo.CONSTANTS where name = 'COMPARISON_THRESHOLD_REL'),30),
		    ('DAUS','Daughters','YIELD_IDTRS',null,1,(select string_value from dbo.CONSTANTS where name = 'COMPARISON_THRESHOLD_DAUS'),31),
		    ('HERDS','Herds','YIELD_IDTRS',null,1,(select string_value from dbo.CONSTANTS where name = 'COMPARISON_THRESHOLD_HERDS'),32),
		    ('CE','	Calving Ease','CT_TRAIT',null,null,null,33),
		    ('SB','	Stillbirth','CT_TRAIT',null,null,null,34),
		    ('1','Final score','TYPE_TYPE_TRAIT',null,null,null,51),
		   ('2','Stature','TYPE_TRAIT',null,null,null,52),
		   ('3','Strength','TYPE_TRAIT',null,null,null,53),
		   ('4','Dairy form','TYPE_TRAIT',null,null,null,54),
		   ('5','Foot angle','TYPE_TRAIT',null,null,null,55),
		   ('6','Rear legs (side view)','TYPE_TRAIT',null,null,null,56),
		   ('7','Body depth','TYPE_TRAIT',null,null,null,57),
		   ('8','Rump angle','TYPE_TRAIT',null,null,null,58),
		   ('9','Rump width','TYPE_TRAIT',null,null,null,59),
		   ('10','Fore udder attachment','TYPE_TRAIT',null,null,null,60),
		   ('11','Rear udder height','TYPE_TRAIT',null,null,null,61),
		   ('12','Rear udder width','TYPE_TRAIT',null,null,null,62),
		   ('13','Udder depth score','TYPE_TRAIT',null,null,null,63),
		   ('14','Udder cleft','TYPE_TRAIT',null,null,null,64),
		   ('15','Front teat placement','TYPE_TRAIT',null,null,null,65),
		   ('16','Teat length','TYPE_TRAIT',null,null,null,66),
		   ('17','Rear legs/Rear View','TYPE_TRAIT',null,null,null,67) 
	    )t (TRAIT, TRAIT_FULL_NAME, TYPE, UNIT, DECIMAL_ADJUST_CODE, COMPARISON_THRESHOLD, OrderBy)
	  
	 
	   )
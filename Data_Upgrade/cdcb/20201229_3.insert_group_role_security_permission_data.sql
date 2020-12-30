
  ----GROUP_FEATURE_COMPONENT_TABLE----- 
  
 INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME  
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - ID/Pedigree',
 (
   select group_key,
          group_short_name
   from group_table 
 )g
 where (COMPONENT_NAME ='Animal Box') -- all groups
 or (COMPONENT_NAME ='Cross References') -- all groups
 or (COMPONENT_NAME ='Pedigree Tree' and group_short_name <>'PUBLIC')  -- exclude public
 or (COMPONENT_NAME ='Clonal Family Members of (DNA ID)' and group_short_name <>'PUBLIC')
 ;
 
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME  
	 
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Evaluation',
 (
   select group_key,
          group_short_name
   from group_table 
 )g
 where (COMPONENT_NAME <>'Type Summary Evaluation') -- all groups
 or (COMPONENT_NAME ='Type Summary Evaluation' and group_short_name in ('BREED','CDCB')) --Breed,CDCB only 
 ;
 
 
  
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME  
 	 
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Progeny',
 (
   select group_key,
          group_short_name
   from group_table 
 )g
 where (COMPONENT_NAME <>'Progeny Information' and group_short_name <>'PUBLIC' ) -- Exclude Public
 or (COMPONENT_NAME ='Progeny Information' and group_short_name not in ('PUBLIC','STUD')) --Exclude Public, Stud
 ;
 
 
  
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME  
 	 
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Errors',
 (
   select group_key,
          group_short_name
   from group_table 
 )g
 where (COMPONENT_NAME not in ('Error 5 Information','Error 6 Information') and group_short_name <>'PUBLIC' ) -- Exclude Public
 or (COMPONENT_NAME in ('Error 5 Information','Error 6 Information')  and group_short_name in ('NDHIA','DRPC','CDCB')) --Include NDHIA, DRPC, CDCB only
 ;
  
  
  
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Lactations',
 (
   select group_key,
          group_short_name
   from group_table 
 )g
 where (COMPONENT_NAME not in ('Pedigree Tree','Lactation Information - Test Day')   ) -- ALL Group 
 or (COMPONENT_NAME in ('Pedigree Tree','Lactation Information - Test Day')  and group_short_name <>'PUBLIC') --Exclude Public
 ;
   
  
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME  
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Herd - Herd Info',
 (
   select group_key,
          group_short_name
   from group_table 
 )g
 where (COMPONENT_NAME ='Herd Information' and  group_short_name in ('NDHIA', 'DRPC', 'DHIA', 'CDCB') )  
 or (COMPONENT_NAME ='Testing Characteristics' and group_short_name <>'PUBLIC') --Exclude Public
 ;
 
 
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME 
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Herd - Data Collection Rating',
 (
   select group_key,
          group_short_name
   from group_table 
 )g
 where group_short_name <>'PUBLIC'
 ;
 
   INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME 
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Herd - List of Cows',
 (
   select group_key,
          group_short_name
   from group_table 
 )g 
 ;
 
 INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME  
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Herd - Cow Lactation',
 (
   select group_key,
          group_short_name
   from group_table 
 )g 
 where group_short_name <>'PUBLIC'
 ;
 
  
 INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Herd - Test Day',
 (
   select group_key,
          group_short_name
   from group_table 
 )g 
 where (COMPONENT_NAME ='Error Message' and  group_short_name <> 'PUBLIC') 
    OR (COMPONENT_NAME <>'Error Message'  ) 
 ;
   
  
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
  
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Goat - ID/Pedigree',
 (
   select group_key,
          group_short_name
   from group_table 
 )g 
 where (COMPONENT_NAME ='Pedigree Tree' and  group_short_name <> 'PUBLIC') 
    OR (COMPONENT_NAME <>'Pedigree Tree'  ) 
 ;
   
 
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Goat - Evaluation',
 (
   select group_key,
          group_short_name
   from group_table 
 )g  ;
   
   
   INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME     
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Goat - Progeny',
 (
   select group_key,
          group_short_name
   from group_table 
 )g  ;  
  
  
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME     
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Goat - Errors',
 (
   select group_key,
          group_short_name
   from group_table 
 )g  ;  
  
  
  
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME     
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Goat - Lactations',
 (
   select group_key,
          group_short_name
   from group_table 
 )g  ;  
  
  
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME     
  
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Goat - Herd - Herd Info',
 (
   select group_key,
          group_short_name
   from group_table 
 )g 
 where (COMPONENT_NAME ='Herd Information' and  group_short_name in ('NDHIA', 'DRPC', 'DHIA', 'CDCB') )  
 or (COMPONENT_NAME ='Testing Characteristics' and group_short_name <>'PUBLIC') --Exclude Public
 ;
   
   
     
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME  
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Goat - Herd - Errors',
 (
   select group_key,
          group_short_name
   from group_table 
 )g ;
 
 
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Goat - Herd - Doe Lactation',
 (
   select group_key,
          group_short_name
   from group_table 
 )g 
 ;
 
  INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Goat - Herd - Test Day',
 (
   select group_key,
          group_short_name
   from group_table 
 )g 
 ;
 
 
   INSERT INTO GROUP_FEATURE_COMPONENT_TABLE
 (
 GROUP_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select GROUP_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >> ID Range',
 (
   select group_key,
          group_short_name
   from group_table 
 )g 
 ;
 
 
 
   INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - ID/Pedigree',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name = 'NOMINATOR'
;


   INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Progeny',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where  COMPONENT_NAME <>'Progeny Information' and role_short_name = 'NOMINATOR'
;



  INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Queries >> Cattle - Genotype',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name <>'LAB'
;



  INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >>  Get Fee',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name <>'LAB'
;


  INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >> Nominate Genotype',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name <>'LAB'
;


  INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >> Move Genotype',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name <>'LAB'
;


  INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >> Check fmt1 Record',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name <>'LAB'
;

  INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >> Suggested Dam',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name <>'LAB'
;


  INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >> History of Genotype',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name <>'LAB'
;

  INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >> Sample ID Look Up',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name <>'NOMINATOR'
;


  INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME   
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >> Reports',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where   role_short_name <>'LAB'
;

 INSERT INTO ROLE_FEATURE_COMPONENT_TABLE
 (
 ROLE_KEY,
 COMPONENT_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
  
 select ROLE_KEY,
        fc.COMPONENT_KEY, 
		current timestamp as CREATED_TIME,
		current timestamp as  MODIFIED_TIME  
 from FEATURE_COMPONENT_TABLE fc
 inner join feature_table f 
 on fc.feature_key = f.feature_key
 and f.feature_name ='Special Section >> Performance Metrics',
 (
   select role_key,
          role_short_name
   from role_table 
 )r
where fc.COMPONENT_NAME ='Get Nomination Performance Metrics based on Requester ID' and role_short_name in('STAFF','NOMINATOR')
      or fc.COMPONENT_NAME ='Get Laboratory Performance Metrics based on Lab ID' and role_short_name in('STAFF','LAB')
;
   
   

  
 ---GROUP_TABLE-------  
  
 INSERT INTO GROUP_TABLE
 (
 GROUP_SHORT_NAME,
 GROUP_NAME,
 STATUS_CODE
 )
 VALUES ('ADMIN', 'Administrator', 'A'),
 ('BREED', 'Breed Associations', 'A'),
 ('CDCB', 'Council on Dairy Cattle Breeding', 'A'),
 ('DHIA', 'DHI Affiliates', 'A'),
 ('DRPC', 'Dairy Record Processing Centers', 'A'),
 ('NAAB', 'National Association of Animal Breeders', 'A'),
 ('NDHIA', 'NDHIA', 'A'), 
 ('STUD', 'AI Organizations with Calving Ease Access', 'A'),
 ('PUBLIC', 'Pubic user', 'A')
 ;
  
 -----ROLE_TABLE------
  INSERT INTO ROLE_TABLE
 (
 ROLE_SHORT_NAME,
 ROLE_NAME,
 STATUS_CODE
 )
 VALUES ('STAFF', 'STAFF', 'A'),
 ('NOMINATOR', 'NOMINATOR', 'A'),
 ('LAB', 'LAB', 'A') 
 ;
 
 ---FEATURE_TABLE--
   INSERT INTO FEATURE_TABLE
 (
 FEATURE_NAME 
 )
 VALUES ('Queries >> Cattle - ID/Pedigree'),
('Queries >> Cattle - Evaluation'),
('Queries >> Cattle - Progeny'),
('Queries >> Cattle - Errors'),
('Queries >> Cattle - Lactations '),
('Queries >> Cattle - Herd - Herd Info'),
('Queries >> Cattle - Herd - Data Collection Rating'),
('Queries >> Cattle - Herd - List of Cows'),
('Queries >> Cattle - Herd - Cow Lactation '),
('Queries >> Cattle - Herd - Test Day'),
('Queries >> Goat - ID/Pedigree'),
('Queries >> Goat - Evaluation'),
('Queries >> Goat - Progeny'),
('Queries >> Goat - Errors'),
('Queries >> Goat - Lactations'),
('Queries >> Goat - Herd - Herd Info'),
('Queries >> Goat - Herd - Errors'),
('Queries >> Goat - Herd - Doe Lactation'),
('Queries >> Goat - Herd - Test Day'),
('Queries >> Cattle - Genotype'),
('Special Section >>  Get Fee'),
('Special Section >> Nominate Genotype'),
('Special Section >> Move Genotype'),
('Special Section >> Check fmt1 Record'),
('Special Section >> Suggested Dam'),
('Special Section >> History of Genotype'),
('Special Section >> Sample ID Look Up'),
('Special Section >> ID Range'),
('Special Section >> Reports'),
('Special Section >> Performance Metrics '),
('Administration >> Account Management'),
('Administration >> Settings'),
('Administration >> Security Level') 
 ;
  
 
 -----FEATURE_COMPONENT_TABLE------
  INSERT INTO FEATURE_COMPONENT_TABLE
 (
 COMPONENT_NAME,
 FEATURE_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES 
			('Animal Box' ),
			('Cross References'),
			('Pedigree Tree'),
			('Clonal Family Members of (DNA ID) '),
			('Pedigree Validation Record')
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - ID/Pedigree'
	    
	    )
	    ;
	    
  INSERT INTO FEATURE_COMPONENT_TABLE
 (
 COMPONENT_NAME,
 FEATURE_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES  
			('Evaluation Run/Breed'),
			('Animal Box '),
			('Pedigree Tree'),
			('NAAB '),
			('Merit  Table'),
			('Inbreeding  '),
			('Evaluation  '),
			('Sire Conception Rate'),
			('Country Contribution  '),
			('Type Summary Evaluation'),
			('Bull History Evaluation')
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Evaluation' 
	    )
	    ;	    
	     
   INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES  
			('Evaluation Run/Breed'),
			('Animal Box'),
			('Pedigree Tree'),
			('Progeny Information'),
			('Daughter List')

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Progeny' 
	    )
	    ;	    
	    
 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES  
			('Evaluation Run/Breed'),
			('Animal Box'),
			('Pedigree Tree'),
			('Error 1 Information'),
			('Error 4 Information'),
			('Error 5 Information'),
			('Error 6 Information') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Errors' 
	    )
	    ;	   
	    
 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Evaluation Run/Breed'),
				('Animal Box'),
				('Pedigree Tree'),
				('Lactation Information Records'),
				('Lactation Information - Standards, DCR, Actual for Yield Trait'),
				('Lactation Information - Test Day') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Lactations' 
	    )
	    ;
	    	   
 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Herd Information  '),
				('Get Fee  '),
				('Testing Characteristics') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Herd - Herd Info' 
	    )
	    ;	   
		   
 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Herd Information  '),
				('Herd Test Information ') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Herd - Data Collection Rating' 
	    )
	    ;	   
	    		        		    	    
	   
 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Herd Information  '),
				('List of Cows by Termination Code') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Herd - List of Cows' 
	    )
	    ;	  
	     
 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Herd Information  '),
				('Cow Lactation Records')


	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Herd - Cow Lactation' 
	    )
	    ;	    		    


INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Herd Information'),
	           ('Error Message'),
			   ('Herd Test-day Information') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Herd - Test Day' 
	    )
	    ;
	    

 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Animal Box'),
				('Cross References'),
				('Pedigree Tree ')

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Goat - ID/Pedigree' 
	    )
	    ;	    		    
  
   INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Evaluation Run/Breed'),
				('Animal Box '),
				('Pedigree Tree '),
				('Merit  Table'),
				('Inbreeding  '),
				('Evaluation  '),
				('Type Summary Evaluation'),
				('Buck History Evaluation') 
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Goat - Evaluation' 
	    )
	    ;	 
	
	 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Evaluation Run/Breed'),
				('Animal Box'),
				('Pedigree Tree'),
				('Progeny Information ') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Goat - Progeny' 
	    )
	    ;
	    
   INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Evaluation Run/Breed'),
				('Animal Box'),
				('Pedigree Tree'),
				('Error 1 Information'),
				('Error 4 Information'),
				('Error 5 Information ') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Goat - Errors' 
	    )
	    ;  
	    
	    
   INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Evaluation Run/Breed'),
				('Animal Box'),
				('Pedigree Tree'),
				('Lactation Information Records'),
				('Lactation Information - Standards, DCR, Actual for Yield Trait'),
				('Lactation Information - Test Day') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Goat - Lactations' 
	    )
	    ;      
	      
	INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Herd Information  '), 
				('Testing Characteristics') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Goat - Herd - Herd Info' 
	    )
	    ;   
  	
    
    INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Herd Information  '),
				('Error Information ')  
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Goat - Herd - Errors' 
	    )
	    ;   	
     
    INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Herd Information  '),
				('Doe Lactation Records  ') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Goat - Herd - Doe Lactation' 
	    )
	    ;       
 
     INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Herd Information  '),
				('Herd Test-Day Information  ') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Goat - Herd - Test Day' 
	    )
	    ;   
	     
	    
	 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES  ('Evaluation Run/Breed'),
				('Animal Box'),
				('Pedigree Tree'),
				('Nomination Status'),
				('Sample Status'),
				('Genotype Confirmations and Genotype Conflicts ') 
	    
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Queries >> Cattle - Genotype' 
	    )
	    ;  
  
   INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES  ('Get Fee by Animal ID (17 bytes)  '),
				('Get Fee by Herd ID  ') 

	    
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >>  Get Fee' 
	    )
	    ; 
	    
	    
	 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES  ('Create Animal and Nominate  ')  
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >> Nominate Genotype' 
	    )
	    ; 
   
   INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Special Section >> Move Genotype')  
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >> Move Genotype' 
	    )
	    ; 
	 
      INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Comparision between the input file and CDCB file ') 
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >> Check fmt1 Record' 
	    )
	    ; 
	    
      INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Special Section >> Suggested Dam') 
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >> Suggested Dam' 
	    )
	    ; 
	    
	  INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('History of Genotype by Animal ID/Sample ID/Barcode&Position') 
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >> History of Genotype' 
	    )
	    ; 
	    
	   
	  INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Sample ID Look Up by Animal ID/Sample ID')
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >> Sample ID Look Up' 
	    )
	    ;
        
        
    INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Special Section >> ID Range') 
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >> ID Range' 
	    )
	    ; 
	    
	    
	 
    INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Get Lists genotypes with fee code=N loaded in the past 6 months'),
				('Get Fee codes for genotypes loaded since the last invoice'),
				('Get Lists parentage only genotypes since the previous genomic run'),
				('Get Reports missing animal ID for a requester'),
				('Get Conflicts for genotypes loaded in the past 45 days'),
				('Get Check for missing pedigree of animals nominated in the past 75 days'),
				('Get List conflicting genotypes within animal (negative keys)'),
				('Get Animals with unlikely grandsire (and no other conflict) in the past 6 months'),
				('Get Animals with genotypes that conflict with imputed dam genotypes'),
				('Get Parentage verification records for genotypes loaded in the past') 
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >> Reports' 
	    )
	    ;  
	    
	 INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
	     
	  SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES ('Get Nomination Performance Metrics based on Requester ID'),
				('Get Laboratory Performance Metrics based on Lab ID') 

	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Special Section >> Performance Metrics' 
	    )
	    ;   

  
 INSERT INTO FEATURE_COMPONENT_TABLE
 (
 COMPONENT_NAME,
 FEATURE_KEY,
 CREATED_TIME,
 MODIFIED_TIME 
 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES 
			('Account Tab' ),
			('Account Request Tab') 
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Administration >> Account Management'
	    
	    )
	    ;
	    
	INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES 
			('Settings Tab' ) 
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Administration >> Settings'
	    
	    )
	    ;	    
   
   INSERT INTO FEATURE_COMPONENT_TABLE
	 (
	 COMPONENT_NAME,
	 FEATURE_KEY,
	 CREATED_TIME,
	 MODIFIED_TIME 
	 )
 
 SELECT  COMPONENT_NAME,
         FEATURE_KEY,
         current timestamp as CREATED_TIME,
		 current timestamp as  MODIFIED_TIME 
	    FROM (
	    VALUES 
			('Group Tab' ),
			('Role Tab' ),
			('Other Tab' ) 
	    )t (COMPONENT_NAME),
	    (SELECT FEATURE_KEY
	     FROM FEATURE_TABLE
	     WHERE FEATURE_NAME ='Administration >> Security Level'
	    
	    )
	    ;	
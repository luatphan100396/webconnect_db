
 
 MERGE INTO user_account_table as A
	 using
	 (
  
		select user_key, 
        user_name || case when rn = 1 then ''
                          else '_'||cast(rn as varchar(10))       
                     end as user_name
		 from 
		 (
			 select user_key, 
				 user_name, 
				 row_number()over(partition by lower(user_name) order by user_key) rn
			 from user_account_table
		 )a
		 
	 )AS B
	 ON  A.user_key = B.user_key  
	 WHEN MATCHED THEN UPDATE
	 SET 
	 user_name =  B.user_name
	 ;
	  
	  
	
 MERGE INTO user_info_table as A
	 using
	 (
  
		select user_key, 
        EMAIL_ADDR || case when rn = 1 then ''
                          else '_'||cast(rn as varchar(10))       
                     end as EMAIL_ADDR
		 from 
		 (
			 select user_key, 
				 trim(EMAIL_ADDR) as EMAIL_ADDR, 
				 row_number()over(partition by lower(EMAIL_ADDR) order by user_key) rn
			 from user_info_table
		 )a
		 
	 )AS B
	 ON  A.user_key = B.user_key  
	 WHEN MATCHED THEN UPDATE
	 SET 
	 EMAIL_ADDR =  B.EMAIL_ADDR
	 ;
	  
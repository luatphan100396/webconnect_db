CREATE OR REPLACE FUNCTION fn_get_admin_email_list
--======================================================
--Author: Nghi Ta
--Created Date: 2021-01-12
--Description: Get admin email list 
--======================================================
(	 
) 
RETURNS VARCHAR(3000)

LANGUAGE SQL
BEGIN 
	DECLARE EMAIL_LIST VARCHAR(3000) ;
	
	SET EMAIL_LIST = (select substr(xmlserialize(xmlagg(xmltext ( ','|| t.email_addr
	                                             
	                                           ) order by t.user_key   ) as VARCHAR(30000)),2)
						from user_group_table ug
						inner join group_table g
							on ug.group_key = g.group_key
							and upper(g.GROUP_SHORT_NAME) = 'ADMIN'
						inner join user_info_table t
							on t.user_key = ug.user_key
					  );
 
	RETURN EMAIL_LIST;
END
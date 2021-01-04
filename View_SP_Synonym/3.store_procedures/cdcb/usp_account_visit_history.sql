CREATE OR REPLACE PROCEDURE usp_Account_Visit_History
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-28
--Description: Get visit history of accoun 
--Output:
--        +Ds1: list Visit History
--======================================================
(
	IN @USER_NAME VARCHAR(30)
	,IN @TIME_RANGE varchar(50)
	,IN @page_number int
	,IN @row_per_page int
)
	DYNAMIC RESULT SETS 2
P1: BEGIN


     declare v_cutoff_timestamp timestamp;
     
     
     set v_cutoff_timestamp = (select case when @TIME_RANGE ='last_hour' then current timestamp - 1 hours
                                           when @TIME_RANGE ='last_24hour' then current timestamp - 24 hours
                                           when @TIME_RANGE ='last_7days' then current timestamp - (7*24) hours
                                           when @TIME_RANGE ='last_4weeks' then current timestamp - (4*7*24) hours
                                           when @TIME_RANGE ='all_time' then null
                                       end
                             from sysibm.sysdummy1);

	BEGIN
	-- Declare cursor
	DECLARE cursor1 CURSOR WITH RETURN for
	SELECT  
		uvhTable.ACCESS_TIME,
		uvhTable.IP_ADDRESS,
		uvhTable.WEB_BROWSER,
		uvhTable.DEVICE
	FROM USER_VISIT_HISTORY_TABLE uvhTable
		INNER JOIN USER_ACCOUNT_TABLE u
			ON uvhTable.USER_KEY=u.USER_KEY
			
			WHERE u.USER_NAME= @USER_NAME
			AND (v_cutoff_timestamp is null or uvhTable.ACCESS_TIME >= v_cutoff_timestamp)
			ORDER BY uvhTable.ACCESS_TIME
		LIMIT @row_per_page
		OFFSET (@page_number-1)*@row_per_page
			with ur;
	
	OPEN cursor1;
	
	BEGIN
		DECLARE cursor2 CURSOR WITH RETURN FOR 	
		 SELECT count(1) as Num_Recs
		FROM USER_VISIT_HISTORY_TABLE uvhTable
		INNER JOIN USER_ACCOUNT_TABLE u
			ON uvhTable.USER_KEY=u.USER_KEY
			AND DATE(uvhTable.ACCESS_TIME) <= v_cutoff_timestamp
			WHERE u.USER_NAME= @USER_NAME
			with ur;
	
	 OPEN cursor2;
   END;
	END;
END P1
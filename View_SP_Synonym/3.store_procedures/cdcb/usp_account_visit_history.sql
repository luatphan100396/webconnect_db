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
	,IN @sort_direction varchar(5) default 'DESC'
)
	DYNAMIC RESULT SETS 3
P1: BEGIN

	DECLARE v_USER_KEY INT;	
    DECLARE v_cutoff_timestamp timestamp;
     
     --SET VARIABLES
     SET v_USER_KEY=(SELECT USER_KEY FROM USER_ACCOUNT_TABLE WHERE USER_NAME=@USER_NAME);
     
     set v_cutoff_timestamp = (select case when @TIME_RANGE ='last_hour' then current timestamp - 1 hours
                                           when @TIME_RANGE ='last_24hour' then current timestamp - 24 hours
                                           when @TIME_RANGE ='last_7days' then current timestamp - (7*24) hours
                                           when @TIME_RANGE ='last_4weeks' then current timestamp - (4*7*24) hours
                                           when @TIME_RANGE ='all_time' then null
                                       end
                             from sysibm.sysdummy1);

	
	IF @sort_direction ='ASC' then 
	
		BEGIN 
			DECLARE cursor1 CURSOR WITH RETURN for
			SELECT
				row_number()over(order by uvhTable.ACCESS_TIME) as No,
				uvhTable.ACCESS_TIME,
				uvhTable.IP_ADDRESS,
				uvhTable.WEB_BROWSER,
				uvhTable.DEVICE
			FROM USER_VISIT_HISTORY_TABLE uvhTable
					WHERE uvhTable.USER_KEY= v_USER_KEY
					AND (v_cutoff_timestamp is null or uvhTable.ACCESS_TIME >= v_cutoff_timestamp)
					ORDER BY uvhTable.ACCESS_TIME ASC
				LIMIT @row_per_page
				OFFSET (@page_number-1)*@row_per_page
					with ur;
			
			OPEN cursor1;
		END;
	ELSEIF  @sort_direction ='DESC' THEN 
		BEGIN
		-- Declare cursor
		DECLARE cursor10 CURSOR WITH RETURN for
		SELECT
			row_number()over(order by uvhTable.ACCESS_TIME) as No,  
			uvhTable.ACCESS_TIME,
			uvhTable.IP_ADDRESS,
			uvhTable.WEB_BROWSER,
			uvhTable.DEVICE
		FROM USER_VISIT_HISTORY_TABLE uvhTable
				WHERE uvhTable.USER_KEY= v_USER_KEY
				AND (v_cutoff_timestamp is null or uvhTable.ACCESS_TIME >= v_cutoff_timestamp)
				ORDER BY uvhTable.ACCESS_TIME DESC
			LIMIT @row_per_page
			OFFSET (@page_number-1)*@row_per_page
				with ur;
		
		OPEN cursor10;
		END;
	END IF; 

	
	BEGIN
		DECLARE cursor2 CURSOR WITH RETURN FOR 	
		 SELECT count(1) as Num_Recs
		FROM USER_VISIT_HISTORY_TABLE uvhTable
		INNER JOIN USER_ACCOUNT_TABLE u
			ON uvhTable.USER_KEY=u.USER_KEY
			WHERE uvhTable.USER_KEY= v_USER_KEY
			AND (v_cutoff_timestamp is null or uvhTable.ACCESS_TIME >= v_cutoff_timestamp)
			with ur;
	
	 OPEN cursor2;
	END;
END P1
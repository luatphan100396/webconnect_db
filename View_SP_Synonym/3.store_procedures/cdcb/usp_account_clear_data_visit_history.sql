 
CREATE OR REPLACE PROCEDURE usp_Account_Clear_Data_Visit_History
--======================================================
--Author: Linh Pham
--Created Date: 2020-12-28
--Description: CLEAR all infor visit history
--Output:
--        +Ds1: clear all Visit History
--======================================================
(
	IN @USER_NAME VARCHAR(30)
)
	DYNAMIC RESULT SETS 1
P1: BEGIN
	--declear variable
	DECLARE v_USER_KEY INT;	
	--set variable
	
	SET v_USER_KEY=(SELECT USER_KEY FROM USER_ACCOUNT_TABLE WHERE USER_NAME=@USER_NAME);
	
	--DELETE ALL ROW OF ACCOUNT IN TABLE
	DELETE FROM USER_VISIT_HISTORY_TABLE WHERE USER_KEY= v_USER_KEY;
	COMMIT;
	
	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
		SELECT  1 AS RESULT 
		FROM sysibm.sysdummy1;
					 
	OPEN cursor1;
	END;  
END P1 
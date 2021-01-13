CREATE OR REPLACE PROCEDURE usp_Account_Reject_Account_Request
--======================================================
--Author: Tri Do
--Created Date: 2021-01-05
--Description: Reject Account Request
--Output: None
--======================================================
(
	@REQUEST_KEY INT
)
DYNAMIC RESULT SETS 10
P1: BEGIN
	DECLARE V_CURRENT_TIME TIMESTAMP;

	SET v_CURRENT_TIME = (SELECT CURRENT TIMESTAMP FROM SYSIBM.SYSDUMMY1);
		
	UPDATE ACCOUNT_REQUEST_TABLE
	SET STATUS = 'Rejected'
		,MODIFIED_TIME = v_CURRENT_TIME
	WHERE REQUEST_KEY = @REQUEST_KEY;
	
	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
		SELECT  1 AS RESULT 
		FROM sysibm.sysdummy1;
	 
		OPEN cursor1;
	 END;
END P1
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
P1: BEGIN
	DECLARE V_CURRENT_TIME TIMESTAMP;

	SET v_CURRENT_TIME = (SELECT CURRENT TIMESTAMP FROM SYSIBM.SYSDUMMY1);
		
	UPDATE ACCOUNT_REQUEST_TABLE
	SET STATUS = 'Rejected'
		,MODIFIED_TIME = v_CURRENT_TIME
	WHERE REQUEST_KEY = @REQUEST_KEY;
END P1
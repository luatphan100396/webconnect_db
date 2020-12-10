CREATE OR REPLACE PROCEDURE rpt_Get_Filter_Breed_List_For_Summary_Stats
--====================================================================================
--Author: Trong Le
--Created Date: 2020-09-22
--Description: Get breed list that used for summary
--Output: 
--       +Ds1: Breed table with breed code and breed name for following breeds: AY, BS, GU, HO, JE, MS
--=======================================================================================
(
)
	DYNAMIC RESULT SETS 1
BEGIN
	-- Breed list
	BEGIN
		DECLARE cursor1 CURSOR WITH RETURN for
		
		SELECT	DISTINCT
				BREED_CODE,
				BREED_NAME
		FROM	BREED_TABLE
		WHERE	BREED_CODE IN ('AY', 'BS', 'GU', 'HO', 'JE', 'MS')
		ORDER BY BREED_CODE WITH UR;
		
		OPEN cursor1;
	END;
END
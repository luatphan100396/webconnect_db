CREATE OR REPLACE FUNCTION fn_Get_List_Feature
--======================================================
--Author: Nghi Ta
--Created Date: 2020-06-15
--Description: Get list traits
--list of value
--======================================================
(
  IN @SEARCH_BY VARCHAR(10)
) 
RETURNS TABLE (
	FEATURE_KEY INT,
	FEATURE_NAME VARCHAR(200)
 )

LANGUAGE SQL

RETURN
   
  SELECT 
			FEATURE_KEY,
			FEATURE_NAME
		FROM FEATURE_TABLE
		WHERE ( UPPER(@SEARCH_BY) ='GROUP' AND FEATURE_NAME IN ('Queries >> Cattle - ID/Pedigree',
																'Queries >> Cattle - Evaluation',
																'Queries >> Cattle - Progeny',
																'Queries >> Cattle - Errors',
																'Queries >> Cattle - Lactations ',
																'Queries >> Cattle - Herd - Herd Info',
																'Queries >> Cattle - Herd - Data Collection Rating',
																'Queries >> Cattle - Herd - List of Cows',
																'Queries >> Cattle - Herd - Cow Lactation ',
																'Queries >> Cattle - Herd - Test Day',
																'Queries >> Goat - ID/Pedigree',
																'Queries >> Goat - Evaluation',
																'Queries >> Goat - Progeny',
																'Queries >> Goat - Errors',
																'Queries >> Goat - Lactations',
																'Queries >> Goat - Herd - Herd Info',
																'Queries >> Goat - Herd - Errors',
																'Queries >> Goat - Herd - Doe Lactation',
																'Queries >> Goat - Herd - Test Day',
																'Administration >> Account Management',
																'Administration >> Settings',
																'Administration >> Security Level')
				)
				OR 
				( UPPER(@SEARCH_BY) ='ROLE' AND FEATURE_NAME IN ('Queries >> Cattle - Herd - Herd Info',
										                        'Queries >> Cattle - Genotype',
																'Special Section >>  Get Fee',
																'Special Section >> Nominate Genotype',
																'Special Section >> Move Genotype',
																'Special Section >> Check fmt1 Record',
																'Special Section >> Suggested Dam',
																'Special Section >> History of Genotype',
																'Special Section >> Sample ID Look Up',
																'Special Section >> ID Range',
																'Special Section >> Reports',
																'Special Section >> Performance Metrics')
				)
		--ORDER BY FEATURE_NAME
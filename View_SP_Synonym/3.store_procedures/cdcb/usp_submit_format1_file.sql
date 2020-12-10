CREATE OR REPLACE PROCEDURE usp_Submit_Format1_File
--======================================================================================
--Author: Trong Le
--Created Date: 2020-10-01
--Description: This SP concatenates elements of format1 from the input and submit it.
--Output: 
--       +Ds1: a file is exported and return the file name with the path.
--======================================================================================
(
	IN @SPECIES_CODE		CHAR(1),
	IN @SEX_CODE			CHAR(1),
	IN @PREFERRED_ID		CHAR(17),
	IN @SIRE_ID				CHAR(17),
	IN @DAM_ID				CHAR(17),
	IN @ALIAS_ID			CHAR(17),
	IN @BIRTH_DATE			CHAR(8),
	IN @SOURCE_CODE			CHAR(1),
	IN @PROCESSING_DATE		CHAR(8),
	IN @RECORD_TYPE			CHAR(1),
	IN @PED_VERIFICATION	CHAR(1),
	IN @RECORD_VERSION		CHAR(1),
	IN @MULTI_BIRTH_CODE	CHAR(1),
	IN @REGIS_STATUS_CODE	CHAR(2),
	IN @ZEROES				CHAR(6),
	IN @LONG_NAME			CHAR(30),
	
	IN @GROUP_NAME			CHAR(8),
	IN @PARENTAGE_ONLY_IND	CHAR(1),
	IN @CDCB_FEE_PAID_CODE	CHAR(1),
	IN @HERD_REASON_CODE	CHAR(1),
	OUT @FILE_NAME			VARCHAR(300)
)
 
 DYNAMIC RESULT SETS  10
BEGIN

   -- Declaration variables
   DECLARE EXPORT_FILE_NAME 	VARCHAR(300);
   DECLARE EXPORT_PATH 			VARCHAR(200);
   DECLARE fmt1_value			CHAR(140);
   
   SET EXPORT_PATH = (SELECT string_value FROM dbo.constants WHERE name ='Export_Folder');
   
   SET fmt1_value =	@SPECIES_CODE		||
		    		@SEX_CODE			||
		    		@PREFERRED_ID		||
		  				
	  				@SIRE_ID			||
	   				@DAM_ID				||
	   				@ALIAS_ID 			||  
	   				@BIRTH_DATE			||
	   				@SOURCE_CODE		||
  					@PROCESSING_DATE	||
   					@RECORD_TYPE		||
   					@PED_VERIFICATION	||
   					@RECORD_VERSION		||
   					@MULTI_BIRTH_CODE	||
   					@REGIS_STATUS_CODE	||
  					@ZEROES				||
		   			@LONG_NAME	 		||

		   			@GROUP_NAME			||
		   			@PARENTAGE_ONLY_IND	||
		   			@CDCB_FEE_PAID_CODE	||
		   			@HERD_REASON_CODE;
		   					
	SET EXPORT_FILE_NAME = REPLACE(REPLACE(REPLACE(CAST(CURRENT TIMESTAMP AS VARCHAR(26)),'.',''),':',''), '-', '');
		
	SET EXPORT_FILE_NAME =  EXPORT_PATH||'/'||EXPORT_FILE_NAME||'.1';	
		
	CALL SYSPROC.ADMIN_CMD( 'export to '||EXPORT_FILE_NAME||' of DEL modified by NOCHARDEL 
		 	  			 select '''||fmt1_value||''' from sysibm.sysdummy1 ');
   
   
   SET @FILE_NAME = EXPORT_FILE_NAME;
   
	 	  			 
END 
CREATE TABLE DOE_TYPE_F941G
(
LINE VARCHAR(520)
);

/*
db2 connect to cdcbdb;
db2 load from /home/db2inst1/Data/Goat/1912/g1912.f941g of del insert into DOE_TYPE_F941G
*/
 
CREATE TABLE TMP_DOE_TYPE_TABLE AS(
	SELECT	CAST (0 AS INT) AS ANIM_KEY
			,CAST (0 AS SMALLINT) AS EVAL_PDATE
			
			,SUBSTRING(LINE,1,17) AS INT_ID						--breed code + country code + identification number 
			,SUBSTRING(LINE,18,1) AS NUM_APPRAISALS				--number of appraisals
			,SUBSTRING(LINE,19,3) AS PTA_FS_QTY					--PTA Final Score
			,SUBSTRING(LINE,22,2) AS PTA_REL_FS_PCT				--reliability Final Score
			,SUBSTRING(LINE,24,3) AS PTA_STT_QTY				--PTA stature
			,SUBSTRING(LINE,27,2) AS PTA_REL_STT_PCT			--reliability stature
			,SUBSTRING(LINE,29,3) AS PTA_STR_QTY				--PTA strength
			,SUBSTRING(LINE,32,2) AS PTA_REL_STR_PCT			--reliability strength
			,SUBSTRING(LINE,34,3) AS PTA_DR_QTY					--PTA dairyness
			,SUBSTRING(LINE,37,2) AS PTA_REL_DR_PCT				--reliability dairyness
			,SUBSTRING(LINE,39,3) AS PTA_TEAT_D_QTY				--PTA teat diameter
			,SUBSTRING(LINE,42,2) AS PTA_REL_TEAT_D_PCT			--REL teat diameter
			,SUBSTRING(LINE,44,3) AS PTA_RL_QTY					--PTA rear legs
			,SUBSTRING(LINE,47,2) AS PTA_REL_RL_PCT				--reliability rear legs
			,SUBSTRING(LINE,49,3) AS PTA_RUMP_A_QTY				--PTA rump angle
			,SUBSTRING(LINE,52,2) AS PTA_REL_RUMP_A_PCT			--reliability rump angle
			,SUBSTRING(LINE,54,3) AS PTA_RUMP_W_QTY				--PTA rump width
			,SUBSTRING(LINE,57,2) AS PTA_REL_RUMP_W_PCT			--reliability rump width
			,SUBSTRING(LINE,59,3) AS PTA_FORE_U_ATT_QTY			--PTA fore udder attachment
			,SUBSTRING(LINE,62,2) AS PTA_REL_FORE_U_ATT_PCT		--reliability fore udder attachment
			,SUBSTRING(LINE,64,3) AS PTA_REAR_U_HT_QTY			--PTA rear udder height
			,SUBSTRING(LINE,67,2) AS PTA_REL_REAR_U_HT_PCT		--reliability rear udder height
			,SUBSTRING(LINE,69,3) AS PTA_REAR_U_ARCH_QTY		--PTA rear udder arch
			,SUBSTRING(LINE,72,2) AS PTA_REL_REAR_U_ARCH_PCT	--reliability rear udder arch
			,SUBSTRING(LINE,74,3) AS PTA_UDDER_D_QTY			--PTA udder depth
			,SUBSTRING(LINE,77,2) AS PTA_REL_UDDER_D_PCT		--reliability udder depth
			,SUBSTRING(LINE,79,3) AS PTA_SUSP_LIG_QTY			--PTA suspensory ligament
			,SUBSTRING(LINE,82,2) AS PTA_REL_SUSP_LIG_PCT		--reliability suspensory ligament 
			,SUBSTRING(LINE,84,3) AS PTA_TEAT_P_QTY				--PTA teat placement
			,SUBSTRING(LINE,87,2) AS PTA_REL_TEAT_P_PCT			--reliability teat placement
	FROM DOE_TYPE_F941G
)DEFINITION ONLY;
													
ALTER TABLE TMP_DOE_TYPE_TABLE ADD CONSTRAINT TMP_DOE_TYPE_TABLE_PK PRIMARY KEY (ANIM_KEY,EVAL_PDATE);


INSERT INTO TMP_DOE_TYPE_TABLE
SELECT	id.ANIM_KEY
		,21884 AS  EVAL_PDATE

		,SUBSTRING(LINE,1,17) AS INT_ID						--breed code + country code + identification number 
		,SUBSTRING(LINE,18,1) AS NUM_APPRAISALS				--number of appraisals
		,SUBSTRING(LINE,19,3) AS PTA_FS_QTY					--PTA Final Score
		,SUBSTRING(LINE,22,2) AS PTA_REL_FS_PCT				--reliability Final Score
		,SUBSTRING(LINE,24,3) AS PTA_STT_QTY				--PTA stature
		,SUBSTRING(LINE,27,2) AS PTA_REL_STT_PCT			--reliability stature
		,SUBSTRING(LINE,29,3) AS PTA_STR_QTY				--PTA strength
		,SUBSTRING(LINE,32,2) AS PTA_REL_STR_PCT			--reliability strength
		,SUBSTRING(LINE,34,3) AS PTA_DR_QTY					--PTA dairyness
		,SUBSTRING(LINE,37,2) AS PTA_REL_DR_PCT				--reliability dairyness
		,SUBSTRING(LINE,39,3) AS PTA_TEAT_D_QTY				--PTA teat diameter
		,SUBSTRING(LINE,42,2) AS PTA_REL_TEAT_D_PCT			--REL teat diameter
		,SUBSTRING(LINE,44,3) AS PTA_RL_QTY					--PTA rear legs
		,SUBSTRING(LINE,47,2) AS PTA_REL_RL_PCT				--reliability rear legs
		,SUBSTRING(LINE,49,3) AS PTA_RUMP_A_QTY				--PTA rump angle
		,SUBSTRING(LINE,52,2) AS PTA_REL_RUMP_A_PCT			--reliability rump angle
		,SUBSTRING(LINE,54,3) AS PTA_RUMP_W_QTY				--PTA rump width
		,SUBSTRING(LINE,57,2) AS PTA_REL_RUMP_W_PCT			--reliability rump width
		,SUBSTRING(LINE,59,3) AS PTA_FORE_U_ATT_QTY			--PTA fore udder attachment
		,SUBSTRING(LINE,62,2) AS PTA_REL_FORE_U_ATT_PCT		--reliability fore udder attachment
		,SUBSTRING(LINE,64,3) AS PTA_REAR_U_HT_QTY			--PTA rear udder height
		,SUBSTRING(LINE,67,2) AS PTA_REL_REAR_U_HT_PCT		--reliability rear udder height
		,SUBSTRING(LINE,69,3) AS PTA_REAR_U_ARCH_QTY		--PTA rear udder arch
		,SUBSTRING(LINE,72,2) AS PTA_REL_REAR_U_ARCH_PCT	--reliability rear udder arch
		,SUBSTRING(LINE,74,3) AS PTA_UDDER_D_QTY			--PTA udder depth
		,SUBSTRING(LINE,77,2) AS PTA_REL_UDDER_D_PCT		--reliability udder depth
		,SUBSTRING(LINE,79,3) AS PTA_SUSP_LIG_QTY			--PTA suspensory ligament
		,SUBSTRING(LINE,82,2) AS PTA_REL_SUSP_LIG_PCT		--reliability suspensory ligament 
		,SUBSTRING(LINE,84,3) AS PTA_TEAT_P_QTY				--PTA teat placement
		,SUBSTRING(LINE,87,2) AS PTA_REL_TEAT_P_PCT			--reliability teat placement
FROM DOE_TYPE_F941G f
INNER JOIN ID_XREF_TABLE id ON SUBSTRING(f.LINE,1,17) = id.INT_ID
							AND id.SEX_CODE ='F'
							AND id.SPECIES_CODE = 1
							AND id.PREFERRED_CODE = 1;

--delete from DOE_TYPE_TABLE immediate;

INSERT INTO DOE_TYPE_TABLE
		(ANIM_KEY
		,EVAL_PDATE
		,INT_ID					
		,NUM_APPRAISALS			
		,PTA_FS_QTY				
		,PTA_REL_FS_PCT			
		,PTA_STT_QTY			
		,PTA_REL_STT_PCT		
		,PTA_STR_QTY			
		,PTA_REL_STR_PCT		
		,PTA_DR_QTY				
		,PTA_REL_DR_PCT			
		,PTA_TEAT_D_QTY			
		,PTA_REL_TEAT_D_PCT		
		,PTA_RL_QTY				
		,PTA_REL_RL_PCT			
		,PTA_RUMP_A_QTY			
		,PTA_REL_RUMP_A_PCT		
		,PTA_RUMP_W_QTY			
		,PTA_REL_RUMP_W_PCT		
		,PTA_FORE_U_ATT_QTY		
		,PTA_REL_FORE_U_ATT_PCT	
		,PTA_REAR_U_HT_QTY		
		,PTA_REL_REAR_U_HT_PCT	
		,PTA_REAR_U_ARCH_QTY	
		,PTA_REL_REAR_U_ARCH_PCT
		,PTA_UDDER_D_QTY		
		,PTA_REL_UDDER_D_PCT	
		,PTA_SUSP_LIG_QTY		
		,PTA_REL_SUSP_LIG_PCT	
		,PTA_TEAT_P_QTY			
		,PTA_REL_TEAT_P_PCT)

SELECT	ANIM_KEY
		,21884 AS EVAL_PDATE
		,INT_ID					
		,NUM_APPRAISALS			
		,PTA_FS_QTY				
		,PTA_REL_FS_PCT			
		,PTA_STT_QTY			
		,PTA_REL_STT_PCT		
		,PTA_STR_QTY			
		,PTA_REL_STR_PCT		
		,PTA_DR_QTY				
		,PTA_REL_DR_PCT			
		,PTA_TEAT_D_QTY			
		,PTA_REL_TEAT_D_PCT		
		,PTA_RL_QTY				
		,PTA_REL_RL_PCT			
		,PTA_RUMP_A_QTY			
		,PTA_REL_RUMP_A_PCT		
		,PTA_RUMP_W_QTY			
		,PTA_REL_RUMP_W_PCT		
		,PTA_FORE_U_ATT_QTY		
		,PTA_REL_FORE_U_ATT_PCT	
		,PTA_REAR_U_HT_QTY		
		,PTA_REL_REAR_U_HT_PCT	
		,PTA_REAR_U_ARCH_QTY	
		,PTA_REL_REAR_U_ARCH_PCT
		,PTA_UDDER_D_QTY		
		,PTA_REL_UDDER_D_PCT	
		,PTA_SUSP_LIG_QTY		
		,PTA_REL_SUSP_LIG_PCT	
		,PTA_TEAT_P_QTY			
		,PTA_REL_TEAT_P_PCT		
 FROM TMP_DOE_TYPE_TABLE;
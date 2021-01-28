CREATE TABLE BUCK_TYPE_F940G
(
LINE VARCHAR(520)
);

/*
db2 connect to cdcbdb;
db2 load from /home/db2inst1/Data/Goat/1912/g1912.f940g of del insert into BUCK_TYPE_F940G
*/

CREATE TABLE TMP_BUCK_TYPE_TABLE AS(
	SELECT	CAST (0 AS INT) AS ANIM_KEY
			,CAST (0 AS SMALLINT) AS EVAL_PDATE
			
			,SUBSTRING(LINE,1,17) AS INT_ID						--breed code + country code + identification number 
			,SUBSTRING(LINE,18,4) AS AVG_DAU_HERD				--average number of type daughters per herd
			,SUBSTRING(LINE,22,2) AS NUM_STATES					--number of states with type daughters
			,SUBSTRING(LINE,24,5) AS NUM_HERDS					--number of herds
			,SUBSTRING(LINE,29,6) AS NUM_DAU					--number of daughters
			,SUBSTRING(LINE,34,5) AS NUM_APPRAISALS				--number of appraisals
			,SUBSTRING(LINE,39,3) AS AVG_DAU_FS					--dau score final score 
			,SUBSTRING(LINE,42,3) AS PTA_FS_QTY					--PTA Final Score
			,SUBSTRING(LINE,45,2) AS PTA_REL_FS_PCT				--reliability Final Score
			,SUBSTRING(LINE,47,3) AS AVG_DAU_STT				--dau score stature
			,SUBSTRING(LINE,50,3) AS PTA_STT_QTY				--PTA stature
			,SUBSTRING(LINE,53,2) AS PTA_REL_STT_PCT			--reliability stature
			,SUBSTRING(LINE,55,3) AS AVG_DAU_STR				--dau score strength
			,SUBSTRING(LINE,58,3) AS PTA_STR_QTY				--PTA strength
			,SUBSTRING(LINE,61,2) AS PTA_REL_STR_PCT			--reliability strength
			,SUBSTRING(LINE,63,3) AS AVG_DAU_DR					--dau score dairyness
			,SUBSTRING(LINE,66,3) AS PTA_DR_QTY					--PTA dairyness
			,SUBSTRING(LINE,69,2) AS PTA_REL_DR_PCT				--reliability dairyness
			,SUBSTRING(LINE,71,3) AS AVG_DAU_TEAT_D				--dau score teat diameter
			,SUBSTRING(LINE,74,3) AS PTA_TEAT_D_QTY				--PTA teat diameter
			,SUBSTRING(LINE,77,2) AS PTA_REL_TEAT_D_PCT			--REL teat diameter
			,SUBSTRING(LINE,79,3) AS AVG_DAU_RL					--dau score rear legs
			,SUBSTRING(LINE,82,3) AS PTA_RL_QTY					--PTA rear legs
			,SUBSTRING(LINE,85,2) AS PTA_REL_RL_PCT				--reliability rear legs
			,SUBSTRING(LINE,87,3) AS AVG_DAU_RUMP_A				--dau score rump angle
			,SUBSTRING(LINE,90,3) AS PTA_RUMP_A_QTY				--PTA rump angle
			,SUBSTRING(LINE,93,2) AS PTA_REL_RUMP_A_PCT				--reliability rump angle
			,SUBSTRING(LINE,95,3) AS AVG_DAU_RUMP_W				--dau score rump width
			,SUBSTRING(LINE,98,3) AS PTA_RUMP_W_QTY				--PTA rump width
			,SUBSTRING(LINE,101,2) AS PTA_REL_RUMP_W_PCT		--reliability rump width
			,SUBSTRING(LINE,103,3) AS AVG_DAU_FORE_U_ATT		--dau score fore udder attachment
			,SUBSTRING(LINE,106,3) AS PTA_FORE_U_ATT_QTY		--PTA fore udder attachment
			,SUBSTRING(LINE,109,2) AS PTA_REL_FORE_U_ATT_PCT	--reliability fore udder attachment
			,SUBSTRING(LINE,111,3) AS AVG_DAU_REAR_U_HT			--dau score rear udder height
			,SUBSTRING(LINE,114,3) AS PTA_REAR_U_HT_QTY			--PTA rear udder height
			,SUBSTRING(LINE,117,2) AS PTA_REL_REAR_U_HT_PCT		--reliability rear udder height
			,SUBSTRING(LINE,119,3) AS AVG_DAU_REAR_U_ARCH		--dau score rear udder arch
			,SUBSTRING(LINE,122,3) AS PTA_REAR_U_ARCH_QTY		--PTA rear udder arch
			,SUBSTRING(LINE,125,2) AS PTA_REL_REAR_U_ARCH_PCT	--reliability rear udder arch
			,SUBSTRING(LINE,127,3) AS AVG_DAU_UDDER_D			--dau score udder depth
			,SUBSTRING(LINE,130,3) AS PTA_UDDER_D_QTY			--PTA udder depth
			,SUBSTRING(LINE,133,2) AS PTA_REL_UDDER_D_PCT		--reliability udder depth
			,SUBSTRING(LINE,135,3) AS AVG_DAU_SUSP_LIG			--dau score suspensory ligament
			,SUBSTRING(LINE,138,3) AS PTA_SUSP_LIG_QTY			--PTA suspensory ligament
			,SUBSTRING(LINE,141,2) AS PTA_REL_SUSP_LIG_PCT		--reliability suspensory ligament
			,SUBSTRING(LINE,143,3) AS AVG_DAU_TEAT_P			--dau score teat placement
			,SUBSTRING(LINE,146,3) AS PTA_TEAT_P_QTY			--PTA teat placement
			,SUBSTRING(LINE,149,1) AS PTA_REL_TEAT_P_PCT		--reliability teat placement
	FROM BUCK_TYPE_F940G
)DEFINITION ONLY;
													
ALTER TABLE TMP_BUCK_TYPE_TABLE ADD CONSTRAINT TMP_BUCK_TYPE_TABLE_PK PRIMARY KEY (ANIM_KEY,EVAL_PDATE);

INSERT INTO TMP_BUCK_TYPE_TABLE
SELECT	id.ANIM_KEY
		,21884 AS  EVAL_PDATE

		,SUBSTRING(LINE,1,17) AS INT_ID						--breed code + country code + identification number 
		,SUBSTRING(LINE,18,4) AS AVG_DAU_HERD				--average number of type daughters per herd
		,SUBSTRING(LINE,22,2) AS NUM_STATES					--number of states with type daughters
		,SUBSTRING(LINE,24,5) AS NUM_HERDS					--number of herds
		,SUBSTRING(LINE,29,6) AS NUM_DAU					--number of daughters
		,SUBSTRING(LINE,34,5) AS NUM_APPRAISALS				--number of appraisals
		,SUBSTRING(LINE,39,3) AS AVG_DAU_FS					--dau score final score 
		,SUBSTRING(LINE,42,3) AS PTA_FS_QTY					--PTA Final Score
		,SUBSTRING(LINE,45,2) AS PTA_REL_FS_PCT				--reliability Final Score
		,SUBSTRING(LINE,47,3) AS AVG_DAU_STT				--dau score stature
		,SUBSTRING(LINE,50,3) AS PTA_STT_QTY				--PTA stature
		,SUBSTRING(LINE,53,2) AS PTA_REL_STT_PCT			--reliability stature
		,SUBSTRING(LINE,55,3) AS AVG_DAU_STR				--dau score strength
		,SUBSTRING(LINE,58,3) AS PTA_STR_QTY				--PTA strength
		,SUBSTRING(LINE,61,2) AS PTA_REL_STR_PCT			--reliability strength
		,SUBSTRING(LINE,63,3) AS AVG_DAU_DR					--dau score dairyness
		,SUBSTRING(LINE,66,3) AS PTA_DR_QTY					--PTA dairyness
		,SUBSTRING(LINE,69,2) AS PTA_REL_DR_PCT				--reliability dairyness
		,SUBSTRING(LINE,71,3) AS AVG_DAU_TEAT_D				--dau score teat diameter
		,SUBSTRING(LINE,74,3) AS PTA_TEAT_D_QTY				--PTA teat diameter
		,SUBSTRING(LINE,77,2) AS PTA_REL_TEAT_D_PCT			--REL teat diameter
		,SUBSTRING(LINE,79,3) AS AVG_DAU_RL					--dau score rear legs
		,SUBSTRING(LINE,82,3) AS PTA_RL_QTY					--PTA rear legs
		,SUBSTRING(LINE,85,2) AS PTA_REL_RL_PCT				--reliability rear legs
		,SUBSTRING(LINE,87,3) AS AVG_DAU_RUMP_A				--dau score rump angle
		,SUBSTRING(LINE,90,3) AS PTA_RUMP_A_QTY				--PTA rump angle
		,SUBSTRING(LINE,93,2) AS PTA_REL_RUMP_A_PCT				--reliability rump angle
		,SUBSTRING(LINE,95,3) AS AVG_DAU_RUMP_W				--dau score rump width
		,SUBSTRING(LINE,98,3) AS PTA_RUMP_W_QTY				--PTA rump width
		,SUBSTRING(LINE,101,2) AS PTA_REL_RUMP_W_PCT		--reliability rump width
		,SUBSTRING(LINE,103,3) AS AVG_DAU_FORE_U_ATT		--dau score fore udder attachment
		,SUBSTRING(LINE,106,3) AS PTA_FORE_U_ATT_QTY		--PTA fore udder attachment
		,SUBSTRING(LINE,109,2) AS PTA_REL_FORE_U_ATT_PCT	--reliability fore udder attachment
		,SUBSTRING(LINE,111,3) AS AVG_DAU_REAR_U_HT			--dau score rear udder height
		,SUBSTRING(LINE,114,3) AS PTA_REAR_U_HT_QTY			--PTA rear udder height
		,SUBSTRING(LINE,117,2) AS PTA_REL_REAR_U_HT_PCT		--reliability rear udder height
		,SUBSTRING(LINE,119,3) AS AVG_DAU_REAR_U_ARCH		--dau score rear udder arch
		,SUBSTRING(LINE,122,3) AS PTA_REAR_U_ARCH_QTY		--PTA rear udder arch
		,SUBSTRING(LINE,125,2) AS PTA_REL_REAR_U_ARCH_PCT	--reliability rear udder arch
		,SUBSTRING(LINE,127,3) AS AVG_DAU_UDDER_D			--dau score udder depth
		,SUBSTRING(LINE,130,3) AS PTA_UDDER_D_QTY			--PTA udder depth
		,SUBSTRING(LINE,133,2) AS PTA_REL_UDDER_D_PCT		--reliability udder depth
		,SUBSTRING(LINE,135,3) AS AVG_DAU_SUSP_LIG			--dau score suspensory ligament
		,SUBSTRING(LINE,138,3) AS PTA_SUSP_LIG_QTY			--PTA suspensory ligament
		,SUBSTRING(LINE,141,2) AS PTA_REL_SUSP_LIG_PCT		--reliability suspensory ligament
		,SUBSTRING(LINE,143,3) AS AVG_DAU_TEAT_P			--dau score teat placement
		,SUBSTRING(LINE,146,3) AS PTA_TEAT_P_QTY			--PTA teat placement
		,SUBSTRING(LINE,149,1) AS PTA_REL_TEAT_P_PCT		--reliability teat placement
FROM BUCK_TYPE_F940G f
INNER JOIN ID_XREF_TABLE id ON SUBSTRING(f.LINE,1,17) = id.INT_ID
							AND id.SEX_CODE ='M'
							AND id.SPECIES_CODE = 1
							AND id.PREFERRED_CODE = 1;
					
--delete from BUCK_TYPE_TABLE immediate;

INSERT INTO BUCK_TYPE_TABLE
		(ANIM_KEY
		,EVAL_PDATE
		,INT_ID
		,AVG_DAU_HERD 
		,NUM_STATES 
		,NUM_HERDS
		,NUM_DAU 
		,NUM_APPRAISALS 
		,AVG_DAU_FS
		,PTA_FS_QTY 
		,PTA_REL_FS_PCT 
		,AVG_DAU_STT
		,PTA_STT_QTY 
		,PTA_REL_STT_PCT 
		,AVG_DAU_STR 
		,PTA_STR_QTY 
		,PTA_REL_STR_PCT 
		,AVG_DAU_DR
		,PTA_DR_QTY 
		,PTA_REL_DR_PCT 
		,AVG_DAU_TEAT_D 
		,PTA_TEAT_D_QTY 
		,PTA_REL_TEAT_D_PCT 
		,AVG_DAU_RL
		,PTA_RL_QTY 
		,PTA_REL_RL_PCT 
		,AVG_DAU_RUMP_A 
		,PTA_RUMP_A_QTY 
		,PTA_REL_RUMP_A_PCT 
		,AVG_DAU_RUMP_W 
		,PTA_RUMP_W_QTY 
		,PTA_REL_RUMP_W_PCT 
		,AVG_DAU_FORE_U_ATT 
		,PTA_FORE_U_ATT_QTY 
		,PTA_REL_FORE_U_ATT_PCT 
		,AVG_DAU_REAR_U_HT 
		,PTA_REAR_U_HT_QTY 
		,PTA_REL_REAR_U_HT_PCT 
		,AVG_DAU_REAR_U_ARCH 
		,PTA_REAR_U_ARCH_QTY 
		,PTA_REL_REAR_U_ARCH_PCT 
		,AVG_DAU_UDDER_D 
		,PTA_UDDER_D_QTY 
		,PTA_REL_UDDER_D_PCT 
		,AVG_DAU_SUSP_LIG 
		,PTA_SUSP_LIG_QTY 
		,PTA_REL_SUSP_LIG_PCT 
		,AVG_DAU_TEAT_P 
		,PTA_TEAT_P_QTY 
		,PTA_REL_TEAT_P_PCT)

SELECT	ANIM_KEY
		,21884 AS EVAL_PDATE
		,INT_ID
		,AVG_DAU_HERD 
		,NUM_STATES 
		,NUM_HERDS
		,NUM_DAU 
		,NUM_APPRAISALS 
		,AVG_DAU_FS
		,PTA_FS_QTY 
		,PTA_REL_FS_PCT 
		,AVG_DAU_STT 
		,PTA_STT_QTY 
		,PTA_REL_STT_PCT 
		,AVG_DAU_STR 
		,PTA_STR_QTY 
		,PTA_REL_STR_PCT 
		,AVG_DAU_DR
		,PTA_DR_QTY 
		,PTA_REL_DR_PCT 
		,AVG_DAU_TEAT_D 
		,PTA_TEAT_D_QTY 
		,PTA_REL_TEAT_D_PCT 
		,AVG_DAU_RL 
		,PTA_RL_QTY 
		,PTA_REL_RL_PCT 
		,AVG_DAU_RUMP_A 
		,PTA_RUMP_A_QTY 
		,PTA_REL_RUMP_A_PCT 
		,AVG_DAU_RUMP_W 
		,PTA_RUMP_W_QTY 
		,PTA_REL_RUMP_W_PCT 
		,AVG_DAU_FORE_U_ATT 
		,PTA_FORE_U_ATT_QTY 
		,PTA_REL_FORE_U_ATT_PCT 
		,AVG_DAU_REAR_U_HT 
		,PTA_REAR_U_HT_QTY 
		,PTA_REL_REAR_U_HT_PCT 
		,AVG_DAU_REAR_U_ARCH 
		,PTA_REAR_U_ARCH_QTY 
		,PTA_REL_REAR_U_ARCH_PCT 
		,AVG_DAU_UDDER_D 
		,PTA_UDDER_D_QTY 
		,PTA_REL_UDDER_D_PCT 
		,AVG_DAU_SUSP_LIG 
		,PTA_SUSP_LIG_QTY 
		,PTA_REL_SUSP_LIG_PCT 
		,AVG_DAU_TEAT_P 
		,PTA_TEAT_P_QTY 
		,PTA_REL_TEAT_P_PCT
 FROM TMP_BUCK_TYPE_TABLE;
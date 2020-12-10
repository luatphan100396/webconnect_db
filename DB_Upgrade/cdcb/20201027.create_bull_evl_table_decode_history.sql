DROP TABLE BULL_EVL_TABLE_DECODE_HISTORY;

CREATE TABLE BULL_EVL_TABLE_DECODE_HISTORY
(
	EVAL_BREED_CODE		CHAR(2)       NOT NULL,
    BULL_ID				CHAR(17)      NOT NULL,
    EVAL_PDATE			SMALLINT      NOT NULL,  
    SOURCE_CODE			CHAR(1)       NOT NULL,
    ANIM_KEY			INTEGER       NOT NULL, 
	STATUS_CODE			CHAR(1)       NOT NULL  DEFAULT 'N',
	PTA_MLK				VARCHAR(15),
	PTA_FAT				VARCHAR(15),
	PTA_PRO				VARCHAR(15),
	PTA_PL				VARCHAR(15),
	PTA_SCS				VARCHAR(15),
	PTA_DPR				VARCHAR(15),
	PTA_HCR				VARCHAR(15),
	PTA_CCR				VARCHAR(15),
	PTA_LIV				VARCHAR(15),
	PTA_GL				VARCHAR(15),
	PTA_MFV				VARCHAR(15),
	PTA_DAB				VARCHAR(15),
	PTA_KET				VARCHAR(15),
	PTA_MAS				VARCHAR(15),
	PTA_MET				VARCHAR(15),
	PTA_RPL				VARCHAR(15),
	PTA_EFC				VARCHAR(15)
);

DECLARE GLOBAL TEMPORARY TABLE SESSION.TMP_TRAIT_CONFIG
(
	MLK_TRAIT_NUM_2			SMALLINT,
	MLK_DECIMAL_ADJUST_CODE	VARCHAR(5),
	FAT_TRAIT_NUM_2			SMALLINT,
	FAT_DECIMAL_ADJUST_CODE	VARCHAR(5),
	PRO_TRAIT_NUM_2			SMALLINT,
	PRO_DECIMAL_ADJUST_CODE	VARCHAR(5),
	PL_TRAIT_NUM_2			SMALLINT,
	PL_DECIMAL_ADJUST_CODE	VARCHAR(5),
	SCS_TRAIT_NUM_2			SMALLINT,
	SCS_DECIMAL_ADJUST_CODE	VARCHAR(5),
	DPR_TRAIT_NUM_2			SMALLINT,
	DPR_DECIMAL_ADJUST_CODE	VARCHAR(5),
	HCR_TRAIT_NUM_2			SMALLINT,
	HCR_DECIMAL_ADJUST_CODE	VARCHAR(5),
	CCR_TRAIT_NUM_2			SMALLINT,
	CCR_DECIMAL_ADJUST_CODE	VARCHAR(5),
	LIV_TRAIT_NUM_2			SMALLINT,
	LIV_DECIMAL_ADJUST_CODE	VARCHAR(5),
	GL_TRAIT_NUM_2			SMALLINT,
	GL_DECIMAL_ADJUST_CODE	VARCHAR(5),
	MFV_TRAIT_NUM_2			SMALLINT,
	MFV_DECIMAL_ADJUST_CODE	VARCHAR(5),
	DAB_TRAIT_NUM_2			SMALLINT,
	DAB_DECIMAL_ADJUST_CODE	VARCHAR(5),
	KET_TRAIT_NUM_2			SMALLINT,
	KET_DECIMAL_ADJUST_CODE	VARCHAR(5),
	MAS_TRAIT_NUM_2			SMALLINT,
	MAS_DECIMAL_ADJUST_CODE	VARCHAR(5),
	MET_TRAIT_NUM_2			SMALLINT,
	MET_DECIMAL_ADJUST_CODE	VARCHAR(5),
	RPL_TRAIT_NUM_2			SMALLINT,
	RPL_DECIMAL_ADJUST_CODE	VARCHAR(5),
	EFC_TRAIT_NUM_2			SMALLINT,
	EFC_DECIMAL_ADJUST_CODE	VARCHAR(5)
) WITH REPLACE ON COMMIT PRESERVE ROWS;

INSERT INTO SESSION.TMP_TRAIT_CONFIG
(
	MLK_TRAIT_NUM_2,
	MLK_DECIMAL_ADJUST_CODE, 
	FAT_TRAIT_NUM_2,
	FAT_DECIMAL_ADJUST_CODE,
	PRO_TRAIT_NUM_2,
	PRO_DECIMAL_ADJUST_CODE,
	PL_TRAIT_NUM_2,
	PL_DECIMAL_ADJUST_CODE,
	SCS_TRAIT_NUM_2,
	SCS_DECIMAL_ADJUST_CODE,
	DPR_TRAIT_NUM_2,
	DPR_DECIMAL_ADJUST_CODE,
	HCR_TRAIT_NUM_2,
	HCR_DECIMAL_ADJUST_CODE,
	CCR_TRAIT_NUM_2,
	CCR_DECIMAL_ADJUST_CODE,
	LIV_TRAIT_NUM_2,
	LIV_DECIMAL_ADJUST_CODE,
	GL_TRAIT_NUM_2,
	GL_DECIMAL_ADJUST_CODE,
	MFV_TRAIT_NUM_2,
	MFV_DECIMAL_ADJUST_CODE,
	DAB_TRAIT_NUM_2,
	DAB_DECIMAL_ADJUST_CODE,
	KET_TRAIT_NUM_2,
	KET_DECIMAL_ADJUST_CODE,
	MAS_TRAIT_NUM_2,
	MAS_DECIMAL_ADJUST_CODE,
	MET_TRAIT_NUM_2,
	MET_DECIMAL_ADJUST_CODE,
	RPL_TRAIT_NUM_2,
	RPL_DECIMAL_ADJUST_CODE,		
	EFC_TRAIT_NUM_2,
	EFC_DECIMAL_ADJUST_CODE
)
SELECT 
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN TRAIT_NUM_2  ELSE NULL END) AS MLK_TRAIT_NUM_2,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'Mlk' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS MLK_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'Fat' THEN TRAIT_NUM_2  ELSE NULL END) AS FAT_TRAIT_NUM_2,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'Fat' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS FAT_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'Pro' THEN TRAIT_NUM_2  ELSE NULL END) AS PRO_TRAIT_NUM_2,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'Pro' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS PRO_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'PL' THEN TRAIT_NUM_2  ELSE NULL END) AS PL_TRAIT_NUM_2,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'PL' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS PL_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'SCS' THEN TRAIT_NUM_2  ELSE NULL END) AS SCS_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'SCS' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS SCS_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'DPR' THEN TRAIT_NUM_2  ELSE NULL END) AS DPR_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'DPR' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS DPR_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'HCR' THEN TRAIT_NUM_2  ELSE NULL END) AS HCR_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'HCR' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS HCR_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'CCR' THEN TRAIT_NUM_2  ELSE NULL END) AS CCR_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'CCR' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS CCR_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'LIV' THEN TRAIT_NUM_2  ELSE NULL END) AS LIV_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'LIV' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS LIV_DECIMAL_ADJUST_CODE,      
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'GL' THEN TRAIT_NUM_2  ELSE NULL END) AS GL_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'GL' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS GL_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'MFV' THEN TRAIT_NUM_2  ELSE NULL END) AS CCR_TRAIT_NUM_2,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'MFV' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS MFV_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'DAB' THEN TRAIT_NUM_2  ELSE NULL END) AS DAB_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'DAB' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS DAB_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'KET' THEN TRAIT_NUM_2  ELSE NULL END) AS KET_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'KET' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS KET_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'MAS' THEN TRAIT_NUM_2  ELSE NULL END) AS MAS_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'MAS' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS MAS_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'MET' THEN TRAIT_NUM_2  ELSE NULL END) AS MET_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'MET' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS MET_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'RPL' THEN TRAIT_NUM_2  ELSE NULL END) AS RPL_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'RPL' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS RPL_DECIMAL_ADJUST_CODE,
       MAX(CASE WHEN TRAIT_SHORT_NAME = 'EFC' THEN TRAIT_NUM_2  ELSE NULL END) AS EFC_TRAIT_NUM_2,
       MAX(CASE when TRAIT_SHORT_NAME = 'EFC' THEN DECIMAL_ADJUST_CODE  ELSE NULL END) AS EFC_DECIMAL_ADJUST_CODE
FROM
(
	SELECT TRAIT_SHORT_NAME, 
	       ((TRAIT_NUM-1)*2)+1 AS TRAIT_NUM_2,
		   CASE  WHEN  DECIMAL_ADJUST_CODE = '0' THEN '1'
                 WHEN  DECIMAL_ADJUST_CODE = '1' THEN '0.1' 
                 WHEN  DECIMAL_ADJUST_CODE = '2' THEN '0.01'
		         ELSE '1'
		   END AS DECIMAL_ADJUST_CODE  
	FROM TRAIT_TABLE
	WHERE TRAIT_SHORT_NAME IN ('Mlk', 'Fat', 'Pro', 'PL', 'SCS', 'DPR', 'HCR', 'CCR', 'LIV', 'GL', 'MFV', 'DAB', 'KET', 'MAS', 'MET', 'RPL', 'EFC')
 )t;
 
 
INSERT INTO BULL_EVL_TABLE_DECODE_HISTORY
 (
 	EVAL_BREED_CODE,
    BULL_ID,
    EVAL_PDATE,  
    SOURCE_CODE,
    ANIM_KEY, 
	STATUS_CODE,
	PTA_MLK,
	PTA_FAT,
	PTA_PRO,
	PTA_PL,
	PTA_SCS,
	PTA_DPR,
	PTA_HCR,
	PTA_CCR,
	PTA_LIV,
	PTA_GL,
	PTA_MFV,
	PTA_DAB,
	PTA_KET,
	PTA_MAS,
	PTA_MET,
	PTA_RPL,
	PTA_EFC
 )
 SELECT	be.EVAL_BREED_CODE,
 		be.BULL_ID,
 		be.EVAL_PDATE,
 		be.SOURCE_CODE,
 		be.ANIM_KEY,
 		be.STATUS_CODE,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.MLK_TRAIT_NUM_2, 2), ''))*tr.MLK_DECIMAL_ADJUST_CODE, tr.MLK_DECIMAL_ADJUST_CODE)	AS PTA_Mlk,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.FAT_TRAIT_NUM_2, 2), ''))*tr.FAT_DECIMAL_ADJUST_CODE, tr.FAT_DECIMAL_ADJUST_CODE)	AS PTA_Fat,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.PRO_TRAIT_NUM_2, 2), ''))*tr.PRO_DECIMAL_ADJUST_CODE, tr.PRO_DECIMAL_ADJUST_CODE) 	AS PTA_Pro,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.PL_TRAIT_NUM_2, 2), ''))*tr.PL_DECIMAL_ADJUST_CODE, tr.PL_DECIMAL_ADJUST_CODE) 	AS PTA_PL,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.SCS_TRAIT_NUM_2, 2), ''))*tr.SCS_DECIMAL_ADJUST_CODE, tr.SCS_DECIMAL_ADJUST_CODE)  AS PTA_SCS, 
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.DPR_TRAIT_NUM_2, 2), ''))*tr.DPR_DECIMAL_ADJUST_CODE, tr.DPR_DECIMAL_ADJUST_CODE)  AS PTA_DPR,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.HCR_TRAIT_NUM_2, 2), ''))*tr.HCR_DECIMAL_ADJUST_CODE, tr.HCR_DECIMAL_ADJUST_CODE)  AS PTA_HCR,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.CCR_TRAIT_NUM_2, 2), ''))*tr.CCR_DECIMAL_ADJUST_CODE, tr.CCR_DECIMAL_ADJUST_CODE)  AS PTA_CCR,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.LIV_TRAIT_NUM_2, 2), ''))*tr.LIV_DECIMAL_ADJUST_CODE, tr.LIV_DECIMAL_ADJUST_CODE)  AS PTA_LIV,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.GL_TRAIT_NUM_2, 2), ''))*tr.GL_DECIMAL_ADJUST_CODE, tr.GL_DECIMAL_ADJUST_CODE)  	AS PTA_GL,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.MFV_TRAIT_NUM_2, 2),''))*tr.MFV_DECIMAL_ADJUST_CODE, tr.MFV_DECIMAL_ADJUST_CODE) 	AS PTA_MFV,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.DAB_TRAIT_NUM_2, 2), ''))*tr.DAB_DECIMAL_ADJUST_CODE, tr.DAB_DECIMAL_ADJUST_CODE)	AS PTA_DAB,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.KET_TRAIT_NUM_2, 2), ''))*tr.KET_DECIMAL_ADJUST_CODE, tr.KET_DECIMAL_ADJUST_CODE)	AS PTA_KET,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.MAS_TRAIT_NUM_2, 2), ''))*tr.MAS_DECIMAL_ADJUST_CODE, tr.MAS_DECIMAL_ADJUST_CODE)	AS PTA_MAS,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.MET_TRAIT_NUM_2, 2), ''))*tr.MET_DECIMAL_ADJUST_CODE, tr.MET_DECIMAL_ADJUST_CODE)	AS PTA_MET,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.RPL_TRAIT_NUM_2, 2), ''))*tr.RPL_DECIMAL_ADJUST_CODE, tr.RPL_DECIMAL_ADJUST_CODE)	AS PTA_RPL,
		FLOAT2CHAR(STR2INT(NULLIF(SUBSTRING(be.TRAIT_PTA_QTY_SEG, tr.EFC_TRAIT_NUM_2, 2), ''))*tr.EFC_DECIMAL_ADJUST_CODE, tr.EFC_DECIMAL_ADJUST_CODE)	AS PTA_EFC
 FROM BULL_EVL_TABLE be
 CROSS JOIN SESSION.TMP_TRAIT_CONFIG tr;
 
ALTER TABLE BULL_EVL_TABLE_DECODE_HISTORY
ADD CONSTRAINT BULL_EVL_TABLE_DECODE_HISTORY_PK PRIMARY KEY (EVAL_BREED_CODE, BULL_ID, EVAL_PDATE, SOURCE_CODE);
 
CREATE INDEX BULL_EVL_TABLE_DECODE_HISTORY_INDEX ON BULL_EVL_TABLE_DECODE_HISTORY   (ANIM_KEY   ASC)  ALLOW REVERSE SCANS;
CREATE INDEX BULL_EVL_TABLE_DECODE_HISTORY_INDEX2 ON BULL_EVL_TABLE_DECODE_HISTORY (EVAL_PDATE DESC, EVAL_BREED_CODE ASC, ANIM_KEY DESC) ALLOW REVERSE SCANS;
CREATE INDEX BULL_EVL_TABLE_DECODE_HISTORY_INDEX_STATUS_CODE ON BULL_EVL_TABLE_DECODE_HISTORY   (STATUS_CODE   ASC)  ALLOW REVERSE SCANS;
 

 
ALTER TABLE BULL_EVL_TABLE_DECODE_HISTORY
ADD COLUMN NM_PTA		VARCHAR(15)
ADD COLUMN NM_REL		VARCHAR(15)
ADD COLUMN MACE			VARCHAR(15)
ADD COLUMN GEN_IND		VARCHAR(15)
ADD COLUMN DAUS			VARCHAR(15)
ADD COLUMN HERDS		VARCHAR(15)
ADD COLUMN US_DAU_PCT	VARCHAR(15)
;

MERGE INTO BULL_EVL_TABLE_DECODE_HISTORY AS A
 USING
 (
 	SELECT	be.ANIM_KEY,
 			be.EVAL_PDATE,
 			STR2INT(NULLIF(SUBSTRING(be.INDEX_AMT_SEG,1,2), '')) AS PTA,
			be.NM_REL_PCT AS NM_PTA,
			CASE WHEN NULLIF(SUBSTRING(be.TRAIT_USABILITY_CODE_SEG, 1, 1), '') BETWEEN 1 AND 8 THEN 'M'
  				 ELSE ''
  			END AS MACE,
  			be.GENOMICS_IND AS GEN_IND,
  			STR2INT(NULLIF(SUBSTRING(be.TRAIT_DAU_QTY_SEG, 1, 4), '')) AS DAUS,
  			STR2INT(NULLIF(SUBSTRING(be.TRAIT_HERDS_QTY_SEG,1,4), '')) AS HERDS,
  			be.US_DAU_PCT AS US_DAU_PCT,
  			ROW_NUMBER()OVER(PARTITION BY ANIM_KEY, EVAL_PDATE ORDER BY	CASE WHEN SOURCE_CODE = 'M' THEN 1
  																			 WHEN SOURCE_CODE = 'I' THEN 2
  																			 WHEN SOURCE_CODE = 'D' THEN 3
  																			 ELSE NULL
  																		END) AS RN
 	FROM BULL_EVL_TABLE be
 ) AS B
 ON A.ANIM_KEY = B.ANIM_KEY
 AND A.EVAL_PDATE = B.EVAL_PDATE
 AND B.RN = 1
 WHEN MATCHED THEN UPDATE 
 SET	NM_PTA = B.PTA,
 		NM_REL = B.NM_PTA,
 		MACE = B.MACE,
 		GEN_IND = B.GEN_IND,
 		DAUS = B.DAUS,
 		HERDS = B.HERDS,
 		US_DAU_PCT = B.US_DAU_PCT
 ;
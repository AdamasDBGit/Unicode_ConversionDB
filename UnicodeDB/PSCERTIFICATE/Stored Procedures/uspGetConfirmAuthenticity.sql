/*
-- =================================================================
-- Author:Chandan Dey
-- Modified By : 
-- Create date:12/07/2007 
-- Description:Select List Student Certificate in T_Student_PS_Certificate table 
-- =================================================================
*/

CREATE PROCEDURE [PSCERTIFICATE].[uspGetConfirmAuthenticity]
(
	@sCertSrlNo	VARCHAR(20),
	@sFirstName			VARCHAR(50),
	@sMiddleName		VARCHAR(50) = NULL,
	@sLastName			VARCHAR(50) = NULL,
	@iPSCert		INT = NULL
)
AS
BEGIN
 SELECT DISTINCT
	ISNULL(TCM.S_Certificate_Name,' ') AS S_Certificate_Name,
	ISNULL(SPC.Dt_Crtd_On,' ') AS Dt_Crtd_On,
	ISNULL(SD.S_Student_ID,' ') AS S_Student_ID,
	ISNULL(SD.S_First_Name,' ') AS S_First_Name,
	ISNULL(SD.S_Middle_Name,' ') AS S_Middle_Name,
	ISNULL(SD.S_Last_Name,' ') AS S_Last_Name,
	ISNULL(CM.S_Course_Name,' ') AS S_Course_Name,
	ISNULL(TM.S_Term_Name,' ') AS S_Term_Name,
	B_PS_Flag AS B_PS_Flag ,
	ISNULL(TCMT.S_Certificate_Name,' ') AS T_Certificate_Name ,
	SCOD.I_Batch_ID  
	   FROM 
			[PSCERTIFICATE].T_Student_PS_Certificate SPC 
			INNER JOIN [PSCERTIFICATE].T_Certificate_Logistic CL
			ON CL.I_Student_Certificate_ID = SPC.I_Student_Certificate_ID
	        INNER JOIN [dbo].T_Student_Detail SD
			ON SPC.I_Student_Detail_ID = SD.I_Student_Detail_ID  -- 3102 = 3102
			INNER JOIN [dbo].T_Student_Center_Detail SCD
			ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID  -- 3102 = 3102
			INNER JOIN dbo.T_Student_Course_Detail SCOD
			ON SD.I_Student_Detail_ID = SCOD.I_Student_Detail_ID
			AND SPC.I_Course_ID = SCOD.I_Course_ID
			AND SCOD.I_Status = 1
			INNER JOIN [dbo].T_Course_Master CM
            ON CM.I_Course_ID = SPC.I_Course_ID   -- 308 = 308
			INNER JOIN [dbo].T_Certificate_Master TCM
			ON TCM.I_Certificate_ID = CM.I_Certificate_ID  -- 28 = 28
			LEFT OUTER JOIN [dbo].T_Term_Master TM
			ON TM.I_Term_ID = SPC.I_Term_ID  -- 186 = 186
			LEFT OUTER JOIN [dbo].T_Certificate_Master TCMT
			ON TCM.I_Certificate_ID = TCMT.I_Certificate_ID  -- 28 = 28
	   WHERE 
			CL.S_Logistic_Serial_No LIKE '%-'+@sCertSrlNo
			AND CL.I_Status =1
			AND SD.S_First_Name = @sFirstName
			AND SD.S_Middle_Name = COALESCE(@sMiddleName, SD.S_Middle_Name)
			AND SD.S_Last_Name = @sLastName
			AND B_PS_Flag = COALESCE(@iPSCert,B_PS_Flag)
END

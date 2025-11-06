/*******************************************************
Description :	This SP enters record into the PS Certificate table based on the 
				Course, Term Module completion status 
				for each student for all the centers

Author	:		Abhisek Bhattacharya
Date	:		06/28/2007
*********************************************************/

CREATE PROCEDURE [PSCERTIFICATE].[uspUpdatePSCertificatePrintStatus] 
(
	@dDate datetime
)
AS

BEGIN TRY 
		
		-- Insert record into T_Student_PS_Certificate table for courses which are completed today
		-- and having Certificate  
		INSERT INTO PSCERTIFICATE.T_Student_PS_Certificate
		(
			I_Student_Detail_ID,
			I_Course_ID,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On
		)
		SELECT	DISTINCT SCD.I_Student_Detail_ID,
				SCD.I_Course_ID,
				1,
				'SYSTEM_BATCH',
				@dDate
		FROM dbo.T_Student_Course_Detail SCD
		INNER JOIN dbo.T_Course_Master CM
		ON SCD.I_Course_ID = CM.I_Course_ID
		AND CM.I_Status = 1
		AND CM.I_Certificate_ID IS NOT NULL
		WHERE SCD.I_Is_Completed = 1
		AND SCD.dt_Upd_On = @dDate
		  
		-- Insert record into T_Student_PS_Certificate table for terms which are completed today
		-- and having Certificate
		INSERT INTO PSCERTIFICATE.T_Student_PS_Certificate
		(
			I_Student_Detail_ID,
			I_Course_ID,
			I_Term_ID,
			B_PS_Flag,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On
		)
		SELECT	DISTINCT STD.I_Student_Detail_ID,
				STD.I_Course_ID,
				STD.I_Term_ID, 
				0,
				1,
				'SYSTEM_BATCH',
				@dDate
		FROM dbo.T_Student_Term_Detail STD
		INNER JOIN dbo.T_Term_Course_Map TCM
		ON STD.I_Course_ID = TCM.I_Course_ID
		AND STD.I_Term_ID = TCM.I_Term_ID
		AND TCM.I_Certificate_ID IS NOT NULL
		WHERE STD.I_Is_Completed = 1
		AND STD.dt_Upd_On = @dDate	
		AND TCM.I_Status = 1

		-- Insert record into T_Student_PS_Certificate table for terms which are completed today
		-- for PS	
		INSERT INTO PSCERTIFICATE.T_Student_PS_Certificate
		(
			I_Student_Detail_ID,
			I_Course_ID,
			I_Term_ID,
			B_PS_Flag,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On
		)
		SELECT	DISTINCT STD.I_Student_Detail_ID,
				STD.I_Course_ID,
				STD.I_Term_ID,
				1,
				1,
				'SYSTEM_BATCH',
				@dDate
		FROM dbo.T_Student_Term_Detail STD
		WHERE STD.I_Is_Completed = 1
		AND STD.dt_Upd_On = @dDate		

		-- Update the S_Certificate_Serial_No column in T_Student_PS_Certificate table
		-- for all Certificate entries done today
		UPDATE PSCERTIFICATE.T_Student_PS_Certificate
		SET S_Certificate_Serial_No = 'CERT_' + CAST(SPSC.I_Student_Certificate_ID AS VARCHAR(150))
		FROM PSCERTIFICATE.T_Student_PS_Certificate SPSC
		WHERE SPSC.S_Crtd_By = 'SYSTEM_BATCH'
		AND SPSC.Dt_Crtd_On = @dDate
		AND ISNULL(SPSC.B_PS_Flag, 0) = 0

		-- Update the S_Certificate_Serial_No column in T_Student_PS_Certificate table
		-- for all PS entries done today
		UPDATE PSCERTIFICATE.T_Student_PS_Certificate
		SET S_Certificate_Serial_No = 'PS_' + CAST(SPSC.I_Student_Certificate_ID AS VARCHAR(150))
		FROM PSCERTIFICATE.T_Student_PS_Certificate SPSC
		WHERE SPSC.S_Crtd_By = 'SYSTEM_BATCH'
		AND SPSC.Dt_Crtd_On = @dDate
		AND ISNULL(SPSC.B_PS_Flag, 0) = 1


END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:18/05/2007 
-- Description:Update Student Request Approve/Reject record in T_Student_Certificate_Request table 
-- =================================================================
*/
CREATE PROCEDURE [PSCERTIFICATE].[uspUpdateStudentRequestApproveReject]
(
		@iStudentCertRequestID	INT		,
		@iStatus		INT,
		@sUpdBy			VARCHAR(20),
		@DtUpdOn		DATETIME,
		@sRemarks		varchar(2000)
)
AS
BEGIN TRY
	
    UPDATE [PSCERTIFICATE].T_Student_Certificate_Request
	SET
	I_Status		= @iStatus,
	S_Upd_By		= @sUpdBy,
	Dt_Upd_On		= @DtUpdOn,
	sRemarks		= @sRemarks
     WHERE  I_Student_Cert_Request_ID = @iStudentCertRequestID  

DECLARE @FName VARCHAR(50)
DECLARE @LName VARCHAR(50)
DECLARE @MName VARCHAR(50)
DECLARE @iStudentID INT

IF (@iStatus = 5)
	BEGIN
-- select the student name to be change for new certificate 
SELECT @FName = SCR.S_Student_FName,@LName = SCR.S_Student_LName,@MName = SCR.S_Student_MName,@iStudentID = SPC.I_Student_Detail_ID
FROM [PSCERTIFICATE].T_Student_Certificate_Request SCR INNER JOIN PSCERTIFICATE.T_Student_PS_Certificate SPC
ON SCR.I_Student_Certificate_ID =SPC.I_Student_Certificate_ID
WHERE SCR.I_Student_Cert_Request_ID = @iStudentCertRequestID 

		IF(@FName <>'' OR @FName IS NOT NULL)
			BEGIN
				-- Update dbo.T_Student_Detail table
			   UPDATE dbo.T_Student_Detail
				SET
					S_First_Name		= UPPER(@FName),
					S_Middle_Name		= COALESCE(UPPER(@MName),S_Middle_Name),
					S_Last_Name			= COALESCE(UPPER(@LName),S_Last_Name),
					S_Upd_By			= @sUpdBy,
					Dt_Upd_On			= @DtUpdOn
			   WHERE  I_Student_Detail_ID = @iStudentID
			END

		
	END

END TRY
BEGIN CATCH
	--Error occurred:

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

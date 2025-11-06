-- =============================================================================================================
-- Author:Ujjwal Sinha
-- Create date:19/06/2007 
-- Description:Insert and Update Duplicate Certificate record in T_Certificate_Logistic ,
--               T_Student_Certificate_Request and T_Student_PS_Certificate table	
-- =============================================================================================================
CREATE PROCEDURE [PSCERTIFICATE].[uspDupPrintPSCertificate] 
(
	@iStudentCertificateID		int		,
	@iStudentCertRequestID		int	        ,
	@sLogisticSerialNo		varchar(100)     ,
	@IStatus			int		,
	@SCrtdBy			varchar(20)	,
	@DtCrtdOn 			datetime 
)
AS
BEGIN TRY
    SET NOCOUNT OFF;

-- Inactive the previous present ps/certificates
IF EXISTS( SELECT * FROM [PSCERTIFICATE].T_Certificate_Logistic WHERE I_Student_Certificate_ID = @iStudentCertificateID)
BEGIN
	UPDATE [PSCERTIFICATE].T_Certificate_Logistic
	SET	I_Status 	     = 0	
	WHERE I_Student_Certificate_ID = @iStudentCertificateID
END

    INSERT INTO [PSCERTIFICATE].T_Certificate_Logistic
      (
	I_Student_Certificate_ID,
	I_Student_Cert_Request_ID	,
	S_Logistic_Serial_No,
	I_Status,
	S_Crtd_By			,
    Dt_Crtd_On
      )
	VALUES
      (
	@iStudentCertificateID,
	@iStudentCertRequestID	,
	@sLogisticSerialNo,
	1,
	@SCrtdBy		,
	@DtCrtdOn 
	)

	UPDATE [PSCERTIFICATE].T_Student_Certificate_Request
	SET 	I_Status 	     = @IStatus		
	WHERE I_Student_Cert_Request_ID = @iStudentCertRequestID
						
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

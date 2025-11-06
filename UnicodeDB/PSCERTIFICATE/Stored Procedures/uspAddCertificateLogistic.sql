-- =================================================================
-- Author:Ujjwal Sinha
-- Create date:11/06/2007 
-- Description:Insert new Certificate Despatch record in T_Certificate_Logistic table	
-- =================================================================
CREATE PROCEDURE [PSCERTIFICATE].[uspAddCertificateLogistic] 
(
	--@iLogisticID				int			,
	--@iStudentCertificateID		int         ,
	--@iStudentCertRequestID		int         ,	
    @SCrtdBy					varchar(20) ,
    @DtCrtdOn 					datetime 
)
AS
BEGIN TRY
    SET NOCOUNT OFF;

    INSERT INTO [PSCERTIFICATE].T_Certificate_Logistic
      (
	--@I_Logistic_ID				,
	--@I_Student_Certificate_ID	,
	--@I_Student_Cert_Request_ID	,	
	S_Crtd_By					,
    Dt_Crtd_On
      )
	VALUES
      (
	--@iLogisticID			,
	--@iStudentCertificateID	,
	--@iStudentCertRequestID  , 
    @SCrtdBy			,
    @DtCrtdOn 
	)
						
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

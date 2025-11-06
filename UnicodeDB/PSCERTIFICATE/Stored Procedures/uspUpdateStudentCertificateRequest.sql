/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:14/05/2007 
-- Description:Update Plcacement registration record in T_Certificate_Query table 
-- =================================================================
*/

CREATE PROCEDURE [PSCERTIFICATE].[uspUpdateStudentCertificateRequest] 
(
	@iStudentCertRequestID		int	      ,
	@iStudentCertificateID		int           ,
	@iStatus			int	      ,
	@sUpdBy				varchar(20)   ,
       	@DtUpdOn 			datetime
	
)
  
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
        -- Update statements for procedure here
	
	UPDATE [PSCERTIFICATE].T_Student_Certificate_Request
	SET 
		I_Status		  = @iStatus			,	
		S_Upd_By		  = @sUpdBy                     ,
	        Dt_Upd_On                = @DtUpdOn
	where I_Student_Cert_Request_ID = @iStudentCertRequestID

--   INSERT INTO [PSCERTIFICATE].T_Certificate_logistic
--      (
--	I_Student_Certificate_ID,
--	I_Student_Cert_Request_ID,
--	S_Crtd_By,
--	Dt_Crtd_On
--      )
--	VALUES
--      (
--	@iStudentCertRequestID  ,
--	@iStudentCertificateID  ,
--       	@sUpdBy		,
--        @DtUpdOn 
--      )
--
END TRY
BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

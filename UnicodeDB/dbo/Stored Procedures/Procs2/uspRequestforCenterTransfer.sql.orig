-- =============================================
-- Author:		Swagata De	
-- Create date: 26/03/2007
-- Description:	Places(inserts) a new request for center transfer
-- =============================================
CREATE PROCEDURE [dbo].[uspRequestforCenterTransfer] 
(
	@iSourceCenterHId int,
	@iDestinationCenterHId int,
	@iStudentDetailId int,
	@dRequestDate datetime,
	@sWorkflowInstanceID varchar(50) = null,
	@iStatus int,
	@sCrtdBy varchar(20),
	@dCrtdOn datetime
	
)
AS
SET NOCOUNT ON
BEGIN TRY	
	DECLARE
	
	@iTransferRequestId int
	
	
	INSERT INTO T_Student_Transfer_Request
	(I_Source_Centre_ID,
	 I_Destination_Centre_ID,
	 I_Student_Detail_ID,
	 Dt_Request_Date,
     S_Workflow_GUID_ID,
	 I_Status,
	 S_Crtd_By,
	 Dt_Crtd_On
	)
	VALUES
	(@iSourceCenterHId,@iDestinationCenterHId,@iStudentDetailId,@dRequestDate,@sWorkflowInstanceID,1,@sCrtdBy,@dCrtdOn)
	
	SET @iTransferRequestId=(SELECT SCOPE_IDENTITY())
	
	SELECT @iTransferRequestId
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

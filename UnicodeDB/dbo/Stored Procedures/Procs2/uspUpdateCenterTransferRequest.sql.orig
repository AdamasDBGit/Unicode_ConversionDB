/**************************************************************************************************************
Created by  : Swagata De
Date		: 02.04.2007
Description : This SP will update the S_Remarks and I_Status fields in the T_Student_Transfer_Request table
Parameters  : CenterTransferRequestID,Remarks and Status
Returns     : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [dbo].[uspUpdateCenterTransferRequest]

(
	 @iCenterTransferReqID INT,
	 @sRemarks VARCHAR(500),
	 @iStatus INT
	 
)
AS
BEGIN TRY 
	
	UPDATE T_Student_Transfer_Request 
	SET S_Remarks = @sRemarks,I_Status=@iStatus
	WHERE I_Transfer_Request_ID=@iCenterTransferReqID
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

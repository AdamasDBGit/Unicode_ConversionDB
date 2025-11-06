/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspApproveGatePassRequest] 
(
	
	@iGatePassRequestID int =null,
	@sRemarks nvarchar(MAX) = null
	
)
AS
begin transaction
BEGIN TRY 
update T_Gate_Pass_Request
SET I_Status = 1
,S_Approved_Remarks = @sRemarks
where I_Gate_Pass_Request_ID = @iGatePassRequestID
select 1 StatusFlag,'Gate pass approved' Message
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction

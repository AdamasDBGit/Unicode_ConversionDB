-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_DeleteTeacherUnavailabilityRequest]
(
	@Mode INT = NULL, -- 1 means RaisedDelte, 2 means Delete
	@UnavailabilityID INT = NULL,
	@RaisedDeleteOrDeleteReason NVARCHAR(MAX) = NULL
)
AS
begin transaction
BEGIN TRY 
	IF (@Mode = 1)
	BEGIN
		update T_ERP_Teacher_Unavailability_Header
		SET I_Status = 4
		,S_RaisedDeleteRequestReason = @RaisedDeleteOrDeleteReason
		,I_RaisedDeleteRequest = 1
		,Dt_RaisedDeleteRequest = GETDATE()
		where I_Teacher_Unavailability_Header_ID = @UnavailabilityID
		select 1 StatusFlag,'Cancellation request created' Message
	END
	ELSE IF(@Mode = 2)
	BEGIN
		update T_ERP_Teacher_Unavailability_Header
		SET I_Status = 3
		,S_CancelReason = @RaisedDeleteOrDeleteReason
		,Dt_CanceledDate = GETDATE()
		where I_Teacher_Unavailability_Header_ID = @UnavailabilityID
		select 1 StatusFlag,'Unavailability request deleted' Message
	END
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction

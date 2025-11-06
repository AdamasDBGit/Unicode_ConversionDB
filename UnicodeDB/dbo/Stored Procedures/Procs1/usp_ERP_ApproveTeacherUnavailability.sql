-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_ApproveTeacherUnavailability]
(
	@Mode INT = NULL, -- 1 means approve, 2 means reject, 3 means approveRaisedDeleteRequest
	@UnavailabilityID INT = NULL,
	@ApprovedOrRejectReason NVARCHAR(MAX) = NULL,
	@ApprovedOrRejectBy INT = NULL
)
AS
begin transaction
BEGIN TRY 
	IF (@Mode = 1)
	BEGIN
		update T_ERP_Teacher_Unavailability_Header
		SET I_Status = 1
		,S_ApprovedRemarks = @ApprovedOrRejectReason
		,I_AprrovedBy = @ApprovedOrRejectBy
		,Dt_Approved = GETDATE()
		where I_Teacher_Unavailability_Header_ID = @UnavailabilityID
		select 1 StatusFlag,'Unavailability approved' Message
	END
	ELSE IF(@Mode = 2)
	BEGIN
		update T_ERP_Teacher_Unavailability_Header
		SET I_Status = 2
		,S_RejectedRemarks = @ApprovedOrRejectReason
		,I_RejectedBy = @ApprovedOrRejectBy
		,Dt_Rejected = GETDATE()
		where I_Teacher_Unavailability_Header_ID = @UnavailabilityID
		select 1 StatusFlag,'Unavailability rejected' Message
	END
	IF (@Mode = 3)
	BEGIN
		update T_ERP_Teacher_Unavailability_Header
		SET I_Status = 3
		,S_ApprovedRemarks = @ApprovedOrRejectReason
		,I_AprrovedBy = @ApprovedOrRejectBy
		,Dt_Approved = GETDATE()
		where I_Teacher_Unavailability_Header_ID = @UnavailabilityID
		select 1 StatusFlag,'Cancellation request approved' Message
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

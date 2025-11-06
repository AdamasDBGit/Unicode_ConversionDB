-- =============================================
-- Author:		Aritra Saha
-- Create date: 12/03/2007
-- Description:	Update Followupinformation
-- =============================================
CREATE PROCEDURE [dbo].[uspSaveFollowUpDetails] 
(
	-- Add the parameters for the stored procedure here
	@iEnquiryRegnID int,
	@iProsEmployeeID int,
	@dFollowUpDate datetime,
	@dNextFollowUpDate datetime,
	@sFollowUpRemarks varchar(200),
	@iFollowUpClosureID int
	
)

AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    -- Update FollowUp Information for an Enquiry
	BEGIN TRANSACTION    
	INSERT INTO dbo.T_Enquiry_Regn_FollowUp (
			I_Enquiry_Regn_ID,
			I_Employee_ID,
			Dt_Followup_Date,
			Dt_Next_Followup_Date,
			S_Followup_Remarks,
			I_Followup_Closure_ID)
	VALUES
		(
		@iEnquiryRegnID,
		@iProsEmployeeID,
		@dFollowUpDate,
		@dNextFollowUpDate,
		@sFollowUpRemarks,
		@iFollowUpClosureID
		)
		
		-- Status Code = 3 ; Closed Enquiry
		IF @iFollowUpClosureID <> 0 
			UPDATE  T_Enquiry_Regn_Detail SET I_Enquiry_Status_Code = 3 WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID
			
		COMMIT TRANSACTION
END TRY

BEGIN CATCH
	--Error occurred:  
	ROLLBACK TRANSACTION
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

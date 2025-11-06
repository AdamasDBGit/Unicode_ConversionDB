-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_SaveFollowUpEnquiry] 
	-- Add the parameters for the stored procedure here
	(
		@FollowUpTypeID INT = NULL, 
		@FollowUpBy VARCHAR(90) = NULL, --
		@FollowUpDate VARCHAR(90) = NULL, --
		@FollowUpRemark VARCHAR(300) = NULL, --
		@FollowUpStatus INT = NULL,  --
		--@FollowUpClosureID INT = NULL,
		@EnquiryRegnID INT = NULL, --
		@EnquiryRegnType INT = NULL --

	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		BEGIN
		INSERT INTO T_ERP_Enquiry_Regn_Followup(R_I_FollowupType_ID, S_Followup_By, Dt_Followup_Date, S_Followup_Remarks, I_Followup_Status, R_I_Enquiry_Regn_ID, R_I_Enquiry_Type_ID)
		VALUES(@FollowUpTypeID, @FollowUpBy, @FollowUpDate, @FollowUpRemark, @FollowUpStatus, @EnquiryRegnID, @EnquiryRegnType);
		SELECT 1 AS statusFlag, 'Follow Up Added Successfully' AS Message
	END
END

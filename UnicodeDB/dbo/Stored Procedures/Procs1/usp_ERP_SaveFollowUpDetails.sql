-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_SaveFollowUpDetails]
(
	@FollowUpTypeID int = NULL, 
	@FollowUpDate datetime = NULL,
	@NextFollowUpDate datetime = NULL,
	@FollowUpRemark NVARCHAR(MAX) = NULL, 
	@FollowUpStatus INT = NULL,  
	@EnquiryRegnID INT = NULL,
	@UserID int = null

	--@FollowUpBy NVARCHAR(MAX) = NULL, --
	--@FollowUpClosureID INT = NULL,
	--@EnquiryRegnType INT = NULL --
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		Declare @EmployeeID int = null;

		set @EmployeeID = (select top 1 ED.I_Employee_ID
						  from 
						  T_Employee_Dtls as ED 
						  inner join
						  T_User_Master as UM on UM.I_Reference_ID=ED.I_Employee_ID
						  where UM.S_User_Type='CE' and UM.I_User_ID=@UserID)
	  
    -- Insert statements for procedure here
	INSERT INTO [dbo].[T_Enquiry_Regn_Followup]
	(
		ERP_R_I_FollowupType_ID, 
		Dt_Followup_Date, 
		Dt_Next_Followup_Date, 
		S_Followup_Remarks, 
		S_Followup_Status, 
		I_Enquiry_Regn_ID,
		I_Employee_ID,
		I_User_ID
	)
	VALUES 
	(
		@FollowUpTypeID, 
		@FollowUpDate, 
		@NextFollowUpDate,
		@FollowUpRemark, 
		@FollowUpStatus, 
		@EnquiryRegnID,
		@EmployeeID, 
		@UserID
	);
	SELECT 1 AS statusFlag, 'Follow Up Added Successfully' AS Message
END


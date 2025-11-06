-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- exec [dbo].[uspGetAllFollowUpType] null
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllFollowUpType]
	-- Add the parameters for the stored procedure here
	(
		@I_FollowupType_ID INT = NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT I_FollowupType_ID
	,S_Followup_Name 
	,Is_Active 

	FROM T_ERP_FollowupType_Master

	WHERE (I_FollowupType_ID = @I_FollowupType_ID OR @I_FollowupType_ID IS NULL)
END

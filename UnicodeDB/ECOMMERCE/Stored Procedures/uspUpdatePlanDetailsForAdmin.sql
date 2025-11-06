-- =============================================
-- Author:		<Parichay Nandi>
-- Create date: <21-04-23>
-- Description:	<to update the details of the Plan>
-- =============================================
CREATE PROCEDURE [ECOMMERCE].[uspUpdatePlanDetailsForAdmin]
	-- Add the parameters for the stored procedure here
	@PlanId Int,@PlanCode varchar(MAX), @PlanName varchar(MAX), @ValidTo datetime, @IsPublished bit, @I_Language_ID int,@I_Language_Name varchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update  [ECOMMERCE].[T_Plan_Master]
	Set PlanCode=@PlanCode, PlanName=@PlanName, ValidTo=@ValidTo, IsPublished=@IsPublished, I_Language_ID=@I_Language_ID, I_Language_Name=@I_Language_Name
	Where PlanID=@PlanId;

END

-- =============================================
-- Author:		<Parichay Nandi>
-- Create date: <21-04-23>
-- Description:	<to get the details of the Plan>
-- =============================================
CREATE PROCEDURE [ECOMMERCE].[uspGetPlanDetailsForAdmin] 
	-- Add the parameters for the stored procedure here
	@PlanID Int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 Select PlanID,PlanCode,PlanName,ValidTo,IsPublished,I_Language_ID,I_Language_Name from [ECOMMERCE].[T_Plan_Master] where PlanID=@PlanID;
	 
	 Select ConfigId,ConfigValue from  [ECOMMERCE].[T_Plan_Config] where PlanID=@PlanID Order By ConfigID Asc;
END

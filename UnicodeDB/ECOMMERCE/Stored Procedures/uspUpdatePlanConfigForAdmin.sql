-- =============================================
-- Author:		<Parichay Nandi>
-- Create date: <21-04-23>
-- Description:	<to update the details of the Plan>
-- =============================================
CREATE PROCEDURE [ECOMMERCE].[uspUpdatePlanConfigForAdmin]
	-- Add the parameters for the stored procedure here
	@PlanId Int, @Img varchar(Max), @CourseDuration varchar(Max),@Price varchar(Max),@DiscountedPrice varchar(Max),@Summary varchar(Max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	Update  [ECOMMERCE].[T_Plan_Config]
	SET ConfigValue = 
  CASE ConfigID
    WHEN 3 THEN @Img
    WHEN 4 THEN @CourseDuration
    WHEN 7 THEN @Price
	WHEN 8 THEN @DiscountedPrice
	WHEN 1006 THEN @Summary
  END
WHERE ConfigID IN (3,4,7,8,1006) AND PlanID=@PlanId;

END

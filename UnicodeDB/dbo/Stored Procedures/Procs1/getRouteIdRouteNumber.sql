-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getRouteIdRouteNumber]
	-- Add the parameters for the stored procedure here
	(
		@BrandID INT NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select I_Route_ID as RouteID
	,S_Route_No as RouteNo
	from T_BusRoute_Master
	where I_Brand_ID = @BrandID 
	and I_Status = 1
END

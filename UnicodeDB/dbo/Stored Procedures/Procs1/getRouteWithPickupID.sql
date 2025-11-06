-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- exec getRouteWithPickupID 1475, 107
-- =============================================
CREATE PROCEDURE [dbo].[getRouteWithPickupID]
	-- Add the parameters for the stored procedure here
	(
		@PickupPoint INT NULL,
		@BrandID INT NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select TTM.I_PickupPoint_ID as PickupID
	,TRTM.I_Route_ID as RouteID
	from T_Route_Transport_Map TRTM
	left join T_Transport_Master as TTM on TRTM.I_PickupPoint_ID = TTM.I_PickupPoint_ID
	where TTM.I_PickupPoint_ID =  @PickupPoint 
	and TRTM.I_Status = 1
	and TTM.I_Status = 1
	and TTM.I_Brand_ID = @BrandID
END

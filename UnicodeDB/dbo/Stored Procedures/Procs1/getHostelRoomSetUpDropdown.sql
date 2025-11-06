-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[getHostelRoomSetUpDropdown]
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
	SELECT DISTINCT S_Building_Name as BuildingName
	FROM T_room_master
	WHERE I_Brand_ID = @BrandID

	Select Distinct S_Block_Name as BlockName
	from T_room_master
	WHERE I_Brand_ID = @BrandID

	Select distinct S_Floor_Name as FloorName
	from T_room_master
	WHERE I_Brand_ID = @BrandID

	Select distinct S_Room_No as RoomNo
	from T_room_master
	WHERE I_Brand_ID = @BrandID
END

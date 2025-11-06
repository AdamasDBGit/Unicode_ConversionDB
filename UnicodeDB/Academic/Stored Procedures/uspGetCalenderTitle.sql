-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Academic].[uspGetCalenderTitle]
	-- Add the parameters for the stored procedure here
	@brandid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 select HCT.I_Calender_Title_ID as CalenderTitle,HCT.S_Calender_Title_Name as CalenderTitleName from T_Holiday_Calender_Title_Master as HCT where HCT.I_Brand_ID= @brandid
END

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Academic].[uspGetHolidayType] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 select HT.I_Holiday_Type_ID as holidayTypeID,HT.S_Holiday_Type_Name as holidayTypeName from [dbo].[T_Holiday_Type] as HT
END

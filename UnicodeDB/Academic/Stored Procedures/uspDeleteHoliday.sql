-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <28th August,2023>
-- Description:	<to delete the holidays using calender id>
-- =============================================
CREATE PROCEDURE [Academic].[uspDeleteHoliday] 
	-- Add the parameters for the stored procedure here
	@iCalenderID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Delete from T_School_Holiday_Calender where I_Calender_ID = @iCalenderID;
   Delete from T_School_Holiday_Calender_Detail where I_Calender_ID= @iCalenderID;
	Delete from	T_Holiday_Calender_Title_Map where I_Calender_ID = @iCalenderID;

	select 1 statusFlag,'Holiday deleted succesfully.' message 
END

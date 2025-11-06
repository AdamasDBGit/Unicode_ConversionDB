-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <23 August 2023>
-- Description:	<to fetch the holiday>
--exec [Academic].[uspGetHoliday]
-- =============================================
CREATE PROCEDURE  [Academic].[uspGetHoliday]
	-- Add the parameters for the stored procedure here
	@brandid int
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
SELECT 
SHC.I_Calender_ID CalenderID,
SHC.S_Holiday_Name HolidayName,
SHC.I_Holiday_Type_ID HolidayType, 
SHC.Dt_From_Date StartDate, 
SHC.Dt_To_Date EndDate,
HCTM.I_Brand_ID BrandID
FROM T_School_Holiday_Calender AS SHC
 left JOIN T_Holiday_Calender_Title_Map THCTM  ON THCTM.I_Calender_ID = SHC.I_Calender_ID
 left join T_Holiday_Calender_Title_Master HCTM ON HCTM.I_Calender_Title_ID = THCTM.I_Calender_Title_ID 
 where I_Brand_ID=@brandid
END

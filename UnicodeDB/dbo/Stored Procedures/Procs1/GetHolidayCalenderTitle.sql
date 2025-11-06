-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 April 02>
-- Description:	<Get All Holiday Calender Title>
-- =============================================
CREATE PROCEDURE [dbo].[GetHolidayCalenderTitle]
	
AS
BEGIN

	select DISTINCT
	HCTM.Calender_Title_ID as HolidayCalenderTitleID,
	HCTM.Calender_Title_Name as Title,
	HCTM.Is_Default as IsDefault,
	HCTM.I_Status as Activestatus,
	HCTM.CreatedBy as CreatedBy,
	HCTM.CreatedOn as CreatedOn,
	CTC.CalenderTitleCategoryID as CalenderTitleCategoryID,
	CTC.CalenderTitleCategoryDesc as CalenderTitleCategoryDesc,
	--- For list : Position can not be change--
	WDM.Day_ID as WeekDayID,
	WDM.Day_Name as WeekDayName,
	SASM.School_Session_ID as AcademicSessionID,
	SASM.Session_Start_Date as SessionStartDate,
	SASM.Session_End_Date as SessionEndDate
	--- ------------------------------------  --
	from Holiday_Calender_Title_Master as HCTM
	left join
	Weekly_Off_Master as WOM on WOM.I_Holiday_Calender_Title_ID=HCTM.Calender_Title_ID
	inner join
	Week_Day_Master as WDM on WDM.Day_ID=WOM.I_Week_Day_ID
	inner join
	School_Academic_Session_Master as SASM on SASM.School_Session_ID=WOM.I_Academic_session_ID
	left join
	Calender_Title_Category as CTC on CTC.CalenderTitleCategoryID=HCTM.Title_Category
END

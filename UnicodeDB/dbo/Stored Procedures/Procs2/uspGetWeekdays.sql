-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-May-11>
-- Description:	<Get All the Weekdays>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetWeekdays] 

AS
BEGIN
	
	select 
	Day_ID as WeekDayID,
	Day_Name as WeekDayName
	from 
	Week_Day_Master 
	

END

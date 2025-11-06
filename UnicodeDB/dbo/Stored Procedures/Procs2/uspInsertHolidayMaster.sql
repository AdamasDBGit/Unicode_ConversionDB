/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspInsertHolidayMaster] 
(
	@sHolidayName nvarchar(100),
	@iHolidayType int = null,
	@UTCalenderTitle UT_CalenderTitle readonly,
	@dtFormDate datetime,
	@dtToDate datetime,
	@sCreatedBy nvarchar(50),
	@iCalenderID int = null
)
AS
begin transaction
BEGIN TRY 
IF(@iCalenderID>0)
BEGIN
Delete from T_School_Holiday_Calender where I_Calender_ID = @iCalenderID;
Delete from T_School_Holiday_Calender_Detail where I_Calender_ID= @iCalenderID;
Delete from	T_Holiday_Calender_Title_Map where I_Calender_ID = @iCalenderID;
END
IF EXISTS(select * from T_School_Holiday_Calender where S_Holiday_Name=@sHolidayName and Dt_From_Date=@dtFormDate and Dt_To_Date = @dtToDate)
BEGIN
SELECT 0 StatusFlag,'Duplicate' Message
END
ELSE
BEGIN
DECLARE @iLsatID int
INSERT INTO T_School_Holiday_Calender
(
I_School_Session_ID
,S_Holiday_Name
,I_Holiday_Type_ID
,Dt_From_Date
,Dt_To_Date
,I_Status
,S_CreatedBy
,Dt_CreatedOn

)
VALUES
(
1,
 @sHolidayName
,@iHolidayType
,@dtFormDate
,@dtToDate
,1
,@sCreatedBy
,GETDATE()
)
set @iLsatID = SCOPE_IDENTITY()
   
	WHILE (@dtFormDate <= @dtToDate) 
	BEGIN
	INSERT INTO T_School_Holiday_Calender_Detail
	(
	 I_Calender_ID
	,I_Weekly_Off_Day_ID
	,Dt_Date
	,S_Remarks
	)
	Values( @iLsatID,0,@dtFormDate,null)
	set @dtFormDate = DATEADD(day, 1, @dtFormDate);
	END

	INSERT INTO T_Holiday_Calender_Title_Map
	(
	I_Calender_ID
	,I_Calender_Title_ID
	)
	select @iLsatID,CalenderTitleID from @UTCalenderTitle
	SELECT 1 StatusFlag,'Holiday added' Message,@iLsatID CalenderID
END



END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
	--RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction


CREATE PROCEDURE [dbo].[usp_ERP_GetTeacherMonthAttendance] 
(
	-- Add the parameters for the stored procedure here
	@FacultyMasterID INT = NULL,
	@MonthID int = NULL
)
AS
BEGIN
	BEGIN TRY
	DECLARE @MinDate DATE = '',
		@MaxDate DATE = '',
		@SessionName NVARCHAR(max),
		@BrandID int;

		set @BrandID = (select I_Brand_ID from T_Faculty_Master where I_Faculty_Master_ID = @FacultyMasterID)
		select top 1 @MinDate=Dt_Session_Start_Date
	,@MaxDate=Dt_Session_End_Date,@SessionName=S_Label
FROM T_School_Academic_Session_Master WHERE I_Current_Session = 1 
and I_Brand_ID=@BrandID
order by I_School_Session_ID desc;

SELECT 
	MONTH(ay_dt.Teaching_Date) MonthID,
	 ay_dt.Teaching_Date Date,
	 ay_dt.week_no
	,TERSD.I_Period_No PeriodNo
	,TERSD.T_FromSlot FromTime
	,TERSD.T_ToSlot ToTime
	,TEAEH.Dt_Date as Class_date
	,CASE when TEAEH.Dt_Date is null then 0 else 1 end Status
	,TESCR.I_Student_Class_Routine_ID

	FROM T_ERP_Student_Class_Routine as TESCR
	inner join T_ERP_Routine_Structure_Detail as TERSD ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID
	inner join T_ERP_Routine_Structure_Header as TERSH ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID
	inner join (
		select Teaching_Date,DATEPART(dw,Teaching_Date) as week_no from 
			(
			SELECT  TOP (DATEDIFF(DAY, @MinDate, @MaxDate) + 1)
					Teaching_Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @MinDate)
					-- ,DATEPART(dw,GETDATE())
			FROM    sys.all_objects a
					CROSS JOIN sys.all_objects b

			) as t
	) as ay_dt on ay_dt.week_no = TERSD.I_Day_ID
	left join (
		
		select Holiday_Date from (
			select 
			case when DATEDIFF(DAY, TE.Dt_StartDate, TE.Dt_EndDate)=0 
				then DATEADD(DAY, ROW_NUMBER() OVER(partition by TE.I_Event_ID ORDER BY I.id)-1, TE.Dt_StartDate) 
				else  DATEADD(DAY, ROW_NUMBER() OVER(partition by TE.I_Event_ID ORDER BY I.id)-1, TE.Dt_StartDate)
				end as Holiday_Date,
			TE.S_Event_Name as HolidayName,
			TEV.S_Event_Category HolidayType,
			TE.I_Event_ID,

			case when DATEDIFF(DAY, TE.Dt_StartDate, TE.Dt_EndDate)=0 
				then SUBSTRING(datename(dw,DATEADD(DAY, ROW_NUMBER() OVER(partition by TE.I_Event_ID ORDER BY I.id)-1, TE.Dt_StartDate) ), 1, 3)
				else  SUBSTRING(datename(dw,DATEADD(DAY, ROW_NUMBER() OVER(partition by TE.I_Event_ID ORDER BY I.id)-1, TE.Dt_StartDate)), 1, 3)
				end 
				Day,
			TE.I_Brand_ID BrandID
			from T_Event TE 
			join T_INCR  I ON I.Id<=(DATEDIFF(DAY, TE.Dt_StartDate, TE.Dt_EndDate) + 1) 
			inner join 
			T_Event_Category TEV ON TE.I_Event_Category_ID = TEV.I_Event_Category_ID
			where TE.I_Brand_ID = @BrandID and TE.S_Is_Unplanned IS NULL
			) as holiday group by Holiday_Date
	) as holiday on holiday.Holiday_Date = ay_dt.Teaching_Date	
	left join T_ERP_Attendance_Entry_Header as TEAEH ON TEAEH.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID
		AND TEAEH.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID
		AND TEAEH.Dt_Date = ay_dt.Teaching_Date
	WHERE TESCR.I_Faculty_Master_ID = @FacultyMasterID and holiday.Holiday_Date is null 
	and MONTH(ay_dt.Teaching_Date)=@MonthID
	order by ay_dt.Teaching_Date
	;
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

		SELECT	@ErrMsg = ERROR_MESSAGE(),
				@ErrSeverity = ERROR_SEVERITY()
		select 0 StatusFlag,@ErrMsg Message
	END CATCH
END



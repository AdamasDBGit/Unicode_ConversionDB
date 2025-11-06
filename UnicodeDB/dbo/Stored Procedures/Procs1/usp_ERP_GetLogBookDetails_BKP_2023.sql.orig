
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Nov-09>
-- Description:	<Get Log book Details>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetLogBookDetails_BKP_2023] 
	-- Add the parameters for the stored procedure here
	@iFacultyID INT,
	@iMonthNo INT,
	@iAcademicSession INT,
	@iBrandID INT,
	@iSchoolGroup INT= NULL,
	@iClass INT=NULL,
	@iSubject INT= NULL,
	@iDayNo varchar(max) = NULL,
	@isection INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	CREATE table #RoutineWiseLogBook
	(
	BrandID int,
	BrandName varchar(max),
	RoutineStructureHeaderID INT,
	TotalNoofPeriods INT,
	RoutineSlotStart time,
	RoutineDuration time,
	PeriodGap time,
	SchoolGroupID INT,
	SchoolGroupName varchar(max),
	ClassID INT,
	ClassName varchar(max),
	SectionID INT,
	SectionName varchar(max),
	SubjectID int,
	SubjectName varchar(max),
	RoutineStructureDetailID INT,
	PeriodNo INT,
	PeriodStart time,
	PeriodEnd time,
	ClassDayID INT,
	ClassDayName varchar(max),
	StudentClassRoutineID INT,
	)

	insert into #RoutineWiseLogBook
	select 
	BM.I_Brand_ID as BrandID,
	BM.S_Brand_Name as BrandName,
	RSH.I_Routine_Structure_Header_ID as RoutineStructureHeaderID,
	RSH.I_Total_Periods as TotalNoofPeriods,
	RSH.T_Start_Slot as RoutineSlotStart,
	RSH.T_Duration as RoutineDuration,
	RSH.T_Period_Gap as PeriodGap,
	ISNULL(SG.I_School_Group_ID,0) as SchoolGroupID,
	ISNULL(SG.S_School_Group_Name,'NA') as SchoolGroupName,
	ISNULL(C.I_Class_ID,0) as ClassID,
	ISNULL(C.S_Class_Name,'NA') as ClassName,
	ISNULL(S.I_Section_ID,0) as SectionID,
	ISNULL(S.S_Section_Name,'--') as SectionName,
	SM.I_Subject_ID as SubjectID,
	SM.S_Subject_Name as SubjectName,
	RSD.I_Routine_Structure_Detail_ID as RoutineStructureDetailID,
	RSD.I_Period_No as PeriodNo,
	RSD.T_FromSlot as PeriodStart,
	RSD.T_ToSlot as PeriodEnd,
	WDM.I_Day_ID as ClassDayID,
	WDM.S_Day_Name as ClassDayName,
	SCR.I_Student_Class_Routine_ID as StudentClassRoutineID
	from
	T_ERP_Routine_Structure_Header as RSH
	inner join
	T_ERP_Routine_Structure_Detail as RSD on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	inner join
	T_ERP_Student_Class_Routine as SCR on SCR.I_Routine_Structure_Detail_ID=RSD.I_Routine_Structure_Detail_ID
	inner join
	T_School_Group SG on SG.I_School_Group_ID=RSH.I_School_Group_ID
	inner join
	T_School_Group_Class as SGC on SGC.I_School_Group_ID=SG.I_School_Group_ID and SGC.I_Class_ID=RSH.I_Class_ID
	inner join
	T_Class as C on C.I_Class_ID=SGC.I_Class_ID and C.I_Class_ID=RSH.I_Class_ID
	inner join
	T_Week_Day_Master as WDM on WDM.I_Day_ID=RSD.I_Day_ID
	inner join
	T_Subject_Master as SM on SM.I_Subject_ID=SCR.I_Subject_ID
	inner join
	T_Brand_Master as BM on BM.I_Brand_ID=SM.I_Brand_ID
	left join
	T_Section as S on S.I_Section_ID=RSH.I_Section_ID

	where SCR.I_Faculty_Master_ID=@iFacultyID and RSH.I_School_Session_ID=@iAcademicSession
	and RSH.I_School_Group_ID = ISNULL(@iSchoolGroup,RSH.I_School_Group_ID)
	and SM.I_Brand_ID=@iBrandID and C.I_Class_ID=ISNULL(@iClass,C.I_Class_ID)


	Declare @days table
	(
	daynumbers int 
	)

	insert into @days
	select cast(val as int) daynumbers from dbo.fnString2Rows(@iDayNo,',')

	--select daynumbers from @days

	if(@iDayNo IS NULL)
		BEGIN
			select 
			Distinct 
			BrandID,
			BrandName,
			RoutineStructureHeaderID,
			TotalNoofPeriods,
			RoutineSlotStart,
			RoutineDuration,
			PeriodGap,
			SchoolGroupID,
			SchoolGroupName,
			ClassID,
			ClassName,
			SectionID,
			SectionName,
			SubjectID,
			SubjectName,
			RoutineStructureDetailID,
			PeriodNo,
			PeriodStart,
			PeriodEnd,
			ClassDayID,
			ClassDayName,
			StudentClassRoutineID
			from #RoutineWiseLogBook
		END

		ELSE
		 BEGIN

			select 
			Distinct 
			BrandID,
			BrandName,
			RoutineStructureHeaderID,
			TotalNoofPeriods,
			RoutineSlotStart,
			RoutineDuration,
			PeriodGap,
			SchoolGroupID,
			SchoolGroupName,
			ClassID,
			ClassName,
			SectionID,
			SectionName,
			SubjectID,
			SubjectName,
			RoutineStructureDetailID,
			PeriodNo,
			PeriodStart,
			PeriodEnd,
			ClassDayID,
			ClassDayName,
			RL.StudentClassRoutineID
			from #RoutineWiseLogBook RL
			inner join
			(
			select TTP.I_Teacher_Time_Plan_ID as LookBookID,
			TTP.Dt_Plan_Date as ClassDate,SSP.I_Subject_Structure_Plan_ID as SubjectStructurePlanID,
			TTP.I_Student_Class_Routine_ID as StudentClassRoutineID,SSP.I_Day_No as LessionPlanDayNo,
			SSP.I_Month_No as LessionPlanMonthno,SSPER.I_Completion_Percentage as CompletionPercentage,SSPER.S_Remarks as Remarks
			,SSPER.Dt_ExecutedAt as ClassExecutedDate
			from T_ERP_Teacher_Time_Plan as TTP 
			inner join
			T_ERP_Subject_Structure_Plan as SSP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
			inner join
			T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
			left join
			T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
			where SSP.I_Month_No=@iMonthNo and (@iDayNo IS NULL or SSP.I_Day_No in (select daynumbers from @days))
			) as Logbook on 
			Logbook.StudentClassRoutineID=RL.StudentClassRoutineID


		 END




	select 
	Distinct
	RL.StudentClassRoutineID,Logbook.* 
	from 
	#RoutineWiseLogBook as RL
	inner join
	(
	select TTP.I_Teacher_Time_Plan_ID as LookBookID,
	CAST(TTP.Dt_Class_Date as DATE) as ClassDate,SSP.I_Subject_Structure_Plan_ID as SubjectStructurePlanID,
	TTP.I_Student_Class_Routine_ID as StudentClassRoutineID,SSP.I_Day_No as LessionPlanDayNo,
	SSP.I_Month_No as LessionPlanMonthno,SSPER.I_Completion_Percentage as CompletionPercentage,SSPER.S_Remarks as Remarks
	,SSPER.Dt_ExecutedAt as ClassExecutedDate
	from T_ERP_Teacher_Time_Plan as TTP 
	inner join
	T_ERP_Subject_Structure_Plan as SSP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	left join
	T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	where SSP.I_Month_No=@iMonthNo and (@iDayNo IS NULL or SSP.I_Day_No in (select daynumbers from @days))
	) as Logbook on 
	Logbook.StudentClassRoutineID=RL.StudentClassRoutineID



	declare @DateListOfMonth table
	(
	Date datetime,
	DayName varchar(max),
	WeekDayNo int
	)

	;WITH DateCTE AS (
		SELECT DATEFROMPARTS(2023, @iMonthNo, 1) AS DateInMonth
		UNION ALL
		SELECT DATEADD(DAY, 1, DateInMonth)
		FROM DateCTE
		WHERE MONTH(DATEADD(DAY, 1, DateInMonth)) = @iMonthNo
	)

	insert into  @DateListOfMonth 
	SELECT
		DateInMonth AS Date,
		DATENAME(WEEKDAY, DateInMonth) AS DayName,
		DATEPART(WEEKDAY, DateInMonth) as WeekDayNo
	FROM
		DateCTE
	OPTION (MAXRECURSION 0);



	select RWLB.StudentClassRoutineID,RWLB.ClassDayID as DBDayID,RWLB.ClassDayName as DBDayName,
	CAST(DLM.Date as DATE) as ClassDate,DLM.DayName,DLM.WeekDayNo from 
	#RoutineWiseLogBook as RWLB
	inner join
	@DateListOfMonth as DLM on DLM.WeekDayNo=RWLB.ClassDayID
	order by ClassDate,RWLB.StudentClassRoutineID,DLM.DayName,DLM.WeekDayNo








END

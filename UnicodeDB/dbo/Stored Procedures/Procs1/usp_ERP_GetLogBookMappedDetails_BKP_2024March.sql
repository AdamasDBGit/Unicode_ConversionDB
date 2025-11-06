

-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Nov-23>
-- Description:	<Get Log Book View Details>
-- =============================================
CREATE   PROCEDURE  [dbo].[usp_ERP_GetLogBookMappedDetails_BKP_2024March]
	-- Add the parameters for the stored procedure here
	@ifaculty INT,
	@iClassRoutineID INT,
	@DtClassDate datetime,
	@iSubjectID INT=null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


	DECLARE @RoutineHeaderID INT=null

	DECLARE @ErrMessage NVARCHAR(4000)

	select @RoutineHeaderID=RSH.I_Routine_Structure_Header_ID from 
	T_ERP_Student_Class_Routine as SCR 
	inner join
	T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	inner join
	T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	inner join
	T_Subject_Master as SM on SM.I_Subject_ID=SCR.I_Subject_ID and RSH.I_Class_ID=SM.I_Class_ID
	where SCR.I_Student_Class_Routine_ID=@iClassRoutineID and SCR.I_Faculty_Master_ID=@ifaculty
	and RSD.I_Day_ID = DATEPART(WEEKDAY,@DtClassDate) 

	IF @RoutineHeaderID IS NOT NULL

	BEGIN

	CREATE table #LogBookDetail
	(
	ClassDate datetime,
	SubjectStructurePlanID int,
	StudentClassRoutineID int,
	RoutineHeaderID int,
	LessionPlanDayNo int,
	LessionPlanMonthno int,
	TeacherTimePlanID int,
	CompletionPercentage decimal(4,1),
	Remarks varchar(max),
	ClassExecutedDate datetime,
	IsDayCompleted bit,
	BrandID int,
	IsEditable bit,
	TotalCompletionPercentage decimal(4,1),
	IsRemarksRegister bit
	)


	Create table #RemainingLessionPlan
	(
	ClassDate datetime,
	SubjectStructurePlanID INT,
	StudentClassRoutineID INT,
	RoutineHeaderID INT,
	LessionPlanDayNo INT,
	LessionPlanMonthno INT,
	IsStarted bit,
	IsCompleted bit,
	TotalCompletionPercentage decimal(4,1)
	)



	insert into #LogBookDetail
	select DISTINCT
	Logbook.* ,
	CASE WHEN ISNULL(LogRegisterAfter.TotalRegisteredAfter,0) > 0 OR (config.S_config_Value like 'No') OR Logbook.IsDayCompleted = 'True'
	then 'false'
	ELSE
	'true'
	END as IsEditable,
	TotalCompletionPercentage.TotalCompletionPercentage,1 IsRemarksRegister
	

	from 
	(
	select CAST(TTP.Dt_Class_Date as DATE) as ClassDate,SSP.I_Subject_Structure_Plan_ID as SubjectStructurePlanID ,
	TTP.I_Student_Class_Routine_ID as StudentClassRoutineID,RSH.I_Routine_Structure_Header_ID as RoutineHeaderID,
	SSP.I_Day_No as LessionPlanDayNo,
	SSP.I_Month_No as LessionPlanMonthno,TTP.I_Teacher_Time_Plan_ID as TeacherTimePlanID,
	SSPER.I_Completion_Percentage as CompletionPercentage,SSPER.S_Remarks as Remarks
	,SSPER.Dt_ExecutedAt as ClassExecutedDate,ISNULL(SSPER.Is_Completed,'false')  as IsDayCompleted,SM.I_Brand_ID as BrandID
	from T_ERP_Teacher_Time_Plan as TTP 
	inner join
	T_ERP_Subject_Structure_Plan as SSP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Student_Class_Routine as SCR on SCR.I_Student_Class_Routine_ID=TTP.I_Student_Class_Routine_ID
	inner join
	T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	inner join
	T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	inner join
	T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Teacher_Time_Plan_ID=TTP.I_Teacher_Time_Plan_ID
	inner join
	T_Subject_Master as SM on SM.I_Subject_ID = SCR.I_Subject_ID
	where TTP.I_Student_Class_Routine_ID=@iClassRoutineID and 
	SCR.I_Subject_ID=@iSubjectID 
	and CONVERT(DATE,TTP.Dt_Class_Date)=CONVERT(DATE,@DtClassDate)
	) as Logbook 
	inner join
	(
	select I_Subject_Structure_Plan_ID,I_Routine_Structure_Header_ID
	,SUM(ISNULL(lessionPercentage,0.0)) as TotalCompletionPercentage

	from 
	(
	select DISTINCT SSP.I_Subject_Structure_Plan_ID,RSH.I_Routine_Structure_Header_ID
	,ISNULL(SSPER.I_Completion_Percentage,0.0) as lessionPercentage
	,SCR.I_Student_Class_Routine_ID,TTP.Dt_Class_Date

	from T_ERP_Teacher_Time_Plan as TTP
		inner join
		T_ERP_Subject_Structure_Plan as SSP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
		inner join
		T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
		inner join
		T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Teacher_Time_Plan_ID=TTP.I_Teacher_Time_Plan_ID
		inner join
		T_ERP_Student_Class_Routine as SCR on SCR.I_Student_Class_Routine_ID=TTP.I_Student_Class_Routine_ID
		inner join
		T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
		inner join
		T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
		where RSH.I_Routine_Structure_Header_ID=@RoutineHeaderID
	) as t
	group by I_Routine_Structure_Header_ID,I_Subject_Structure_Plan_ID
	) TotalCompletionPercentage on TotalCompletionPercentage.I_Subject_Structure_Plan_ID=Logbook.SubjectStructurePlanID
	
	
	
	left join
	(
	select
	I_Subject_Structure_Plan_ID,I_Routine_Structure_Header_ID,count(*) as TotalRegisteredAfter

	from 
	(
	select DISTINCT SSP.I_Subject_Structure_Plan_ID,RSH.I_Routine_Structure_Header_ID


	from T_ERP_Teacher_Time_Plan as TTP
		inner join
		T_ERP_Subject_Structure_Plan as SSP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
		inner join
		T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
		inner join
		T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Teacher_Time_Plan_ID=TTP.I_Teacher_Time_Plan_ID
		inner join
		T_ERP_Student_Class_Routine as SCR on SCR.I_Student_Class_Routine_ID=TTP.I_Student_Class_Routine_ID
		inner join
		T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
		inner join
		T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
		where RSH.I_Routine_Structure_Header_ID=@RoutineHeaderID and 
		SCR.I_Subject_ID=@iSubjectID 
	and CONVERT(DATE,TTP.Dt_Class_Date)>CONVERT(DATE,@DtClassDate) 

	) as t
	group by I_Routine_Structure_Header_ID,I_Subject_Structure_Plan_ID
	) as LogRegisterAfter on LogRegisterAfter.I_Subject_Structure_Plan_ID=Logbook.SubjectStructurePlanID

	left join
	(
	select ECM.S_config_code,ECM.S_config_Value,ECM.I_Brand_ID from 
	T_ERP_Configuration_Master as ECM
	inner join
	T_ERP_Configuration_Type as ECT on ECM.I_Config_Type_ID=ECT.I_Config_Type_ID
	where 
	ECT.S_Config_Type='Validation' and ECM.S_Screen='LogBook' and ECM.S_config_code='IS_MODIFIED_DAY_ALLOWED'
	and ECM.I_Status=1
	) as config on config.I_Brand_ID=Logbook.BrandID


	order by Logbook.LessionPlanDayNo,Logbook.IsDayCompleted

	
	select DISTINCT
	--@DtClassDate,
	ISNULL(SG.I_School_Group_ID,0) as SchoolGroupID,
	ISNULL(SG.S_School_Group_Name,'NA') as SchoolGroupName,
	ISNULL(C.I_Class_ID,0) as ClassID,
	ISNULL(C.S_Class_Name,'NA') as ClassName,
	ISNULL(S2.I_Section_ID,0) as SectionID,
	ISNULL(S2.S_Section_Name,'--') as SectionName,
	ISNULL(S.I_Stream_ID,0) as StreamID,
	ISNULL(S.S_Stream,'NA') as Stream,
	SM.I_Subject_ID as SubjectID,
	SM.S_Subject_Name as SubjectName,
	RSD.I_Period_No as PeriodNo,
	RSD.T_FromSlot as PeriodStart,
	RSD.T_ToSlot as PeriodEnd,
	WDM.I_Day_ID as ClassDayID,
	WDM.S_Day_Name as ClassDayName,
	SCR.I_Faculty_Master_ID as Faculty,
	CASE WHEN config.S_config_code IS NULL OR config.S_config_Value = 'Yes' THEN 'true'
	ELSE
	'false' END as IsMultipleIncompleteDaysAllowed
	from 
	T_ERP_Student_Class_Routine as SCR 
	inner join
	T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	inner join
	T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	inner join
	T_Subject_Master as SM on SM.I_Subject_ID=SCR.I_Subject_ID and SM.I_Status=1
	inner join
	T_Week_Day_Master as WDM on WDM.I_Day_ID=RSD.I_Day_ID
	inner join
	T_Faculty_Master as FM on FM.I_Faculty_Master_ID=SCR.I_Faculty_Master_ID
	left join
	T_School_Group as SG on SG.I_School_Group_ID=RSH.I_School_Group_ID
	left join
	T_Class as C on C.I_Class_ID=RSH.I_Class_ID
	left join
	T_Stream as S on S.I_Stream_ID=RSH.I_Stream_ID
	left join
	T_Section as S2 on S2.I_Section_ID=RSH.I_Section_ID
	left join
	(
	select ECM.S_config_code,ECM.S_config_Value,ECM.I_Brand_ID from 
	T_ERP_Configuration_Master as ECM
	inner join
	T_ERP_Configuration_Type as ECT on ECM.I_Config_Type_ID=ECT.I_Config_Type_ID
	where 
	ECT.S_Config_Type='Validation' and ECM.S_Screen='LogBook' and ECM.S_config_code='IS_MULTIPLE_INCOMPLETE_DAYS_ALLOWED'
	and ECM.I_Status=1
	) as config on config.I_Brand_ID=SG.I_Brand_Id
	where SCR.I_Student_Class_Routine_ID=@iClassRoutineID
	
	
	
	select * from #LogBookDetail

	

	insert into #RemainingLessionPlan
	select DISTINCT 
	@DtClassDate as ClassDate,
     SubjectStructurePlan.SubjectStructurePlanID as SubjectStructurePlanID,
	 SCR.I_Student_Class_Routine_ID as StudentClassRoutineID,
	 RSH.I_Routine_Structure_Header_ID as RoutineHeaderID,
	 SubjectStructurePlan.LessionPlanDayNo as LessionPlanDayNo,
	 SubjectStructurePlan.LessionPlanMonthno as LessionPlanMonthno,
	 CASE
	 WHEN 
	 TotalCompletionPercentage.TotalCompletionPercentage IS NULL then 'false'
	 ELSE
	 'true'
	 END as IsStarted,
	 CASE WHEN ExcludeSubjectPlanDetails.I_Subject_Structure_Plan_ID IS NOT NULL then 'true'
	 ELSE
	 'false'
	 END as IsCompleted,
	ISNULL(TotalCompletionPercentage.TotalCompletionPercentage,0.0) as TotalCompletionPercentage
	from 
	T_ERP_Student_Class_Routine as SCR 
	inner join
	T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	inner join
	T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	inner join
	T_Subject_Master as SM on SM.I_Subject_ID=SCR.I_Subject_ID and SM.I_Status=1
	left join
	T_School_Group as SG on SG.I_School_Group_ID=RSH.I_School_Group_ID
	left join
	T_Class as C on C.I_Class_ID=RSH.I_Class_ID
	left join
	T_Stream as S on S.I_Stream_ID=RSH.I_Stream_ID
	inner join
	(
		
		select SSP.I_Subject_Structure_Plan_ID as SubjectStructurePlanID,
		SSP.I_Day_No as LessionPlanDayNo,SSP.I_Month_No as LessionPlanMonthno,SSP.I_Subject_ID 

		from 
		T_ERP_Subject_Structure_Plan as SSP 
		inner join
		T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
		inner join
		T_ERP_Subject_Structure as ESS on ESS.I_Subject_Structure_ID=SSPD.I_Subject_Structure_ID
		inner join
		T_ERP_Subject_Structure_Header as ESSH on ESSH.I_Subject_Structure_Header_ID=ESS.I_Subject_Structure_Header_ID
		inner join
		T_ERP_Subject_Template_Header as ESTH on ESTH.I_Subject_Template_Header_ID=ESSH.I_Subject_Template_Header_ID
		inner join
		T_ERP_Subject_Template as EST on EST.I_Subject_Template_Header_ID=ESTH.I_Subject_Template_Header_ID
		and EST.I_Subject_Template_ID=ESS.I_Subject_Template_ID
		
		
	) as SubjectStructurePlan on SubjectStructurePlan.I_Subject_ID=SM.I_Subject_ID 
	and SubjectStructurePlan.LessionPlanMonthno=DATEPART(month, @DtClassDate) 
	left join
	(
	(select TTP.I_Subject_Structure_Plan_ID 
	from 
	T_ERP_Teacher_Time_Plan as TTP
	inner join
	T_ERP_Subject_Structure_Plan_Execution_Remarks as ESSPER on TTP.I_Teacher_Time_Plan_ID=ESSPER.I_Teacher_Time_Plan_ID
	inner join
	T_ERP_Student_Class_Routine as SCR on TTP.I_Student_Class_Routine_ID=SCR.I_Student_Class_Routine_ID
	inner join
	T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	inner join
	T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	
	where ESSPER.Is_Completed=1 and RSH.I_Routine_Structure_Header_ID=@RoutineHeaderID
	)
	union

	select SubjectStructurePlanID from #LogBookDetail


	) as ExcludeSubjectPlanDetails on ExcludeSubjectPlanDetails.I_Subject_Structure_Plan_ID=SubjectStructurePlan.SubjectStructurePlanID

	left join
	(
	select I_Subject_Structure_Plan_ID,I_Routine_Structure_Header_ID
	,SUM(ISNULL(lessionPercentage,0.0)) as TotalCompletionPercentage

	from 
	(
	select DISTINCT SSP.I_Subject_Structure_Plan_ID,RSH.I_Routine_Structure_Header_ID
	,ISNULL(SSPER.I_Completion_Percentage,0.0) as lessionPercentage
	,SCR.I_Student_Class_Routine_ID,TTP.Dt_Class_Date

	from T_ERP_Teacher_Time_Plan as TTP
		inner join
		T_ERP_Subject_Structure_Plan as SSP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
		inner join
		T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
		inner join
		T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Teacher_Time_Plan_ID=TTP.I_Teacher_Time_Plan_ID
		inner join
		T_ERP_Student_Class_Routine as SCR on SCR.I_Student_Class_Routine_ID=TTP.I_Student_Class_Routine_ID
		inner join
		T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
		inner join
		T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
		where RSH.I_Routine_Structure_Header_ID=@RoutineHeaderID
	) as t
	group by I_Routine_Structure_Header_ID,I_Subject_Structure_Plan_ID
	) TotalCompletionPercentage
	on TotalCompletionPercentage.I_Subject_Structure_Plan_ID=SubjectStructurePlan.SubjectStructurePlanID
	


	where SubjectStructurePlan.I_Subject_ID=@iSubjectID and SCR.I_Student_Class_Routine_ID=@iClassRoutineID
	and ExcludeSubjectPlanDetails.I_Subject_Structure_Plan_ID IS NULL
	order by SubjectStructurePlan.LessionPlanDayNo,TotalCompletionPercentage

	select * from #RemainingLessionPlan

	select remainglessionPlan.SubjectStructurePlanID,SSPD.I_Subject_Structure_ID as LeafSubjectStructureID from 
	#RemainingLessionPlan as remainglessionPlan
	inner join
	T_ERP_Subject_Structure_Plan as SSP on remainglessionPlan.SubjectStructurePlanID=SSP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Subject_Structure as SS on SSPD.I_Subject_Structure_ID=SS.I_Subject_Structure_ID and I_Status=1
	Union
	select mappedlessionPlan.SubjectStructurePlanID,SSPD.I_Subject_Structure_ID as LeafSubjectStructureID from 
	#LogBookDetail as mappedlessionPlan
	inner join
	T_ERP_Subject_Structure_Plan as SSP on mappedlessionPlan.SubjectStructurePlanID=SSP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Subject_Structure as SS on SSPD.I_Subject_Structure_ID=SS.I_Subject_Structure_ID and I_Status=1
	
	
	--order by remainglessionPlan.SubjectStructurePlanID

	drop table #RemainingLessionPlan
	drop table #LogBookDetail
	
	
	
	END

	ELSE

		BEGIN

		SELECT @ErrMessage='Invalid Request'

		RAISERROR(@ErrMessage,11,1)

		END


END

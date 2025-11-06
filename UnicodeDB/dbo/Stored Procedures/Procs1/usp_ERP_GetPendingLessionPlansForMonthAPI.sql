


-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Nov-23>
-- Description:	<Get Log Book View Details>
-- =============================================
CREATE   PROCEDURE  [dbo].[usp_ERP_GetPendingLessionPlansForMonthAPI]
	-- Add the parameters for the stored procedure here
	@stoken NVARCHAR(MAX),
	@iClassRoutineID INT,
	@DtClassDate datetime,
	@iSubjectID INT=null

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here


	DECLARE @iFacultyID INT=NULL
	DECLARE @ErrMessage NVARCHAR(4000)


	IF NOT EXISTS
	(
	select * from 
	T_Faculty_Master as FM 
	inner join
	T_ERP_User as UM on UM.I_User_ID=FM.I_User_ID where 
	UM.S_Token=@sToken
	)
	BEGIN

		SELECT @ErrMessage='Invalid Token'

		RAISERROR(@ErrMessage,11,1)

	END

	ELSE

	BEGIN

	IF NOT EXISTS
	(
	select * from 
	T_Faculty_Master as FM 
	inner join
	T_ERP_User as UM on UM.I_User_ID=FM.I_User_ID
	inner join
	T_ERP_Student_Class_Routine as SCR on SCR.I_Faculty_Master_ID=FM.I_Faculty_Master_ID
	inner join
	T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	where 
	UM.S_Token=@sToken and SCR.I_Subject_ID=@iSubjectID and SCR.I_Student_Class_Routine_ID=@iClassRoutineID
	and RSD.I_Day_ID = DATEPART(WEEKDAY,@DtClassDate)
	)
	BEGIN

		SELECT @ErrMessage='Invalid Request'

		RAISERROR(@ErrMessage,11,1)

	END

	END


	select @iFacultyID=FM.I_Faculty_Master_ID from 
	T_Faculty_Master as FM 
	inner join
	T_ERP_User as UM on UM.I_User_ID=FM.I_User_ID where 
	UM.S_Token=@sToken 




	DECLARE @RoutineHeaderID INT=null

	select @RoutineHeaderID=RSH.I_Routine_Structure_Header_ID from 
	T_ERP_Student_Class_Routine as SCR 
	inner join
	T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	inner join
	T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	where SCR.I_Student_Class_Routine_ID=@iClassRoutineID

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
	
	)



	Create table #RemainingLessionPlan
	(
	ClassDate datetime,
	BrandID INT,
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
	Logbook.* 
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



	insert into #RemainingLessionPlan
	select DISTINCT 
	@DtClassDate as ClassDate,
	SM.I_Brand_ID as BrandID,
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
	select I_Subject_Structure_Plan_ID--,I_Routine_Structure_Header_ID
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
	group by 
	--I_Routine_Structure_Header_ID,
	I_Subject_Structure_Plan_ID
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


	drop table #RemainingLessionPlan
	drop table #LogBookDetail
	
	END

END


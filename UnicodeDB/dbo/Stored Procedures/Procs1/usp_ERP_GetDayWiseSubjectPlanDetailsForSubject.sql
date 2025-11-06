
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Nov-02>
-- Description:	<Get Subject mapped with structure>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetDayWiseSubjectPlanDetailsForSubject] 
	-- Add the parameters for the stored procedure here
	@iAcademicSessionID INT=NULL,
	@iBrandID INT,
	@iSubject INT=NULL
	,@iMonthNo INT=NULL
	,@iUserID INT=NULL
	,@iSchoolGroup INT=NULL
	,@iClass INT = NULL
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	Create Table #SubjectStructurePlan
			(
			SubjectID int,
			SubjectName varchar(max),
			MonthNo INT,
			DayNo INT,
			SubjectStructurePlanID int,
			SubjectStructurePlanDetailID int,
			LeafSubjectStructureID int,
			LeafSubjectLevelDesc varchar(max),
			IsPlanedMappedwithRoutine bit
			)


	insert into #SubjectStructurePlan
	 select 
	 SM.I_Subject_ID as SubjectID
	,SM.S_Subject_Name as SubjectName
	,subjectStructurePlan.I_Month_No as MonthNo
	,subjectStructurePlan.I_Day_No as DayNo
	,subjectStructurePlan.I_Subject_Structure_Plan_ID as SubjectStructurePlanID
	,subjectStructurePlan.I_Subject_Structure_Plan_Detail_ID as SubjectStructurePlanDetailID
	,subjectStructurePlan.I_Subject_Structure_ID as LeafSubjectStructureID
	,subjectStructurePlan.S_Name as LeafSubjectLevelDesc
	,CASE 
	WHEN SubjectTimePlan.Dt_Class_Date IS NULL THEN 0
	ELSE 1
	END as IsPlanedMappedwithRoutine
	 from 
	T_Subject_Master as SM 
	inner join
	T_School_Group as SG on SG.I_School_Group_ID=SM.I_School_Group_ID and SG.I_Status=1
	inner join
	T_Class as TC on TC.I_Class_ID=SM.I_Class_ID and TC.I_Status=1
	left join
	(
		select SSP.*,SSPD.I_Subject_Structure_Plan_Detail_ID,SSPD.I_Subject_Structure_ID,ESS.S_Name  from 
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
		where SSP.I_Month_No=ISNULL(@iMonthNo,SSP.I_Month_No) and (SSP.I_School_Session_ID=ISNULL(@iAcademicSessionID,SSP.I_School_Session_ID)) 
	) as subjectStructurePlan on subjectStructurePlan.I_Subject_ID=SM.I_Subject_ID

	left join
	(
	select SSP.I_Subject_Structure_Plan_ID,SSP.I_Subject_ID,TTP.Dt_Class_Date,SSP.I_Day_No from 
	T_ERP_Subject_Structure_Plan as SSP
	inner join
	T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Teacher_Time_Plan as TTP on SSP.I_Subject_Structure_Plan_ID=TTP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Student_Class_Routine as SCR on SCR.I_Student_Class_Routine_ID=TTP.I_Student_Class_Routine_ID
	inner join
	T_ERP_Routine_Structure_Detail as RSD on RSD.I_Routine_Structure_Detail_ID=SCR.I_Routine_Structure_Detail_ID
	inner join
	T_ERP_Routine_Structure_Header as RSH on RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID
	inner join
	T_School_Academic_Session_Master as SASM on SASM.I_School_Session_ID=RSH.I_School_Session_ID
	where SSP.I_Month_No=ISNULL(@iMonthNo,SSP.I_Month_No) and (SSP.I_School_Session_ID=ISNULL(@iAcademicSessionID,SSP.I_School_Session_ID))
	) as SubjectTimePlan on --SubjectTimePlan.I_Subject_Structure_Plan_ID=subjectStructurePlan.I_Subject_Structure_Plan_ID
	SubjectTimePlan.I_Subject_ID=SM.I_Subject_ID
	and
	SubjectTimePlan.I_Day_No=subjectStructurePlan.I_Day_No
	where SM.I_Brand_ID=@iBrandID 
	and SG.I_School_Group_ID=ISNULL(@iSchoolGroup,SG.I_School_Group_ID) 
	and TC.I_Class_ID=ISNULL(@iClass,TC.I_Class_ID)
	and SM.I_Subject_ID= ISNULL(@iSubject,SM.I_Subject_ID)
	and SM.I_Status=1

	select DISTINCT * from #SubjectStructurePlan where MonthNo IS NOT NULL

	drop table #SubjectStructurePlan



END

-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Nov-23>
-- Description:	<Get Log Book View Details>
-- =============================================
CREATE PROCEDURE  [dbo].[ups_ERP_GetLogBookMappedDetails]
	-- Add the parameters for the stored procedure here
	@iClasRoutineID INT,
	@DtClassDate datetime,
	@iSubjectID INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
	Logbook.* ,
	TotalCompletionPercentage.TotalCompletionPercentage
	from 
	(
	select TTP.I_Teacher_Time_Plan_ID as TeacherTimePlanID,
	CAST(TTP.Dt_Class_Date as DATE) as ClassDate,SSP.I_Subject_Structure_Plan_ID as SubjectStructurePlanID ,
	TTP.I_Student_Class_Routine_ID as StudentClassRoutineID,SSP.I_Day_No as LessionPlanDayNo,
	SSP.I_Month_No as LessionPlanMonthno,SSPER.I_Completion_Percentage as CompletionPercentage,SSPER.S_Remarks as Remarks
	,SSPER.Dt_ExecutedAt as ClassExecutedDate
	from T_ERP_Teacher_Time_Plan as TTP 
	inner join
	T_ERP_Subject_Structure_Plan as SSP on TTP.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	inner join
	T_ERP_Subject_Structure_Plan_Detail as SSPD on SSPD.I_Subject_Structure_Plan_ID=SSP.I_Subject_Structure_Plan_ID
	left join
	T_ERP_Subject_Structure_Plan_Execution_Remarks as SSPER on SSPER.I_Teacher_Time_Plan_ID=TTP.I_Teacher_Time_Plan_ID
	) as Logbook 
	inner join
	(
	select I_Subject_Structure_Plan_ID,I_Routine_Structure_Header_ID
	,SUM(ISNULL(lessionPercentage,0.0)) as TotalCompletionPercentage

	from 
	(
	select DISTINCT SSP.I_Subject_Structure_Plan_ID,RSH.I_Routine_Structure_Header_ID
	,ISNULL(SSPER.I_Completion_Percentage,0.0) as lessionPercentage


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
		
	) as t
	group by I_Routine_Structure_Header_ID,I_Subject_Structure_Plan_ID
	) TotalCompletionPercentage on TotalCompletionPercentage.I_Subject_Structure_Plan_ID=Logbook.SubjectStructurePlanID




END

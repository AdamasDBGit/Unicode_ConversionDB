-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 July 17>
-- Description:	<Get Result List>
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspGetStudentMarks]
	-- Add the parameters for the stored procedure here
	(
	@iBrandID int 
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
	SR.I_Student_Result_ID as StudentResultID
	,SAM.S_Label as AcademicSession
	,RES.Title as ExamScheduleTitle
	,SR.S_Student_ID as StudentID
	,SG.S_School_Group_Name as SchoolGroupName
	,TC.S_Class_Name as ClassName
	,SBM.S_Batch_Name as BatchName 
	,ISNULL(SR.I_Aggregate_Full_Marks,0) as AggregateFullMarks
	,ISNULL(SR.I_Aggregate_Obtained_Marks,0) as AggregateObtainedMarks
	,ISNULL(SR.I_Aggregate_Pass_Marks,0) as AggregatePassMarks
	,ISNULL(SR.I_Aggregate_Percentage,0) as AggregatePercentage
	,ISNULL(SR.I_Aggregate_Class_Highest_Percentage,0) as AggregateClassHighestPercentage
	,ISNULL(SR.I_Aggregate_Section_Highest_Percentage,0) as AggregateSectionHighestPercentage
	,ISNULL(SR.I_Aggregrate_Class_Average_Percentage,0) as AggregrateClassAveragePercentage
	,ISNULL(SR.I_Attendance_Percentage,0) as AttendancePercentage
	,ISNULL(SR.I_Student_Rank,0) as StudentRank
	,ISNULL(SR.I_Total_Students,0) as TotalStudents
	,SR.Dt_ResultDate as ResultDate
	from 
	T_Student_Result as SR
	inner join
	T_Result_Exam_Schedule as RES on SR.I_Result_Exam_Schedule_ID=RES.I_Result_Exam_Schedule_ID
	inner join
	T_Course_Master as CM on CM.I_Course_ID=RES.I_Course_ID
	inner join
	T_School_Academic_Session_Master as SAM on SAM.I_School_Session_ID=RES.I_School_Session_ID
	inner join
	T_Term_Master as TM on TM.I_Term_ID=SR.I_Term_ID
	inner join
	T_School_Group_Class as SGC on SGC.I_School_Group_Class_ID=RES.I_School_Group_Class_ID
	inner join
	T_School_Group as SG on SG.I_School_Group_ID=SGC.I_School_Group_ID
	inner join
	T_Class as TC on TC.I_Class_ID=SGC.I_Class_ID
	inner join
	T_Student_Batch_Master as SBM on SBM.I_Batch_ID=SR.I_Batch_ID
	where SG.I_Brand_Id=@iBrandID
	order by SBM.I_Batch_ID,S_Student_ID
	

    
END

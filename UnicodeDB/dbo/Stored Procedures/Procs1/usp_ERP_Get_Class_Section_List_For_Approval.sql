
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-Jan-07>
-- Description:	<Get Student Promotion Academic Approval Class List>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_Get_Class_Section_List_For_Approval]
	-- Add the parameters for the stored procedure here
	@iAcademicSessionID INT=NULL,
	@iBrandID INT=NULL,
	@iSchoolProgramID INT=NULL,
	@iClassID INT=NULL,
	@PromotionalStatus INT=NULL -- 1:Pending for Academic Approval,2:In Progress,3: Ready for Financial Approval
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	create table #AcademicPromotionEligibleClass
	(
	ClassID int,
	ClassName varchar(max),
	SectionID int,
	SectionName varchar(max),
	StreamID int,
	StreamName varchar(max),
	SchoolGroupID int,
	SchoolGroupName varchar(max),
	SchoolSessionID int,
	SchoolSession varchar(max),
	ExamScheduleDetailID int,
	ExamName varchar(max),
	PromotionalStatus int,
	PromotionalStatusDesc varchar(max),
	TotalStudent int
	)



    -- Insert statements for procedure here
	insert into #AcademicPromotionEligibleClass
	(
	ClassID,
	ClassName,
	SectionID,
	SectionName,
	StreamID,
	StreamName,
	SchoolGroupID,
	SchoolGroupName,
	SchoolSessionID,
	SchoolSession,
	ExamScheduleDetailID,
	ExamName
	)
	select DISTINCT C.I_Class_ID as ClassID,C.S_Class_Name as ClassName,
	S.I_Section_ID as SectionID,S.S_Section_Name as SectionName,
	S1.I_Stream_ID as StreamID,S1.S_Stream as StreamName,
	SG.I_School_Group_ID as SchoolGroupID,SG.S_School_Group_Name as SchoolGroupName,
	SASM.I_School_Session_ID as SchoolSessionID,SASM.S_Label as SchoolSession,
	ESD.inExamScheduleDetailId as ExamScheduleDetailID,
	ESD.stExamName as ExamName
	from 
	T_ERP_Exam_ScheduleSubjectDetails as ESSD
	inner join
	T_ERP_Exam_SchedulesDetails as ESD on ESSD.inExamScheduleDetailId=ESD.inExamScheduleDetailId
	inner join
	T_Class as C on ESSD.inClassId=C.I_Class_ID
	inner join
	T_Section as S on ESSD.inSectionId=S.I_Section_ID
	inner join
	T_School_Academic_Session_Master as SASM on ESD.inAcademicSessionId=SASM.I_School_Session_ID
	inner join
	T_School_Group as SG on ESD.inSchoolProgramId=SG.I_School_Group_ID
	left join
	T_Stream as S1 on ESSD.inStreamId=S1.I_Stream_ID
	where ESD.flgIsFinalExam='true'
	and ISNULL(@iAcademicSessionID,SASM.I_School_Session_ID)=SASM.I_School_Session_ID
	and ISNULL(@iSchoolProgramID,SG.I_School_Group_ID)=SG.I_School_Group_ID
	and ISNULL(@iClassID,C.I_Class_ID)=C.I_Class_ID


	Create table #NoStudentForEligibleForPromotion
	(
	I_NoStudentForEligibleForPromotion_ID int,
	I_Brand_ID int,
	I_Class_ID int,
	I_School_Group_ID int,
	I_School_Session_ID int,
	I_Section_ID int,
	I_Stream_ID int,
	I_Status int,
	NumberOfStudent int
	)
	
	insert into #NoStudentForEligibleForPromotion
	(
	I_Brand_ID,
	I_Class_ID,
	I_School_Group_ID,
	I_School_Session_ID,
	I_Section_ID,
	I_Stream_ID,
	I_Status,
	NumberOfStudent
	)
	select 
	PromotedStudents.I_Brand_ID,
	PromotedStudents.I_Class_ID,
	PromotedStudents.I_School_Group_ID,
	PromotedStudents.I_School_Session_ID,
	PromotedStudents.I_Section_ID,
	PromotedStudents.I_Stream_ID,
	PromotedStudents.I_Status,
	PromotedStudents.NumberOfStudent
	from #AcademicPromotionEligibleClass as APEC
	inner join
	(

		select 
		SCS.I_Brand_ID,SGC.I_Class_ID,SGC.I_School_Group_ID,SCS.I_School_Session_ID,SCS.I_Section_ID,SCS.I_Stream_ID,SCS.I_Status
		,count(SCS.I_Student_Detail_ID) as NumberOfStudent

		from 
		T_ERP_Exam_SchedulesDetails as ESD
		inner join
		T_ERP_Exam_ScheduleSubjectDetails as ESSD on ESD.inExamScheduleDetailId=ESSD.inExamScheduleDetailId
		inner join
		T_School_Group_Class as SGC on ESSD.inClassId=SGC.I_Class_ID and ESD.inSchoolProgramId=SGC.I_School_Group_ID
		inner join
		T_Student_Class_Section as SCS
		on SGC.I_School_Group_Class_ID=SCS.I_School_Group_Class_ID and SCS.I_School_Session_ID=ESD.inAcademicSessionId and 
		SCS.I_Section_ID=ESSD.inSectionId and SCS.I_Stream_ID=ESSD.inStreamId
		group by SCS.I_Brand_ID,SCS.I_School_Session_ID,SCS.I_Section_ID,SCS.I_Stream_ID,SCS.I_Status,SGC.I_Class_ID,SGC.I_School_Group_ID


	) as PromotedStudents on PromotedStudents.I_School_Session_ID=APEC.SchoolSessionID and 
	PromotedStudents.I_Section_ID=APEC.SectionID and PromotedStudents.I_Stream_ID=APEC.StreamID and 
	PromotedStudents.I_School_Group_ID=APEC.SchoolGroupID and PromotedStudents.I_Class_ID=APEC.ClassID



	-------------

	--select * from #NoStudentForEligibleForPromotion

	-------------


	---1:Pending for Academic Approval
	--select 
	--I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	--	,ISNULL(sum(NumberOfStudent),0) as TotalNumberOfStudent
	--from #NoStudentForEligibleForPromotion where I_Status=2 group by I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	

	update APEC 
	set APEC.PromotionalStatus = 1,APEC.PromotionalStatusDesc='Pending for Academic Approval',
	APEC.TotalStudent=NotPromotedStudents.TotalNumberOfStudent
	from #AcademicPromotionEligibleClass as APEC
	left join
	(select 
	I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
		,ISNULL(sum(NumberOfStudent),0) as TotalNumberOfStudent
	from #NoStudentForEligibleForPromotion where I_Status=2 group by I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	) 
	as PromotedStudents on PromotedStudents.I_School_Session_ID=APEC.SchoolSessionID and 
	PromotedStudents.I_Section_ID=APEC.SectionID and PromotedStudents.I_Stream_ID=APEC.StreamID and 
	PromotedStudents.I_School_Group_ID=APEC.SchoolGroupID and PromotedStudents.I_Class_ID=APEC.ClassID
	left join
	(select 
	I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
		,ISNULL(sum(NumberOfStudent),0) as TotalNumberOfStudent
	from #NoStudentForEligibleForPromotion where I_Status=1 group by I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	) 
	as NotPromotedStudents on NotPromotedStudents.I_School_Session_ID=APEC.SchoolSessionID and 
	NotPromotedStudents.I_Section_ID=APEC.SectionID and NotPromotedStudents.I_Stream_ID=APEC.StreamID and 
	NotPromotedStudents.I_School_Group_ID=APEC.SchoolGroupID and NotPromotedStudents.I_Class_ID=APEC.ClassID


	where ISNULL(PromotedStudents.TotalNumberOfStudent,0) <= 0
	

	---2:In Progress

	--select 
	--I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	--	,ISNULL(sum(NumberOfStudent),0) as TotalNumberOfStudent
	--from #NoStudentForEligibleForPromotion where I_Status=2 group by I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	

	update APEC 
	set APEC.PromotionalStatus = 2,APEC.PromotionalStatusDesc='In Progress'
	,APEC.TotalStudent=PromotedStudents.TotalNumberOfStudent
	from #AcademicPromotionEligibleClass as APEC
	left join
	(select 
	I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
		,ISNULL(sum(NumberOfStudent),0) as TotalNumberOfStudent
	from #NoStudentForEligibleForPromotion where I_Status in (2,3)  group by I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	) 
	as PromotedStudents on PromotedStudents.I_School_Session_ID=APEC.SchoolSessionID and 
	PromotedStudents.I_Section_ID=APEC.SectionID and PromotedStudents.I_Stream_ID=APEC.StreamID and 
	PromotedStudents.I_School_Group_ID=APEC.SchoolGroupID and PromotedStudents.I_Class_ID=APEC.ClassID
	left join
	(select 
	I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
		,ISNULL(sum(NumberOfStudent),0) as TotalNumberOfStudent
	from #NoStudentForEligibleForPromotion where I_Status in (1)  group by I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	) 
	as NotPromotedStudents on NotPromotedStudents.I_School_Session_ID=APEC.SchoolSessionID and 
	NotPromotedStudents.I_Section_ID=APEC.SectionID and NotPromotedStudents.I_Stream_ID=APEC.StreamID and 
	NotPromotedStudents.I_School_Group_ID=APEC.SchoolGroupID and NotPromotedStudents.I_Class_ID=APEC.ClassID


	where ISNULL(PromotedStudents.TotalNumberOfStudent,0) > 0 and ISNULL(NotPromotedStudents.TotalNumberOfStudent,0) > 0


	---3:Ready for Financial Approval

	--select 
	--I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	--	,ISNULL(sum(NumberOfStudent),0) as TotalNumberOfStudent
	--from #NoStudentForEligibleForPromotion where I_Status=1  group by I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	

	update APEC 
	set APEC.PromotionalStatus = 3,APEC.PromotionalStatusDesc='Ready for Financial Approval'
	,APEC.TotalStudent=PromotedStudents.TotalNumberOfStudent
	from #AcademicPromotionEligibleClass as APEC
	left join
	(select 
	I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
		,ISNULL(sum(NumberOfStudent),0) as TotalNumberOfStudent
	from #NoStudentForEligibleForPromotion where I_Status=1  group by I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	) 
	as PromotedStudents on PromotedStudents.I_School_Session_ID=APEC.SchoolSessionID and 
	PromotedStudents.I_Section_ID=APEC.SectionID and PromotedStudents.I_Stream_ID=APEC.StreamID and 
	PromotedStudents.I_School_Group_ID=APEC.SchoolGroupID and PromotedStudents.I_Class_ID=APEC.ClassID
	where PromotedStudents.TotalNumberOfStudent <= 0

	--- under NULL

	update APEC 
	set APEC.PromotionalStatus = NULL,APEC.PromotionalStatusDesc=NULL,
	APEC.TotalStudent=PromotedStudents.TotalNumberOfStudent
	from #AcademicPromotionEligibleClass as APEC
	left join
	(select 
	I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
		,ISNULL(sum(NumberOfStudent),0) as TotalNumberOfStudent
	from #NoStudentForEligibleForPromotion group by I_Brand_ID,I_Class_ID,I_School_Group_ID,I_School_Session_ID,I_Section_ID,I_Stream_ID
	) 
	as PromotedStudents on PromotedStudents.I_School_Session_ID=APEC.SchoolSessionID and 
	PromotedStudents.I_Section_ID=APEC.SectionID and PromotedStudents.I_Stream_ID=APEC.StreamID and 
	PromotedStudents.I_School_Group_ID=APEC.SchoolGroupID and PromotedStudents.I_Class_ID=APEC.ClassID
	where ISNULL(PromotedStudents.TotalNumberOfStudent,0) <= 0




	select * from #AcademicPromotionEligibleClass where PromotionalStatus IS NOT NULL



	drop table #NoStudentForEligibleForPromotion
	drop table #AcademicPromotionEligibleClass

END

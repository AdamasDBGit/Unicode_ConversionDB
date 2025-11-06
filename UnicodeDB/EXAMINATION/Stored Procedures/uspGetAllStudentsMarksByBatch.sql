
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 Jan 01>
-- Description:	<Use for all the all students' Marks Display>
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspGetAllStudentsMarksByBatch] 
(
@BrandID INT,
@CentreID INT,
@BatchID INT, 
@TermID INT=NULL
)
AS
BEGIN
	

	CREATE TABLE #AllStudent
	(
	StudentID VARCHAR(MAX),
	StudentDetailID INT,
	S_First_Name VARCHAR(MAX),
	S_Middle_Name VARCHAR(MAX),
	S_Last_Name VARCHAR(MAX),
	I_Status INT,
	CourseID INT,
	CourseName VARCHAR(MAX),
	BatchID INT,
	BatchName VARCHAR(MAX),
	CenterID INT,
	CenterName VARCHAR(MAX)
	)



	CREATE TABLE #StudentsResult
	(
	StudentID VARCHAR(MAX),
	StudentDetailID INT,
	CourseID INT,
	BatchID INT,
	TermID INT,
	TermName VARCHAR(MAX),
	ModuleID INT,
	ModuleName VARCHAR(MAX),
	ExamComponentID INT,
	ExamComponentName VARCHAR(MAX),
	SubExamComponentName VARCHAR(MAX),
	FullMarks DECIMAL(14,2),
	Weightage DECIMAL(14,2),
	MarksObtained DECIMAL(14,2),
	EffectiveMarks DECIMAL(14,2),
	ModuleGrade VARCHAR(20),
	ModuleRemarks VARCHAR(MAX),
	ModuleAttendance INT,
	ModuleAllottedDays INT,
	Grade VARCHAR(20),
	TermTotal DECIMAL(14,2),
	HighestMarks DECIMAL(14,2),
	HighestGrade VARCHAR(10),
	SequenceNo INT,
	TermAttendance INT,
	PromotedBatch INT,
	ClassTeacher VARCHAR(MAX),
	CumMarks DECIMAL(14,2),
	ClassTeacherRemarks VARCHAR(MAX),
	AllottedClasses INT,
	OverallTermTotal INT,
	OverallTermPerc INT,
	Student_Rank INT
	)


	DECLARE @iStudentDetailID INT;
	DECLARE @iCourseID INT;


	insert into #AllStudent
	exec EXAMINATION.uspGetAllStudentDetailsForBatch @BatchID

	DECLARE StudentIDs CURSOR 
	FOR 
	(
	select StudentDetailID,CourseID from #AllStudent
	)


	OPEN StudentIDs
    FETCH NEXT FROM StudentIDs
	INTO @iStudentDetailID,@iCourseID

        WHILE ( @@FETCH_STATUS = 0 ) 
            BEGIN

				insert into #StudentsResult
				exec EXAMINATION.uspGetAISStudentMarksForAPI @BrandID,@CentreID,@iCourseID,@iStudentDetailID,NULL

				--select @iStudentDetailID,@iCourseID

				 FETCH NEXT FROM StudentIDs
				INTO @iStudentDetailID,@iCourseID
			END

		CLOSE StudentIDs ;
        DEALLOCATE StudentIDs ;


		select * from #AllStudent

		select * from #StudentsResult


END

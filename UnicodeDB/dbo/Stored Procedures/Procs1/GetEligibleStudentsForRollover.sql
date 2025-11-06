CREATE PROCEDURE [dbo].[GetEligibleStudentsForRollover]
(
    @iAcademicSessionID INT,
    @iBrandID INT,
    @iSchoolGroupID INT,
    @iClassID INT,
    @iSectionID INT,
	@iStreamID int=null
)
AS
BEGIN
    SET NOCOUNT ON;
 
    /*
        ===================================================================
        Author:      Susmita Paul
        Created On:  2025-Sept-10
        Description: 
            Fetch students eligible for academic rollover.
            ✅ Includes only sections that have a published FINAL EXAM.
            🚫 Excludes students already in T_ERP_Student_Promotion_History_Header.
        ===================================================================
    */
 
    -- Step 1: Identify eligible published final exam sections
    ;WITH PublishedFinalExamSections AS
    (
        SELECT DISTINCT
			ESSD.inExamScheduleSubjectDetailId,
            ESD.inBrandId,
            ESD.inAcademicSessionId,
            ESD.dtPublishDate,
            ESSD.inClassId,
            ESSD.stClassName,
            ESSD.inSectionId,
            ESSD.stSectionName,
			ESSD.inStreamId,
			ESSD.stStreamName,
            ESD.inSchoolProgramId AS I_School_Group_ID,
            ESSD.IsFinalExam
        FROM T_ERP_Exam_SchedulesDetails ESD
        INNER JOIN T_ERP_Exam_ScheduleSubjectDetails ESSD  
            ON ESD.inExamScheduleDetailId = ESSD.inExamScheduleDetailId
        WHERE 
            ESD.inResultProcessStatus = 3
            AND ESD.dtPublishDate IS NOT NULL
            AND ESSD.IsFinalExam = 1
            AND ESD.inBrandId = @iBrandID
            AND ESD.inAcademicSessionId = @iAcademicSessionID
            AND (@iSchoolGroupID IS NULL OR ESD.inSchoolProgramId = @iSchoolGroupID)
            AND (@iClassID IS NULL OR ESSD.inClassId = @iClassID)
            AND (@iSectionID IS NULL OR ESSD.inSectionId = @iSectionID)
			AND (@iStreamID IS NULL OR ESSD.inStreamId=@iStreamID)
    )
 
    -- Step 2: Fetch students from those sections and exclude promoted ones
    SELECT DISTINCT
        SD.S_First_Name 
            + ISNULL(' ' + SD.S_Middle_Name, '') 
            + ISNULL(' ' + SD.S_Last_Name, '') AS [Name],
        SD.S_Student_ID AS StudentId,
		C.I_Class_ID as CurrentClassID,
        C.S_Class_Name AS CurrentClass,
		SEC.I_Section_ID As CurrentSectionID,
        SEC.S_Section_Name AS CurrentSection,
		S.I_Stream_ID as CurrentStreamID,
		S.S_Stream as CurrentStream,
        ISNULL(SCS.S_Class_Roll_No, 0) AS CurrentRollNo,
        SD.I_Student_Detail_ID AS StudentDetailsId,
		SG.I_School_Group_ID as SchoolGroupID,
		SG.S_School_Group_Name as SchoolGroupName,
		attendence.AggregateAttendancePercentage
    FROM 
        T_Student_Detail SD
		INNER JOIN T_ERP_Exam_ScheduleSubjectAttendanceMarks ESAM  on SD.I_Student_Detail_ID=ESAM.inStudentId
		INNER JOIN T_ERP_Exam_ScheduleSubjectDetails ESSD on ESAM.inExamScheduleDetailId=ESSD.inExamScheduleDetailId
		INNER JOIN T_ERP_Exam_SchedulesDetails as ESD on ESSD.inExamScheduleDetailId=ESD.inExamScheduleDetailId
		left join 
		(
		select  CAST(AVG(ESRH.inAttendance) AS DECIMAL(5,2)) AS AggregateAttendancePercentage
		,ESRH.inStudentId,ESRH.sStudentID
		
		from 
		T_ERP_Exam_StudentResultHeader as ESRH		
		inner join
		T_ERP_Exam_SchedulesDetails as ESD on ESRH.inExamScheduleDetailId=ESD.inExamScheduleDetailId
		where ESD.inAcademicSessionId=@iAcademicSessionID 
		and ESD.inSchoolProgramId = @iSchoolGroupID
		group by ESRH.inStudentId,ESRH.sStudentID
		) attendence on attendence.inStudentId=SD.I_Student_Detail_ID
		INNER JOIN PublishedFinalExamSections as PFES on ESSD.inExamScheduleSubjectDetailId=PFES.inExamScheduleSubjectDetailId
		INNER JOIN T_School_Group_Class as SGC on SGC.I_Class_ID=PFES.inClassId and SGC.I_School_Group_ID=PFES.I_School_Group_ID
		and SGC.I_Status=1
		INNER JOIN T_Student_Class_Section as SCS  
		on SD.I_Student_Detail_ID=SCS.I_Student_Detail_ID and SCS.I_School_Session_ID=PFES.inAcademicSessionId
		and SCS.I_School_Group_Class_ID=SGC.I_School_Group_Class_ID and SCS.I_Status=1
		and PFES.inSectionId=SCS.I_Section_ID 
        INNER JOIN T_Class C ON ESSD.inClassId = C.I_Class_ID and C.I_Status=1
        INNER JOIN T_Section SEC ON ESSD.inSectionId = SEC.I_Section_ID
		inner join T_School_Group as SG on SGC.I_School_Group_ID=SG.I_School_Group_ID
		left join
		T_Stream as S on PFES.inStreamId=S.I_Stream_ID
    WHERE
        ESD.inBrandId = @iBrandID
        AND ESD.inAcademicSessionId = @iAcademicSessionID
        AND SD.I_Status = 1
        AND SD.I_Student_Detail_ID NOT IN 
        (
            SELECT DISTINCT PH.I_Student_DetailID
            FROM T_ERP_Student_Promotion_History_Header PH
            WHERE PH.I_Brand_ID = @iBrandID
              AND PH.I_Source_Academic_Session = @iAcademicSessionID
              AND (PH.IsAcademicApproved = 1 OR PH.WillOnHold = 1)
			  AND PH.I_Promotion_Status=1
        )
    ORDER BY 
         SD.S_Student_ID;
END


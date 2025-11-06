CREATE PROCEDURE [dbo].[GetAcademicRolloverData]
(
    @iBrandID INT,
    @iAcademicSessionID INT,
    @iSchoolGroupID INT = NULL,
    @iClassID INT = NULL,
    @iSectionID INT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- ================================================
    -- Author:      Susmita Paul
    -- Create date: 2025-Oct-09
    -- Description: Get list of published sections with student rollover summary
    -- ================================================

    ;WITH PublishedSections AS
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
    ),
    -- 🧩 Promotion summary (Processed/Pending/Completed)
    PromotionStatus AS
    (
        SELECT 
            SPHH.I_Brand_ID AS inBrandId,
            SPHH.I_Source_Academic_Session AS inAcademicSessionId,
            SPHH.I_Source_School_Group_ID AS SchoolGroupID,
            SPHH.I_Source_Class_ID AS ClassID,
            SPHH.I_Source_SectionID AS SectionID,

            COUNT(DISTINCT CASE 
                WHEN ISNULL(SPHH.IsAcademicApproved, 0) = 1 
                     AND ISNULL(SPHH.IsFinancialApproved, 0) = 0 
                THEN SPHH.I_Student_DetailID END) AS ProcessedStudents,

            COUNT(DISTINCT CASE 
                WHEN (ISNULL(SPHH.IsAcademicApproved, 0) = 0 
                      AND ISNULL(SPHH.IsFinancialApproved, 0) = 0)
                THEN SPHH.I_Student_DetailID END) AS PendingStudents
        FROM T_ERP_Student_Promotion_History_Header SPHH
        WHERE 
            SPHH.I_Brand_ID = @iBrandID
            AND SPHH.I_Source_Academic_Session = @iAcademicSessionID
            AND (@iSchoolGroupID IS NULL OR SPHH.I_Source_School_Group_ID = @iSchoolGroupID)
            AND (@iClassID IS NULL OR SPHH.I_Source_Class_ID = @iClassID)
            AND (@iSectionID IS NULL OR SPHH.I_Source_SectionID = @iSectionID)
        GROUP BY 
            SPHH.I_Brand_ID,
            SPHH.I_Source_Academic_Session,
            SPHH.I_Source_School_Group_ID,
            SPHH.I_Source_Class_ID,
            SPHH.I_Source_SectionID
    ),
    -- 🧩 Total students from attendance marks
    SectionStudentCount AS
    (
        SELECT
            PS.inBrandId,
            PS.inAcademicSessionId,
            PS.I_School_Group_ID AS SchoolGroupID,
            PS.inClassId AS ClassID,
            PS.inSectionId AS SectionID,
            COUNT(DISTINCT SAM.inStudentId) AS TotalStudents,
            MAX(PS.dtPublishDate) AS ResultPublishedDate
        FROM PublishedSections PS
        INNER JOIN T_School_Group SG 
            ON SG.I_School_Group_ID = PS.I_School_Group_ID
        INNER JOIN T_ERP_Exam_ScheduleSubjectAttendanceMarks SAM 
            ON SAM.inExamScheduleSubjectDetailId = PS.inExamScheduleSubjectDetailId
        GROUP BY 
            PS.inBrandId,
            PS.inAcademicSessionId,
            PS.I_School_Group_ID,
            PS.inClassId,
            PS.inSectionId
    )

    SELECT 
        PS.inBrandId,
        PS.inAcademicSessionId AS AcademicSessionID,
        PS.I_School_Group_ID AS SchoolGroupID,
        SG.S_School_Group_Name AS GroupName,
        PS.inClassId AS ClassID,
        PS.stClassName AS ClassName,
        PS.inSectionId AS SectionID,
        PS.stSectionName AS SectionName,
        SC.TotalStudents AS NoOfStudents,
        ISNULL(PR.ProcessedStudents, 0) AS ProcessedStudents,
        ISNULL(PR.PendingStudents, 0) AS PendingStudents,
        SC.ResultPublishedDate,

        CASE 
            WHEN ISNULL(PR.ProcessedStudents, 0) = ISNULL(SC.TotalStudents, 0) 
                 AND ISNULL(SC.TotalStudents, 0) > 0 THEN 'Completed'
            WHEN ISNULL(PR.ProcessedStudents, 0) > 0 
                 AND ISNULL(PR.ProcessedStudents, 0) < ISNULL(SC.TotalStudents, 0) THEN 'In Progress'
            ELSE 'Pending'
        END AS StatusText,

        CASE 
            WHEN ISNULL(PR.ProcessedStudents, 0) = ISNULL(SC.TotalStudents, 0) 
                 AND ISNULL(SC.TotalStudents, 0) > 0 THEN 1
            ELSE 0
        END AS StatusBit

    FROM PublishedSections PS
    LEFT JOIN SectionStudentCount SC 
        ON SC.inBrandId = PS.inBrandId
       AND SC.inAcademicSessionId = PS.inAcademicSessionId
       AND SC.SchoolGroupID = PS.I_School_Group_ID
       AND SC.ClassID = PS.inClassId
       AND SC.SectionID = PS.inSectionId
    LEFT JOIN PromotionStatus PR 
        ON PR.inBrandId = PS.inBrandId
       AND PR.inAcademicSessionId = PS.inAcademicSessionId
       AND PR.SchoolGroupID = PS.I_School_Group_ID
       AND PR.ClassID = PS.inClassId
       AND PR.SectionID = PS.inSectionId
    LEFT JOIN T_School_Group SG 
        ON SG.I_School_Group_ID = PS.I_School_Group_ID
    GROUP BY 
        PS.inBrandId,
        PS.inAcademicSessionId,
        PS.I_School_Group_ID,
        SG.S_School_Group_Name,
        PS.inClassId,
        PS.stClassName,
        PS.inSectionId,
        PS.stSectionName,
        SC.TotalStudents,
        SC.ResultPublishedDate,
        PR.ProcessedStudents,
        PR.PendingStudents,
        PR.ProcessedStudents 
    ORDER BY 
        PS.stClassName,
        PS.stSectionName;

END

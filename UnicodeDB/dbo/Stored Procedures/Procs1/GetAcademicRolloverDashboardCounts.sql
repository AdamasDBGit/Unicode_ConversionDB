CREATE PROCEDURE [dbo].[GetAcademicRolloverDashboardCounts]
(
    @iAcademicSessionID INT,
    @iBrandID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- ================================================
    -- Author:      Susmita Paul
    -- Create date: 2025-Sep-09
    -- Description: Get Academic Rollover Dashboard Counts
    -- ================================================

    ;WITH ExamSectionSummary AS
    (
        SELECT DISTINCT
            ESD.inBrandId,
            ESD.inAcademicSessionId,
            ESSD.inClassId,
            ESSD.stClassName,
            ESSD.inSectionId,
            ESSD.stSectionName,
            ESD.inResultProcessStatus,
            ESD.dtPublishDate
        FROM T_ERP_Exam_SchedulesDetails ESD
        INNER JOIN T_ERP_Exam_ScheduleSubjectDetails ESSD 
            ON ESD.inExamScheduleDetailId = ESSD.inExamScheduleDetailId
        WHERE 
            ESD.inStatus = 1
            AND ESSD.IsFinalExam = 1 
            AND ESD.inBrandId = @iBrandID
            AND ESD.inAcademicSessionId = @iAcademicSessionID
    ),
    RollOverStatus AS
    (
        SELECT 
            SPHH.I_Brand_ID AS inBrandId,
            SPHH.I_Source_Academic_Session AS inAcademicSessionId,
            SPHH.I_Source_Class_ID AS inClassId,
            SPHH.I_Source_SectionID AS inSectionId,
            SPHH.I_Source_School_Group_ID AS inSchoolGroup,
            MAX(CAST(ISNULL(SPHH.IsAcademicApproved, 0) AS INT)) AS IsAcademicApproved,
            MAX(CAST(ISNULL(SPHH.IsFinancialApproved, 0) AS INT)) AS IsFinancialApproved,
            MAX(CAST(ISNULL(SPHH.IsFeeMapped, 0) AS INT)) AS IsFeeMapped
        FROM T_ERP_Student_Promotion_History_Header SPHH
        WHERE 
            SPHH.I_Brand_ID = @iBrandID
            AND SPHH.I_Source_Academic_Session = @iAcademicSessionID
        GROUP BY 
            SPHH.I_Brand_ID, 
            SPHH.I_Source_Academic_Session, 
            SPHH.I_Source_Class_ID, 
            SPHH.I_Source_SectionID,
            SPHH.I_Source_School_Group_ID
    ),
    Combined AS
    (
        SELECT 
            E.inBrandId,
            E.inAcademicSessionId,
            E.inClassId,
            E.inSectionId,
            E.stClassName,
            E.stSectionName,
            E.inResultProcessStatus,
            E.dtPublishDate,
            R.IsAcademicApproved,
            R.IsFinancialApproved,
            R.IsFeeMapped,

            -- ✅ Result publish and pending
            CASE 
                WHEN E.inResultProcessStatus = 3 AND E.dtPublishDate IS NOT NULL THEN 1 
                ELSE 0 
            END AS IsResultPublished,

            CASE 
                WHEN (E.inResultProcessStatus IS NULL OR E.inResultProcessStatus <> 3) THEN 1 
                ELSE 0 
            END AS IsResultPending,

            -- ✅ Pending rollover: result published but no approvals yet
            CASE
                WHEN (E.inResultProcessStatus = 3 AND E.dtPublishDate IS NOT NULL)
                     AND (ISNULL(R.IsAcademicApproved, 0) = 0 
                          AND ISNULL(R.IsFinancialApproved, 0) = 0 
                          AND ISNULL(R.IsFeeMapped, 0) = 0)
                THEN 1 ELSE 0
            END AS IsPendingRollover,

            -- ✅ Completed: result published + academic approved
            CASE 
                WHEN (E.inResultProcessStatus = 3 AND E.dtPublishDate IS NOT NULL)
                     AND R.IsAcademicApproved = 1
                     AND ISNULL(R.IsFinancialApproved, 0) = 0
                     AND ISNULL(R.IsFeeMapped, 0) = 0
                THEN 1 ELSE 0
            END AS IsCompleted
        FROM ExamSectionSummary E
        LEFT JOIN RollOverStatus R 
            ON E.inBrandId = R.inBrandId
           AND E.inAcademicSessionId = R.inAcademicSessionId
           AND E.inClassId = R.inClassId
           AND E.inSectionId = R.inSectionId
    )

    SELECT 
        C.inBrandId,
        C.inAcademicSessionId,
        COUNT(DISTINCT CONCAT(C.inClassId, '-', C.inSectionId)) AS Total_Class_Section,
        COUNT(DISTINCT CASE WHEN C.IsResultPublished = 1 THEN CONCAT(C.inClassId, '-', C.inSectionId) END) AS Result_Published,
        COUNT(DISTINCT CASE WHEN C.IsResultPending = 1 THEN CONCAT(C.inClassId, '-', C.inSectionId) END) AS Result_Pending,
        COUNT(DISTINCT CASE WHEN C.IsPendingRollover = 1 THEN CONCAT(C.inClassId, '-', C.inSectionId) END) AS Pending_Rollover,
        COUNT(DISTINCT CASE WHEN C.IsCompleted = 1 THEN CONCAT(C.inClassId, '-', C.inSectionId) END) AS Completed
    FROM Combined C
    GROUP BY 
        C.inBrandId, 
        C.inAcademicSessionId
    ORDER BY 
        C.inBrandId, 
        C.inAcademicSessionId;

END

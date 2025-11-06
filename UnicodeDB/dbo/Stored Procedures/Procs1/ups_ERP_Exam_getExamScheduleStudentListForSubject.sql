CREATE PROCEDURE [dbo].[ups_ERP_Exam_getExamScheduleStudentListForSubject]  
(  
    @inExamScheduleDetailId INT,  
    @inSubjectId INT,  
    @inSectionId INT,
    @inStreamId INT = NULL,
    @inSubjectComponentID INT = NULL  
)  
AS  
BEGIN  
    SET NOCOUNT ON;
 
    SELECT DISTINCT
        TEESSAM.inExamScheduleSubjectAttendanceMarksId,
        TEESSD.inExamScheduleDetailId,  
        TEESSD.inExamScheduleSubjectDetailId, 
        TEESSD.stStudentName,
        TEESSD.I_Student_Detail_ID AS inStudentID,
        TEESSD.S_Student_ID AS stStudentID,
        TEESSD.inSubjectID,  
        TEESSD.inSubjectComponentID,          
        TEESSD.stClassName,  
        TEESSD.stSectionName,  
        TEESSD.stStreamName,
        TEESSAM.inPresent,
        TEESSAM.stAttendanceRemarks,  
        TEESSAM.dcObtainedMarks,  
        TEESSAM.inConduct,  
        TEESSAM.inRanks,  
        TEESSAM.inPaperStatus,  
        TEESSAM.stRemarks,
        TEESSD.stSubjectName,
        TEESSD.stSubjectComponentName,
        TEESSD.inAttendanceStatus,
        TEESSD.inMarksStatus,
        TEESSD.dcFullMarks
    FROM (
        SELECT    
            TEESSD.inExamScheduleDetailId,  
            TEESSD.inExamScheduleSubjectDetailId,  
            ISNULL(TSD.S_First_Name, '') + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' ' + ISNULL(TSD.S_Last_Name, '') AS stStudentName,
            TEESSD.inSubjectID,  
            TEESSD.stSubjectName,
            TEESSD.inSubjectComponentID,          
            TEESSD.stSubjectComponentName,
            TEESSD.stClassName,  
            TEESSD.stSectionName,  
            TEESSD.stStreamName,
            TSD.S_Student_ID,
            TSD.I_Student_Detail_ID,
            TEESSD.inAttendanceStatus,
            TEESSD.inMarksStatus,
            TEESSD.dcFullMarks
        FROM   
            T_ERP_Exam_ScheduleSubjectDetails TEESSD  
        JOIN T_ERP_Student_Subject TESS 
            ON TESS.I_Subject_ID = TEESSD.inSubjectID  
        JOIN T_Student_Detail TSD  
            ON TSD.I_Student_Detail_ID = TESS.I_Student_Detail_ID  
        JOIN T_Student_Class_Section SCS 
            ON SCS.I_Student_Detail_ID = TESS.I_Student_Detail_ID  
        WHERE   
            TEESSD.inExamScheduleDetailId = @inExamScheduleDetailId  
            AND TESS.I_Subject_ID = @inSubjectId  
            AND TEESSD.inSectionId = @inSectionId
            AND (TEESSD.inSubjectComponentID = @inSubjectComponentID OR @inSubjectComponentID IS NULL) 
            AND (TEESSD.inStreamId = @inStreamId OR @inStreamId IS NULL) 
    ) AS TEESSD
    LEFT JOIN T_ERP_Exam_ScheduleSubjectAttendanceMarks TEESSAM
        ON TEESSD.inExamScheduleDetailId = TEESSAM.inExamScheduleDetailId
        AND TEESSD.inExamScheduleSubjectDetailId = TEESSAM.inExamScheduleSubjectDetailId
        AND TEESSD.inSubjectID = TEESSAM.inSubjectId
        AND TEESSAM.inStudentId = TEESSD.I_Student_Detail_ID
 
    UNION
 
    SELECT DISTINCT
        TEESSAM.inExamScheduleSubjectAttendanceMarksId,
        TEESSD2.inExamScheduleDetailId,  
        TEESSD2.inExamScheduleSubjectDetailId, 
        TEESSD2.stStudentName,
        TEESSD2.I_Student_Detail_ID AS inStudentID,
        TEESSD2.S_Student_ID AS stStudentID,
        TEESSD2.inSubjectID,  
        TEESSD2.inSubjectComponentID,          
        TEESSD2.stClassName,  
        TEESSD2.stSectionName,  
        TEESSD2.stStreamName,
        TEESSAM.inPresent,
        TEESSAM.stAttendanceRemarks,  
        TEESSAM.dcObtainedMarks,  
        TEESSAM.inConduct,  
        TEESSAM.inRanks,  
        TEESSAM.inPaperStatus,  
        TEESSAM.stRemarks,
        TEESSD2.stSubjectName,
        TEESSD2.stSubjectComponentName,
        TEESSD2.inAttendanceStatus,
        TEESSD2.inMarksStatus,
        TEESSD2.dcFullMarks
    FROM (
        SELECT    
            TEESSD.inExamScheduleDetailId,  
            TEESSD.inExamScheduleSubjectDetailId,  
            ISNULL(TSD.S_First_Name, '') + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' ' + ISNULL(TSD.S_Last_Name, '') AS stStudentName,
            TEESSD.inSubjectID,  
            TEESSD.stSubjectName,
            TEESSD.inSubjectComponentID,          
            TEESSD.stSubjectComponentName,
            TEESSD.stClassName,  
            TEESSD.stSectionName,  
            TEESSD.stStreamName,
            TSD.S_Student_ID,
            TSD.I_Student_Detail_ID,
            TEESSD.inAttendanceStatus,
            TEESSD.inMarksStatus,
            TEESSD.dcFullMarks
        FROM   
            T_ERP_Exam_ScheduleSubjectDetails TEESSD  
        JOIN (
            SELECT DISTINCT 
                SGC.I_School_Group_ID, 
                SGC.I_Class_ID,
                SCS.I_Student_Detail_ID,
                SM.I_Subject_ID,
                SCS.I_School_Session_ID 
            FROM 
                T_Student_Class_Section SCS
            INNER JOIN T_School_Group_Class SGC 
                ON SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID
            INNER JOIN T_Subject_Master SM 
                ON SM.I_School_Group_ID = SGC.I_School_Group_ID AND SM.I_Class_ID = SGC.I_Class_ID
            INNER JOIN T_ERP_Exam_SchedulesDetails ESD 
                ON ESD.inBrandId = SCS.I_Brand_ID 
                AND ESD.inAcademicSessionId = SCS.I_School_Session_ID
                AND ESD.inSchoolProgramId = SGC.I_School_Group_ID
            WHERE SCS.I_Status = 1
        ) TESS ON TESS.I_Subject_ID = TEESSD.inSubjectID  
        JOIN T_Student_Detail TSD  
            ON TSD.I_Student_Detail_ID = TESS.I_Student_Detail_ID  
        JOIN T_Student_Class_Section SCS 
            ON SCS.I_Student_Detail_ID = TESS.I_Student_Detail_ID  
        WHERE   
            TEESSD.inExamScheduleDetailId = @inExamScheduleDetailId  
            AND TESS.I_Subject_ID = @inSubjectId  
            AND TEESSD.inSectionId = @inSectionId
            AND (TEESSD.inSubjectComponentID = @inSubjectComponentID OR @inSubjectComponentID IS NULL) 
            AND (TEESSD.inStreamId = @inStreamId OR @inStreamId IS NULL) 
    ) AS TEESSD2
    LEFT JOIN T_ERP_Exam_ScheduleSubjectAttendanceMarks TEESSAM
        ON TEESSD2.inExamScheduleDetailId = TEESSAM.inExamScheduleDetailId
        AND TEESSD2.inExamScheduleSubjectDetailId = TEESSAM.inExamScheduleSubjectDetailId
        AND TEESSD2.inSubjectID = TEESSAM.inSubjectId
        AND TEESSAM.inStudentId = TEESSD2.I_Student_Detail_ID;
 
END;
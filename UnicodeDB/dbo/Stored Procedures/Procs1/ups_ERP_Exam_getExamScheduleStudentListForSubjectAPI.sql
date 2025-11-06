
CREATE PROCEDURE [dbo].[ups_ERP_Exam_getExamScheduleStudentListForSubjectAPI]
(
    @inExamScheduleSubjectDetailId INT
)
AS
BEGIN
    SELECT DISTINCT
        TEESSAM.inExamScheduleSubjectAttendanceMarksId AS ExamScheduleSubjectAttendanceMarksId,
        TEESSD.inExamScheduleDetailId AS ExamScheduleDetailId,
        TEESSD.inExamScheduleSubjectDetailId AS ExamScheduleSubjectDetailId,
        TEESSD.stStudentName AS StudentName,
        TEESSD.I_Student_Detail_ID AS StudentID,
        TEESSD.S_Student_ID AS StudentCode,
        TEESSD.inSubjectID AS SubjectID,
        TEESSD.inSubjectComponentID AS SubjectComponentID,
        TEESSD.stClassName AS ClassName,
        TEESSD.stSectionName AS SectionName,
        TEESSD.stStreamName AS StreamName,
        ISNULL(TEESSAM.inPresent, 0) AS IsPresent,
        TEESSAM.stAttendanceRemarks AS AttendanceRemarks,
        TEESSAM.dcObtainedMarks AS ObtainedMarks,
        TEESSAM.inConduct AS Conduct,
        TEESSAM.inRanks AS Rank,
        TEESSAM.inPaperStatus AS PaperStatus,
        TEESSAM.stRemarks AS Remarks,
        TEESSD.stSubjectName AS SubjectName,
        TEESSD.stSubjectComponentName AS SubjectComponentName,
        TEESSD.inAttendanceStatus AS AttendanceStatus,
        TEESSD.inMarksStatus AS MarksStatus,
        TEESSD.dcFullMarks AS FullMarks,
        TEESSD.S_Student_Photo AS StudentPhoto,
        TEESSD.S_Class_Roll_No AS RollNo
    FROM (
        SELECT    
            TEESSD.inExamScheduleDetailId,
            TEESSD.inExamScheduleSubjectDetailId,
            ISNULL(TSD.S_First_Name, '') + ' ' + ISNULL(TSD.S_Middle_Name, '') + ' ' + ISNULL(TSD.S_Last_Name, '') AS stStudentName,
            TEESSD.inSubjectID,
            TEESSD.stClassName,
            TEESSD.stSectionName,
            TEESSD.stStreamName,
            TSD.S_Student_ID,
            TSD.I_Student_Detail_ID,
            TEESSD.inSubjectComponentID,
            TEESSD.stSubjectName,
            TEESSD.stSubjectComponentName,
            TEESSD.inAttendanceStatus,
            TEESSD.inMarksStatus,
            TEESSD.dcFullMarks,
			TERD.S_Student_Photo,
			SCS.S_Class_Roll_No
        FROM   
            T_ERP_Exam_ScheduleSubjectDetails TEESSD  
        JOIN 
            T_ERP_Student_Subject TESS 
            ON TESS.I_Subject_ID = TEESSD.inSubjectID  
        JOIN 
            T_Student_Detail TSD  
            ON TSD.I_Student_Detail_ID = TESS.I_Student_Detail_ID  
        JOIN 
            T_Student_Class_Section SCS 
            ON SCS.I_Student_Detail_ID = TESS.I_Student_Detail_ID  
        JOIN 
            T_Enquiry_Regn_Detail TERD 
            ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   
            TEESSD.inExamScheduleSubjectDetailId = @inExamScheduleSubjectDetailId  
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
        TEESSD2.dcFullMarks,
		TEESSD2.S_Student_Photo,
		TEESSD2.S_Class_Roll_No
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
            TEESSD.dcFullMarks,
			TERD.S_Student_Photo,
			SCS.S_Class_Roll_No
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
		JOIN 
            T_Enquiry_Regn_Detail TERD 
            ON TERD.I_Enquiry_Regn_ID = TSD.I_Enquiry_Regn_ID
        WHERE   
           TEESSD.inExamScheduleSubjectDetailId = @inExamScheduleSubjectDetailId  
    ) AS TEESSD2
    LEFT JOIN T_ERP_Exam_ScheduleSubjectAttendanceMarks TEESSAM
        ON TEESSD2.inExamScheduleDetailId = TEESSAM.inExamScheduleDetailId
        AND TEESSD2.inExamScheduleSubjectDetailId = TEESSAM.inExamScheduleSubjectDetailId
        AND TEESSD2.inSubjectID = TEESSAM.inSubjectId
        AND TEESSAM.inStudentId = TEESSD2.I_Student_Detail_ID;
END;

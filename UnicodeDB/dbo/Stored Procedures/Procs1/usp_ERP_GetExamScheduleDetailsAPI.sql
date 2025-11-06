CREATE PROCEDURE [dbo].[usp_ERP_GetExamScheduleDetailsAPI]
    @token nnvarchar(max),
    @MonthId INT
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @FacultyId int
	set @FacultyId = (select I_User_ID from T_ERP_User where S_Token=@token)
    SELECT 
        t2.inExamScheduleDetailId AS ExamScheduleDetailId,
        t2.stExamName AS ExamName,
        t1.dtStartDate AS StartDate,
        t3.tmSlotStartTime AS SlotStartTime,
        t3.tmSlotEndTime AS SlotEndTime,
        t1.stClassName AS ClassName,
        t1.stSectionName AS SectionName,
        t1.stStreamName AS StreamName,
        t1.stSubjectName AS SubjectName,
        t1.stSubjectComponentName AS SubjectComponentName,
        t1.stSubjectTypeName AS SubjectTypeName,
        COUNT(DISTINCT ss.I_Student_Detail_ID) AS TotalStudentCount
    FROM 
        T_ERP_Exam_ScheduleSubjectDetails t1
    INNER JOIN 
        T_ERP_Exam_SchedulesDetails t2
        ON t2.inExamScheduleDetailId = t1.inExamScheduleDetailId
    INNER JOIN 
        T_ERP_Exam_Slot_Master t3
        ON t3.inSlotID = t1.inExamSlotId
    LEFT JOIN 
        T_ERP_Student_Subject ss
        ON ss.I_Subject_ID = t1.inSubjectID 
        AND ss.I_School_Session_ID = t2.inAcademicSessionId
        AND ss.I_Class_ID = t1.inClassId
    WHERE 
        t1.inExamGraderId = @FacultyId
        AND MONTH(t1.dtStartDate) = @MonthId
    GROUP BY 
        t2.inExamScheduleDetailId,
        t2.stExamName,
        t1.dtStartDate,
        t3.tmSlotStartTime,
        t3.tmSlotEndTime,
        t1.stClassName,
        t1.stSectionName,
        t1.stStreamName,
        t1.stSubjectName,
        t1.stSubjectComponentName,
        t1.stSubjectTypeName;
END;

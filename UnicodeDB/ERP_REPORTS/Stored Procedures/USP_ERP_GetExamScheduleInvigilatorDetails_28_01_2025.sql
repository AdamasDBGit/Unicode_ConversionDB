CREATE PROCEDURE [ERP_REPORTS].[USP_ERP_GetExamScheduleInvigilatorDetails_28/01/2025]
    @BrandID INT,
    @SessionID INT,
    @SchoolGroupID INT,
    @ClassID INT,
    @sectionID INT,
    @StartDt DATE,
    @Enddt DATE,
    @ExamID INT,
    @SubjectID INT,
    @FacultyID INT
AS
BEGIN
 
    SELECT DISTINCT 
        @BrandID AS BrandName,
        SG.S_School_Group_Name AS School_Programme,
        ASM.S_Label AS Academic_Session,
        SD.S_Student_ID AS StudentID,
        SD.S_First_Name + 
            CASE 
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''   
                THEN ' ' + SD.S_Middle_Name   
                ELSE ''   
            END +   
            ' ' + SD.S_Last_Name AS StudentName,  
        Tc.S_Class_Name AS Class,
        TS.S_Section_Name AS Section,
        ESD.stExamName AS ExamName,
        EEC.stExamCategoryName AS ExamCategory,
        SM.S_Subject_Name AS Subject,
        CASE WHEN ESS.inExamMode = 1 THEN 'Online' ELSE 'Offline' END AS ExamMode,
        EU.S_First_Name +   
            CASE   
                WHEN EU.S_Middle_Name IS NOT NULL AND EU.S_Middle_Name != ''   
                THEN ' ' + EU.S_Middle_Name   
                ELSE ''   
            END +   
            ' ' + EU.S_Last_Name AS Invigilator,  
        SD.I_RollNo AS RollNo,
        SD.S_Mobile_No AS Phone,
        CONVERT(DATE, ESS.dtStartDate) AS ExamStartDate,
        CONVERT(DATE, ESS.dtEndDate) AS ExamEndDate
    FROM 
        T_ERP_Exam_SchedulesDetails ESD
    INNER JOIN 
        T_School_Group SG ON SG.I_School_Group_ID = ESD.inSchoolProgramId
        AND SG.I_Brand_Id = @BrandID 
        AND ESD.inAcademicSessionId = @SessionID
    INNER JOIN 
        T_ERP_Exam_ScheduleSubjects ESS ON ESS.inExamScheduleDetailId = ESD.inExamScheduleDetailId
    INNER JOIN 
        T_Subject_Master SM ON SM.I_Subject_ID = ESS.inSubjectID
        AND SM.I_School_Group_ID = ESD.inSchoolProgramId
        AND SM.I_Class_ID = ESS.inClassId
    INNER JOIN 
        T_ERP_Faculty_Subject EFS ON EFS.I_Subject_ID = ESS.inSubjectID
    INNER JOIN 
        T_Class Tc ON Tc.I_Class_ID = ESS.inClassId 
        AND Tc.I_Brand_ID = @BrandID
    LEFT JOIN 
        T_Section TS ON TS.I_Section_ID = ESS.inSectionId
    INNER JOIN  
        T_School_Academic_Session_Master ASM ON ASM.I_School_Session_ID = ESD.inAcademicSessionId
    LEFT JOIN 
        T_Faculty_Master FM ON FM.I_Faculty_Master_ID = EFS.I_Faculty_Master_ID
        AND FM.I_Brand_ID = @BrandID
    INNER JOIN 
        T_ERP_Exam_ScheduleSubjectAttendanceMarks SSAM ON SSAM.inExamScheduleDetailId = ESS.inExamScheduleDetailId
        AND SSAM.inSubjectId = ESS.inSubjectID 
    INNER JOIN 
        T_Student_Detail SD ON SD.I_Student_Detail_ID = SSAM.inStudentId
    INNER JOIN 
        T_ERP_Exam_Slot_Master ESM ON ESM.inSlotID = ESS.inExamSlotId
    LEFT JOIN 
        T_ERP_Exam_Grade_Master_Header EGMH ON EGMH.inExamGradeHederId = ESS.inExamGraderId
    INNER JOIN 
        T_ERP_EXAM_CATEGORY EEC ON EEC.inExamCategoryId = ESD.inExamCategoryId
    LEFT JOIN 
        T_ERP_User EU ON EU.I_User_ID = ESS.inExamInvigilatorId
    WHERE 
        ESD.inSchoolProgramId = @SchoolGroupID
        AND ESS.inClassId = @ClassID 
        AND ESS.inSectionId = @sectionID
        AND ESD.inExamScheduleDetailId = @ExamID
        AND ESS.inSubjectID = @SubjectID
        AND ESS.dtStartDate = @StartDt 
        AND ESS.dtEndDate = @Enddt;
END;
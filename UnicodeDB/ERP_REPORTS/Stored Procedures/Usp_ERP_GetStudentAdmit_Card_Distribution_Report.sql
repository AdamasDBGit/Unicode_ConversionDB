CREATE PROCEDURE [ERP_REPORTS].[Usp_ERP_GetStudentAdmit_Card_Distribution_Report]
    @BrandID INT,
    @SessionID INT,
    @SchoolGroupID INT,
    --@ClassID INT,
	@strclass varchar(100),
    --@SectionID INT,
	@strSection varchar(100),
    @StartDt DATE,
    @EndDt DATE,
    @ExamID INT,
    @SubjectID INT,
    @FacultyID INT
AS
BEGIN

--step1
	IF OBJECT_ID('tempdb..#Courses') IS NULL
	BEGIN     CREATE TABLE #Courses (         Id INT IDENTITY(1,1), CourseID INT     )
	END  
	--step2
INSERT INTO #Courses (CourseID) -- Adjust ColumnName to match your table's column                                  
SELECT Value                                  
FROM dbo.ERP_SplitString(@strclass, ',');

--step1
	IF OBJECT_ID('tempdb..#Sections') IS NULL
	BEGIN     CREATE TABLE #Sections (         Id INT IDENTITY(1,1), SectionID INT     )
	END  
--step2
INSERT INTO #Sections (SectionID) -- Adjust ColumnName to match your table's column                                  
SELECT Value                                  
FROM dbo.ERP_SplitString(@strSection, ',');

    SELECT DISTINCT  
        @BrandID AS BrandName,
        SG.S_School_Group_Name AS School_Programme,
        ASM.S_Label AS Academic_Session,
        ESD.stExamName AS Exam_Name,
        SD.S_Student_ID AS StudentID,
        SD.S_First_Name + 
            CASE   
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''   
                THEN ' ' + SD.S_Middle_Name   
                ELSE ''   
            END + ' ' + SD.S_Last_Name AS StudentName,  
        Tc.S_Class_Name AS Class,
        TS.S_Section_Name AS Section,
        SD.I_RollNo AS Rollno,
        SD.S_Mobile_No AS Phone
    FROM T_ERP_Exam_SchedulesDetails ESD
    INNER JOIN T_School_Group SG 
        ON SG.I_School_Group_ID = ESD.inSchoolProgramId
        AND SG.I_Brand_Id = @BrandID 
        AND ESD.inAcademicSessionId = @SessionID
    INNER JOIN T_ERP_Exam_ScheduleSubjects ESS 
        ON ESS.inExamScheduleDetailId = ESD.inExamScheduleDetailId
    INNER JOIN T_Subject_Master SM 
        ON SM.I_Subject_ID = ESS.inSubjectID
        AND SM.I_School_Group_ID = ESD.inSchoolProgramId
        AND SM.I_Class_ID = ESS.inClassId
    INNER JOIN T_ERP_Faculty_Subject EFS 
        ON EFS.I_Subject_ID = ESS.inSubjectID
    INNER JOIN T_Class Tc 
        ON Tc.I_Class_ID = ESS.inClassId 
        AND Tc.I_Brand_ID = @BrandID
	INNER JOIN
		#Courses cs on cs.CourseID = ESS.inClassId
    LEFT JOIN T_Section TS 
        ON TS.I_Section_ID = ESS.inSectionId
	LEFT JOIN
		#Sections ss on ss.SectionID = ESS.inClassId
    INNER JOIN T_School_Academic_Session_Master ASM 
        ON ASM.I_School_Session_ID = ESD.inAcademicSessionId
    LEFT JOIN T_Faculty_Master FM 
        ON FM.I_Faculty_Master_ID = EFS.I_Faculty_Master_ID
        AND FM.I_Brand_ID = @BrandID
    INNER JOIN T_ERP_Exam_ScheduleSubjectAttendanceMarks SSAM 
        ON SSAM.inExamScheduleDetailId = ESS.inExamScheduleDetailId
        AND SSAM.inSubjectId = ESS.inSubjectID 
    INNER JOIN T_Student_Detail SD 
        ON SD.I_Student_Detail_ID = SSAM.inStudentId
    INNER JOIN T_ERP_Exam_Slot_Master ESM 
        ON ESM.inSlotID = ESS.inExamSlotId
    LEFT JOIN T_ERP_Exam_Grade_Master_Header EGMH 
        ON EGMH.inExamGradeHederId = ESS.inExamGraderId
    WHERE 
        ESD.inSchoolProgramId = @SchoolGroupID
        --AND ESS.inClassId = @ClassID
        --AND ESS.inSectionId = @SectionID
        AND ESD.inExamScheduleDetailId = @ExamID
        AND ESS.inSubjectID = @SubjectID
        AND ESS.dtStartDate = @StartDt 
        AND ESS.dtEndDate = @EndDt;
END;
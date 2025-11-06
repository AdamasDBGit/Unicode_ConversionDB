CREATE PROCEDURE [dbo].[USP_ERP_GetExam_Marks_Attend_StudentDetails]
    @iExamscheduleID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @brandID INT;

    -- Get the Brand ID
    SET @brandID =
    (
        SELECT TOP 1 asm.I_Brand_ID 
        FROM T_ERP_Exam_SchedulesDetails sc
        INNER JOIN T_School_Academic_Session_Master asm 
            ON sc.inAcademicSessionId = asm.I_School_Session_ID
        WHERE sc.inExamScheduleDetailId = @iExamscheduleID
    );

    -- Main Query
    SELECT DISTINCT  
        SD.I_Student_Detail_ID, 
        SD.S_Student_ID AS StudentID,
        SD.S_First_Name +   
            CASE     
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''     
                THEN ' ' + SD.S_Middle_Name     
                ELSE ''     
            END + ' ' + SD.S_Last_Name AS StudentName,
        exmsc.inSchoolProgramId AS SchoolGroupID,
        sg.S_School_Group_Name AS School_Group_Name,
        exmsub.inClassId AS ClassID,
        exmsub.stClassName AS ClassName,
        exmsub.inSectionId AS SectionID,
        exmsub.stSectionName AS SectionName,
        exmsub.inStreamId AS StreamID,
        exmsub.stStreamName AS StreamName,
        exmmarks.inSubjectID AS SubjectID,
        SBM.S_Subject_Name AS SubjectName,
        ISNULL(exmmarks.dcObtainedMarks, 0.00) AS Obtaion_Marks,
        ISNULL(sub_atten.StudPresent, 0) AS Attendence_Present_Count,
        TT4.TotalDays_wk AS TotalDays_perweek,
        (TT4.TotalDays_wk * 52) AS Total_days_per_Year,
        CAST(((CAST(ISNULL(sub_atten.StudPresent, 0) AS DECIMAL(10, 2)) / (TT4.TotalDays_wk * 52)) * 100) AS DECIMAL(10,2)) AS Overall_Atten_Percentage
    FROM T_ERP_Exam_ScheduleSubjectAttendanceMarks exmmarks
    INNER JOIN T_ERP_Exam_ScheduleSubjectDetails exmsub 
        ON exmsub.inExamScheduleDetailId = exmmarks.inExamScheduleDetailId
    INNER JOIN T_ERP_Exam_SchedulesDetails exmsc 
        ON exmsc.inExamScheduleDetailId = exmmarks.inExamScheduleDetailId
    INNER JOIN T_School_Group sg 
        ON sg.I_School_Group_ID = exmsc.inSchoolProgramId
    INNER JOIN T_Student_Detail SD 
        ON SD.I_Student_Detail_ID = exmmarks.inStudentId
    INNER JOIN T_Subject_Master SBM 
        ON SBM.I_Subject_ID = exmmarks.inSubjectId
    INNER JOIN T_School_Group_Class SGC 
        ON SGC.I_Class_ID = exmsub.inClassId 
        AND SGC.I_School_Group_ID = sg.I_School_Group_ID
    INNER JOIN T_Student_Class_Section SCS 
        ON SCS.I_Student_Detail_ID = exmmarks.inStudentId
        AND SCS.I_School_Group_Class_ID = SGC.I_School_Group_Class_ID 
        AND SCS.I_Section_ID = exmsub.inSectionId
        AND (SCS.I_Stream_ID = exmsub.inStreamId OR exmsub.inStreamId IS NULL)
        AND SCS.I_School_Session_ID = exmsc.inAcademicSessionId
    LEFT JOIN (
        SELECT Maint.I_Student_Detail_ID, 
               SUM(Maint.Present_count) AS StudPresent,
               Maint.I_School_Session_ID 
        FROM (
            SELECT DISTINCT 
                AED.I_Student_Detail_ID, 
                COUNT(AED.I_IsPresent) OVER (PARTITION BY AED.I_Student_Detail_ID, AEH.I_Student_Class_Routine_ID) AS Present_count,
                tt1.I_School_Session_ID
            FROM T_ERP_Attendance_Entry_Header AEH
            INNER JOIN T_ERP_Attendance_Entry_Detail AED 
                ON AED.I_Attendance_Entry_Header_ID = AEH.I_Attendance_Entry_Header_ID
            INNER JOIN (
                SELECT DISTINCT  
                    RSD.I_Routine_Structure_Detail_ID, 
                    RSH.I_School_Group_ID, 
                    RSH.I_School_Session_ID, 
                    SCR.I_Student_Class_Routine_ID
                FROM T_ERP_Routine_Structure_Detail RSD
                INNER JOIN T_ERP_Routine_Structure_Header RSH 
                    ON RSD.I_Routine_Structure_Header_ID = RSH.I_Routine_Structure_Header_ID
                INNER JOIN T_ERP_Student_Class_Routine SCR
                    ON SCR.I_Routine_Structure_Detail_ID = RSD.I_Routine_Structure_Detail_ID
            ) AS tt1 
                ON tt1.I_Student_Class_Routine_ID = AEH.I_Student_Class_Routine_ID
            WHERE AED.I_IsPresent = 1
        ) AS Maint
        GROUP BY Maint.I_Student_Detail_ID, Maint.I_School_Session_ID
    ) sub_atten 
        ON sub_atten.I_Student_Detail_ID = SCS.I_Student_Detail_ID
        AND sub_atten.I_School_Session_ID = exmsc.inAcademicSessionId
    LEFT JOIN (
        SELECT I_School_Session_ID, I_School_Group_ID, I_Class_ID, I_Section_ID, I_Stream_ID,
               COUNT(I_Day_ID) AS TotalDays_wk 
        FROM (
            SELECT   
                RSH.I_School_Group_ID, RSH.I_Class_ID, RSH.I_School_Session_ID,
                RSH.I_Section_ID, RSH.I_Stream_ID, RSH.I_Total_Periods,    
                RSD.I_Day_ID, WDM.S_Day_Name,    
                COUNT(RSD.I_Routine_Structure_Detail_ID) AS TotalClass    
            FROM T_ERP_Routine_Structure_Detail RSD    
            INNER JOIN T_ERP_Routine_Structure_Header RSH     
                ON RSH.I_Routine_Structure_Header_ID = RSD.I_Routine_Structure_Header_ID    
            INNER JOIN T_Week_Day_Master WDM 
                ON WDM.I_Day_ID = RSD.I_Day_ID    
            WHERE RSD.I_Is_Break = 0  
            GROUP BY RSH.I_Routine_Structure_Header_ID, RSH.I_School_Group_ID, 
                     RSH.I_Class_ID, RSH.I_School_Session_ID, RSH.I_Total_Periods,    
                     RSD.I_Day_ID, WDM.S_Day_Name, RSH.I_Section_ID, RSH.I_Stream_ID  
        ) AS T 
        GROUP BY I_School_Session_ID, I_School_Group_ID, I_Class_ID, I_Section_ID, I_Stream_ID
    ) AS TT4 
        ON TT4.I_School_Session_ID = exmsc.inAcademicSessionId
        AND TT4.I_School_Group_ID = sg.I_School_Group_ID 
        AND TT4.I_Class_ID = exmsub.inClassId
        AND ISNULL(TT4.I_Section_ID, exmsub.inSectionId) = exmsub.inSectionId
        AND (TT4.I_Stream_ID = exmsub.inStreamId OR exmsub.inStreamId IS NULL)
    WHERE exmsc.inExamScheduleDetailId = @iExamscheduleID 
    AND SCS.I_Status = 1;
END;
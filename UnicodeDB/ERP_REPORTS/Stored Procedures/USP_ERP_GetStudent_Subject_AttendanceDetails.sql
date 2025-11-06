CREATE PROCEDURE ERP_REPORTS.USP_ERP_GetStudent_Subject_AttendanceDetails  
    @brandid INT ,  
    @SessionID INT ,  
    @SchoolGroupID INT,  
    @Classid INT ,  
    @sectionid INT,  
    @fromdt DATE ,  
    @Todate DATE   
AS  
BEGIN  
    -- Main query to fetch student details, attendance, and class routine data  
    SELECT   
        TBM.S_Brand_Name AS Brand,            -- 1. Brand  
        SG.S_School_Group_Name AS SchoolProgram, -- 2. School Program  
        ASM.S_Label AS AcademicSession,        -- 3. Academic Session  
        SM.S_Subject_Name AS Subject,          -- 4. Subject  
        SD.S_Student_ID AS StudentID,          -- 5. Student ID  
        SD.S_First_Name +   
            CASE   
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''   
                THEN ' ' + SD.S_Middle_Name   
                ELSE ''   
            END + ' ' + SD.S_Last_Name AS StudentName, -- 6. Student Name  
        Tc.S_Class_Name AS Class,              -- 7. Class  
        TS.S_Section_Name AS Section,          -- 8. Section  
        SD.S_Mobile_No AS Phone,               -- 9. Phone  
        SM.S_Subject_Code AS SubjectCode,      -- 10. Subject Code  
        SM.S_Subject_Name AS SubjectName,      -- 11. Subject Name  
        FM.S_Faculty_Name AS Faculty,          -- 12. Faculty  
        ISNULL(TotalClassData.Classcount, 0) AS TotalClassesHeld, -- 13. Total Classes held  
        ISNULL(AttendanceData.TotalPresent, 0) AS ClassesAttended, -- 14. Classes Attended  
        FLOOR(ISNULL((CAST(AttendanceData.TotalPresent AS DECIMAL(10, 2)) / NULLIF(TotalClassData.Classcount, 0)) * 100, 0)) AS AttendancePercentage -- 15. Attendance Percentage  
    FROM   
        -- Subquery 1: Student Details  
        T_Student_Class_Section SCS  
    INNER JOIN   
        T_Student_Detail SD ON SD.I_Student_Detail_ID = SCS.I_Student_Detail_ID  
        AND SCS.I_Status = 1  
    INNER JOIN   
        T_School_Group_Class SGC ON SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID  
    INNER JOIN   
        T_School_Group SG ON SG.I_School_Group_ID = SGC.I_School_Group_ID  
        AND SG.I_Brand_Id = @brandid  
    INNER JOIN   
        T_Class Tc ON Tc.I_Class_ID = SGC.I_Class_ID   
        AND Tc.I_Brand_ID = @brandid  
    INNER JOIN   
        T_Section TS ON TS.I_Section_ID = SCS.I_Section_ID  
    LEFT JOIN   
        T_ERP_Student_Subject ESS ON ESS.I_Student_Detail_ID = SD.I_Student_Detail_ID  
        AND ESS.I_School_Group_ID = SG.I_School_Group_ID  
        AND ESS.I_Class_ID = Tc.I_Class_ID  
        AND ESS.I_School_Session_ID = SCS.I_School_Session_ID  
    LEFT JOIN   
        T_Subject_Master SM ON SM.I_Subject_ID = ESS.I_Subject_ID  
    LEFT JOIN   
        T_Brand_Master TBM ON TBM.I_Brand_ID = @brandid  
    LEFT JOIN   
        T_School_Academic_Session_Master ASM ON ASM.I_School_Session_ID = @SessionID  
  
    -- Subquery 2: Attendance Data  
    LEFT JOIN   
        (  
            SELECT   
                I_Student_Detail_ID,  
                SCR.I_Subject_ID,  
                eh.I_Faculty_Master_ID,  
                COUNT(CASE WHEN ISNULL(i_isPresent, 0) = 1 THEN 1 END) AS TotalPresent  
            FROM   
                T_ERP_Attendance_Entry_Detail ed  
            INNER JOIN   
                T_ERP_Attendance_Entry_Header eh ON ed.I_Attendance_Entry_Header_ID = eh.I_Attendance_Entry_Header_ID  
            INNER JOIN   
                T_ERP_Student_Class_Routine SCR ON SCR.I_Student_Class_Routine_ID = eh.I_Student_Class_Routine_ID  
            WHERE   
                eh.Dt_Date >= @fromdt   
                AND eh.Dt_Date <= @Todate  
            GROUP BY   
                I_Student_Detail_ID,   
                SCR.I_Subject_ID,   
                eh.I_Faculty_Master_ID  
        ) AS AttendanceData   
        ON AttendanceData.I_Student_Detail_ID = SCS.I_Student_Detail_ID   
        AND AttendanceData.I_Subject_ID = ESS.I_Subject_ID  
  
    -- Subquery 3: Total Classes Data  
    LEFT JOIN   
        (  
         SELECT   
            COUNT(RSD.I_Routine_Structure_Detail_ID) AS Classcount,  
            RSH.I_Routine_Structure_Header_ID,  
            SCR.I_Faculty_Master_ID,  
            SCR.I_Subject_ID,  
            RSH.I_School_Session_ID,  
            RSH.I_School_Group_ID,  
            RSH.I_Class_ID,  
            RSH.I_Section_ID  
        FROM   
            T_ERP_Routine_Structure_Detail RSD  
        INNER JOIN   
            T_ERP_Student_Class_Routine SCR ON SCR.I_Routine_Structure_Detail_ID = RSD.I_Routine_Structure_Detail_ID  
        INNER JOIN   
            T_ERP_Routine_Structure_Header RSH ON RSH.I_Routine_Structure_Header_ID = RSD.I_Routine_Structure_Header_ID  
        WHERE   
            I_Is_Break = 0  
            AND RSH.I_School_Session_ID = @SessionID   
            AND RSH.I_School_Group_ID = @SchoolGroupID  
            AND RSH.I_Class_ID = @Classid  
        GROUP BY   
            SCR.I_Faculty_Master_ID,   
            SCR.I_Subject_ID,   
            RSH.I_School_Session_ID,  
            RSH.I_School_Group_ID,   
            RSH.I_Class_ID,   
            RSH.I_Section_ID,  
            RSH.I_Routine_Structure_Header_ID  
        ) AS TotalClassData   
        ON TotalClassData.I_Section_ID = SCS.I_Section_ID   
        AND TotalClassData.I_Subject_ID = ESS.I_Subject_ID  
        AND TotalClassData.I_Faculty_Master_ID = AttendanceData.I_Faculty_Master_ID  
    LEFT JOIN   
        T_Faculty_Master FM ON FM.I_Faculty_Master_ID = TotalClassData.I_Faculty_Master_ID  
    WHERE   
        SCS.I_Brand_ID = @brandid   
        AND SG.I_School_Group_ID = @SchoolGroupID  
        AND Tc.I_Class_ID = @Classid  
        AND SCS.I_School_Session_ID = @SessionID  
        AND (SCS.I_Section_ID = @sectionid OR @sectionid IS NULL);  
END;  
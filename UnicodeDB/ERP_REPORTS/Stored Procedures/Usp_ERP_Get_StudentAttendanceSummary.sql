  
CREATE PROCEDURE [ERP_REPORTS].[Usp_ERP_Get_StudentAttendanceSummary]  
    @brandid INT,  
    @SessionID INT,  
    @SchoolGroupID INT,  
    @Classid INT,  
    @fromdt DATE,  
    @Todate DATE  
AS  
BEGIN  
    -- Ensure no data leakage if there are errors  
    SET NOCOUNT ON;  
  
    -- Main query  
    SELECT DISTINCT   
        tt.Attendancedate,  
        TBM.S_Brand_Name AS Brand,  
        tt1.S_School_Group_Name AS GroupName,  
        tt1.S_Class_Name AS Class,  
        ASM.S_Label AS AcademicSession,  
        tt1.S_Student_ID AS StudentID,  
        tt1.Studentname,  
        tt1.S_Section_Name AS Section,  
        tt1.RollNo,  
        tt1.StudentMobile,  
        tt.TotalPresent AS TotalPresentCount,  
        --tt.TotalAbsent AS TotalAbsentCount,  
       CAST(((CAST(tt.TotalPresent AS DECIMAL(10, 2)) / totclass.TotalClass) * 100) As decimal(10,2)) AS Overall_dayPercentage  
    FROM   
    (  
        -- Subquery for attendance details  
        SELECT DISTINCT  
            Dt_Date AS Attendancedate,  
            I_Student_Detail_ID,  
            COUNT(CASE WHEN ISNULL(i_isPresent, 0) = 1 THEN 1 END) AS TotalPresent, -- Count present  
            COUNT(CASE WHEN ISNULL(i_isPresent, 0) = 0 THEN 1 END) AS TotalAbsent -- Count absent  
        FROM   
            T_ERP_Attendance_Entry_Detail ed  
        INNER JOIN   
            T_ERP_Attendance_Entry_Header eh ON ed.I_Attendance_Entry_Header_ID = eh.I_Attendance_Entry_Header_ID  
        WHERE   
            eh.Dt_Date >= @fromdt   
            AND eh.Dt_Date <= @Todate  
        GROUP BY   
            I_Student_Detail_ID, Dt_Date  
    ) tt   
    INNER JOIN  
    (  
        -- Subquery for student details  
        SELECT DISTINCT   
            SCS.I_School_Session_ID,   
            SCS.I_Student_Detail_ID,  
            SD.S_Student_ID,  
            SD.S_First_Name +   
            CASE   
                WHEN SD.S_Middle_Name IS NOT NULL AND SD.S_Middle_Name != ''   
                THEN ' ' + SD.S_Middle_Name   
                ELSE ''   
            END +   
            ' ' + SD.S_Last_Name AS Studentname,  
            SD.S_Mobile_No AS StudentMobile,  
            SCS.I_School_Group_Class_ID,  
            SG.I_School_Group_ID,  
            SG.S_School_Group_Name,  
            Tc.I_Class_ID,  
            Tc.S_Class_Name,  
            SCS.S_Class_Roll_No AS RollNo,  
            SCS.I_Section_ID,  
            TS.S_Section_Name  
        FROM   
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
        WHERE   
            SCS.I_Brand_ID = @brandid   
            AND SG.I_School_Group_ID = @SchoolGroupID  
            AND Tc.I_Class_ID = @Classid  
            AND SCS.I_School_Session_ID = @SessionID  
    ) tt1   
    ON tt.I_Student_Detail_ID = tt1.I_Student_Detail_ID  
 Left Join   
 (  
 Select RSH.I_Routine_Structure_Header_ID  
 ,RSH.I_School_Group_ID,RSH.I_Class_ID,RSH.I_School_Session_ID,RSH.I_Total_Periods  
 ,RSD.I_Day_ID ,WDM.S_Day_Name  
 ,COUNT(RSD.I_Routine_Structure_Detail_ID) as TotalClass  
 from T_ERP_Routine_Structure_Detail RSD  
 Inner Join T_ERP_Routine_Structure_Header RSH   
 ON RSH.I_Routine_Structure_Header_ID=RSD.I_Routine_Structure_Header_ID  
 Inner Join T_Week_Day_Master WDM ON WDM.I_Day_ID=RSD.I_Day_ID  
 where RSH.I_School_Group_ID=@SchoolGroupID and RSH.I_Class_ID=@Classid  
 and RSH.I_School_Session_ID=@SessionID and RSD.I_Is_Break=0  
  
 Group by RSH.I_Routine_Structure_Header_ID  
 ,RSH.I_School_Group_ID,RSH.I_Class_ID,RSH.I_School_Session_ID,RSH.I_Total_Periods  
 ,RSD.I_Day_ID ,WDM.S_Day_Name  
 ) totclass ON totclass.I_School_Group_ID=tt1.I_School_Group_ID  
 and totclass.I_Class_ID=tt1.I_Class_ID  
 and totclass.I_School_Session_ID=tt1.I_School_Session_ID  
 and totclass.S_Day_Name=DATENAME(WEEKDAY, tt.Attendancedate)  
    INNER JOIN   
        T_Brand_Master TBM ON TBM.I_Brand_ID = @brandid  
    INNER JOIN   
        T_School_Academic_Session_Master ASM ON ASM.I_School_Session_ID = @SessionID;  
  
    -- Ensure no rows are returned accidentally on execution  
    SET NOCOUNT OFF;  
END;  
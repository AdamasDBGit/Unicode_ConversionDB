CREATE PROCEDURE [dbo].[TeacherRoutineMyClasses_bak]            
-- =============================================          
-- Author: Tridip Chatterjee          
-- Create date: 18-09-2023          
-- Description: Teacher Day Wise My Class Routine_Details          
-- exec [TeacherRoutineMyClasses_bak] 1066,'2024-09-02'          
-- =============================================          
-- Add the parameters for the stored procedure here          
@TeacherID int,          
@Day date         
AS          
BEGIN          
    -- SET NOCOUNT ON added to prevent extra result sets from          
    SET NOCOUNT ON;          
    DECLARE @D int;          
    SET @D = (          
        SELECT I_Day_ID 
        FROM T_Week_Day_Master 
        WHERE S_Day_Name = (SELECT DATENAME(dw, @Day))
    );          
    
    -- Start with a basic query, focusing on eliminating duplicates
    SELECT DISTINCT
        TERSD.T_FromSlot,          
        TERSD.T_ToSlot,          
        TERSH.I_School_Session_ID,          
        TWDM.S_Day_Name,          
        TERSD.I_Period_No,          
        TFM.S_Faculty_Name,          
        TFM.I_Faculty_Master_ID,          
        TSM.S_Subject_Name,          
        TSM.I_Subject_ID,          
        TSG.S_School_Group_Name,          
        TSG.I_School_Group_ID,          
        TC.S_Class_Name,          
        TC.I_Class_ID,          
        TERSD.I_Day_ID,          
        TS.S_Section_Name,          
        TESCR.I_Student_Class_Routine_ID,          
        CASE WHEN (          
            SELECT COUNT(*) 
            FROM T_ERP_Attendance_Entry_Header AS TEAEH 
            WHERE TEAEH.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID 
            AND TEAEH.I_Faculty_Master_ID = TFM.I_Faculty_Master_ID 
            AND CAST(TEAEH.Dt_Date AS date) = CAST(GETDATE() AS date)    
        ) > 0 THEN 1 ELSE 0 END AS IsAttendance,          
        CASE WHEN (          
            SELECT COUNT(*) 
            FROM T_ERP_Teacher_Time_Plan AS TETTP         
            INNER JOIN T_ERP_Subject_Structure_Plan AS SSP 
                ON TETTP.I_Subject_Structure_Plan_ID = SSP.I_Subject_Structure_Plan_ID        
            INNER JOIN T_ERP_Subject_Structure_Plan_Detail AS SSPD 
                ON SSPD.I_Subject_Structure_Plan_ID = SSP.I_Subject_Structure_Plan_ID        
            LEFT JOIN T_ERP_Subject_Structure_Plan_Execution_Remarks AS SSPER 
                ON SSPER.I_Teacher_Time_Plan_ID = TETTP.I_Teacher_Time_Plan_ID        
            INNER JOIN T_ERP_Student_Class_Routine SCR 
                ON SCR.I_Student_Class_Routine_ID = TETTP.I_Student_Class_Routine_ID  
            WHERE TETTP.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID   
            AND SSP.I_Month_No = MONTH(@Day) 
            AND (@D IS NULL OR SSP.I_Day_No = @D)          
        ) > 0 THEN 1 ELSE 0 END AS IsLogbook,         
        TFM.S_Faculty_Name AS TeacherName,          
        TESCRW.S_ClassWork AS ClassWork,          
        ttc.TotalStud AS Total_Student,        
        TERSH.I_Stream_ID,  
        TST.S_Stream AS Stream_Name
          
    FROM          
        T_ERP_Student_Class_Routine TESCR          
    INNER JOIN 
        T_ERP_Routine_Structure_Detail TERSD 
        ON TERSD.I_Routine_Structure_Detail_ID = TESCR.I_Routine_Structure_Detail_ID          
    INNER JOIN 
        T_ERP_Routine_Structure_Header TERSH 
        ON TERSH.I_Routine_Structure_Header_ID = TERSD.I_Routine_Structure_Header_ID          
    INNER JOIN 
        T_Faculty_Master TFM 
        ON TFM.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID          
    INNER JOIN 
        T_Subject_Master TSM 
        ON TSM.I_Subject_ID = TESCR.I_Subject_ID          
    INNER JOIN 
        T_School_Group TSG 
        ON TSG.I_School_Group_ID = TERSH.I_School_Group_ID          
    INNER JOIN 
        T_Class TC 
        ON TC.I_Class_ID = TERSH.I_Class_ID          
    INNER JOIN 
        T_Week_Day_Master TWDM 
        ON TWDM.I_Day_ID = TERSD.I_Day_ID          
    INNER JOIN 
        T_Section TS 
        ON TS.I_Section_ID = TERSH.I_Section_ID           
    LEFT JOIN 
        T_ERP_Student_Class_Routine_Work TESCRW 
        ON TESCRW.I_Student_Class_Routine_ID = TESCR.I_Student_Class_Routine_ID           
        AND TESCRW.I_Faculty_Master_ID = TESCR.I_Faculty_Master_ID          
        AND CAST(TESCRW.Dt_Date AS date) = CAST(@Day AS date)         
    LEFT JOIN 
        T_Stream TST 
        ON TST.I_Stream_ID = TERSH.I_Stream_ID OR TERSH.I_Stream_ID IS NULL        
    LEFT JOIN (        
        SELECT 
            A.I_Brand_ID,
            A.I_School_Session_ID,
            TC.I_Class_ID,
            TST.I_Stream_ID,        
            COUNT(I_Student_Class_Section_ID) AS TotalStud,
            TS.I_Section_ID,
            B.I_School_Group_ID       
        FROM 
            T_Student_Class_Section A        
        INNER JOIN 
            T_School_Group_Class B 
            ON A.I_School_Group_Class_ID = B.I_School_Group_Class_ID        
        INNER JOIN 
            T_Class TC 
            ON TC.I_Class_ID = B.I_Class_ID        
        INNER JOIN 
            T_Section TS 
            ON A.I_Section_ID = TS.I_Section_ID  -- Join T_Section if exists        
        LEFT JOIN 
            T_Stream TST 
            ON A.I_Stream_ID = TST.I_Stream_ID     
        GROUP BY 
            A.I_Brand_ID,
            A.I_School_Session_ID,
            TC.I_Class_ID,        
            TST.I_Stream_ID,
            TS.I_Section_ID,
            B.I_School_Group_ID            
    ) AS ttc 
        ON ttc.I_School_Session_ID = TERSH.I_School_Session_ID        
        AND ttc.I_Class_ID = TERSH.I_Class_ID     
        AND ttc.I_Section_ID = TERSH.I_Section_ID 
        AND ttc.I_School_Group_ID = TSG.I_School_Group_ID
        AND (ttc.I_Stream_ID = TERSH.I_Stream_ID OR TERSH.I_Stream_ID IS NULL)  
  
    WHERE           
        TESCR.I_Faculty_Master_ID = @TeacherID 
        AND TERSD.I_Day_ID = @D;
          
END;

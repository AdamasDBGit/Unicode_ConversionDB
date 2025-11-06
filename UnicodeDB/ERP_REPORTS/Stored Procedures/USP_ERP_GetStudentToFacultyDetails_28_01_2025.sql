CREATE PROCEDURE [ERP_REPORTS].[USP_ERP_GetStudentToFacultyDetails_28/01/2025]    
    @BrandID INT,    
    @schoolGroupID INT,    
    @classID INT,    
    @SectionID INT = NULL, -- Optional parameter    
    @sessionID INT    
AS    
BEGIN    
    SET NOCOUNT ON; -- Prevents extra result sets from interfering with SELECT statements    
    
    SELECT TT.*,     
           ISNULL(T1.TotalAssigned_Faculty, 0) AS TotalAssigned_Faculty,    
            CASE   
               WHEN ISNULL(T1.TotalAssigned_Faculty, 0) = 0 THEN '0:0'  -- Handle division by zero  
               ELSE CAST(TT.TotalStudentcount AS VARCHAR(10)) + ':' + CAST(ISNULL(T1.TotalAssigned_Faculty, 0) AS VARCHAR(10))  
           END AS Student_to_Faculty_Ratio    
    FROM (    
        SELECT SG.I_School_Group_ID,    
               SG.S_School_Group_Name,    
               TC.I_Class_ID,    
               TC.S_Class_Name,    
               TS.I_Section_ID,    
               TS.S_Section_Name,    
               ISNULL(COUNT(distinct scs.I_Student_Detail_ID), 0) AS TotalStudentcount    
        FROM T_Student_Class_Section SCS    
        INNER JOIN T_School_Group_Class SGC     
            ON SGC.I_School_Group_Class_ID = SCS.I_School_Group_Class_ID    
           AND SCS.I_Brand_ID = @BrandID    
           AND SCS.I_School_Session_ID = @sessionID    
        INNER JOIN T_Class TC     
            ON TC.I_Class_ID = SGC.I_Class_ID    
           AND TC.I_Brand_ID = @BrandID    
        INNER JOIN T_School_Group SG     
            ON SG.I_School_Group_ID = SGC.I_School_Group_ID    
           AND SG.I_Brand_Id = @BrandID    
        LEFT JOIN T_Section TS     
            ON TS.I_Section_ID = SCS.I_Section_ID    
        WHERE SCS.I_Status = 1    
        GROUP BY SG.I_School_Group_ID, SG.S_School_Group_Name,    
                 TC.I_Class_ID, TC.S_Class_Name,    
                 TS.I_Section_ID, TS.S_Section_Name    
    ) TT    
    LEFT JOIN (    
        SELECT RSH.I_School_Group_ID,    
               RSH.I_Class_ID,    
               RSH.I_Section_ID,    
               COUNT(SCR.I_Faculty_Master_ID) AS TotalAssigned_Faculty    
        FROM T_ERP_Routine_Structure_Header RSH    
        INNER JOIN T_ERP_Routine_Structure_Detail RSD     
            ON RSH.I_Routine_Structure_Header_ID = RSD.I_Routine_Structure_Header_ID    
        INNER JOIN T_ERP_Student_Class_Routine SCR     
            ON SCR.I_Routine_Structure_Detail_ID = RSD.I_Routine_Structure_Detail_ID    
        GROUP BY RSH.I_School_Group_ID, RSH.I_Class_ID, RSH.I_Section_ID    
    ) T1     
    ON TT.I_School_Group_ID = T1.I_School_Group_ID    
       AND TT.I_Class_ID = T1.I_Class_ID    
       AND TT.I_Section_ID = T1.I_Section_ID    
    WHERE TT.I_School_Group_ID = @schoolGroupID    
      AND TT.I_Class_ID = @classID    
      AND (TT.I_Section_ID = @SectionID OR @SectionID IS NULL);    
END; 
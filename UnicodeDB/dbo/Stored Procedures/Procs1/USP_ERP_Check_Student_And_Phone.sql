CREATE PROCEDURE [dbo].[USP_ERP_Check_Student_And_Phone]      
    @brandID INT ,      
    @StudentID NVARCHAR(max)       
AS      
BEGIN      
    DECLARE @Studentexists INT, @phoneExists nvarchar(max)      
          
    SET @Studentexists = NULL      
    SET @phoneExists = NULL      
      
    SELECT TOP 1        
        @Studentexists = sd.I_Student_Detail_ID     
             
    FROM T_Student_Class_Section scs      
    INNER JOIN T_Student_Detail sd ON sd.I_Student_Detail_ID = scs.I_Student_Detail_ID      
    LEFT JOIN T_Student_Parent_Maps tspm ON tspm.S_Student_ID = sd.S_Student_ID                              
         
    WHERE       
        scs.I_Brand_ID = @brandID       
        AND sd.S_Student_ID = @StudentID       
        AND scs.I_Status = 1       
        AND sd.I_Status = 1      
              
      
    IF (@Studentexists IS NULL)      
    BEGIN      
        SELECT       
            0 AS StatusFlag,      
            'No matching student ID available' AS Message      
    END       
     
    ELSE      
    BEGIN      
        SELECT       
            1 AS StatusFlag,      
            'StudentID Available' AS Message      
    END      
END 


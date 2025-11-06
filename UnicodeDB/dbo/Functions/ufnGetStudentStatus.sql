-- =============================================  
-- Author:  Soumya Sikder  
-- Create date: '27/04/2007'  
-- Description: This Function return the Current Status of Student Belonging to a particular Center  
-- Return: Status Character  
-- =============================================  
CREATE FUNCTION [dbo].[ufnGetStudentStatus](@CenterLevelID int, @StudentID int)  
RETURNS  VARCHAR(50)  
AS   
-- Returns the Student Status whether ACTIVE, ON LEAVE or DROPOUT.  
BEGIN  
DECLARE @retStudentStatus VARCHAR(50)  
SET @retStudentStatus =   
        CASE   
--            -- Check for Financial Dropout  
--            WHEN EXISTS(SELECT * FROM dbo.T_Dropout_Dtls E  
--                WHERE I_Student_ID = @StudentID  
--      AND I_Dropout_Status_ID = 1  
--                AND E.I_Center_ID = @CenterLevelID)   
--                THEN 'Financial Dropout'  
--            -- Check for On Leave  
            WHEN EXISTS(SELECT A.I_Student_Leave_ID   
    FROM dbo.T_Student_Leave_Request A,   
      dbo.T_Student_Center_Detail B  
                WHERE A.I_Student_Detail_ID = B.I_Student_Detail_ID  
    AND A.I_Student_Detail_ID = @StudentID  
    AND DATEDIFF(dd,[A].[Dt_From_Date],GETDATE()) >= 0
    AND DATEDIFF(dd,[A].[Dt_To_Date],GETDATE()) <= 0
    AND A.I_Status = 1  
    AND B.I_Status = 1  
                AND B.I_Centre_ID = @CenterLevelID)   
                THEN 'On Leave'  
--            -- Check for Academic Dropout  
--            WHEN EXISTS(SELECT * FROM dbo.T_Dropout_Dtls F  
--                WHERE F.I_Dropout_Status_ID = 1  
--      AND I_Student_ID = @StudentID  
--                AND F.I_Center_ID = @CenterLevelID)   
--                THEN 'Academic Dropout'  
            -- Check for Active  
            WHEN EXISTS(SELECT * FROM dbo.T_Student_Center_Detail G  
                WHERE G.I_Status = 1   
    AND DATEDIFF(dd,G.Dt_Valid_From,GETDATE()) >= 0
    AND G.I_Student_Detail_ID = @StudentID  
    AND G.I_Centre_Id = @CenterLevelID)   
                 THEN 'Active'  
        END;  
    -- Return the information to the caller  
    RETURN @retStudentStatus  
END;
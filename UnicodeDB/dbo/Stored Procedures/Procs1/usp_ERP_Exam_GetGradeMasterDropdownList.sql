-- =============================================  
-- Author:      Qutub Haider  
-- Create date: 15 Aug 2024  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetGradeMasterDropdownList]  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT   
        inExamGradeHederId,  
        stGradeHederName  
    FROM   
        [dbo].[T_ERP_Exam_Grade_Master_Header]  
 WHERE    
  IsActive = 1  
    ORDER BY   
        stGradeHederName;   
  
END
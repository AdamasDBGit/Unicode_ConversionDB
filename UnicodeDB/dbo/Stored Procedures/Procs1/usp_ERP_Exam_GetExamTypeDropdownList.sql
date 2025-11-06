-- =============================================        
-- Author:  <Abhik Porel>        
-- Create date: <24-July-2024>        
-- Description:   
-- =============================================        
      
CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetExamTypeDropdownList]       
(      
   @iBrandID int= null       
)        
AS        
BEGIN        
    SELECT   
  inExamTypeID AS iId,  
  stExamTypeName AS sTypeName,  
  IsMainExam  
    FROM [T_ERP_Exam_Type_Master]   
    WHERE  
    inBrandID = @iBrandID             
END     
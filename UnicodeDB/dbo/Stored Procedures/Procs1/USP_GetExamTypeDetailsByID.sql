-- Author: Md Qutubuddin Haider  
-- Create date: 2024-08-25  
  
CREATE PROCEDURE [dbo].[USP_GetExamTypeDetailsByID]  
    @inExamTypeID INT  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT   
        [inExamTypeID],  
        [stExamTypeName],  
        [inTYPE],  
        [unTypeId],  
        [inBrandID],  
        [IsMainExam]  
    FROM   
        [dbo].[T_ERP_Exam_Type_Master]  
    WHERE   
        [inExamTypeID] = @inExamTypeID;  
END;  
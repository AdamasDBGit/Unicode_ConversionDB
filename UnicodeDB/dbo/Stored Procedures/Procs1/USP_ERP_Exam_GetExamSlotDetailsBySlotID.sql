-- Author: Md Qutubuddin Haider  
-- Create date: 2024-08-15  
CREATE PROCEDURE [dbo].[USP_ERP_Exam_GetExamSlotDetailsBySlotID]  
    @inSlotID INT  
AS  
BEGIN   
      
    SET NOCOUNT ON;  
    SELECT   
        inSlotID,  
        stSlotCode,  
        tmSlotStartTime,  
        tmSlotEndTime,  
        IsActive  
    FROM   
        [dbo].[T_ERP_Exam_Slot_Master]  
    WHERE   
        inSlotID = @inSlotID;  
END  
  
-- =============================================  
-- Author:      Qutub Haider  
-- Create date: 15 Aug 2024  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_Exam_GetSlotDropdownList]  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT   
        ES.inSlotID AS SlotID,  
        ES.stSlotCode AS SlotCode,  
        ES.tmSlotStartTime AS SlotStartTime,  
        ES.tmSlotEndTime AS SlotEndTime  
    FROM   
        [dbo].[T_ERP_Exam_Slot_Master] AS ES      
    ORDER BY   
        ES.inSlotID;  
  
END  
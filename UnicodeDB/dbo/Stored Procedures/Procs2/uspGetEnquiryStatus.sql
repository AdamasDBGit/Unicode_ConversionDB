CREATE PROCEDURE [dbo].[uspGetEnquiryStatus]     
AS    
BEGIN    
    
 SELECT DISTINCT     
 I_Status_Value,    
 S_Status_Desc    
 FROM dbo.T_Status_Master    
 WHERE S_Status_Type = 'enq'    
    
END

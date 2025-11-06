CREATE PROCEDURE [dbo].[uspRevokeStudentBatch_BeforeFeePlanModify_March2023]    
(  
 @iBatchId INT  
)       
AS  
BEGIN  
 DELETE FROM dbo.T_Center_Batch_Details WHERE I_Batch_ID = @iBatchId  
 UPDATE dbo.T_Student_Batch_Master SET   
 I_Status = 0 WHERE  
 I_Batch_ID = @iBatchId  
 DELETE FROM dbo.T_Student_Batch_Schedule WHERE I_Batch_ID = @iBatchId
END

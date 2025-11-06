CREATE PROCEDURE [dbo].[uspValidateStudentBatchDetails]    
(  
 @iBatchId INT  
)       
AS  
BEGIN  
 SELECT COUNT(*) FROM dbo.T_Student_Batch_Details  
 WHERE  
 I_Batch_ID = @iBatchId  
 AND  
 I_Status = 1  
 SELECT COUNT(*) FROM dbo.T_Student_Registration_Details  
 WHERE  
 I_Batch_ID = @iBatchId  
 AND  
 I_Status = 1 
END

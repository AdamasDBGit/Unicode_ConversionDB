CREATE PROCEDURE [dbo].[uspGetBatchScheduleDtlForHOBatch]    
        
@iBatchID INT = NULL   
        
AS        
BEGIN          
        
SELECT COUNT(*) AS iCount FROM T_Student_Batch_Schedule WHERE    
I_Batch_ID=ISNULL(@iBatchID,I_Batch_ID) 
        
END

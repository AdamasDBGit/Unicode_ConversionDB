CREATE PROCEDURE [dbo].[uspUpdateBatchEndDate]
(  
  @iBatchID INT,
  @dtBatchEndDate  DATETIME
)  
AS  
BEGIN  
UPDATE dbo.T_Student_Batch_Master SET Dt_Course_Expected_End_Date = @dtBatchEndDate
WHERE I_Batch_ID=@iBatchID

END

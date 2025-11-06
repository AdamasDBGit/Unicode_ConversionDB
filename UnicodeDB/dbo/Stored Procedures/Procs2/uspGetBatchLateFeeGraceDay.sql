CREATE PROCEDURE [dbo].[uspGetBatchLateFeeGraceDay] 
( 
 @iStudentDetailId int  
)  
  
AS  
BEGIN  
   
 SELECT   
 Max(SBM.I_Latefee_Grace_Day) AS I_Latefee_Grace_Day 
 FROM  dbo.T_Student_Batch_Master SBM
 INNER JOIN dbo.T_Student_Batch_Details SBD  
 ON SBM.I_Batch_ID = SBD.I_Batch_ID
 WHERE SBD.I_Student_ID = @iStudentDetailId  AND SBD.I_Status =1  
END

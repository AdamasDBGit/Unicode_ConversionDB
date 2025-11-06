
create FUNCTION [dbo].[fnGetTotalStudentCount]  
(  
 @iBatchID INT
)  
RETURNS INT  
AS  
BEGIN  
 DECLARE @iCount INT  
  
 SELECT @iCount = COUNT(SD.I_Student_Detail_ID)
		FROM dbo.T_Student_Detail SD  
	INNER JOIN dbo.T_Student_Batch_Details AS TSBD  
    ON SD.I_Student_Detail_ID = TSBD.I_Student_ID  
    AND TSBD.I_Status = 1  
    AND SD.I_Status = 1 
   INNER JOIN dbo.T_Student_Batch_Master AS TSBM
   ON TSBD.I_Batch_ID = TSBM.I_Batch_ID 
   Where TSBD.I_Batch_ID=@iBatchID
 RETURN @iCount  
END
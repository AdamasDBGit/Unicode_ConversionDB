CREATE PROCEDURE [dbo].[uspGetTransferAdviceC]      
(       
  @iStudentDetailId INT      
 ,@iTransferRequestId INT    
      
)      
AS      
BEGIN      
    
SELECT ISNULL(I_Course_Duration,0) AS I_Course_Duration
      ,ISNULL(I_Course_Completed,0) AS I_Course_Completed
FROM dbo.T_Student_Transfer_Request WHERE I_Transfer_Request_Id = @iTransferRequestId    
    
SELECT ISNULL(SUM(ISNULL(IP.N_Invoice_Amount,0)),0) AS N_Invoice_Amount
FROM dbo.T_Student_Detail SD      
INNER JOIN dbo.T_Invoice_Parent IP      
 ON SD.I_Student_Detail_ID = IP.I_Student_Detail_ID
 AND IP.I_Student_Detail_ID = @iStudentDetailId
WHERE SD.I_Student_Detail_Id = @iStudentDetailId
AND [IP].[I_Status] IN (1,3)
      
SELECT ISNULL(SUM(ISNULL(RH.N_Receipt_Amount,0)),0) AS N_Receipt_Amount
FROM dbo.T_Receipt_Header RH      
INNER JOIN dbo.T_Invoice_Parent IP       
  ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID      
WHERE RH.I_Student_Detail_ID = @iStudentDetailId      
--AND IP.I_Centre_Id <> @iDestinationCenterId      
AND RH.I_Status = 1    
    
SELECT ISNULL(SUM(ISNULL(N_DCCourse_Amount,0)),0) AS N_DCCourse_Amount5
FROM dbo.T_Student_Transfer_Request WHERE I_Transfer_Request_Id = @iTransferRequestId       
--      
--SELECT @duration = DATEDIFF(MM,Dt_Course_Start_Date,Dt_Course_Expected_End_Date)       
--FROM dbo.T_Student_Course_Detail       
--WHERE I_Student_Detail_Id = @iStudentDetailId      
--      
--SELECT DATEDIFF(MM,Dt_Course_Start_Date,Dt_Course_Expected_End_Date)       
--FROM dbo.T_Student_Course_Detail       
--WHERE I_Student_Detail_Id = @iStudentDetailId      
--      
--      
--SELECT @diff = DATEDIFF(MM,Dt_Course_Start_Date,GETDATE())       
--FROM dbo.T_Student_Course_Detail       
--WHERE I_Student_Detail_Id = @iStudentDetailId      
--      
--IF @diff > @duration      
--BEGIN      
--SELECT 0      
--END      
--ELSE      
--BEGIN      
--SELECT DATEDIFF(MM,Dt_Course_Start_Date,GETDATE())       
--FROM dbo.T_Student_Course_Detail       
--WHERE I_Student_Detail_Id = @iStudentDetailId      
--END      
--      
--     
    
      
END

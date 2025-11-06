--uspGetTransferAdvice 160358,40,10
CREATE PROCEDURE [dbo].[uspGetTransferAdvice]
(     
  @iStudentDetailId INT    
 ,@iSourceCenterId INT = null    
 ,@iDestinationCenterId INT = null    
    
)    
AS    
BEGIN    
    
DECLARE @duration INT    
DECLARE @diff INT    
    
SELECT @duration = DATEDIFF(MM,Dt_Course_Start_Date,Dt_Course_Expected_End_Date)     
FROM dbo.T_Student_Course_Detail WITH(NOLOCK)    
WHERE I_Student_Detail_Id = @iStudentDetailId AND I_STATUS = 1   
    
SELECT DATEDIFF(MM,Dt_Course_Start_Date,Dt_Course_Expected_End_Date)     
FROM dbo.T_Student_Course_Detail WITH(NOLOCK)
WHERE I_Student_Detail_Id = @iStudentDetailId AND I_STATUS = 1   
    
    
SELECT @diff = DATEDIFF(MM,Dt_Course_Start_Date,GETDATE())     
FROM dbo.T_Student_Course_Detail WITH(NOLOCK)
WHERE I_Student_Detail_Id = @iStudentDetailId  AND I_STATUS = 1  
    
IF @diff > @duration    
BEGIN    
SELECT 0    
END    
ELSE    
BEGIN    
SELECT DATEDIFF(MM,Dt_Course_Start_Date,GETDATE())     
FROM dbo.T_Student_Course_Detail WITH(NOLOCK)     
WHERE I_Student_Detail_Id = @iStudentDetailId   AND I_STATUS = 1 
END    
    
SELECT IP.N_Invoice_Amount    
FROM dbo.T_Student_Detail SD   WITH(NOLOCK)  
INNER JOIN dbo.T_Invoice_Parent IP   WITH(NOLOCK)  
 ON SD.I_Student_Detail_ID = IP.I_Student_Detail_ID    
WHERE SD.I_Student_Detail_Id = @iStudentDetailId  
AND IP.I_Centre_Id =  @iSourceCenterId 
    
SELECT ISNULL(SUM(RH.N_Receipt_Amount),0)
FROM dbo.T_Receipt_Header RH    WITH(NOLOCK) 
INNER JOIN dbo.T_Invoice_Parent IP   WITH(NOLOCK)   
  ON RH.I_Invoice_Header_ID = IP.I_Invoice_Header_ID    
WHERE RH.I_Student_Detail_ID = @iStudentDetailId    
AND IP.I_Centre_Id = @iSourceCenterId    
AND RH.I_Status = 1    
    
END

CREATE PROCEDURE [dbo].[uspGetCTAdditionalInfo]        
(              
 @iStudentDetailId INT  
,@iTransferRequestId INT         
)          
AS          
BEGIN       
      
SELECT ISNULL(I_Course_Duration,0) AS I_Course_Duration      
 ,ISNULL(I_Course_Completed,0) AS I_Course_Completed      
 ,ISNULL(N_DCCourse_Amount,0) AS N_DCCourse_Amount      
FROM dbo.T_Student_Transfer_Request      
WHERE I_Student_Detail_ID = @iStudentDetailId     
AND  I_Transfer_Request_ID = @iTransferRequestId  
AND I_Status NOT IN (0,13)     
      
END

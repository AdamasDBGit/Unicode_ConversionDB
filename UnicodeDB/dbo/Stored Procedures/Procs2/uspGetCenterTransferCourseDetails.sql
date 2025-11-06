CREATE PROCEDURE [dbo].[uspGetCenterTransferCourseDetails]        
(              
 @iStudentDetailId INT     
,@iTransferRequestId INT        
)          
AS          
BEGIN       
      
SELECT I_Transfer_Request_ID    
,I_Course_ID    
,I_Course_Fee_Plan_ID    
,I_Delivery_Pattern_ID    
,I_TimeSlot_ID    
,S_Payment_Mode
,ISNULL(I_Batch_ID,0) AS I_Batch_ID
FROM dbo.T_Student_Transfer_Request_Details    
WHERE I_Transfer_Request_ID = @iTransferRequestId    
    
SELECT SD.I_Enquiry_Regn_ID    
  ,TR.I_Destination_Centre_Id    
FROM dbo.T_Student_Transfer_Request TR    
INNER JOIN dbo.T_Student_Detail SD ON TR.I_Student_Detail_ID = TR.I_Student_Detail_ID    
WHERE TR.I_Transfer_Request_ID = @iTransferRequestId AND SD.I_Student_Detail_ID = @iStudentDetailId    
      
END

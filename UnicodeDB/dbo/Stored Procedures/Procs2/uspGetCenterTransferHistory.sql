CREATE PROCEDURE [dbo].[uspGetCenterTransferHistory]        
        
(       
   @iTransferRequestId int       
  ,@iStudentDetailId int           
)        
AS      
BEGIN      
 SELECT       
   TH.S_Remarks      
  ,TH.I_Status_ID      
  ,TH.S_Crtd_By      
  ,TH.Dt_Crtd_On      
 FROM T_Student_Transfer_Request TR      
 INNER JOIN T_Student_Transfer_History TH      
  ON TR.I_Transfer_Request_ID = TH.I_Transfer_Request_ID      
 WHERE TR.I_Student_Detail_Id = @iStudentDetailId      
  AND TR.I_Transfer_Request_ID = @iTransferRequestId    
 ORDER BY TH.I_Status_ID ASC  
END

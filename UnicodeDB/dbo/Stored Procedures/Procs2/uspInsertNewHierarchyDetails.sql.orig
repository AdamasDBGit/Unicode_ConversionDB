CREATE PROCEDURE [dbo].[uspInsertNewHierarchyDetails]               
(              
  @sLoginID    VARCHAR(500)  
 ,@iStudentDetailId  INT  
 ,@iTransferRequestId  INT 
)              
AS              
BEGIN   
  
     
DECLARE @iUserId INT      
DECLARE @iHierarchyMasterId INT      
DECLARE @iHierarchyDetailId INT      
DECLARE @iUHID INT   
DECLARE @iDestinationCenterID INT  
  
SELECT @iDestinationCenterID = I_Destination_Centre_Id  
FROM T_STUDENT_TRANSFER_REQUEST  
WHERE I_Transfer_Request_ID = @iTransferRequestId AND I_Student_Detail_ID = @iStudentDetailId  
      
SELECT @iHierarchyDetailId = I_HIERARCHY_DETAIL_ID       
FROM T_CENTER_HIERARCHY_DETAILS       
WHERE I_Center_Id = @iDestinationCenterID AND I_STATUS = 1      
      
SELECT  @iUHID = I_User_Hierarchy_Detail_ID,@iUserId = I_User_Id , @iHierarchyMasterId = I_Hierarchy_Master_ID      
FROM  T_USER_HIERARCHY_DETAILS      
WHERE I_User_ID IN      
(      
SELECT I_User_ID FROM T_USER_MASTER WHERE I_REFERENCE_ID = @iStudentDetailId AND I_STATUS = 1      
)      
      
IF @iUserId IS NOT NULL AND @iHierarchyMasterId IS NOT NULL      
BEGIN      
 UPDATE T_USER_HIERARCHY_DETAILS SET I_Status = 0  WHERE I_User_Hierarchy_Detail_ID = @iUHID     
 INSERT INTO T_USER_HIERARCHY_DETAILS VALUES(@iUserId,@iHierarchyMasterId,@iHierarchyDetailId,GETDATE(),NULL,1)      
END     

UPDATE T_Student_Attendance_Details SET I_Centre_Id = @iDestinationCenterID WHERE I_Student_Detail_id = @iStudentDetailId 
  
END

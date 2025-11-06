CREATE PROCEDURE [dbo].[uspMasterCenterTransfer]                         
(                         
  @sLoginId VARCHAR(100)                        
 ,@iSourceCenterID INT = NULL                        
 ,@iDestinationCenterID INT = NULL                        
 ,@iStudentDetailId INT = NULL                        
 ,@sRemarks VARCHAR(500)                        
 ,@iCTStatus INT                        
 ,@iTransferRequestId INT = NULL                  
 ,@iCourseDuration INT = NULL                  
 ,@iDurationSpent INT = NULL                  
 ,@dDCCourseValue NUMERIC(18,2) = NULL           
 ,@iTaskIdCompleted INT = NULL                     
)                        
AS                        
BEGIN      
      
INSERT INTO dbo.T_Student_Transfer_Request                        
 (                        
   I_Source_Centre_Id                        
  ,I_Destination_Centre_Id                        
  ,I_Student_Detail_ID                        
  ,S_Remarks                        
  ,Dt_Request_Date                        
  ,I_Status                        
  ,S_Crtd_By                        
  ,Dt_Crtd_On                   
  ,I_Course_Duration                  
  ,I_Course_Completed                  
  ,N_DCCourse_Amount                     
 )                        
 VALUES                        
 (                        
   @iSourceCenterID                        
  ,@iDestinationCenterID                        
  ,@iStudentDetailId                        
  ,@sRemarks                        
  ,GETDATE()                        
  ,@iCTStatus                        
  ,@sLoginId                        
  ,GETDATE()                  
  ,@iCourseDuration                  
  ,@iDurationSpent                  
  ,@dDCCourseValue                    
 )      
 DECLARE @ID INT       
 SET @ID = SCOPE_IDENTITY()               
 SET  @iTransferRequestId  = @ID                    
 INSERT INTO dbo.T_Student_Transfer_History                        
 (                        
  I_Transfer_Request_ID                        
  ,S_Remarks                        
  ,I_Status_ID                        
  ,S_Crtd_By                        
  ,Dt_Crtd_On                        
 )                        
VALUES(                        
  @ID                        
  ,@sRemarks                        
  ,@iCTStatus                        
  ,@sLoginId                        
  ,GETDATE()                    
   )   
  
DECLARE @iUserId INT  
DECLARE @iHierarchyMasterId INT  
DECLARE @iHierarchyDetailId INT  
DECLARE @iUHID INT  
  
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
     
SELECT 1      
      
END

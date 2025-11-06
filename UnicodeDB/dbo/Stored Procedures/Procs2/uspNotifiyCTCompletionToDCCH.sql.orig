CREATE PROCEDURE [dbo].[uspNotifiyCTCompletionToDCCH]    
(    
  @iTaskMasterId INT
 ,@iStudentDetailId INT    
 ,@iSourceCenterId INT 
 ,@iDestinationCenterId INT
 ,@sUserID VARCHAR(500)   
)    
AS    
BEGIN  

DECLARE @ID INT
DECLARE @info VARCHAR(500)
DECLARE @USERID TABLE (I_User_Id INT)
--------------
 
INSERT INTO @USERID(I_User_Id)                  
SELECT I_User_Id FROM dbo.fnGetCHandHOA(@iDestinationCenterId,8)

------------ message --------------- 
SET @info = 'Center Transfer successfully completed for '

SELECT @info = @info +  ' ['+S_Student_Id+' , '+ISNULL(S_First_Name,'') + ' ' + ISNULL(S_Middle_Name,'') + ' ' + ISNULL(S_Last_Name,'')+'] '
FROM T_Student_Detail WHERE I_Student_Detail_Id = @iStudentDetailId

SELECT @info = @info + '[OC:'+S_Center_Name+'] ' FROM T_Centre_Master WHERE I_Centre_Id =  @iSourceCenterId

SELECT @info = @info + '[DC:'+S_Center_Name+'] ' FROM T_Centre_Master WHERE I_Centre_Id =  @iDestinationCenterId

IF @info IS NULL    
BEGIN    
  SET @info = 'Center Transfer successfully.'   
END    
--------------------------------------- 
INSERT INTO dbo.T_Task_Details                  
 (                  
   I_Task_Master_Id                  
  ,S_Task_Description                  
  ,S_Querystring                  
  ,I_Hierarchy_Master_ID                  
  ,S_Hierarchy_Chain                  
  ,I_Status                  
  ,Dt_Due_date                  
  ,Dt_Created_Date                  
 )                  
VALUES                  
 (                  
   @iTaskMasterId                  
  ,@info               
  ,''                  
  ,1                  
  ,''                  
  ,1                  
  ,GETDATE()                  
  ,GETDATE()                  
 )

SET @ID = SCOPE_IDENTITY() 

INSERT INTO dbo.T_Task_Assignment(I_Task_ID,I_To_User_ID,S_From_User)              
SELECT @ID,I_User_Id,@sUserID FROM @USERID 

END

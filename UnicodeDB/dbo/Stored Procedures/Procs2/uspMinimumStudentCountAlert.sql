CREATE PROCEDURE [dbo].[uspMinimumStudentCountAlert]          
          
AS          
BEGIN          
          
DECLARE @USERID TABLE (I_User_Id INT)               
          
SELECT A.I_Batch_ID,B.S_Batch_Code,I_Centre_Id,0 AS [EnrolmentCount],I_Min_Strength,B.Dt_BatchStartDate INTO #temptable             
  FROM dbo.T_Center_Batch_Details A          
  INNER JOIN dbo.T_Student_Batch_Master B          
  ON A.I_Batch_ID = B.I_Batch_ID           
  WHERE B.I_Status!=3                        
            
UPDATE T                
SET T.[EnrolmentCount] = T.[EnrolmentCount]+A1                
FROM (SELECT COUNT(DISTINCT I_Student_Detail_ID) AS A1,SBD.I_Batch_ID, SCD.I_Centre_Id                   
 FROM dbo.T_Student_Batch_Details SBD                  
 INNER JOIN dbo.T_Student_Center_Detail SCD                  
 ON SBD.I_Student_ID = SCD.I_Student_Detail_ID                  
 WHERE SBD.I_Status = 1                  
 GROUP BY SBD.I_Batch_ID, SCD.I_Centre_Id) A                  
INNER JOIN #temptable T                  
ON A.I_Batch_ID = T.I_Batch_ID                  
AND A.I_Centre_Id = T.I_Centre_Id              
          
DECLARE @CurrentDate DATETIME          
          
SELECT @CurrentDate = GETDATE()         
          
DECLARE @MinimumDay VARCHAR(50)          
          
SELECT @MinimumDay = S_Config_Value          
FROM dbo.T_Center_Configuration            
WHERE I_Status = 1 AND S_Config_Code='MAIL_ALERT_DAY'           
      
DECLARE Cursor_temptable CURSOR FOR                
SELECT * FROM #temptable          
WHERE DATEDIFF(DAY,@CurrentDate,Dt_BatchStartDate) = @MinimumDay          
AND EnrolmentCount < ISNULL(I_Min_Strength,EnrolmentCount)          
          
          
DECLARE @iBatchID INT             
DECLARE @sBatchCode VARCHAR(50)          
DECLARE @iCentreId INT          
DECLARE @EnrolmentCount INT          
DECLARE @iMinStrength INT          
DECLARE @dtBatchStartDate DATETIME          
           
DECLARE @iTaskMasterId INT=143       
DECLARE @info VARCHAR(200)          
DECLARE @ID INT           
DECLARE @iTaskDetailId INT             
DECLARE @sHierarchyChain VARCHAR(1000)                
          
          
 OPEN Cursor_temptable                   
 FETCH NEXT FROM Cursor_temptable INTO @iBatchID,             
 @sBatchCode,          
 @iCentreId,          
 @EnrolmentCount,          
 @iMinStrength,          
 @dtBatchStartDate          
           
           
 WHILE @@FETCH_STATUS =0          
          
 BEGIN       
 SELECT @info = S_Description FROM dbo.T_Task_Master WHERE I_Task_Master_Id = @iTaskMasterId          
 SELECT @info = REPLACE(REPLACE(REPLACE(REPLACE(@info,'[MinStudent]',@iMinStrength),'[BatchCode]',@sBatchCode),'[BatchStartDate]',@dtBatchStartDate),'[TotalEnrolment]',@EnrolmentCount)          
 FROM #temptable          
          
SELECT @sHierarchyChain = COALESCE(S_Hierarchy_Chain + ', ', '') FROM dbo.T_Hierarchy_Mapping_Details A          
INNER JOIN dbo.T_Center_Hierarchy_Details CHD          
ON A.I_Hierarchy_Detail_ID = CHD.I_Hierarchy_Detail_ID          
INNER JOIN  dbo.T_Center_Batch_Details CBD ON chd.I_Center_Id = cbd.I_Centre_Id           
INNER JOIN dbo.T_Student_Batch_Master SBM ON CBD.I_Batch_ID = SBM.I_Batch_ID           
WHERE CBD.I_Batch_ID = @iBatchID          
              
 PRINT @sHierarchyChain          
          
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
  ,(SELECT Min(I_Hierarchy_Master_ID) FROM dbo.T_Hierarchy_Details THD INNER JOIN dbo.T_Task_Hierarchy_Mapping THM ON THD.I_Hierarchy_Detail_ID = THM.I_Hierarchy_Detail_ID          
    WHERE THM.I_Task_Master_Id = @iTaskMasterId)                              
  ,@sHierarchyChain                                
  ,1                                
  ,GETDATE()                                
,GETDATE()                                
 )                  
           
SET @iTaskDetailId  =  SCOPE_IDENTITY()                     
          
 IF(  SELECT b_IsHOBatch FROM dbo.T_Student_Batch_Master A          
 INNER JOIN #temptable T ON          
 A.I_Batch_ID = T.I_Batch_ID           
 WHERE T.I_Batch_ID = @iBatchID)>0          
           
 BEGIN          
           
 -- User for HO Batch          
 INSERT INTO @USERID(I_User_Id)          
 SELECT DISTINCT (UHD.I_User_Id)          
 FROM dbo.T_User_Hierarchy_Details UHD             
 INNER JOIN dbo.T_User_Role_Details URD                  
 ON UHD.I_User_Id = URD.I_User_Id               
 INNER JOIN dbo.T_Role_Master RM          
 ON URD.I_Role_ID = RM.I_Role_ID               
 INNER JOIN dbo.T_User_Master UM                  
 ON UHD.I_User_Id = UM.I_User_Id                  
 WHERE URD.I_Role_Id in (SELECT I_Role_ID FROM dbo.T_Role_Master WHERE I_Hierarchy_Detail_ID IN           
 (SELECT I_Hierarchy_Detail_ID FROM dbo.T_Task_Hierarchy_Mapping WHERE I_Task_Master_Id = @iTaskMasterId))          
 AND UHD.I_Hierarchy_Detail_ID IN (SELECT * FROM dbo.fnString2Rows(@sHierarchyChain,','))          
 AND UHD.I_Status = 1                  
 AND UM.I_Status = 1           
 AND um.S_User_Type != 'ST'          
            
 END           
 ELSE          
 BEGIN          
 INSERT INTO @USERID(I_User_Id)          
 SELECT DISTINCT(UHD.I_User_Id)                  
 FROM dbo.T_Center_Hierarchy_Details CHD                  
 INNER JOIN dbo.T_Hierarchy_Mapping_Details HMD                   
 ON CHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID                  
 INNER JOIN dbo.T_User_Hierarchy_Details UHD                  
 ON HMD.I_Hierarchy_Detail_ID = UHD.I_Hierarchy_Detail_ID                  
 INNER JOIN dbo.T_User_Role_Details URD                  
 ON UHD.I_User_Id = URD.I_User_Id               
 INNER JOIN dbo.T_Role_Master RM          
 ON URD.I_Role_ID = RM.I_Role_ID               
 INNER JOIN dbo.T_User_Master UM                  
 ON UHD.I_User_Id = UM.I_User_Id                  
 WHERE URD.I_Role_Id in (SELECT I_Role_ID FROM dbo.T_Role_Master WHERE I_Hierarchy_Detail_ID IN           
 (SELECT I_Hierarchy_Detail_ID FROM dbo.T_Task_Hierarchy_Mapping WHERE I_Task_Master_Id = @iTaskMasterId))                
 AND CHD.I_Center_Id = @iCentreId                  
 AND CHD.I_Status = 1                  
 AND HMD.I_Status = 1                  
 AND UHD.I_Status = 1                  
 AND UM.I_Status = 1            
 AND UM.S_User_Type = 'CE'          
 AND RM.S_Role_Type = 'CE'   
 UNION     
 SELECT DISTINCT (UHD.I_User_Id)        
 FROM dbo.T_User_Hierarchy_Details UHD           
 INNER JOIN dbo.T_User_Role_Details URD                
 ON UHD.I_User_Id = URD.I_User_Id             
 INNER JOIN dbo.T_Role_Master RM        
 ON URD.I_Role_ID = RM.I_Role_ID             
 INNER JOIN dbo.T_User_Master UM                
 ON UHD.I_User_Id = UM.I_User_Id                
 WHERE URD.I_Role_Id in (SELECT I_Role_ID FROM dbo.T_Role_Master WHERE I_Hierarchy_Detail_ID IN         
 (SELECT I_Hierarchy_Detail_ID FROM dbo.T_Task_Hierarchy_Mapping WHERE I_Task_Master_Id = 143))        
 AND UHD.I_Hierarchy_Detail_ID IN (SELECT * FROM dbo.fnString2Rows(@sHierarchyChain,','))        
 AND UHD.I_Status = 1                
 AND UM.I_Status = 1         
 AND um.S_User_Type != 'EMP'            
                            
 END          
          
    
INSERT INTO dbo.T_Task_Assignment(I_Task_ID,I_To_User_ID,S_From_User)                                
SELECT @iTaskDetailId,I_User_Id,'sa' FROM @USERID          
          
          
          
 FETCH NEXT FROM Cursor_temptable INTO @iBatchID,             
 @sBatchCode,        
 @iCentreId,          
 @EnrolmentCount,          
 @iMinStrength,          
 @dtBatchStartDate          
          
          
 END          
 CLOSE Cursor_temptable                   
 DEALLOCATE Cursor_temptable              
           
DROP TABLE #temptable          
          
END

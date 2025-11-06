CREATE PROCEDURE [dbo].[uspGetCenterTransferStatus]           
(          
 @sStudentCode VARCHAR(500) = NULL          
,@sStudentFName VARCHAR(50)  = NULL          
,@sStudentMName VARCHAR(50)  = NULL          
,@sStudentLName VARCHAR(50)  = NULL    
,@iHierarchyDetailId INT           
)          
AS          
BEGIN         
    
-------------------------      
DECLARE @TempTable TABLE(ROWID INT IDENTITY (1,1) ,I_Transfer_Request_Id INT , I_Task_Details_Id INT, S_Users VARCHAR(500))        
INSERT INTO @TempTable(I_Transfer_Request_Id,I_Task_Details_Id)        
SELECT I_Transfer_Request_Id,MAX(I_Task_Details_Id)        
FROM T_student_transfer_history        
GROUP BY I_Transfer_Request_Id     
-------------------------------------    
DECLARE @sSearchCriteria VARCHAR(400)    
DECLARE @TempCenter TABLE    
(     
 I_Center_ID int    
)    
    
SELECT @sSearchCriteria= S_Hierarchy_Chain     
FROM T_Hierarchy_Mapping_Details     
WHERE I_Hierarchy_detail_id = @iHierarchyDetailId    
    
INSERT INTO @TempCenter     
SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE     
TCHD.I_Hierarchy_Detail_ID IN     
(SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details     
WHERE I_Status = 1    
AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())    
AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())    
AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%'     
)      
--------------------------          
        
DECLARE @min INT        
DECLARE @max INT        
DECLARE @users VARCHAR(100) set @users = ''       
        
SELECT @min = MIN(rowid), @max = MAX(rowid) FROM @TempTable        
        
WHILE ( @min < = @max )         
BEGIN        
        
DECLARE @iTaskId INT        
SELECT @iTaskId = I_Task_Details_Id FROM @TempTable WHERE rowid = @min        
        
SELECT @users = @users + UM.S_Login_Id + ','        
FROM T_User_Master UM        
INNER JOIN T_Task_Assignment TA ON UM.I_User_Id = TA.I_To_User_Id        
WHERE TA.I_Task_Id = @iTaskId        
        
IF(LEN(@users)>1)        
BEGIN        
UPDATE @TempTable SET  S_Users = (LEFT(@users,(LEN(@users)-1))) WHERE I_Task_Details_Id = @iTaskId        
END        
SET @min = @min + 1        
        
SET @users = ''        
        
END        
        
SELECT TR.I_Transfer_Request_Id        
,SD.I_Student_Detail_Id        
,SD.S_Student_ID        
,SD.S_First_Name          
,SD.S_Middle_Name          
,SD.S_Last_Name        
,CM1.S_Center_Name AS S_Source_Center_Name        
,CM2.S_Center_Name AS S_Destination_Center_Name        
,ISNULL(TT.S_Users,'') AS S_UserAssigned      
,TR.I_Status        
FROM T_Student_Transfer_Request TR        
INNER JOIN T_Student_Detail SD ON TR.I_Student_Detail_Id = SD.I_Student_Detail_Id        
INNER JOIN T_Centre_Master CM1 ON CM1.I_Centre_Id = TR.I_Source_Centre_Id        
INNER JOIN T_Centre_Master CM2 ON CM2.I_Centre_Id = TR.I_Destination_Centre_Id        
INNER JOIN @TempTable TT ON TT.I_Transfer_Request_Id = TR.I_Transfer_Request_Id  
INNER JOIN T_Task_Details TD ON TD.I_Task_Details_Id = TT.I_Task_Details_Id        
WHERE ISNULL(SD.I_Status,1) = 1   
 AND TD.I_Status = 1        
 AND SD.S_Student_ID LIKE ISNULL(@sStudentCode,SD.S_Student_ID )+'%'          
 AND SD.S_First_Name LIKE ISNULL(@sStudentFName,SD.S_First_Name )+'%'          
 AND ISNULL(SD.S_Middle_Name,'') LIKE ISNULL(@sStudentMName,'' )+'%'          
 AND SD.S_Last_Name LIKE ISNULL(@sStudentLName,SD.S_Last_Name )+'%'    
 AND TR.I_Source_Centre_Id IN (SELECT I_Center_Id FROM @TempCenter)        
 ORDER BY  SD.S_First_Name        
        
END

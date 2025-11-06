CREATE PROCEDURE [dbo].[uspCreateTaskForEachUser]  
(  
 @iTaskID INT,  
 @sCreatedBy varchar(20),  
 @sTrustDomain VARCHAR(200) = null,  
 @sStudentIDs VARCHAR(200) = null,  
 @sCenterID Varchar(200) = null,  
 @iEmployeeID INT = null,  
 @iRoleID INT = null,  
 @sHierarchyChain Varchar(200),
 @iUserID INT = NULL
)  
   
as  
BEGIN TRY  
   
 CREATE TABLE #TEMPUSERTABLE  
 (  
  I_User_ID INT,  
  S_Login_ID VARCHAR(200)  
 )  
  
 INSERT INTO #TEMPUSERTABLE  
 SELECT UM.I_User_ID, UM.S_Login_ID
	FROM dbo.T_User_Master UM  
	INNER JOIN dbo.T_User_Hierarchy_Details UHD  
	ON UM.I_User_ID = UHD.I_User_ID  
	AND UHD.I_Status = 1  
	WHERE I_Hierarchy_Master_ID = 1  
	AND (@sTrustDomain IS NULL OR I_Hierarchy_Detail_ID IN (SELECT * FROM dbo.fnString2Rows(@sTrustDomain,',')))
	AND (@sStudentIDs IS NULL OR UM.I_Reference_ID IN (SELECT * FROM dbo.fnString2Rows(@sStudentIDs,',')))
	AND (@iEmployeeID IS NULL OR UM.I_Reference_ID = @iEmployeeID)
	AND (@iRoleID IS NULL OR UM.I_User_ID IN (SELECT I_User_ID FROM dbo.T_User_Role_Details WHERE I_Role_ID = @iRoleID))
	AND (@sHierarchyChain IS NULL OR UM.I_User_ID IN
		   (  
			SELECT UM.I_User_ID   
			FROM dbo.T_User_Master UM  
			INNER JOIN dbo.T_User_Hierarchy_Details UHD  
			ON UM.I_User_ID = UHD.I_User_ID  
			AND UHD.I_Status = 1  
			INNER JOIN dbo.T_Hierarchy_Mapping_Details HMD  
			ON UHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID  
			AND HMD.I_Status = 1  
			where HMD.S_Hierarchy_Chain like @sHierarchyChain  
		   ))
		   
 --SELECT I_User_ID,S_Login_ID   
 --FROM dbo.T_User_Master   
 --WHERE S_User_Type NOT LIKE 'TE'  
  
 --IF @sTrustDomain IS NOT NULL  
 --BEGIN  
 -- DELETE FROM #TEMPUSERTABLE  
 -- WHERE I_User_ID NOT IN   
 --  (  
 --   SELECT UM.I_User_ID   
 --   FROM dbo.T_User_Master UM  
 --   INNER JOIN dbo.T_User_Hierarchy_Details UHD  
 --   ON UM.I_User_ID = UHD.I_User_ID  
 --   AND UHD.I_Status = 1  
 --   WHERE I_Hierarchy_Master_ID = 1  
 --   AND I_Hierarchy_Detail_ID IN   
 --   (  
 --    SELECT * FROM dbo.fnString2Rows(@sTrustDomain,',')  
 --   )  
 --  )   
 --END   
  
 --IF @sStudentIDs IS NOT NULL  
 --BEGIN  
 -- DELETE FROM #TEMPUSERTABLE  
 -- WHERE I_User_ID NOT IN   
 --  (  
 --   SELECT UM.I_User_ID   
 --   FROM dbo.T_User_Master UM  
 --   INNER JOIN dbo.T_Student_Detail SD  
 --   ON UM.I_Reference_ID = SD.I_Student_Detail_ID  
 --   WHERE UM.I_Reference_ID IN   
 --   (  
 --    SELECT * FROM dbo.fnString2Rows(@sStudentIDs,',')  
 --   )  
 --  )  
 --END  
  
 --IF @iEmployeeID IS NOT NULL  
 --BEGIN  
 -- DELETE FROM #TEMPUSERTABLE  
 -- WHERE I_User_ID NOT IN   
 --  (  
 --   SELECT UM.I_User_ID   
 --   FROM dbo.T_User_Master UM  
 --   INNER JOIN dbo.T_Employee_Dtls ED  
 --   ON UM.I_Reference_ID = ED.I_Employee_ID  
 --   WHERE UM.I_Reference_ID = @iEmployeeID  
 --  )  
 --END  
  
 --IF @iRoleID IS NOT NULL  
 --BEGIN  
 -- DELETE FROM #TEMPUSERTABLE  
 -- WHERE I_User_ID NOT IN   
 --  (  
 --   SELECT UM.I_User_ID   
 --   FROM dbo.T_User_Master UM  
 --   INNER JOIN dbo.T_User_Role_Details URD  
 --   ON UM.I_User_ID = URD.I_User_ID  
 --   WHERE URD.I_Role_ID = @iRoleID  
 --  )  
 --END  
  
 --IF @sHierarchyChain IS NOT NULL  
 --BEGIN  
 -- DELETE FROM #TEMPUSERTABLE  
 -- WHERE I_User_ID NOT IN   
 --  (  
 --   SELECT UM.I_User_ID   
 --   FROM dbo.T_User_Master UM  
 --   INNER JOIN dbo.T_User_Hierarchy_Details UHD  
 --   ON UM.I_User_ID = UHD.I_User_ID  
 --   AND UHD.I_Status = 1  
 --   INNER JOIN dbo.T_Hierarchy_Mapping_Details HMD  
 --   ON UHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID  
 --   AND HMD.I_Status = 1  
 --   where HMD.S_Hierarchy_Chain like @sHierarchyChain  
 --  )  
 --END
  
 IF @sCenterID IS NOT NULL  
 BEGIN  
   Create table #TempCenterHierarchyIDs  
   (  
    I_Hierarchy_ID INT  
   )  
     
   CREATE TABLE #TempCenterTable  
   (  
    ID_Identity INT IDENTITY(1,1),  
    I_Center_ID INT   
   )  
   CREATE TABLE #TempUsers  
   (  
    I_User_ID INT  
   )  
  
   INSERT INTO #TempCenterTable  
   SELECT * FROM dbo.fnString2Rows(@sCenterID,',')  
  
   DECLARE @iCount1 INT  
   DECLARE @iRowCount INT  
   DECLARE @iCenterIDTemp INT  
   SELECT @iRowCount = count(ID_Identity) FROM #TempCenterTable  
   SET @iCount1 = 1  
  
   WHILE (@iCount1 <= @iRowCount)  
   BEGIN   
     
    SELECT @iCenterIDTemp = I_Center_ID from #TempCenterTable where ID_Identity = @iCount1  
      
    Declare @sHierarchyCenterChain VARCHAR(200)  
  
    SELECT @sHierarchyCenterChain = S_Hierarchy_Chain  
     FROM dbo.T_Hierarchy_Mapping_Details HMD  
     INNER JOIN dbo.T_Center_Hierarchy_Details CHD  
     ON CHD.I_Hierarchy_Detail_ID = HMD.I_Hierarchy_Detail_ID  
     INNER JOIN dbo.T_Hierarchy_Details HD  
     ON HMD.I_Hierarchy_Detail_ID = HD.I_Hierarchy_Detail_ID  
     WHERE HD.I_Hierarchy_Master_ID <> 1  
     AND CHD.I_Center_Id = @iCenterIDTemp      
  
      
  
    INSERT INTO #TempCenterHierarchyIDs  
    SELECT * FROM dbo.fnString2Rows(@sHierarchyCenterChain,',')      
      
    INSERT INTO #TempUsers      
    SELECT UM.I_User_ID   
    FROM dbo.T_User_Master UM  
    INNER JOIN dbo.T_User_Hierarchy_Details UHD  
    ON UM.I_User_ID = UHD.I_User_ID  
    AND UHD.I_Status = 1  
    WHERE UHD.I_Hierarchy_Detail_ID IN  
    (  
     SELECT * FROM #TempCenterHierarchyIDs  
    )  
  
   
    TRUNCATE TABLE #TempCenterHierarchyIDs  
      
    SET @iCount1 = @iCount1 + 1  
   END    
  
  DROP TABLE #TempCenterHierarchyIDs  
  TRUNCATE TABLE #TempCenterTable  
  DROP TABLE #TempCenterTable  
  
  DELETE FROM #TEMPUSERTABLE  
  WHERE I_User_ID NOT IN (SELECT * from #TempUsers)  
     
  SELECT * from #TempUsers  
  SELECT * from #TEMPUSERTABLE  
  Drop table #TempUsers  
    
 END  
  
   
  
 Declare @iUserCount INT  
 Declare @iTempUsers INT  
 SELECT @iUserCount = count(*) from T_Task_Assignment where I_Task_ID = @iTaskID   
  
 IF @iUserCount > 0  
 BEGIN  
    
  DELETE from T_Task_Assignment where I_Task_ID = @iTaskID AND I_To_User_ID = 1  
  
 END  
  
  
 SELECT @iTempUsers = count(*) from #TEMPUSERTABLE  
 SELECT @iUserCount = count(*) from T_Task_Assignment where I_Task_ID = @iTaskID   
  
 IF EXISTS  
 (SELECT 'TRUE' FROM dbo.T_Task_Hierarchy_Mapping WHERE I_Task_Master_Id IN  
 (SELECT I_Task_Master_Id FROM dbo.T_Task_Details WHERE I_Task_Details_Id = @iTaskID))  
 BEGIN  
  IF (@iTempUsers = 0 AND @iUserCount = 0)  
  BEGIN  
   INSERT INTO #TEMPUSERTABLE  
   SELECT I_User_ID,S_Login_ID   
    FROM dbo.T_User_Master   
    WHERE I_User_ID = 1  
  END  
 END  
  
 INSERT INTO [dbo].[T_Task_Assignment]  
 (  
  I_Task_ID,  
  I_To_User_ID,  
  S_From_User  
 )  
 SELECT @iTaskID,I_User_ID,@sCreatedBy  
 from #TEMPUSERTABLE  
  
 SELECT @iUserCount = count(*) from T_Task_Assignment where I_Task_ID = @iTaskID AND I_To_User_ID <> 1  
  
 IF @iUserCount > 0  
 BEGIN  
    
  DELETE from T_Task_Assignment where I_Task_ID = @iTaskID AND I_To_User_ID = 1  
  
 END  
  
 TRUNCATE TABLE #TEMPUSERTABLE  
 DROP TABLE #TEMPUSERTABLE  
  
END TRY  
BEGIN CATCH  
 --Error occurred:    
  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH

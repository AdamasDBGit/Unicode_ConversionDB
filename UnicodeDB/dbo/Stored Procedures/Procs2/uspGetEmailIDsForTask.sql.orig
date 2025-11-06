CREATE PROCEDURE [dbo].[uspGetEmailIDsForTask] 
(	
	@sLoginID varchar(200),
	@iHierarchyMasterID int,	
	@iSrcHierarchyDetailID int,
	@iSelectedHierarchyDetailID int = null
)

AS
BEGIN
	
	SET NOCOUNT ON;  
   
 DECLARE @iUserHierarchyDetailID int  
 DECLARE @iUserID int  
 DECLARE @iRowCount int  
 DECLARE @iGetIndex int  
 DECLARE @iLength int  
 DECLARE @iTempHierarchyDetailID int  
 DECLARE @sUserHierarchyChain varchar(100)  
 DECLARE @sTempHierarchyChain varchar(100)  
   
 DECLARE @tblUserList TABLE  
 (   
  [ID] int identity(1,1),  
  iHierarchyDetailID int,  
  iUserID int,  
  sEmailID varchar(200),  
  sHierarchyChain varchar(100),  
  iStatus int,
  sLoginId varchar(200),
  sUserType varchar(20)   
 )  
  
 -- Select the UserID for the User who has initiated the Task  
 SELECT @iUserID = I_User_ID  
 FROM dbo.T_User_Master  
 WHERE S_Login_ID = @sLoginID  
 AND I_Status = 1  
  
 -- Select the HierarchyDetailID for the User who has initiated the Task  
 SELECT @iUserHierarchyDetailID = I_Hierarchy_Detail_ID  
 FROM dbo.T_User_Hierarchy_Details   
 WHERE I_User_ID = @iUserID  
 AND I_Hierarchy_Master_ID = @iHierarchyMasterID  
 AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())  
 AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())  
 AND I_Status = 1  
   
 -- User Hierarchy Chain  
 SELECT @sUserHierarchyChain = S_Hierarchy_Chain  
 FROM dbo.T_Hierarchy_Mapping_Details  
 WHERE I_Hierarchy_Detail_ID = @iUserHierarchyDetailID  
 AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())  
 AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())  
 AND I_Status = 1  
   
 IF @iSelectedHierarchyDetailID IS NOT NULL AND @iSelectedHierarchyDetailID <> 0  
 BEGIN  
  SELECT @sTempHierarchyChain = S_Hierarchy_Chain  
  FROM dbo.T_Hierarchy_Mapping_Details  
  WHERE I_Hierarchy_Detail_ID = @iSelectedHierarchyDetailID  
  AND I_Status = 1  
  AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())  
  AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())  
  
  SET @sUserHierarchyChain = @sTempHierarchyChain  
 END  
  
 -- Insert all the Users having same Role Hierarchy as required in the same Hierarchy  
 INSERT INTO @tblUserList  
 (  
  iHierarchyDetailID,  
  iUserID,  
  sEmailID,  
  sHierarchyChain,  
  iStatus,
  sLoginId,
  sUserType  
 )  
 SELECT DISTINCT A.I_Hierarchy_Detail_ID,   
   A.I_User_ID,  
   B.S_Email_ID,  
   C.S_Hierarchy_Chain,  
   0,
   B.S_Login_ID,
   B.S_User_Type 
 FROM dbo.T_User_Hierarchy_Details A  
 INNER JOIN dbo.T_User_Master B  
 ON A.I_User_ID = B.I_User_ID  
 INNER JOIN dbo.T_Hierarchy_Mapping_Details C  
 ON A.I_Hierarchy_Detail_ID = C.I_Hierarchy_Detail_ID  
 WHERE A.I_Hierarchy_Master_ID = @iHierarchyMasterID  
 AND A.I_Status = 1  
 AND B.I_Status = 1  
 AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())  
 AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())  
 AND A.I_User_ID IN (   
     SELECT I_User_ID  
     FROM dbo.T_User_Hierarchy_Details  
     WHERE I_Hierarchy_Detail_ID = @iSrcHierarchyDetailID  
     AND I_Status = 1  
     AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())  
     AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE())   
      )  
 AND C.I_Status = 1  
 AND GETDATE() >= ISNULL(C.Dt_Valid_From, GETDATE())  
 AND GETDATE() <= ISNULL(C.Dt_Valid_To, GETDATE())  
   
 SELECT @iRowCount = COUNT([ID])   
 FROM @tblUserList  
  
 -- If there is no user for the given condition  
 IF @iRowCount = 0  
 BEGIN  
  RETURN  
 END  
 -- If there is only one user for the given condition  
 ELSE IF @iRowCount = 1  
 BEGIN  
  SELECT sEmailID   
  FROM @tblUserList  
 END  
 -- If there are more than one user for the given condition  
 ELSE  
 BEGIN  
  SET @sUserHierarchyChain = @sUserHierarchyChain + ','  
    
  -- Set the status of all the Users as 1 who are having TD below the User originating the Task  
  UPDATE @tblUserList  
  SET iStatus = 1  
  WHERE iUserID IN  
  ( SELECT A.I_User_ID  
   FROM dbo.T_User_Hierarchy_Details A  
   INNER JOIN dbo.T_Hierarchy_Mapping_Details B  
   ON A.I_Hierarchy_Detail_ID = B.I_Hierarchy_Detail_ID  
   AND A.I_Status = 1  
   AND B.I_Status = 1  
   AND GETDATE() >= ISNULL(A.Dt_Valid_From, GETDATE())  
   AND GETDATE() <= ISNULL(A.Dt_Valid_To, GETDATE())  
   AND GETDATE() >= ISNULL(B.Dt_Valid_From, GETDATE())  
   AND GETDATE() <= ISNULL(B.Dt_Valid_To, GETDATE())  
   AND B.S_Hierarchy_Chain LIKE @sUserHierarchyChain + '%' )  
  
  -- If all the Users selected at first has got TD below the User originating the Task    
  IF @iRowCount = ( SELECT COUNT([ID]) FROM @tblUserList WHERE iStatus = 1)  
  BEGIN  
   SELECT DISTINCT sEmailID   
   FROM @tblUserList  
     
   RETURN  
  END  
    
  SET @iGetIndex = CHARINDEX(',',LTRIM(RTRIM(@sUserHierarchyChain)),1)  
    
  IF @iGetIndex > 1   
  BEGIN  
   WHILE LEN(@sUserHierarchyChain) > 0  
   BEGIN  
    SET @iGetIndex = CHARINDEX(',',@sUserHierarchyChain,1)  
    SET @iLength = LEN(@sUserHierarchyChain)  
    SET @iTempHierarchyDetailID = CAST(LTRIM(RTRIM(LEFT(@sUserHierarchyChain,@iGetIndex-1))) AS int)  
      
    UPDATE @tblUserList  
    SET iStatus = 1  
    WHERE iUserID IN  
    ( SELECT A.I_User_ID  
     FROM dbo.T_User_Hierarchy_Details A  
     WHERE I_Hierarchy_Detail_ID = @iTempHierarchyDetailID  
     AND I_Status = 1  
     AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())  
     AND GETDATE() <= ISNULL(Dt_Valid_To, GETDATE()) )  
      
    SELECT @sUserHierarchyChain = SUBSTRING(@sUserHierarchyChain,@iGetIndex + 1, @iLength - @iGetIndex)  
    SELECT @sUserHierarchyChain = LTRIM(RTRIM(@sUserHierarchyChain))  
   END  
  END  
  
  UPDATE @tblUserList
  SET sEmailID = sLoginId + '@company.ac.in'
  WHERE sUserType = 'AE'

  -- If there are users higher up the linear Hierarchy than User originating the Task   
  IF EXISTS ( SELECT [ID] FROM @tblUserList WHERE iStatus = 1)  
  BEGIN  
   SELECT DISTINCT sEmailID   
   FROM @tblUserList  
   WHERE iStatus = 1
  END  
  -- Return all the Users having same TD  
  ELSE  
  BEGIN  
   SELECT DISTINCT sEmailID   
   FROM @tblUserList  
  END  
 END 
END

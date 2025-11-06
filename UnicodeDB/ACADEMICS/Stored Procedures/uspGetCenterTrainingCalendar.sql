CREATE PROCEDURE [ACADEMICS].[uspGetCenterTrainingCalendar]   
(  
 @iCenterID int = null,  
 @iEmployeeID int = null,  
 @iUserID int = null,  
 @dtFromDate datetime = null,  
 @dtToDate datetime = null,  
 @CurrentDate datetime = null,  
 @iFlag int,
 @iHierarchyDetailID int  = null
)  
AS  
BEGIN TRY   

DECLARE @iBrandID INT

-- Retrieve brand id from hierarchy detail id
SELECT @iBrandID = I_Brand_Id FROM T_Hierarchy_Brand_Details 
WHERE I_Hierarchy_Master_Id = @iHierarchyDetailID and I_Status = 1

 -- For selecting Training within a particular period  
 IF @iFlag = 1  
 BEGIN  
  -- TABLE 1  
  SELECT TC.I_Training_ID,  
     TC.S_Training_Name,  
     TC.Dt_Training_Date,  
     TC.Dt_Training_End_Date,  
     TC.S_Description,  
     TC.S_Venue,  
     TC.I_Status,  
     TC.I_User_ID,  
     TC.I_Document_ID,  
     TC.S_Crtd_By,  
     TC.Dt_Crtd_On,  
     UD.S_Document_Name,  
     UD.S_Document_Type,  
     UD.S_Document_Path,  
     UD.S_Document_URL  
  FROM ACADEMICS.T_Training_Calendar TC WITH(NOLOCK)  
  LEFT OUTER JOIN dbo.T_Upload_Document UD  
  ON TC.I_Document_ID = UD.I_Document_ID  
  AND UD.I_Status = 1 
  --WHERE TC.I_Status <> 2 
  INNER JOIN ACADEMICS.T_Training_Skill TS on TC.I_Training_Id = TS.I_Training_Id
  INNER JOIN T_EOS_Skill_Master TESM on TS.I_Skill_Id = TESM.I_Skill_Id   
  WHERE TESM.I_Brand_ID = ISNULL (@iBrandID,TESM.I_Brand_ID) 
  AND ISNULL(@dtFromDate, TC.Dt_Training_Date) <= TC.Dt_Training_Date  
  AND ISNULL(@dtToDate, TC.Dt_Training_Date) >= TC.Dt_Training_Date  
  ORDER BY TC.DT_Training_Date DESC  
    
  -- TABLE 2  
  SELECT T.I_Training_ID,  
     S.I_Skill_ID,  
     S.S_Skill_Desc,  
     S.S_Skill_No,  
     S.S_Skill_Type,  
     S.I_Status  
  FROM ACADEMICS.T_Training_Skill T WITH(NOLOCK)  
  INNER JOIN dbo.T_EOS_Skill_Master S  
  ON T.I_Skill_ID = S.I_Skill_ID  
  AND S.I_Status = 1  
  INNER JOIN ACADEMICS.T_Training_Calendar TC WITH(NOLOCK)  
  ON T.I_Training_ID = TC.I_Training_ID  
  WHERE TC.I_Status <> 2  
  AND ISNULL(@dtFromDate, TC.Dt_Training_Date) <= TC.Dt_Training_Date  
  AND ISNULL(@dtToDate, TC.Dt_Training_Date) >= TC.Dt_Training_Date  
   
 END  
   
 -- For selecting all present and future Training for a particular center  
 ELSE IF @iFlag = 2  
 BEGIN  
    
  -- TABLE 1  
  SELECT A.I_Training_ID,  
      B.I_Center_Id,  
      C.S_Center_Code,  
      C.S_Center_Name,  
      A.S_Training_Name,  
      A.Dt_Training_Date,  
      A.Dt_Training_End_Date,  
      A.S_Description,  
      A.S_Venue,  
      A.I_Status,  
      A.I_User_ID,  
      A.I_Document_ID,  
      A.S_Crtd_By,  
      A.Dt_Crtd_On,  
      UD.S_Document_Name,  
         UD.S_Document_Type,  
         UD.S_Document_Path,  
         UD.S_Document_URL  
  FROM ACADEMICS.T_Training_Calendar A WITH(NOLOCK)  
  INNER JOIN ACADEMICS.T_Training_Center_Mapping B  
  ON A.I_Training_ID = B.I_Training_ID  
  AND A.Dt_Training_Date >= @CurrentDate  
  AND A.I_Status <> 2  
  AND B.I_Status = 1  
  INNER JOIN dbo.T_Centre_Master C  
  ON B.I_Center_Id = C.I_Centre_Id  
  AND B.I_Center_Id = @iCenterID  
  AND C.I_Status = 1  
  AND @CurrentDate >= ISNULL(C.Dt_Valid_From,@CurrentDate)  
  AND @CurrentDate <= ISNULL(C.Dt_Valid_To,@CurrentDate)  
  LEFT OUTER JOIN dbo.T_Upload_Document UD  
  ON A.I_Document_ID = UD.I_Document_ID  
  AND UD.I_Status = 1  
  ORDER BY A.DT_Training_Date DESC  
  
  -- TABLE 2   
  SELECT T.I_Training_ID,  
     S.I_Skill_ID,  
     S.S_Skill_Desc,  
     S.S_Skill_No,  
     S.S_Skill_Type,  
     S.I_Status  
  FROM ACADEMICS.T_Training_Skill T WITH(NOLOCK)  
  INNER JOIN dbo.T_EOS_Skill_Master S  
  ON T.I_Skill_ID = S.I_Skill_ID  
  AND S.I_Status = 1  
  INNER JOIN ACADEMICS.T_Training_Calendar TC WITH(NOLOCK)  
  ON T.I_Training_ID = TC.I_Training_ID  
  INNER JOIN ACADEMICS.T_Training_Center_Mapping B  
  ON TC.I_Training_ID = B.I_Training_ID  
  AND CONVERT(VARCHAR(12),TC.Dt_Training_Date, 101) >= CONVERT(VARCHAR(12), @CurrentDate, 101)  
  AND TC.I_Status <> 2  
  AND B.I_Status = 1  
  INNER JOIN dbo.T_Centre_Master C  
  ON B.I_Center_Id = C.I_Centre_Id  
  AND B.I_Center_Id = @iCenterID  
  AND C.I_Status = 1  
  AND @CurrentDate >= ISNULL(C.Dt_Valid_From,@CurrentDate)  
  AND @CurrentDate <= ISNULL(C.Dt_Valid_To,@CurrentDate)  
    
 END  
   
 -- For selecting the training assigned to the login user  
 ELSE IF @iFlag = 3  
 BEGIN  
    
  -- TABLE 1  
  SELECT TC.I_Training_ID,  
     TC.S_Training_Name,  
     TC.Dt_Training_Date,  
     TC.Dt_Training_End_Date,  
     TC.S_Description,  
     TC.S_Venue,  
     TC.I_Status,  
     TC.I_User_ID,  
     TC.I_Document_ID,  
     TC.I_User_ID,  
     TC.S_Crtd_By,  
     TC.Dt_Crtd_On,  
     UD.S_Document_Name,  
     UD.S_Document_Type,  
     UD.S_Document_Path,  
     UD.S_Document_URL  
  FROM ACADEMICS.T_Training_Calendar TC WITH(NOLOCK)  
  LEFT OUTER JOIN dbo.T_Upload_Document UD  
  ON TC.I_Document_ID = UD.I_Document_ID  
  AND UD.I_Status = 1  
  WHERE TC.I_User_ID = @iUserID  
  AND TC.Dt_Training_Date <= @CurrentDate  
  AND TC.I_Status <> 2  
  ORDER BY TC.DT_Training_Date DESC  
  
  -- TABLE 2  
  SELECT T.I_Training_ID,  
     S.I_Skill_ID,  
     S.S_Skill_Desc,  
     S.S_Skill_No,  
     S.S_Skill_Type,  
     S.I_Status  
  FROM ACADEMICS.T_Training_Skill T WITH(NOLOCK)  
  INNER JOIN dbo.T_EOS_Skill_Master S  
  ON T.I_Skill_ID = S.I_Skill_ID  
  AND S.I_Status = 1  
  INNER JOIN ACADEMICS.T_Training_Calendar TC WITH(NOLOCK)  
  ON T.I_Training_ID = TC.I_Training_ID  
  WHERE TC.I_User_ID = @iUserID  
  AND TC.Dt_Training_Date <= @CurrentDate  
  AND TC.I_Status <> 2  
  
 END  
  
 -- For selecting the training for a given faculty  
 ELSE IF @iFlag = 4  
 BEGIN  
   
  --TABLE 1  
  SELECT A.I_Training_ID,  
      C.I_Center_Id,  
      A.S_Training_Name,  
      A.Dt_Training_Date,  
      A.Dt_Training_End_Date,  
      A.S_Description,  
      A.S_Venue,  
      A.I_Status,  
      A.I_User_ID,  
      A.I_Document_ID,  
      A.S_Crtd_By,  
      A.Dt_Crtd_On,  
      UD.S_Document_Name,  
         UD.S_Document_Type,  
         UD.S_Document_Path,  
         UD.S_Document_URL  
  FROM ACADEMICS.T_Training_Calendar A WITH(NOLOCK)  
  INNER JOIN ACADEMICS.T_Faculty_Nomination B  
  ON A.I_Training_ID = B.I_Training_ID  
  AND A.I_Status <> 2  
  AND A.Dt_Training_Date <= @CurrentDate  
  INNER JOIN ACADEMICS.T_Training_Center_Mapping C  
  ON A.I_Training_ID = C.I_Training_ID  
  LEFT OUTER JOIN dbo.T_Upload_Document UD  
  ON A.I_Document_ID = UD.I_Document_ID  
  AND UD.I_Status = 1  
  WHERE C.I_Center_Id = @iCenterID  
  AND B.I_Employee_ID = @iEmployeeID  
  AND B.C_Attended = 'Y'  
  AND ISNULL(B.C_Feedback_Provided, 'N') <> 'Y'  
  AND C.I_Status = 1  
  ORDER BY A.DT_Training_Date DESC  
  
  -- TABLE 2  
  SELECT T.I_Training_ID,  
     S.I_Skill_ID,  
     S.S_Skill_Desc,  
     S.S_Skill_No,  
     S.S_Skill_Type,  
     S.I_Status  
  FROM ACADEMICS.T_Training_Skill T WITH(NOLOCK)  
  INNER JOIN dbo.T_EOS_Skill_Master S  
  ON T.I_Skill_ID = S.I_Skill_ID  
  AND S.I_Status = 1  
  INNER JOIN ACADEMICS.T_Training_Calendar TC WITH(NOLOCK)  
  ON T.I_Training_ID = TC.I_Training_ID  
  AND TC.Dt_Training_Date <= @CurrentDate  
  AND TC.I_Status <> 2  
  INNER JOIN ACADEMICS.T_Faculty_Nomination B  
  ON TC.I_Training_ID = B.I_Training_ID  
  INNER JOIN ACADEMICS.T_Training_Center_Mapping C  
  ON TC.I_Training_ID = C.I_Training_ID  
  WHERE C.I_Center_Id = @iCenterID  
  AND B.I_Employee_ID = @iEmployeeID  
  AND B.C_Attended = 'Y'  
  AND ISNULL(B.C_Feedback_Provided, 'N') <> 'Y'  
  AND C.I_Status = 1  
  
 END  
   
 -- For selecting all present and future Trainings  
 ELSE IF @iFlag = 5  
 BEGIN  
    
  -- TABLE 1  
  SELECT A.I_Training_ID,  
      B.I_Center_Id,  
      C.S_Center_Code,  
      C.S_Center_Name,  
      A.S_Training_Name,  
      A.Dt_Training_Date,  
      A.Dt_Training_End_Date,  
      A.S_Description,  
      A.S_Venue,  
      A.I_Status,  
      A.I_User_ID,  
      A.I_Document_ID,  
      A.S_Crtd_By,  
      A.Dt_Crtd_On,  
      UD.S_Document_Name,  
         UD.S_Document_Type,  
         UD.S_Document_Path,  
         UD.S_Document_URL  
  FROM ACADEMICS.T_Training_Calendar A WITH(NOLOCK)  
  INNER JOIN ACADEMICS.T_Training_Center_Mapping B  
  ON A.I_Training_ID = B.I_Training_ID  
  AND A.Dt_Training_Date >= @CurrentDate  
  AND A.I_Status <> 2  
  AND B.I_Status = 1  
  INNER JOIN dbo.T_Centre_Master C  
  ON B.I_Center_Id = C.I_Centre_Id  
  AND C.I_Status = 1  
  AND @CurrentDate >= ISNULL(C.Dt_Valid_From,@CurrentDate)  
  AND @CurrentDate <= ISNULL(C.Dt_Valid_To,@CurrentDate)  
  LEFT OUTER JOIN dbo.T_Upload_Document UD  
  ON A.I_Document_ID = UD.I_Document_ID  
  AND UD.I_Status = 1  
  ORDER BY A.DT_Training_Date DESC  
  
  -- TABLE 2   
  SELECT T.I_Training_ID,  
     S.I_Skill_ID,  
     S.S_Skill_Desc,  
     S.S_Skill_No,  
     S.S_Skill_Type,  
     S.I_Status  
  FROM ACADEMICS.T_Training_Skill T WITH(NOLOCK)  
  INNER JOIN dbo.T_EOS_Skill_Master S  
  ON T.I_Skill_ID = S.I_Skill_ID  
  AND S.I_Status = 1  
  INNER JOIN ACADEMICS.T_Training_Calendar TC WITH(NOLOCK)  
  ON T.I_Training_ID = TC.I_Training_ID  
  INNER JOIN ACADEMICS.T_Training_Center_Mapping B  
  ON TC.I_Training_ID = B.I_Training_ID  
  AND TC.Dt_Training_Date >= @CurrentDate  
  AND TC.I_Status <> 2  
  AND B.I_Status = 1  
  INNER JOIN dbo.T_Centre_Master C  
  ON B.I_Center_Id = C.I_Centre_Id  
  AND C.I_Status = 1  
  AND @CurrentDate >= ISNULL(C.Dt_Valid_From,@CurrentDate)  
  AND @CurrentDate <= ISNULL(C.Dt_Valid_To,@CurrentDate)  
    
 END  
   
 -- For selecting Training within a particular period for a Particular Center  
 ELSE IF @iFlag = 6  
 BEGIN  
  -- TABLE 1  
  SELECT TC.I_Training_ID,  
     TC.S_Training_Name,  
     TC.Dt_Training_Date,  
     TC.Dt_Training_End_Date,  
     TC.S_Description,  
     TC.S_Venue,  
     TC.I_Status,  
     TC.I_User_ID,  
     TC.I_Document_ID,  
     TC.S_Crtd_By,  
     TC.Dt_Crtd_On,  
     UD.S_Document_Name,  
     UD.S_Document_Type,  
     UD.S_Document_Path,  
     UD.S_Document_URL  
  FROM ACADEMICS.T_Training_Calendar TC WITH(NOLOCK)  
  INNER JOIN ACADEMICS.T_Training_Center_Mapping B  
  ON TC.I_Training_ID = B.I_Training_ID  
  AND B.I_Status = 1  
  INNER JOIN dbo.T_Centre_Master C  
  ON B.I_Center_Id = C.I_Centre_Id  
  AND B.I_Center_Id = @iCenterID  
  AND C.I_Status = 1  
  AND @CurrentDate >= ISNULL(C.Dt_Valid_From,@CurrentDate)  
  AND @CurrentDate <= ISNULL(C.Dt_Valid_To,@CurrentDate)  
  LEFT OUTER JOIN dbo.T_Upload_Document UD  
  ON TC.I_Document_ID = UD.I_Document_ID  
  AND UD.I_Status = 1   
  --WHERE TC.I_Status <> 2  
  WHERE ISNULL(@dtFromDate, TC.Dt_Training_Date) <= TC.Dt_Training_Date  
  AND ISNULL(@dtToDate, TC.Dt_Training_Date) >= TC.Dt_Training_Date  
  ORDER BY TC.DT_Training_Date DESC  
    
  -- TABLE 2  
  SELECT T.I_Training_ID,  
     S.I_Skill_ID,  
     S.S_Skill_Desc,  
     S.S_Skill_No,  
     S.S_Skill_Type,  
     S.I_Status  
  FROM ACADEMICS.T_Training_Skill T WITH(NOLOCK)  
  INNER JOIN dbo.T_EOS_Skill_Master S  
  ON T.I_Skill_ID = S.I_Skill_ID  
  AND S.I_Status = 1  
  INNER JOIN ACADEMICS.T_Training_Calendar TC WITH(NOLOCK)  
  ON T.I_Training_ID = TC.I_Training_ID  
  WHERE TC.I_Status <> 2  
  AND ISNULL(@dtFromDate, TC.Dt_Training_Date) <= TC.Dt_Training_Date  
  AND ISNULL(@dtToDate, TC.Dt_Training_Date) >= TC.Dt_Training_Date  
   
 END  
  
END TRY  
BEGIN CATCH  
   
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int  
  
 SELECT @ErrMsg = ERROR_MESSAGE(),  
   @ErrSeverity = ERROR_SEVERITY()  
  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)  
END CATCH

CREATE PROCEDURE [CUSTOMERCARE].[uspGetComplaintList]  
(  
@iComplaintCategoryID INT = null,  
@iSelectedHierarchyId INT = null,  
@dtComplaintToDate DATETIME = null,  
@dtComplaintFromDate DATETIME = null,  
@sStudentCode VARCHAR(500) = null,  
@sFirstName VARCHAR(50)= null,  
@sMiddleName VARCHAR(50)= null,  
@sLastName VARCHAR(50)= null,  
@sComplaintCode  VARCHAR(20) = null,  
@iStatus INT = null,  
@iUserID INT = null,  
@sLoginID VARCHAR(200) = null,  
@iBrandID INT = null  
)  
AS  
BEGIN  
 DECLARE @iStudentDetailID INT  
 DECLARE @sStudentFName VARCHAR(50)  
 DECLARE @sStudentMName VARCHAR(50)  
 DECLARE @sStudentLName VARCHAR(50)  
  
 --Check First name Middle and last name is null or not and build the search like query  
 IF(@sFirstName is null)  
  SET @sStudentFName= ''  
 IF(@sMiddleName is null)   
  SET @sStudentMName = ''  
 IF(@sLastName is null)  
  SET @sStudentLName = ''  
  
 SET @sStudentFName = @sFirstName + '%'  
 SET @sStudentMName = @sMiddleName + '%'  
 SET @sStudentLName = @sLastName + '%'  
  
 DECLARE @sSearchCriteria varchar(20)  
   
 CREATE TABLE #TempCenter   
 (   
  I_Center_ID int  
 )  
  
 IF @iSelectedHierarchyId IS NOT NULL   
 BEGIN  
  
  SELECT @sSearchCriteria= S_Hierarchy_Chain from T_Hierarchy_Mapping_Details where I_Hierarchy_detail_id = @iSelectedHierarchyId    
    
  IF @iBrandId = 0   
   BEGIN  
    INSERT INTO #TempCenter   
    SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD WHERE   
    TCHD.I_Hierarchy_Detail_ID IN   
    (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details   
    WHERE I_Status = 1  
    AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())  
    AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())  
    AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%')   
   END  
  ELSE  
   BEGIN  
    INSERT INTO #TempCenter   
    SELECT TCHD.I_Center_Id FROM T_CENTER_HIERARCHY_DETAILS TCHD,T_BRAND_CENTER_DETAILS TBCD WHERE  
    TCHD.I_Hierarchy_Detail_ID IN   
      (SELECT I_HIERARCHY_DETAIL_ID FROM T_Hierarchy_Mapping_Details   
    WHERE I_Status = 1  
    AND GETDATE() >= ISNULL(Dt_Valid_From,GETDATE())  
    AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())  
    AND S_Hierarchy_Chain LIKE @sSearchCriteria + '%') AND  
    TBCD.I_Brand_ID=@iBrandId AND  
    TBCD.I_Centre_Id = TCHD.I_Center_Id       
   END  
 END  
 ELSE  
 BEGIN  
  INSERT INTO #TempCenter  
  SELECT I_Centre_ID FROM T_Centre_Master WHERE I_Status = 1  
 END  
  
  
  
 -- Select student detail id from student name and student code  
  
 SET @iStudentDetailID = (SELECT I_Student_Detail_ID FROM T_Student_Detail  
        WHERE  S_Student_ID = @sStudentCode)  
  
   SELECT   
   CRD.I_Complaint_Req_ID AS I_Complaint_Req_ID,  
   ISNULL(CRD.I_Course_ID,0) AS I_Course_ID,     
   ISNULL(CRD.S_Remarks,'') AS  S_Remarks,  
   ISNULL(CRD.I_Current_Escalation_level,0) AS I_Current_Escalation_level,   
   ISNULL(CRD.S_Email_ID,' ') AS  S_Email_ID,  
   ISNULL(CRD.S_Contact_Number,' ') AS  S_Contact_Number,  
   ISNULL(CRD.I_Complaint_Category_ID, 0) as I_Complaint_Category_ID,  
   ISNULL(CRD.I_Complaint_Mode_ID,0) as I_Complaint_Mode_ID,  
   ISNULL(CMM.S_Complaint_Mode_Value,' ') AS S_Complaint_Mode_Value ,  
   ISNULL(CRD.I_User_Hierarchy_detail_ID,0) AS I_User_Hierarchy_detail_ID,  
   ISNULL(CRD.S_Complaint_Code,' ') AS S_Complaint_Code,  
   ISNULL(CRD.I_Status_ID, 0) as I_Status_ID,  
   ISNULL(CRD.I_User_ID,0) AS  I_User_ID,    
   ISNULL(CRD.S_Complaint_Details,' ') AS  S_Complaint_Details,  
   CRD.Dt_Complaint_Date AS  Dt_Complaint_Date,  
   ISNULL(SD.S_First_Name,'') AS S_First_Name,  
   ISNULL(SD.S_Middle_Name,'') AS S_Middle_Name,  
   ISNULL(SD.S_Last_Name,'') AS S_Last_Name,  
   ISNULL(SD.S_Student_ID,' ') AS S_Student_ID,  
   ISNULL(CCM.S_Complaint_Desc,'') AS S_Complaint_Desc,  
   ISNULL(CRD.I_Center_ID, 0) AS I_Center_ID,  
   ISNULL(CM.S_Center_Name,'') AS S_Center_Name,  
   ISNULL(CM.S_Center_Code,'') AS S_Center_Code,  
   ISNULL(UD.S_Document_Name,' ') AS S_Document_Name,  
   ISNULL(UD.S_Document_Path,' ') AS S_Document_Path,  
   ISNULL(UD.S_Document_Type,' ') AS S_Document_Type,  
   ISNULL(UD.S_Document_URL,' ') AS S_Document_URL,  
   ISNULL(UD.I_Document_ID,0) AS I_Document_ID,  
   ISNULL(COM.S_Course_Name,' ') AS S_Course_Name,  
   ISNULL(RCM.S_Root_Cause_Desc,' ') AS S_Root_Cause_Desc,  
   ISNULL(CRD.I_Root_Cause_ID,0) AS I_Root_Cause_ID,  
   CRD.Dt_Upd_On AS Dt_Upd_On,  
   ISNULL(CRD.S_Upd_By,' ') AS S_Upd_By,  
   ISNULL(CAST(([REPORT].fnGetCycleTimeForCustomerCare(2,CRD.I_Status_ID,CRD.I_Complaint_Req_ID))AS INT),0) AS CycleTime      
   FROM         
   CUSTOMERCARE.T_Complaint_Request_Detail CRD   
   INNER JOIN T_Student_Detail SD WITH (NOLOCK)  
   ON CRD.I_Student_Detail_ID = SD.I_Student_Detail_ID  
   INNER JOIN CUSTOMERCARE.T_Complaint_Category_Master CCM WITH (NOLOCK)  
   ON CRD.I_Complaint_Category_ID = CCM.I_Complaint_Category_ID   
   INNER JOIN T_Centre_Master CM WITH (NOLOCK)  
   ON CRD.I_Center_ID = CM.I_Centre_ID   
   INNER JOIN dbo.T_Brand_Center_Details BCD  
   ON BCD.I_Centre_Id  = CM.I_Centre_ID   
   INNER JOIN CUSTOMERCARE.T_Complaint_Mode_Master CMM WITH (NOLOCK)  
   ON CRD.I_Complaint_Mode_ID =CMM.I_Complaint_Mode_ID  
   LEFT OUTER JOIN dbo.T_Course_Master COM  
   ON CRD.I_Course_ID = COM.I_Course_ID  
   LEFT OUTER JOIN  dbo.T_Upload_Document UD   
   ON    CRD.I_Document_ID  = UD.I_Document_ID      
   LEFT OUTER JOIN CUSTOMERCARE.T_Root_Cause_Master RCM  
   ON RCM.I_Root_Cause_ID =CRD.I_Root_Cause_ID  
  
   WHERE SD.I_Student_Detail_ID = COALESCE(@iStudentDetailID,SD.I_Student_Detail_ID)     
   AND CCM.I_Complaint_Category_ID =COALESCE(@iComplaintCategoryID,CCM.I_Complaint_Category_ID)   
   AND SD.S_First_Name LIKE COALESCE(@sStudentFName,SD.S_First_Name)  
   AND SD.S_Middle_Name LIKE COALESCE(@sStudentMName,SD.S_Middle_Name)  
   AND SD.S_Last_Name LIKE COALESCE(@sStudentLName,SD.S_Last_Name)  
   AND DATEDIFF(dd, ISNULL(@dtComplaintFromDate,CRD.Dt_Complaint_Date), CRD.Dt_Complaint_Date) >= 0  
   AND DATEDIFF(dd, ISNULL(DATEADD(dd,1,@dtComplaintToDate),CRD.Dt_Complaint_Date), CRD.Dt_Complaint_Date) < 0  
   --AND DATEDIFF(dd, ISNULL(@dtCurrentDate,CRD.Dt_Complaint_Date), CRD.Dt_Complaint_Date) >= 0  
   AND CRD.S_Complaint_Code = COALESCE(@sComplaintCode,CRD.S_Complaint_Code)  
   AND CRD.I_Status_ID = COALESCE(@iStatus,CRD.I_Status_ID)  
   AND CRD.I_User_ID = COALESCE(@iUserID,CRD.I_User_ID)  
   AND CRD.S_Crtd_BY = COALESCE(@sLoginID,CRD.S_Crtd_BY)   
   AND BCD.I_Brand_ID = COALESCE(@iBrandID,BCD.I_Brand_ID)    
   AND CM.I_Centre_ID  IN (SELECT I_Center_ID FROM #TempCenter)  
END

CREATE PROCEDURE [PSCERTIFICATE].[uspGetPSCertificateStudentCertificateListCF]  
(  
 @iCenterID   INT = NULL,  
 @iBrandID   INT = NULL,  
 @iCourseID   INT = NULL,  
 @iTermID   INT = NULL,  
 @iPSCert   CHAR(1) = NULL ,  
 @iStatusID   INT ,  
 @iCourseFamilyID INT = NULL,  
 @iTemplate   INT = NULL,  
 @iFlag    INT =NULL  
   
)  
AS  
BEGIN  
  
IF(@iTemplate IS NULL)  
 BEGIN  
  EXEC [PSCERTIFICATE].[uspGetPSCertificateStudentCertificateList]@iCenterID,@iBrandID,@iCourseID,@iTermID,@iPSCert,@iStatusID  
 END  
ELSE   
BEGIN  
  
DECLARE @TemCourse TABLE  
(  
I_Course_ID INT  
)  
  
  
IF(@iCourseID IS NULL)  
BEGIN  
 INSERT INTO @TemCourse   
 SELECT I_Course_ID FROM dbo.T_Course_Master  
 WHERE I_CourseFamily_ID = @iCourseFamilyID  
 AND I_Course_ID IN (SELECT I_Course_ID from [dbo].[fnCourseListFromTemplateID](@iTemplate,@iFlag))  
END  
ELSE  
BEGIN  
 IF  EXISTS(SELECT I_Course_ID from [dbo].[fnCourseListFromTemplateID](@iTemplate,@iFlag) WHERE I_Course_ID =@iCourseID)   
 BEGIN  
  INSERT INTO @TemCourse(I_Course_ID) VALUES(@iCourseID)  
 END  
    ELSE  
 BEGIN  
  INSERT INTO @TemCourse(I_Course_ID) VALUES(0)  
 END   
END  
  
if (@iTermID IS NOT NULL)  
BEGIN  
     
SELECT  
DISTINCT(ISNULL(A.I_Student_Certificate_ID,0)) AS  I_Student_Certificate_ID,  
  ISNULL(A.I_Student_Detail_ID,0) AS  I_Student_Detail_ID,  
        ISNULL(A.S_Certificate_Serial_No,' ') AS  S_Certificate_Serial_No,  
        ISNULL(A.Dt_Certificate_Issue_Date,' ') AS  Dt_Certificate_Issue_Date,  
        ISNULL(A.Dt_Status_Date,' ') AS Dt_Status_Date,  
  (A.B_PS_Flag) AS B_PS_Flag,  
        --ISNULL(C.S_Logistic_Serial_No,' ') AS  S_Logistic_Serial_No,  
        ISNULL(A.I_Status,0) AS I_Status,  
        ISNULL(A.S_Crtd_By,' ') AS S_Crtd_By,  
        ISNULL(A.S_Upd_By,' ') AS S_Upd_By,  
        ISNULL(A.Dt_Crtd_On,' ') AS Dt_Crtd_On,  
        ISNULL(A.Dt_Upd_On,' ') AS Dt_Upd_On,  
  ISNULL(B.I_Student_Detail_ID,0) AS I_Student_Detail_ID,  
  ISNULL(B.I_Enquiry_Regn_ID,0) AS I_Enquiry_Regn_ID,  
  ISNULL(B.S_Student_ID,' ') AS S_Student_ID,  
  ISNULL(B.S_Title,' ') AS S_Title,  
  ISNULL(B.S_First_Name,' ') AS S_First_Name,  
  ISNULL(B.S_Middle_Name,' ') AS S_Middle_Name,  
  ISNULL(B.S_Last_Name,' ') AS S_Last_Name,  
  ISNULL(C.I_Logistic_ID,0) AS I_Logistic_ID,  
  ISNULL(C.S_Logistic_Serial_No,0) AS S_Logistic_Serial_No,  
  ISNULL(CM.S_Center_Name ,'') AS S_Center_Name,  
  CM.I_Centre_Id AS  I_Center_ID,  
  ISNULL(COM.S_Course_Name,'') AS S_Course_Name,  
  ISNULL(TM.S_Term_Name,'') AS S_Term_Name,  
  SCD.I_Batch_ID   
   FROM [PSCERTIFICATE].T_Student_PS_Certificate A  
  LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Logistic C  
  ON  A.I_Student_Certificate_ID = C.I_Student_Certificate_ID AND [C].[I_Status] = 1  
  INNER JOIN [dbo].T_Student_Detail B  
  ON B.I_Student_Detail_ID = A.I_Student_Detail_ID  
  INNER JOIN dbo.T_Student_Course_Detail SCD  
  ON SCD.I_Student_Detail_ID = A.I_Student_Detail_ID  
  AND SCD.I_Course_ID = COALESCE(@iCourseID, SCD.I_Course_ID)
  INNER JOIN [dbo].T_Course_Master COM  
  ON COM.I_Course_ID = SCD.I_Course_ID  
  INNER JOIN dbo.T_Term_Course_Map TCM  
  ON COM.I_Course_ID = TCM.I_Course_ID  
  INNER JOIN [dbo].T_Term_Master TM  
  ON TM.I_Term_ID = A.I_Term_ID  
  INNER JOIN [dbo].T_Student_Center_Detail F  
  ON F.I_Student_Detail_ID = A.I_Student_Detail_ID  
  INNER JOIN dbo.T_Centre_Master CM  
  ON CM.I_Centre_Id = F.I_Centre_Id  
  INNER JOIN dbo.T_Brand_Center_Details BCD  
  ON BCD.I_Centre_Id  = F.I_Centre_ID   
   WHERE    
  CM.I_Centre_Id = COALESCE(@iCenterID, F.I_Centre_Id)  
  AND BCD.I_Brand_Id = COALESCE(@iBrandID, BCD.I_Brand_Id)  
  AND A.I_Course_ID = COALESCE(@iCourseID, A.I_Course_ID)  
  AND TM.I_Term_ID = COALESCE(@iTermID, TM.I_Term_ID)  
  AND A.[C_Certificate_Type] = COALESCE(@iPSCert, A.[C_Certificate_Type])  
  AND A.I_Status = COALESCE(@iStatusID, A.I_Status)  
  --AND C.I_Status= 1  
END  
ELSE IF (@iCourseID IS NULL)  
BEGIN  
    
SELECT  
DISTINCT(ISNULL(A.I_Student_Certificate_ID,0)) AS  I_Student_Certificate_ID,  
  ISNULL(A.I_Student_Detail_ID,0) AS  I_Student_Detail_ID,  
        ISNULL(A.S_Certificate_Serial_No,' ') AS  S_Certificate_Serial_No,  
        ISNULL(A.Dt_Certificate_Issue_Date,' ') AS  Dt_Certificate_Issue_Date,  
        ISNULL(A.Dt_Status_Date,' ') AS Dt_Status_Date,  
  A.I_Course_ID AS I_Course_ID,  
        (A.B_PS_Flag) AS B_PS_Flag,  
        --ISNULL(C.S_Logistic_Serial_No,' ') AS  S_Logistic_Serial_No,  
        ISNULL(A.I_Status,0) AS I_Status,  
        ISNULL(A.S_Crtd_By,' ') AS S_Crtd_By,  
        ISNULL(A.S_Upd_By,' ') AS S_Upd_By,  
        ISNULL(A.Dt_Crtd_On,' ') AS Dt_Crtd_On,  
        ISNULL(A.Dt_Upd_On,' ') AS Dt_Upd_On,  
  ISNULL(B.I_Student_Detail_ID,0) AS I_Student_Detail_ID,  
  ISNULL(B.I_Enquiry_Regn_ID,0) AS I_Enquiry_Regn_ID,  
  ISNULL(B.S_Student_ID,' ') AS S_Student_ID,  
  ISNULL(B.S_Title,' ') AS S_Title,  
  ISNULL(B.S_First_Name,' ') AS S_First_Name,  
  ISNULL(B.S_Middle_Name,' ') AS S_Middle_Name,  
  ISNULL(B.S_Last_Name,' ') AS S_Last_Name,  
  ISNULL(C.I_Logistic_ID,0) AS I_Logistic_ID,  
  ISNULL(C.S_Logistic_Serial_No,0) AS S_Logistic_Serial_No,  
  ISNULL(CM.S_Center_Name ,'') AS S_Center_Name,  
  CM.I_Centre_Id AS  I_Center_ID,  
  ISNULL(COM.S_Course_Name,'') AS S_Course_Name,  
  ISNULL(TM.S_Term_Name,'') AS S_Term_Name,  
  SCD.I_Batch_ID   
   FROM [PSCERTIFICATE].T_Student_PS_Certificate A  
  LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Logistic C  
  ON  A.I_Student_Certificate_ID = C.I_Student_Certificate_ID AND [C].[I_Status] = 1  
  INNER JOIN [dbo].T_Student_Detail B  
  ON B.I_Student_Detail_ID = A.I_Student_Detail_ID  
  INNER JOIN dbo.T_Student_Course_Detail SCD  
  ON SCD.I_Student_Detail_ID = A.I_Student_Detail_ID  
  INNER JOIN [dbo].T_Course_Master COM  
  ON COM.I_Course_ID = SCD.I_Course_ID  
  INNER JOIN dbo.T_Term_Course_Map TCM  
  ON COM.I_Course_ID = TCM.I_Course_ID  
  LEFT OUTER JOIN [dbo].T_Term_Master TM  
  ON TM.I_Term_ID = A.I_Term_ID  
  INNER JOIN [dbo].T_Student_Center_Detail F  
  ON F.I_Student_Detail_ID = A.I_Student_Detail_ID  
  INNER JOIN dbo.T_Centre_Master CM  
  ON CM.I_Centre_Id = F.I_Centre_Id  
  INNER JOIN dbo.T_Brand_Center_Details BCD  
  ON BCD.I_Centre_Id  = F.I_Centre_ID   
   WHERE    
  CM.I_Centre_Id = COALESCE(@iCenterID, F.I_Centre_Id)  
  AND BCD.I_Brand_Id = COALESCE(@iBrandID, BCD.I_Brand_Id)  
  --AND COM.I_Course_ID = COALESCE(@iCourseID, COM.I_Course_ID)  
  AND COM.I_Course_ID IN (SELECT I_Course_ID FROM @TemCourse)  
  --AND TM.I_Term_ID = COALESCE(@iTermID, TM.I_Term_ID)  
  AND A.[C_Certificate_Type] = COALESCE(@iPSCert, A.[C_Certificate_Type])  
  AND A.I_Status = COALESCE(@iStatusID, A.I_Status)  
  --AND C.I_Status= 1  
END  
ELSE  
BEGIN  
     
SELECT  
DISTINCT(ISNULL(A.I_Student_Certificate_ID,0)) AS  I_Student_Certificate_ID,  
  ISNULL(A.I_Student_Detail_ID,0) AS  I_Student_Detail_ID,  
        ISNULL(A.S_Certificate_Serial_No,' ') AS  S_Certificate_Serial_No,  
        ISNULL(A.Dt_Certificate_Issue_Date,' ') AS  Dt_Certificate_Issue_Date,  
        ISNULL(A.Dt_Status_Date,' ') AS Dt_Status_Date,  
        (A.B_PS_Flag) AS B_PS_Flag,  
        --ISNULL(C.S_Logistic_Serial_No,' ') AS  S_Logistic_Serial_No,  
        ISNULL(A.I_Status,0) AS I_Status,  
        ISNULL(A.S_Crtd_By,' ') AS S_Crtd_By,  
        ISNULL(A.S_Upd_By,' ') AS S_Upd_By,  
        ISNULL(A.Dt_Crtd_On,' ') AS Dt_Crtd_On,  
        ISNULL(A.Dt_Upd_On,' ') AS Dt_Upd_On,  
  ISNULL(B.I_Student_Detail_ID,0) AS I_Student_Detail_ID,  
  ISNULL(B.I_Enquiry_Regn_ID,0) AS I_Enquiry_Regn_ID,  
  ISNULL(B.S_Student_ID,' ') AS S_Student_ID,  
  ISNULL(B.S_Title,' ') AS S_Title,  
  ISNULL(B.S_First_Name,' ') AS S_First_Name,  
  ISNULL(B.S_Middle_Name,' ') AS S_Middle_Name,  
  ISNULL(B.S_Last_Name,' ') AS S_Last_Name,  
  ISNULL(C.I_Logistic_ID,0) AS I_Logistic_ID,  
  ISNULL(C.S_Logistic_Serial_No,0) AS S_Logistic_Serial_No,  
  ISNULL(CM.S_Center_Name ,'') AS S_Center_Name,  
  CM.I_Centre_Id AS  I_Center_ID,  
  ISNULL(COM.S_Course_Name,'') AS S_Course_Name,  
  ISNULL(TM.S_Term_Name,'') AS S_Term_Name,  
  SCD.I_Batch_ID   
   FROM [PSCERTIFICATE].T_Student_PS_Certificate A  
  LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Logistic C  
  ON  A.I_Student_Certificate_ID = C.I_Student_Certificate_ID AND [C].[I_Status] = 1  
  INNER JOIN [dbo].T_Student_Detail B  
  ON B.I_Student_Detail_ID = A.I_Student_Detail_ID  
  INNER JOIN dbo.T_Student_Course_Detail SCD  
  ON SCD.I_Student_Detail_ID = A.I_Student_Detail_ID 
  AND SCD.I_Course_ID = COALESCE(@iCourseID, SCD.I_Course_ID) 
  INNER JOIN [dbo].T_Course_Master COM  
  ON COM.I_Course_ID = SCD.I_Course_ID  
  INNER JOIN dbo.T_Term_Course_Map TCM  
  ON COM.I_Course_ID = TCM.I_Course_ID  
  LEFT OUTER JOIN [dbo].T_Term_Master TM  
  ON TM.I_Term_ID = A.I_Term_ID  
  INNER JOIN [dbo].T_Student_Center_Detail F  
  ON F.I_Student_Detail_ID = A.I_Student_Detail_ID  
  INNER JOIN dbo.T_Centre_Master CM  
  ON CM.I_Centre_Id = F.I_Centre_Id  
  INNER JOIN dbo.T_Brand_Center_Details BCD  
  ON BCD.I_Centre_Id  = F.I_Centre_ID   
   WHERE    
  CM.I_Centre_Id = COALESCE(@iCenterID, F.I_Centre_Id)  
  AND BCD.I_Brand_Id = COALESCE(@iBrandID, BCD.I_Brand_Id)  
  AND A.I_Course_ID = COALESCE(@iCourseID, A.I_Course_ID)  
  AND TM.I_Term_ID IS NULL  
  AND A.[C_Certificate_Type] = COALESCE(@iPSCert, A.[C_Certificate_Type])  
  AND A.I_Status = COALESCE(@iStatusID, A.I_Status)  
  --AND C.I_Status= 1  
END  
END  
END

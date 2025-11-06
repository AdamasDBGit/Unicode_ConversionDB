/*    
-- =================================================================    
-- Author:Shankha roy     
-- Modified By :     
-- Create date:17/01/2008    
-- Description:This sp return the list of certificates and ps details    
--     that are already printed.This sp used for re-issue of     
     damage print certificate and PS.    
-- =================================================================    
*/    
    
CREATE PROCEDURE [PSCERTIFICATE].[uspGetPSCertificateListByLogisticNOCF]    
(    
 @iCenterID  INT = NULL,    
 @iBrandID  INT,    
 @iCourseID  INT=NULL,    
 @iTermID  INT = NULL,    
 @iPSCert  CHAR(1) = NULL ,    
 @iStatusID  INT = NULL,    
 @sLogisticStartNO  VARCHAR(max) = NULL,    
 @sLogisticEndNO  VARCHAR(max) = NULL,    
 @sEnrolmentNo   VARCHAR(500) = NULL,    
 @sStudentFName VARCHAR(50) = NULL,    
 @sStudentMName VARCHAR(50) = NULL,    
 @sStudentLName VARCHAR(50) = NULL,    
 @HierarchyDetailID INT =NULL,    
 @iCourseFamilyID INT,    
 @iTemplate INT,    
 @iFlag INT = 0,  
 @CertificateType CHAR(1) = NULL   
)    
AS    
BEGIN    
    
 --Check First name Middle and last name is null or not and build the search like query    
 IF(@sStudentFName is not null)    
  SET @sStudentFName= '%'+@sStudentFName+'%'    
 IF(@sStudentMName is not null)     
  SET @sStudentMName = '%'+@sStudentMName+'%'    
 IF(@sStudentLName is not null)    
  SET @sStudentLName = '%'+@sStudentLName+'%'    
    
DECLARE @startindex INT,@endindex INT  
SET @startindex = CAST(SUBSTRING(@sLogisticStartNO,CHARINDEX('-', @sLogisticStartNO) + 1, LEN(@sLogisticStartNO)) AS INT)    
SET @endindex =  CAST(SUBSTRING(@sLogisticEndNO,CHARINDEX('-', @sLogisticEndNO) + 1, LEN(@sLogisticEndNO)) AS INT)     
-- For course family    
    
DECLARE @TemCourse TABLE    
(    
I_Course_ID INT    
)    
    
--    
--IF(@iCourseID IS NULL)    
--BEGIN    
-- INSERT INTO @TemCourse     
-- SELECT I_Course_ID FROM dbo.T_Course_Master    
-- WHERE I_CourseFamily_ID = @iCourseFamilyID    
--END    
--ELSE    
--BEGIN    
-- INSERT INTO @TemCourse(I_Course_ID) VALUES(@iCourseID)    
--END    
    
    
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
    
    
    
-- For Term     
DECLARE @TemTermCourse TABLE    
(    
I_Term_ID INT    
)    
    
    
IF(@iTermID IS NULL)    
BEGIN    
 INSERT INTO @TemTermCourse     
 SELECT DISTINCT I_Term_ID FROM dbo.T_Term_Course_Map    
 WHERE I_Course_ID IN (SELECT I_Course_ID FROM @TemCourse )     
END    
ELSE    
BEGIN    
 INSERT INTO @TemTermCourse(I_Term_ID) VALUES(@iTermID)    
END    
    
    
    
    
    
IF (@iTermID IS NOT NULL)    
BEGIN    
  SELECT DISTINCT    
  ISNULL(A.S_Certificate_Serial_No,' ') AS  S_Certificate_Serial_No,    
  ISNULL(A.I_Student_Certificate_ID,0) AS  I_Student_Certificate_ID,    
  ISNULL(A.I_Student_Detail_ID,0) AS  I_Student_Detail_ID,            
        ISNULL(A.Dt_Certificate_Issue_Date,' ') AS  Dt_Certificate_Issue_Date,    
        ISNULL(A.Dt_Status_Date,' ') AS Dt_Status_Date,    
        (A.B_PS_Flag) AS B_PS_Flag,    
        ISNULL(C.S_Logistic_Serial_No,' ') AS  S_Logistic_Serial_No,    
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
  ISNULL(B.I_Status,0) AS I_Status,    
  ISNULL(B.S_Crtd_By,' ') AS S_Crtd_By,    
  ISNULL(B.S_Upd_By,' ') AS S_Upd_By,    
  ISNULL(B.Dt_Crtd_On,' ') AS Dt_Crtd_On,    
  ISNULL(B.Dt_Upd_On,' ') AS Dt_Upd_On    
  --ISNULL(C.I_Logistic_ID,0) AS I_Logistic_ID    
   FROM [PSCERTIFICATE].T_Student_PS_Certificate A    
  LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Logistic C    
  ON  A.I_Student_Certificate_ID = C.I_Student_Certificate_ID,    [dbo].T_Student_Detail B,    
  [dbo].T_Student_Center_Detail F,    
  [dbo].T_Brand_Center_Details G    
   WHERE    
  A.I_Student_Detail_ID = B.I_Student_Detail_ID    
  AND B.I_Student_Detail_ID = F.I_Student_Detail_ID    
  AND F.I_Centre_Id = G.I_Centre_Id    
  --AND F.I_Centre_Id = COALESCE(@iCenterID, F.I_Centre_Id)    
  AND F.I_Centre_Id  IN ( SELECT FN1.I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@HierarchyDetailID,@iBrandID) FN1)    
  AND G.I_Brand_Id = COALESCE(@iBrandID, G.I_Brand_Id)    
  --AND A.I_Course_ID = COALESCE(@iCourseID, A.I_Course_ID)    
  AND A.I_Course_ID IN (SELECT I_Course_ID FROM @TemCourse)    
  --AND A.I_Term_ID = COALESCE(@iTermID, A.I_Term_ID)    
  AND A.I_Term_ID IN (SELECT I_Term_ID FROM @TemTermCourse)    
  AND [A].[C_Certificate_Type] = COALESCE(@iPSCert, [A].[C_Certificate_Type])    
  AND A.I_Status IN (2,3,5)    
  AND C.I_Status = 1    
  AND CAST(SUBSTRING(C.S_Logistic_Serial_No,CHARINDEX('-', C.S_Logistic_Serial_No) + 1, LEN(C.S_Logistic_Serial_No)) AS INT) >= COALESCE( @startindex,CAST(SUBSTRING(C.S_Logistic_Serial_No,CHARINDEX('-', C.S_Logistic_Serial_No) + 1, LEN(C.S_Logistic_Serial_No)) AS INT))    
  AND CAST(SUBSTRING(C.S_Logistic_Serial_No,CHARINDEX('-', C.S_Logistic_Serial_No) + 1, LEN(C.S_Logistic_Serial_No)) AS INT) <= COALESCE( @endindex,CAST(SUBSTRING(C.S_Logistic_Serial_No,CHARINDEX('-', C.S_Logistic_Serial_No) + 1, LEN(C.S_Logistic_Serial_No)) AS INT))    
  AND B.S_First_Name LIKE  COALESCE(@sStudentFName, B.S_First_Name)     
  --AND B.S_Middle_Name LIKE COALESCE(@sStudentMName, B.S_Middle_Name)     
  AND B.S_Last_Name LIKE  COALESCE(@sStudentLName, B.S_Last_Name)     
  AND A.I_Student_Detail_ID = COALESCE(@sEnrolmentNo,A.I_Student_Detail_ID)     
  AND A.C_Certificate_Type = ISNULL(@CertificateType,A.C_Certificate_Type)  
END    
ELSE    
BEGIN    
  SELECT    
  DISTINCT    
  ISNULL(A.S_Certificate_Serial_No,' ') AS  S_Certificate_Serial_No,    
  ISNULL(A.I_Student_Certificate_ID,0) AS  I_Student_Certificate_ID,    
  ISNULL(A.I_Student_Detail_ID,0) AS  I_Student_Detail_ID,            
        ISNULL(A.Dt_Certificate_Issue_Date,' ') AS  Dt_Certificate_Issue_Date,    
        ISNULL(A.Dt_Status_Date,' ') AS Dt_Status_Date,    
        (A.B_PS_Flag) AS B_PS_Flag,    
        ISNULL(C.S_Logistic_Serial_No,' ') AS  S_Logistic_Serial_No,    
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
  ISNULL(B.I_Status,0) AS I_Status,    
  ISNULL(B.S_Crtd_By,' ') AS S_Crtd_By,    
  ISNULL(B.S_Upd_By,' ') AS S_Upd_By,    
  ISNULL(B.Dt_Crtd_On,' ') AS Dt_Crtd_On,    
  ISNULL(B.Dt_Upd_On,' ') AS Dt_Upd_On    
  --ISNULL(C.I_Logistic_ID,0) AS I_Logistic_ID    
   FROM [PSCERTIFICATE].T_Student_PS_Certificate A    
  LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Logistic C    
  ON  A.I_Student_Certificate_ID = C.I_Student_Certificate_ID,    
  [dbo].T_Student_Detail B,    
  [dbo].T_Student_Center_Detail F,    
  [dbo].T_Brand_Center_Details G    
   WHERE    
  A.I_Student_Detail_ID = B.I_Student_Detail_ID    
  AND B.I_Student_Detail_ID = F.I_Student_Detail_ID    
  AND F.I_Centre_Id = G.I_Centre_Id    
  --AND F.I_Centre_Id = COALESCE(@iCenterID, F.I_Centre_Id)    
  AND F.I_Centre_Id IN ( SELECT FN1.I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@HierarchyDetailID,@iBrandID) FN1)    
  AND G.I_Brand_Id = COALESCE(@iBrandID, G.I_Brand_Id)    
  --AND A.I_Course_ID = COALESCE(@iCourseID, A.I_Course_ID)    
  AND A.I_Course_ID IN (SELECT I_Course_ID FROM @TemCourse)    
  --AND A.I_Term_ID = COALESCE(@iTermID, A.I_Term_ID)    
  --AND A.I_Term_ID IS NULL    
  AND [A].[C_Certificate_Type] = COALESCE(@iPSCert, [A].[C_Certificate_Type])    
  --AND A.I_Status = COALESCE(@iStatusID, A.I_Status)    
  AND A.I_Status IN (2) -- 2 :for Printed Status  3: For Dispatched 5: for ReissueApproved    
  AND C.I_Status = 1    
  AND CAST(SUBSTRING(C.S_Logistic_Serial_No,CHARINDEX('-', C.S_Logistic_Serial_No) + 1, LEN(C.S_Logistic_Serial_No)) AS INT) >= COALESCE( @startindex,CAST(SUBSTRING(C.S_Logistic_Serial_No,CHARINDEX('-', C.S_Logistic_Serial_No) + 1, LEN(C.S_Logistic_Serial_No)) AS INT))    
  AND CAST(SUBSTRING(C.S_Logistic_Serial_No,CHARINDEX('-', C.S_Logistic_Serial_No) + 1, LEN(C.S_Logistic_Serial_No)) AS INT) <= COALESCE( @endindex,CAST(SUBSTRING(C.S_Logistic_Serial_No,CHARINDEX('-', C.S_Logistic_Serial_No) + 1, LEN(C.S_Logistic_Serial_No)) AS INT))    
  AND B.S_First_Name LIKE  COALESCE(@sStudentFName, B.S_First_Name)    
  --AND B.S_Middle_Name LIKE  COALESCE(@sStudentMName, B.S_Middle_Name)     
  AND B.S_Last_Name LIKE COALESCE(@sStudentLName, B.S_Last_Name)    
  AND A.I_Student_Detail_ID = COALESCE(@sEnrolmentNo,A.I_Student_Detail_ID)     
  AND A.C_Certificate_Type = ISNULL(@CertificateType,A.C_Certificate_Type)  
END    
END

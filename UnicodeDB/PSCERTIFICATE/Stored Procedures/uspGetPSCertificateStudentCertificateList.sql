/*  
-- =================================================================  
-- Author:Chandan Dey  
-- Modified By :  
-- Create date:06/11/2007  
-- Description:Select List PSCertificateStudentCertificateList record in T_Student_PS_Certificate table  
-- =================================================================  
*/  
  
CREATE PROCEDURE [PSCERTIFICATE].[uspGetPSCertificateStudentCertificateList]  
(  
 @iCenterID    INT = NULL,  
 @iBrandID    INT = NULL,  
 @iCourseID    INT = NULL,  
 @iTermID    INT = NULL,  
 @iPSCert    CHAR(1) = NULL ,  
 @iStatusID    INT  
 --@dtFromDate    DATETIME = NULL,  
    --@dtToDate     DATETIME = NULL  
)  
AS  
BEGIN  
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
  ISNULL(B.S_Guardian_Name,' ') AS S_Guardian_Name,  
  ISNULL(B.I_Guardian_Occupation_ID,0) AS I_Guardian_Occupation_ID,  
  ISNULL(B.S_Guardian_Email_ID,' ') AS S_Guardian_Email_ID,  
  ISNULL(B.S_Guardian_Phone_No,' ') AS S_Guardian_Phone_No,  
  ISNULL(B.S_Guardian_Mobile_No,' ') AS S_Guardian_Mobile_No,  
  ISNULL(B.I_Income_Group_ID,0) AS I_Income_Group_ID,  
  ISNULL(B.Dt_Birth_Date,' ') AS Dt_Birth_Date,  
  ISNULL(B.S_Age,' ') AS S_Age,  
  ISNULL(B.S_Email_ID,' ') AS S_Email_ID,  
  ISNULL(B.S_Phone_No,' ') AS S_Phone_No,  
  ISNULL(B.S_Mobile_No,' ') AS S_Mobile_No,  
  ISNULL(B.C_Skip_Test,' ') AS C_Skip_Test,  
  ISNULL(B.I_Occupation_ID,0) AS I_Occupation_ID,  
  ISNULL(B.I_Pref_Career_ID,0) AS I_Pref_Career_ID,  
  ISNULL(B.I_Qualification_Name_ID,0) AS I_Qualification_Name_ID,  
  ISNULL(B.I_Stream_ID,0) AS I_Stream_ID,  
  ISNULL(B.S_Curr_Address1,' ') AS S_Curr_Address1,  
  ISNULL(B.S_Curr_Address2,' ') AS S_Curr_Address2,  
  ISNULL(B.I_Curr_Country_ID,0) AS I_Curr_Country_ID,  
  ISNULL(B.I_Curr_State_ID,0) AS I_Curr_State_ID,  
  ISNULL(B.I_Curr_City_ID,0) AS I_Curr_City_ID,  
  ISNULL(B.S_Curr_Area,' ') AS S_Curr_Area,  
  ISNULL(B.S_Curr_Pincode,' ') AS S_Curr_Pincode,  
  ISNULL(B.S_Perm_Address1,' ') AS S_Perm_Address1,  
  ISNULL(B.S_Perm_Address2,' ') AS S_Perm_Address2,  
  ISNULL(B.I_Perm_Country_ID,0) AS I_Perm_Country_ID,  
  ISNULL(B.I_Perm_State_ID,0) AS I_Perm_State_ID,  
  ISNULL(B.I_Perm_City_ID,0) AS I_Perm_City_ID,  
  ISNULL(B.S_Perm_Area,' ') AS S_Perm_Area,  
  ISNULL(B.S_Perm_Pincode,' ') AS S_Perm_Pincode,  
  ISNULL(B.I_Status,0) AS I_Status,  
  ISNULL(B.S_Crtd_By,' ') AS S_Crtd_By,  
  ISNULL(B.S_Upd_By,' ') AS S_Upd_By,  
  ISNULL(B.Dt_Crtd_On,' ') AS Dt_Crtd_On,  
  ISNULL(B.Dt_Upd_On,' ') AS Dt_Upd_On,  
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
  ISNULL(B.S_Guardian_Name,' ') AS S_Guardian_Name,  
  ISNULL(B.I_Guardian_Occupation_ID,0) AS I_Guardian_Occupation_ID,  
  ISNULL(B.S_Guardian_Email_ID,' ') AS S_Guardian_Email_ID,  
  ISNULL(B.S_Guardian_Phone_No,' ') AS S_Guardian_Phone_No,  
  ISNULL(B.S_Guardian_Mobile_No,' ') AS S_Guardian_Mobile_No,  
  ISNULL(B.I_Income_Group_ID,0) AS I_Income_Group_ID,  
  ISNULL(B.Dt_Birth_Date,' ') AS Dt_Birth_Date,  
  ISNULL(B.S_Age,' ') AS S_Age,  
  ISNULL(B.S_Email_ID,' ') AS S_Email_ID,  
  ISNULL(B.S_Phone_No,' ') AS S_Phone_No,  
  ISNULL(B.S_Mobile_No,' ') AS S_Mobile_No,  
  ISNULL(B.C_Skip_Test,' ') AS C_Skip_Test,  
  ISNULL(B.I_Occupation_ID,0) AS I_Occupation_ID,  
  ISNULL(B.I_Pref_Career_ID,0) AS I_Pref_Career_ID,  
  ISNULL(B.I_Qualification_Name_ID,0) AS I_Qualification_Name_ID,  
  ISNULL(B.I_Stream_ID,0) AS I_Stream_ID,  
  ISNULL(B.S_Curr_Address1,' ') AS S_Curr_Address1,  
  ISNULL(B.S_Curr_Address2,' ') AS S_Curr_Address2,  
  ISNULL(B.I_Curr_Country_ID,0) AS I_Curr_Country_ID,  
  ISNULL(B.I_Curr_State_ID,0) AS I_Curr_State_ID,  
  ISNULL(B.I_Curr_City_ID,0) AS I_Curr_City_ID,  
  ISNULL(B.S_Curr_Area,' ') AS S_Curr_Area,  
  ISNULL(B.S_Curr_Pincode,' ') AS S_Curr_Pincode,  
  ISNULL(B.S_Perm_Address1,' ') AS S_Perm_Address1,  
  ISNULL(B.S_Perm_Address2,' ') AS S_Perm_Address2,  
  ISNULL(B.I_Perm_Country_ID,0) AS I_Perm_Country_ID,  
  ISNULL(B.I_Perm_State_ID,0) AS I_Perm_State_ID,  
  ISNULL(B.I_Perm_City_ID,0) AS I_Perm_City_ID,  
  ISNULL(B.S_Perm_Area,' ') AS S_Perm_Area,  
  ISNULL(B.S_Perm_Pincode,' ') AS S_Perm_Pincode,  
  ISNULL(B.I_Status,0) AS I_Status,  
  ISNULL(B.S_Crtd_By,' ') AS S_Crtd_By,  
  ISNULL(B.S_Upd_By,' ') AS S_Upd_By,  
  ISNULL(B.Dt_Crtd_On,' ') AS Dt_Crtd_On,  
  ISNULL(B.Dt_Upd_On,' ') AS Dt_Upd_On,  
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
  ISNULL(B.S_Guardian_Name,' ') AS S_Guardian_Name,  
  ISNULL(B.I_Guardian_Occupation_ID,0) AS I_Guardian_Occupation_ID,  
  ISNULL(B.S_Guardian_Email_ID,' ') AS S_Guardian_Email_ID,  
  ISNULL(B.S_Guardian_Phone_No,' ') AS S_Guardian_Phone_No,  
  ISNULL(B.S_Guardian_Mobile_No,' ') AS S_Guardian_Mobile_No,  
  ISNULL(B.I_Income_Group_ID,0) AS I_Income_Group_ID,  
  ISNULL(B.Dt_Birth_Date,' ') AS Dt_Birth_Date,  
  ISNULL(B.S_Age,' ') AS S_Age,  
  ISNULL(B.S_Email_ID,' ') AS S_Email_ID,  
  ISNULL(B.S_Phone_No,' ') AS S_Phone_No,  
  ISNULL(B.S_Mobile_No,' ') AS S_Mobile_No,  
  ISNULL(B.C_Skip_Test,' ') AS C_Skip_Test,  
  ISNULL(B.I_Occupation_ID,0) AS I_Occupation_ID,  
  ISNULL(B.I_Pref_Career_ID,0) AS I_Pref_Career_ID,  
  ISNULL(B.I_Qualification_Name_ID,0) AS I_Qualification_Name_ID,  
  ISNULL(B.I_Stream_ID,0) AS I_Stream_ID,  
  ISNULL(B.S_Curr_Address1,' ') AS S_Curr_Address1,  
  ISNULL(B.S_Curr_Address2,' ') AS S_Curr_Address2,  
  ISNULL(B.I_Curr_Country_ID,0) AS I_Curr_Country_ID,  
  ISNULL(B.I_Curr_State_ID,0) AS I_Curr_State_ID,  
  ISNULL(B.I_Curr_City_ID,0) AS I_Curr_City_ID,  
  ISNULL(B.S_Curr_Area,' ') AS S_Curr_Area,  
  ISNULL(B.S_Curr_Pincode,' ') AS S_Curr_Pincode,  
  ISNULL(B.S_Perm_Address1,' ') AS S_Perm_Address1,  
  ISNULL(B.S_Perm_Address2,' ') AS S_Perm_Address2,  
  ISNULL(B.I_Perm_Country_ID,0) AS I_Perm_Country_ID,  
  ISNULL(B.I_Perm_State_ID,0) AS I_Perm_State_ID,  
  ISNULL(B.I_Perm_City_ID,0) AS I_Perm_City_ID,  
  ISNULL(B.S_Perm_Area,' ') AS S_Perm_Area,  
  ISNULL(B.S_Perm_Pincode,' ') AS S_Perm_Pincode,  
  ISNULL(B.I_Status,0) AS I_Status,  
  ISNULL(B.S_Crtd_By,' ') AS S_Crtd_By,  
  ISNULL(B.S_Upd_By,' ') AS S_Upd_By,  
  ISNULL(B.Dt_Crtd_On,' ') AS Dt_Crtd_On,  
  ISNULL(B.Dt_Upd_On,' ') AS Dt_Upd_On,  
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

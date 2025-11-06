/*    
-- =================================================================    
-- Author:Chandan Dey    
-- Modified By :    
-- Create date: 27/10/2007    
-- Description: Select List PSCertificateStudentCertificateList record in T_Student_PS_Certificate table    
-- =================================================================    
*/    
CREATE PROCEDURE [PSCERTIFICATE].[uspGetPSCertificateDispatchList]    
(    
 @iCenterID    INT,    
 @iBrandID    INT,    
 @iCourseID    INT,    
 @iTermID    INT = NULL,    
 @iPSCert    INT = NULL ,    
 @iStatusID    INT = NULL,    
 @dtFromDate    DATETIME = NULL,    
 @dtToDate    DATETIME = NULL    
)    
AS    
BEGIN    
if (@iTermID IS NOT NULL)    
BEGIN    
   SELECT    
  ISNULL(A.I_Student_Certificate_ID,0) AS  I_Student_Certificate_ID,    
  ISNULL(A.I_Student_Detail_ID,0) AS  I_Student_Detail_ID,    
        ISNULL(A.S_Certificate_Serial_No,' ') AS  S_Certificate_Serial_No,    
        ISNULL(A.Dt_Certificate_Issue_Date,' ') AS  Dt_Certificate_Issue_Date,    
        ISNULL(A.Dt_Status_Date,' ') AS Dt_Status_Date,    
        (A.B_PS_Flag) AS B_PS_Flag,    
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
  ISNULL(CDI.I_Courier_ID,0) AS I_Courier_ID,    
  ISNULL(CDI.I_Despatch_ID,0) AS I_Despatch_ID,    
  Dt_Dispatch_Date,    
  ISNULL(CDI.S_Docket_No,'') AS S_Docket_No,    
  ISNULL(CM.S_Courier_Name,'') AS S_Courier_Name    
   FROM [PSCERTIFICATE].T_Student_PS_Certificate A    
  INNER JOIN [PSCERTIFICATE].T_Certificate_Logistic C    
  ON  A.I_Student_Certificate_ID = C.I_Student_Certificate_ID    
  LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Despatch_Info CDI    
  ON CDI.I_Logistic_ID = C.I_Logistic_ID    
  LEFT OUTER JOIN dbo.T_Courier_Master CM    
  ON CM.I_Courier_ID = CDI.I_Courier_ID,    
  [dbo].T_Student_Detail B,    
  [dbo].T_Student_Center_Detail F    
  INNER JOIN dbo.T_Brand_Center_Details BCD    
  ON BCD.I_Centre_Id  = F.I_Centre_ID    
   WHERE    
  A.I_Student_Detail_ID = B.I_Student_Detail_ID    
  AND B.I_Student_Detail_ID = F.I_Student_Detail_ID    
  AND C.I_Status = 1    
  AND F.I_Centre_Id = COALESCE(@iCenterID, F.I_Centre_Id)    
  AND BCD.I_Brand_Id = COALESCE(@iBrandID, BCD.I_Brand_Id)    
  AND A.I_Course_ID = COALESCE(@iCourseID, A.I_Course_ID)    
  AND A.I_Term_ID = COALESCE(@iTermID, A.I_Term_ID)    
  --AND A.B_PS_Flag = COALESCE(@iPSCert, A.B_PS_Flag)    
     --AND (A.I_Status = 2 OR A.I_Status = 3)    
  AND A.I_Status = COALESCE(@iStatusID, A.I_Status)    
  AND A.[Dt_Crtd_On] >= COALESCE(@dtFromDate, A.Dt_Upd_On)    
     AND A.[Dt_Crtd_On] <= COALESCE(@dtToDate + 1, A.Dt_Upd_On)    
END    
ELSE    
BEGIN    
   SELECT    
  ISNULL(A.I_Student_Certificate_ID,0) AS  I_Student_Certificate_ID,    
  ISNULL(A.I_Student_Detail_ID,0) AS  I_Student_Detail_ID,    
        ISNULL(A.S_Certificate_Serial_No,' ') AS  S_Certificate_Serial_No,    
        ISNULL(A.Dt_Certificate_Issue_Date,' ') AS  Dt_Certificate_Issue_Date,    
        ISNULL(A.Dt_Status_Date,' ') AS Dt_Status_Date,    
        (A.B_PS_Flag) AS B_PS_Flag,    
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
  ISNULL(C.S_Logistic_Serial_No,0) AS S_Logistic_Serial_No,      ISNULL(CDI.I_Courier_ID,0) AS I_Courier_ID,    
  ISNULL(CDI.I_Despatch_ID,0) AS I_Despatch_ID,    
  Dt_Dispatch_Date,    
  ISNULL(CDI.S_Docket_No,'') AS S_Docket_No,    
  ISNULL(CM.S_Courier_Name,'') AS S_Courier_Name    
   FROM [PSCERTIFICATE].T_Student_PS_Certificate A    
  INNER JOIN [PSCERTIFICATE].T_Certificate_Logistic C     
  ON A.I_Student_Certificate_ID = C.I_Student_Certificate_ID    
  LEFT OUTER JOIN [PSCERTIFICATE].T_Certificate_Despatch_Info CDI    
  ON CDI.I_Logistic_ID = C.I_Logistic_ID    
  LEFT OUTER JOIN dbo.T_Courier_Master CM    
  ON CM.I_Courier_ID = CDI.I_Courier_ID,    
  [dbo].T_Student_Detail B,    
  [dbo].T_Student_Center_Detail F    
  INNER JOIN dbo.T_Brand_Center_Details BCD    
  ON BCD.I_Centre_Id  = F.I_Centre_ID    
   WHERE    
  A.I_Student_Detail_ID = B.I_Student_Detail_ID    
  AND C.I_Status = 1    
  AND B.I_Student_Detail_ID = F.I_Student_Detail_ID    
  AND F.I_Centre_Id = COALESCE(@iCenterID, F.I_Centre_Id)    
  AND BCD.I_Brand_Id = COALESCE(@iBrandID, BCD.I_Brand_Id)    
  AND A.I_Course_ID = COALESCE(@iCourseID, A.I_Course_ID)    
  --AND A.I_Term_ID IS NULL    
  --AND A.B_PS_Flag = COALESCE(@iPSCert, A.B_PS_Flag)    
  --AND (A.I_Status = 2 OR A.I_Status = 3)    
  AND A.I_Status = COALESCE(@iStatusID, A.I_Status)    
  AND A.[Dt_Crtd_On] >= COALESCE(@dtFromDate, A.[Dt_Crtd_On])    
     AND A.[Dt_Crtd_On] <= COALESCE(@dtToDate + 1, A.[Dt_Crtd_On])    
END    
END

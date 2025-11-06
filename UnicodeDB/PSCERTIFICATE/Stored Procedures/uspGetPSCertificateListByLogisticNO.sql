/*
-- =================================================================
-- Author:Shankha roy 
-- Modified By : Chandan Dey
-- Create date:09/07/2007
-- Description:This sp return the list of certificates and ps details
--			  that are already printed.This sp used for re-issue of 
			  damage print certificate and PS.
-- =================================================================
*/

CREATE PROCEDURE [PSCERTIFICATE].[uspGetPSCertificateListByLogisticNO]
(
	@iCenterID		INT = NULL,
	@iBrandID		INT,
	@iCourseID		INT,
	@iTermID		INT = NULL,
	@iPSCert		INT = NULL ,
	@iStatusID		INT = NULL,
	@sLogisticStartNO		VARCHAR(20) = NULL,
	@sLogisticEndNO		VARCHAR(20) = NULL,
	@sEnrolmentNo   VARCHAR(500) = NULL,
	@sStudentFName	VARCHAR(50) = NULL,
	@sStudentMName	VARCHAR(50) = NULL,
	@sStudentLName	VARCHAR(50) = NULL,
	@HierarchyDetailID INT =NULL
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
		AND F.I_Centre_Id  IN ( SELECT FN1.I_Center_ID FROM [dbo].[fnGetCenterIDFromHierarchy](@HierarchyDetailID,@iBrandID) FN1)
		AND G.I_Brand_Id = COALESCE(@iBrandID, G.I_Brand_Id)
		AND A.I_Course_ID = COALESCE(@iCourseID, A.I_Course_ID)
		AND A.I_Term_ID = COALESCE(@iTermID, A.I_Term_ID)
		--AND A.I_Term_ID = @iTermID
		AND A.B_PS_Flag = COALESCE(@iPSCert, A.B_PS_Flag)
		AND A.I_Status IN (2,3,5)
		AND C.I_Status = 1
		AND C.S_Logistic_Serial_No >= COALESCE( @sLogisticStartNO,C.S_Logistic_Serial_No)
		AND C.S_Logistic_Serial_No <= COALESCE( @sLogisticEndNO,C.S_Logistic_Serial_No)
		AND B.S_First_Name LIKE  COALESCE(@sStudentFName, B.S_First_Name) 
		--AND B.S_Middle_Name LIKE COALESCE(@sStudentMName, B.S_Middle_Name) 
		AND B.S_Last_Name LIKE  COALESCE(@sStudentLName, B.S_Last_Name) 
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
		AND A.I_Course_ID = COALESCE(@iCourseID, A.I_Course_ID)
		--AND A.I_Term_ID = COALESCE(@iTermID, A.I_Term_ID)
		--AND A.I_Term_ID IS NULL
		AND A.B_PS_Flag = COALESCE(@iPSCert, A.B_PS_Flag)
		--AND A.I_Status = COALESCE(@iStatusID, A.I_Status)
		AND A.I_Status IN (2,3,5) -- 2 :for Printed Status  3: For Dispatched 5: for ReissueApproved
		AND C.I_Status = 1
		AND C.S_Logistic_Serial_No >= COALESCE( @sLogisticStartNO,C.S_Logistic_Serial_No)
		AND C.S_Logistic_Serial_No <= COALESCE( @sLogisticEndNO,C.S_Logistic_Serial_No)
		AND B.S_First_Name LIKE  COALESCE(@sStudentFName, B.S_First_Name)
		--AND B.S_Middle_Name LIKE  COALESCE(@sStudentMName, B.S_Middle_Name) 
		AND B.S_Last_Name LIKE COALESCE(@sStudentLName, B.S_Last_Name)
END
END

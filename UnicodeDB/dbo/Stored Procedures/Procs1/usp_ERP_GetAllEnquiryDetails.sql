-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- exec usp_ERP_GetAllEnquiryDetails_Bak06122023 7
-- exec usp_ERP_GetAllEnquiryDetails 3
---- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetAllEnquiryDetails]   
(  
 @iEnquiryRegnID int  
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  --Declare @iEnquiryRegnID int=7
 SELECT   
 TEERD.I_Enquiry_Regn_ID,  
 TEERD.I_Enquiry_Status_Code,  
 TEERD.I_Info_Source_ID,  
 TEERD.I_Enquiry_Type_ID,  
 TEERD.S_Enquiry_No,  
 TEERD.S_First_Name,  
 TEERD.S_Middle_Name,  
 TEERD.S_Last_Name,  
 TEERD.I_Gender_ID,  
 TEERD.Dt_Birth_Date,  
 TEERD.S_Mobile_No,  
 TEERD.I_Blood_Group_ID,  
 TEERD.I_Native_Language_ID,  
 TEERD.I_Nationality_ID,  
 TEERD.I_Religion_ID,  
 TEERD.I_Caste_ID,  
 TEERD.S_Email_ID,  
 TEERD.S_Student_Photo as CandidatePhotoPath,  
 TEERD.Enquiry_Date,  
 TEERD.PreEnquiryDate,  
 TEERD.S_Enquiry_No  ,
 TESFSCM.R_I_Fee_Structure_ID FeeStructureID
 FROM T_ERP_Enquiry_Regn_Detail TEERD 
 LEFT JOIN 
 T_ERP_Stud_Fee_Struct_Comp_Mapping TESFSCM ON TESFSCM.R_I_Enquiry_Regn_ID = TEERD.I_Enquiry_Regn_ID
 WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID;  
  
  
  
 SELECT * INTO #Temp FROM T_ERP_Enquiry_Regn_Guardian_Master  WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID 
   
   
  
 SELECT * INTO #FatherTable FROM #Temp WHERE I_Relation_ID = 1  
 SELECT * INTO #MotherTable FROM #Temp WHERE I_Relation_ID = 2  

  Declare @f_RelationID int,@m_RelationID int
  SET @f_RelationID=(Select top 1 I_Relation_ID from #FatherTable)
  SET @m_RelationID=(Select top 1 I_Relation_ID from #MotherTable)
  If  (@f_RelationID is not null and @m_RelationID is not null) 
  BEGIN  
  SELECT   
  ft.I_Enquiry_Regn_ID AS I_Enquiry_Regn_ID,  
  ft.I_Relation_ID AS I_Father_Relation_ID,  
  ft.S_Mobile_No AS S_Father_Mobile_No,  
  ft.S_First_Name AS S_Father_First_Name,  
  ft.S_Middile_Name AS S_Father_Middile_Name,  
  ft.S_Last_Name AS S_Father_Last_Name,  
  ft.S_Guardian_Email AS S_Father_Email_ID,  
  ft.I_Qualification_ID AS I_Father_Qualification_ID,  
  ft.I_Occupation_ID AS I_Father_Occupation_ID,  
  ft.S_Company_Name AS S_Father_Company_Name,  
  ft.S_Designation AS S_Father_Designation,  
  ft.I_Income_Group_ID AS I_Father_Income_Group_ID,  
  ft.S_Profile_Picture AS S_Father_Photo_Path,  
  
  mt.I_Relation_ID AS I_Mother_Relation_ID,  
  mt.S_Mobile_No AS S_Mother_Mobile_No,  
  mt.S_First_Name AS S_Mother_First_Name,  
  mt.S_Middile_Name AS S_Mother_Middile_Name,  
  mt.S_Last_Name AS S_Mother_Last_Name,  
  mt.S_Guardian_Email AS S_Mother_Email_ID,  
  mt.I_Qualification_ID AS I_Mother_Qualification_ID,  
  mt.I_Occupation_ID AS I_Mother_Occupation_ID,  
  mt.S_Company_Name AS S_Mother_Company_Name,  
  mt.S_Designation AS S_Mother_Designation,  
  mt.I_Income_Group_ID AS I_Mother_Income_Group_ID,  
  mt.S_Profile_Picture AS S_Mother_Photo_Path,  
  
  
  TEERA.S_Address_Type,  
  TEERA.S_Country_ID,  
  TEERA.S_State_ID,  
  TEERA.S_City_ID,  
  TEERA.S_Address1,  
  TEERA.S_Address2,  
  TEERA.S_Pincode  
  
  FROM #FatherTable ft    
  INNER JOIN #MotherTable mt ON ft.I_Enquiry_Regn_ID = mt.I_Enquiry_Regn_ID  
  INNER JOIN T_ERP_Enquiry_Regn_Address TEERA ON ft.I_Enquiry_Regn_ID = TEERA.I_Enquiry_Regn_ID  
 END  
  ELSE IF @f_RelationID is not Null and @m_RelationID is null
 BEGIN  
  SELECT   
  ft.I_Enquiry_Regn_ID AS I_Enquiry_Regn_ID,  
  ft.I_Relation_ID AS I_Father_Relation_ID,  
  ft.S_Mobile_No AS S_Father_Mobile_No,  
  ft.S_First_Name AS S_Father_First_Name,  
  ft.S_Middile_Name AS S_Father_Middile_Name,  
  ft.S_Last_Name AS S_Father_Last_Name,  
  ft.S_Guardian_Email AS S_Father_Email_ID,  
  ft.I_Qualification_ID AS I_Father_Qualification_ID,  
  ft.I_Occupation_ID AS I_Father_Occupation_ID,  
  ft.S_Company_Name AS S_Father_Company_Name,  
  ft.S_Designation AS S_Father_Designation,  
  ft.I_Income_Group_ID AS I_Father_Income_Group_ID,  
  ft.S_Profile_Picture AS S_Father_Photo_Path,  
  
  TEERA.S_Address_Type,  
  TEERA.S_Country_ID,  
  TEERA.S_State_ID,  
  TEERA.S_City_ID,  
  TEERA.S_Address1,  
  TEERA.S_Address2,  
  TEERA.S_Pincode  
  
  FROM #FatherTable ft      
  INNER JOIN T_ERP_Enquiry_Regn_Address TEERA ON ft.I_Enquiry_Regn_ID = TEERA.I_Enquiry_Regn_ID  
 END  
  Else If @m_RelationID is not null and @f_RelationID is Null
 BEGIN  
  SELECT  
  mt.I_Enquiry_Regn_ID,
  mt.I_Relation_ID AS I_Mother_Relation_ID,  
  mt.S_Mobile_No AS S_Mother_Mobile_No,  
  mt.S_First_Name AS S_Mother_First_Name,  
  mt.S_Middile_Name AS S_Mother_Middile_Name,  
  mt.S_Last_Name AS S_Mother_Last_Name,  
  mt.S_Guardian_Email AS S_Mother_Email_ID,  
  mt.I_Qualification_ID AS I_Mother_Qualification_ID,  
  mt.I_Occupation_ID AS I_Mother_Occupation_ID,  
  mt.S_Company_Name AS S_Mother_Company_Name,  
  mt.S_Designation AS S_Mother_Designation,  
  mt.I_Income_Group_ID AS I_Mother_Income_Group_ID,  
  mt.S_Profile_Picture AS S_Mother_Photo_Path,  
  
  
  TEERA.S_Address_Type,  
  TEERA.S_Country_ID,  
  TEERA.S_State_ID,  
  TEERA.S_City_ID,  
  TEERA.S_Address1,  
  TEERA.S_Address2,  
  TEERA.S_Pincode  
  
  FROM #MotherTable mt      
  INNER JOIN T_ERP_Enquiry_Regn_Address TEERA ON mt.I_Enquiry_Regn_ID = TEERA.I_Enquiry_Regn_ID  
 END  

  
 -- Deleting all the temp tables  
 DROP TABLE #Temp  
 DROP TABLE #FatherTable  
 DROP TABLE #MotherTable  
  
 SELECT   
 TEERD.I_Enquiry_Regn_ID,  
 TEERD.I_Enquiry_Type_ID,  
 TEERD.I_School_Group_ID,  
 TEERD.I_Course_Applied_For,  
 TEERD.Is_Prev_Academy,  
 TEERD.Is_Sibling,  
  
 TEEPD.R_I_Prev_Class_ID,  
 CASE   
        WHEN TEEPD.Is_Marks_Input = 1 THEN 0   
        WHEN TEEPD.Is_Marks_Input = 0 THEN 1  
    END AS Is_Marks_Input,  
 TEEPD.N_TotalMarks,  
 TEEPD.N_Obtain_Marks,  
 TEEPD.S_Grade,  
 TEEPD.N_Percentage,  
 TEEPD.S_School_Name,  
 TEEPD.S_School_Board,  
 TEEPD.S_Address,  
  
 TEPS.S_StudentID,  
 TEPS.S_Stud_Name,  
 CASE   
        WHEN TEPS.Is_Running_Stud = 1 THEN 0   
        WHEN TEPS.Is_Running_Stud = 0 THEN 1   
    END AS Is_Running_Stud,  
 TEPS.S_Passout_Year  
  
 FROM   
 T_ERP_Enquiry_Regn_Detail AS TEERD  
 left join T_ERP_EnquiryReg_Prev_Details AS TEEPD ON TEERD.I_Enquiry_Regn_ID = TEEPD.R_I_Enquiry_Regn_ID  
 left join T_ERP_PreEnq_Siblings AS TEPS ON TEERD.I_Enquiry_Regn_ID = TEPS.R_I_Enquiry_Regn_ID   
 WHERE TEERD.I_Enquiry_Regn_ID = @iEnquiryRegnID;  
END

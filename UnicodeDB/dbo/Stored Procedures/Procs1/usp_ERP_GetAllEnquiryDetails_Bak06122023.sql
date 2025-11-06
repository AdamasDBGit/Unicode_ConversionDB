-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- exec usp_ERP_GetAllEnquiryDetails 7  
---- =============================================  
CREATE PROCEDURE [dbo].[usp_ERP_GetAllEnquiryDetails_Bak06122023]   
(  
 @iEnquiryRegnID int = NULL  
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  --Declare @iEnquiryRegnID int=7
 SELECT   
 I_Enquiry_Regn_ID,  
 I_Enquiry_Status_Code,  
 I_Info_Source_ID,  
 I_Enquiry_Type_ID,  
 S_Enquiry_No,  
 S_First_Name,  
 S_Middle_Name,  
 S_Last_Name,  
 I_Gender_ID,  
 Dt_Birth_Date,  
 S_Mobile_No,  
 I_Blood_Group_ID,  
 I_Native_Language_ID,  
 I_Nationality_ID,  
 I_Religion_ID,  
 I_Caste_ID,  
 S_Email_ID,  
 S_Student_Photo as CandidatePhotoPath,  
 Enquiry_Date,  
 PreEnquiryDate,  
 S_Enquiry_No  
 FROM T_ERP_Enquiry_Regn_Detail WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID;  
  
  
  
 SELECT * INTO #Temp FROM T_ERP_Enquiry_Regn_Guardian_Master  WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID 
   
   --select * from #Temp where I_Relation_ID>=1 and I_Relation_ID<=2
   
  
 SELECT * INTO #FatherTable FROM #Temp WHERE I_Relation_ID = 1  
 SELECT * INTO #MotherTable FROM #Temp WHERE I_Relation_ID = 2  
 --SELECT * INTO #MotherTable FROM #Temp WHERE I_Relation_ID = 2  
  --select * from #FatherTable
  --select * from #MotherTable
  Declare @f_RelationID int,@m_RelationID int
  SET @f_RelationID=(Select top 1 I_Relation_ID from #FatherTable)
  SET @m_RelationID=(Select top 1 I_Relation_ID from #MotherTable)
  If  (@f_RelationID is not null and @m_RelationID is not null)
 --IF EXISTS (SELECT * FROM #Temp WHERE I_Relation_ID >= 1 OR I_Relation_ID <= 2)  
  BEGIN  
  SELECT   
  ft.I_Enquiry_Regn_ID,  
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
  ft.I_Enquiry_Regn_ID,  
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


  
  
  
 --SELECT   
 --ft.I_Enquiry_Regn_ID,  
 --ft.I_Relation_ID AS I_Father_Relation_ID,  
 --ft.S_Mobile_No AS S_Father_Mobile_No,  
 --ft.S_First_Name AS S_Father_First_Name,  
 --ft.S_Middile_Name AS S_Father_Middile_Name,  
 --ft.S_Last_Name AS S_Father_Last_Name,  
 --ft.S_Guardian_Email AS S_Father_Email_ID,  
 --ft.I_Qualification_ID AS I_Father_Qualification_ID,  
 --ft.I_Occupation_ID AS I_Father_Occupation_ID,  
 --ft.S_Company_Name AS S_Father_Company_Name,  
 --ft.S_Designation AS S_Father_Designation,  
 --ft.I_Income_Group_ID AS I_Father_Income_Group_ID,  
 --ft.S_Profile_Picture AS S_Father_Photo_Path,  
  
 --mt.I_Relation_ID AS I_Mother_Relation_ID,  
 --mt.S_Mobile_No AS S_Mother_Mobile_No,  
 --mt.S_First_Name AS S_Mother_First_Name,  
 --mt.S_Middile_Name AS S_Mother_Middile_Name,  
 --mt.S_Last_Name AS S_Mother_Last_Name,  
 --mt.S_Guardian_Email AS S_Mother_Email_ID,  
 --mt.I_Qualification_ID AS I_Mother_Qualification_ID,  
 --mt.I_Occupation_ID AS I_Mother_Occupation_ID,  
 --mt.S_Company_Name AS S_Mother_Company_Name,  
 --mt.S_Designation AS S_Mother_Designation,  
 --mt.I_Income_Group_ID AS I_Mother_Income_Group_ID,  
 --mt.S_Profile_Picture AS S_Mother_Photo_Path,  
  
  
 --TEERA.S_Address_Type,  
 --TEERA.S_Country_ID,  
 --TEERA.S_State_ID,  
 --TEERA.S_City_ID,  
 --TEERA.S_Address1,  
 --TEERA.S_Address2,  
 --TEERA.S_Pincode  
  
 --FROM #FatherTable ft    
 --INNER JOIN #MotherTable mt ON ft.I_Enquiry_Regn_ID = mt.I_Enquiry_Regn_ID  
 --INNER JOIN T_ERP_Enquiry_Regn_Address TEERA ON ft.I_Enquiry_Regn_ID = TEERA.I_Enquiry_Regn_ID  
   
  
  
 --SELECT * FROM T_ERP_Enquiry_Regn_Guardian_Master  
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
        ELSE 1   
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
        ELSE 1   
    END AS Is_Running_Stud,  
 TEPS.S_Passout_Year  
  
 FROM   
 T_ERP_Enquiry_Regn_Detail AS TEERD  
 inner join T_ERP_EnquiryReg_Prev_Details AS TEEPD ON TEERD.I_Enquiry_Regn_ID = TEEPD.R_I_Enquiry_Regn_ID  
 inner join T_ERP_PreEnq_Siblings AS TEPS ON TEERD.I_Enquiry_Regn_ID = TEPS.R_I_Enquiry_Regn_ID   
 WHERE TEERD.I_Enquiry_Regn_ID = @iEnquiryRegnID;  
END

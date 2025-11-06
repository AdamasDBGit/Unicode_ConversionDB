
   
CREATE PROCEDURE [STUDENTFEATURES].[uspUpdateStudentInformation]            
 @Centre INT ,    
 @iEnquiryStatus INT = NULL,    
 @iStudentDetailID  int,       
 @FirstName VARCHAR(50),                 
 @MiddleName VARCHAR(50)=NULL,            
 @LastName VARCHAR(50),            
 @dtDOB DATETIME,     
 @Age INT =NULL,      
 @casteID INT,    
 @iSex INT,    
 @iNativeLanguage INT,    
 @iNationality INT,    
 @iReligion INT,    
 @iMaritalStatus INT,    
 @iBloodGroup INT,    
 @sEmailID    varchar(200) = null,     
 @sPhoneNo    varchar(20) = null,                  
 @sMobileNo    varchar(500) = null,             
 @iScholarType INT,    
 @sSecondLanguageOpted VARCHAR(100),    
 @sStudentPhoto VARCHAR(500),     
                     
 @sGuardianName   varchar(200)=null,                  
 @iGuardianOccupationID int = null,                  
 @sGuardianEmailID  varchar(200) = null,                   
 @sGuardianPhoneNo  varchar(20) = null,                  
 @sGuardianMobileNo  varchar(500) = null,                  
 @iGuardianIncomeGroupID int=null,                  
 @sGuardianRelation VARCHAR(200),    
 @sGuardianAddress VARCHAR(2000),       
 @sFatherName VARCHAR(200),    
 @sMotherName VARCHAR(200),     
 @iFatherQualification INT,    
 @iFatherOccupation INT,    
 @iFatherBusinessType INT,    
 @sFatherCompany VARCHAR(200),    
 @sFatherDesignation VARCHAR(200),    
 @sFatherOfficePhone VARCHAR(20),    
 @sFatherOfficeAddress VARCHAR(2000),      
 @iFatherIncomeGroup INT,    
 @sFatherPhoto VARCHAR(500),    
 @iMotherQualification INT,    
 @iMotherOccupation INT,    
 @iMotherBusinessType INT,    
 @sMotherCompany VARCHAR(200),    
 @sMotherDesignation VARCHAR(200),    
 @sMotherOfficePhone VARCHAR(20),    
 @iMotherIncomeGroup INT,    
 @sMotherPhoto VARCHAR(500),    
 @sMotherOfficeAddress VARCHAR(2000),    
 @iMonthlyFamilyIncome INT,    
            
 @sCurrentAddress1  varchar(200)=null,                  
 @sCurrentAddress2  Varchar(200)=null,                  
 @iCurrentCountryID  int=null,                  
 @iCurrentStateID  int=null,                   
 @iCurrentCityID   int=null,                  
 @sCurrentArea   varchar(500)=null,                  
 @sCurrentPincode  Varchar(500)=null,                  
 @sPermanentAddress1  varchar(200)=null,                  
 @sPermanentAddress2  Varchar(200)=null,                  
 @iPermanentCountryID int=null,                  
 @iPermanentStateID  int=null,                   
 @iPermanentCityID  int=null,                  
 @sPermanentArea   varchar(500)=null,                  
 @sPermanentPincode  Varchar(500)=null,                  
 @sUser     Varchar(20)=null,                  
 @dDate     DATETIME,                   
 @sSiblingID VARCHAR(500),    
 @bCanSponsorEducation BIT,    
 @iResidenceArea INT ,    
 @iSeatType INT,    
 @iEnrolmentType INT,    
 @sEnrolmentNo VARCHAR(50),    
 @iRankObtained INT,    
 @sUniversityRegnNo VARCHAR(50),    
 @sUnivRollNo VARCHAR(50),    
 @sPhysicalAilment VARCHAR(200)  =NULL,     
 @sQualificationXML XML,  
 @iHouse  int=null,  
 @sAgent VARCHAR(50)  =NULL,  
 @dtSettledOnDate DATETIME = NULL,  
 @nSettledAmount NUMERIC(18, 2) = NULL ,
 @HasTakenLoan BIT=0,
 @DiscountType int=1
 --@sXRONumber VARCHAR(50),          
      

     
 --@CrtdBy VARCHAR(20) ,    
 --@DtCrtdOn DATETIME,       
 --@iCorporateID INT,    
 --@iCorporatePlanID INT,    
    
     
    
 -- @sPhysicalAilment VARCHAR(200)  =NULL,    
 -- @sQualificationXML XML       
                  
AS                  
BEGIN TRY                  
 -- SET NOCOUNT ON added to prevent extra result sets from                  
 -- interfering with SELECT statements.                  
 SET NOCOUNT ON                  
 --DECLARE @iCenterID int     
 DECLARE @iEnquiryRegnID int                 
 --   -- Update statements for procedure here                  
 --  SELECT @iCenterID = I_Center_Id FROM             
 --dbo.T_Center_Hierarchy_Details WHERE            
 --I_Hierarchy_Detail_ID = @Centre         
                 
  UPDATE dbo.T_Student_Detail                  
  SET                   
   S_Guardian_Name    =@sGuardianName,                  
   I_Guardian_Occupation_ID =@iGuardianOccupationID,                  
   S_Guardian_Email_ID   =@sGuardianEmailID,                  
   S_Guardian_Phone_No   =@sGuardianPhoneNo,                  
   S_Guardian_Mobile_No  =@sGuardianMobileNo,                  
   I_Income_Group_ID   =@iGuardianIncomeGroupID,                  
   S_Phone_No     =@sPhoneNo,                  
   S_Mobile_No     =@sMobileNo,                  
   S_Email_ID     =@sEmailID,                  
   S_Curr_Address1    =@sCurrentAddress1,                  
   S_Curr_Address2    =@sCurrentAddress2,                  
   I_Curr_Country_ID   =@iCurrentCountryID,                  
   I_Curr_State_ID    =@iCurrentStateID,                  
   I_Curr_City_ID    =@iCurrentCityID,                  
   S_Curr_Area     =@sCurrentArea,                  
   S_Curr_Pincode    =@sCurrentPincode,                  
   S_Perm_Address1    =@sPermanentAddress1,                  
   S_Perm_Address2    =@sPermanentAddress2,                  
   I_Perm_Country_ID   =@iPermanentCountryID,                  
   I_Perm_State_ID    =@iPermanentStateID,                  
   I_Perm_City_ID    =@iPermanentCityID,                  
   S_Perm_Area     =@sPermanentArea,                  
   S_Perm_Pincode    =@sPermanentPincode,                  
   S_Upd_By     =@sUser,                  
   Dt_Upd_On     =@dDate,            
   S_First_Name      =@FirstName,            
   S_Middle_Name =@MiddleName,            
   S_Last_Name =@LastName,            
   Dt_Birth_Date =@dtDOB  ,          
   S_Age = @Age     ,  
   I_House_ID=@iHouse,
   B_HasTakenLoan=@HasTakenLoan,
   I_DiscountType_ID=@DiscountType
  where I_Student_Detail_ID = @iStudentDetailID                 
                  
  UPDATE dbo.T_Enquiry_Regn_Detail           
  SET           
 I_Centre_Id = @Centre,    
 --I_Occupation_ID =@OccupationID,    
 --I_Pref_Career_ID  = @PrefCareerID,    
 I_Enquiry_Status_Code = ISNULL(@iEnquiryStatus,I_Enquiry_Status_Code),--sudipta da                           
 --I_Info_Source_ID = @InfoSourceID,            
 --I_Enquiry_Type_ID = @EnquiryTypeID,            
 --S_Is_Corporate = @IsCorporate,            
 --S_Enquiry_Desc = @EnquiryDesc,            
 --S_Title = @Title,            
 S_First_Name = @FirstName,            
 S_Middle_Name = @MiddleName,            
 S_Last_Name = @LastName,            
 Dt_Birth_Date = @dtDOB,            
 S_Age = @Age,            
 S_Student_Photo =@sStudentPhoto,                              
 --I_Qualification_Name_ID = @QualificationNameID,            
 --C_Skip_Test = @SkipTest,            
 --I_Stream_ID = @StreamID,            
 S_Email_ID = @sEmailID,            
 S_Phone_No = @sPhoneNo,            
 S_Mobile_No = @sMobileNo,            
 I_Curr_City_ID = @iCurrentCityID,            
 I_Curr_State_ID = @iCurrentStateID,            
 I_Curr_Country_ID = @iCurrentCountryID,            
 S_Guardian_Name = @sGuardianName,            
 I_Guardian_Occupation_ID = @iGuardianOccupationID,            
 S_Guardian_Email_ID = @sGuardianEmailID,            
 S_Guardian_Phone_No = @sGuardianPhoneNo,            
 S_Guardian_Mobile_No = @sGuardianMobileNo,            
 I_Income_Group_ID = @iMonthlyFamilyIncome,            
 S_Curr_Address1 = @sCurrentAddress1,            
 S_Curr_Address2 = @sCurrentAddress2,            
 S_Curr_Pincode = @sCurrentPincode,            
 S_Curr_Area = @sCurrentArea,            
 S_Perm_Address1 = @sPermanentAddress1,            
 S_Perm_Address2 = @sPermanentAddress2,            
 S_Perm_Pincode = @sPermanentPincode,            
 I_Perm_City_ID = @iPermanentCityID,            
 I_Perm_State_ID = @iPermanentStateID,            
 I_Perm_Country_ID = @iPermanentCountryID,            
 S_Perm_Area = @sPermanentArea,     
 I_Residence_Area_ID=@iResidenceArea,           
 S_Upd_By = ISNULL(@sUser, S_Upd_By),                                              
 Dt_Upd_On = @dDate,           
 --I_Corporate_ID = @iCorporateID,         
 --I_Corporate_Plan_ID = @iCorporatePlanID,                                                       
 I_Caste_ID = @CasteID,                    
 S_Father_Name =@sFatherName,    
 S_Mother_Name =@sMotherName,    
 --B_IsPreEnquiry =@bIsPreEnquiry,    
 I_Sex_ID =@iSex,    
 I_Native_Language_ID =@iNativeLanguage,    
 I_Nationality_ID =@iNationality,    
 I_Religion_ID =@iReligion,    
 I_Marital_Status_ID =@iMaritalStatus,    
 I_Blood_Group_ID =@iBloodGroup,    
 I_Father_Qualification_ID =@iFatherQualification,    
 I_Father_Occupation_ID =@iFatherOccupation,    
 I_Father_Business_Type_ID =@iFatherBusinessType,    
 S_Father_Company_Name =@sFatherCompany,    
 S_Father_Designation =@sFatherDesignation,    
 S_Father_Office_Phone =@sFatherOfficePhone,    
 I_Father_Income_Group_ID =@iFatherIncomeGroup,    
 S_Father_Photo =@sFatherPhoto,    
 S_Father_Office_Address =@sFatherOfficeAddress,    
 I_Mother_Qualification_ID =@iMotherQualification,    
 I_Mother_Occupation_ID =@iMotherOccupation,    
 I_Mother_Business_Type_ID =@iMotherBusinessType,    
 S_Mother_Designation =@sMotherDesignation,    
 S_Mother_Company_Name =@sMotherCompany,    
 S_Mother_Office_Address =@sMotherOfficeAddress,    
 S_Mother_Office_Phone =@sMotherOfficePhone,    
 I_Mother_Income_Group_ID =@iMotherIncomeGroup,    
 S_Mother_Photo =@sMotherPhoto,    
 S_Guardian_Relationship =@sGuardianRelation,    
 S_Guardian_Address =@sGuardianAddress,    
 I_Monthly_Family_Income_ID =@iMonthlyFamilyIncome,    
 B_Can_Sponsor_Education =@bCanSponsorEducation,    
 S_Sibling_ID =@sSiblingID,    
     
     
 I_Seat_Type_ID =@iSeatType,    
 I_Enrolment_Type_ID =@iEnrolmentType,    
 S_Enrolment_No =@sEnrolmentNo,    
 I_Rank_Obtained =@iRankObtained,    
 S_Univ_Registration_No =@sUniversityRegnNo,    
 S_Univ_Roll_No =@sUnivRollNo,    
 I_Scholar_Type_ID=@iScholarType,    
 S_Second_Language_Opted=@sSecondLanguageOpted,    
 S_Physical_Ailment=@sPhysicalAilment     
 --WHERE I_Enquiry_Regn_ID = @iEnquiryID                   
  WHERE I_Enquiry_Regn_ID IN (SELECT I_Enquiry_Regn_ID FROM dbo.T_Student_Detail WHERE I_Student_Detail_ID = @iStudentDetailID)                
                
  UPDATE dbo.T_User_Master SET S_First_Name = @FirstName,S_Middle_Name = @MiddleName,S_Last_Name = @LastName, S_Email_ID = @sEmailID WHERE I_Reference_ID = @iStudentDetailID AND S_User_Type = 'ST'              
     
--Delete enquiry Qualification Information    
 SELECT @iEnquiryRegnID = I_Enquiry_Regn_ID FROM             
 dbo.T_Student_Detail WHERE            
 I_Student_Detail_ID = @iStudentDetailID           
     
 DELETE FROM dbo.T_Enquiry_Qualification_Details            
 WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID    
      
--Update enquiry Qualification Information       
 INSERT INTO dbo.T_Enquiry_Qualification_Details    
           ( I_Enquiry_Regn_ID ,    
             S_Name_Of_Exam ,    
             S_University_Name ,    
             S_Year_From ,    
             S_Year_To ,    
             S_Subject_Name ,    
             N_Marks_Obtained ,    
             N_Percentage ,    
             S_Division ,    
             I_Status ,    
             S_Crtd_By ,    
             Dt_Crtd_On    
           )    
 SELECT  @iEnquiryRegnID, T.c.value('@S_Name_Of_Exam', 'varchar(200)') ,    
                             T.c.value('@S_University_Name', 'varchar(200)') ,    
        T.c.value('@S_Year_From', 'varchar(4)') ,    
           T.c.value('@S_Year_To', 'varchar(4)') ,    
        T.c.value('@S_Subject_Name', 'varchar(200)') ,    
        T.c.value('@N_Marks_Obtained', 'decimal(18,2)') ,    
        T.c.value('@N_Percentage', 'decimal(18, 2)') ,    
        T.c.value('@S_Division', 'varchar(50)') ,1,@sUser,@dDate    
    FROM    @sQualificationXML.nodes('/Root/Qualification') T ( c )   
      
  IF(@sAgent is not null)  
  begin  
 INSERT INTO dbo.T_APAI_Information  
 ( I_Student_Detail_ID ,    
      S_Agent_Name ,    
      Dt_Settled_On ,    
      N_Amount ,  
      S_Crtd_By ,    
      Dt_Crtd_On ,  
      I_Status      
    )values(@iStudentDetailID,@sAgent,@dtSettledOnDate,@nSettledAmount,@sUser,@dDate,1)  
      
    UPDATE dbo.T_Student_Detail                  
 SET B_Is_APAI_Acc_Settled    = 1  
 WHERE I_Student_Detail_ID = @iStudentDetailID  
  END
  
  EXEC LMS.uspUpdateStudentInfo @iStudentDetailID,@sMobileNo,@sUser
                      
END TRY                  
BEGIN CATCH                  
 --Error occurred:                    
                  
 DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int                  
 SELECT @ErrMsg = ERROR_MESSAGE(),                  
   @ErrSeverity = ERROR_SEVERITY()                  
                  
 RAISERROR(@ErrMsg, @ErrSeverity, 1)                  
END CATCH

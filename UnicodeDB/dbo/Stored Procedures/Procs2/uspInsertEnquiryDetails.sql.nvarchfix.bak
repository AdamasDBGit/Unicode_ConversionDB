CREATE PROCEDURE [dbo].[uspInsertEnquiryDetails]    
    (    
   @iEnquiryID INT = NULL,    
      @Centre INT ,    
      @OccupationID INT =NULL,    
      @PrefCareerID INT =NULL,    
      @InfoSourceID INT =NULL,    
      @EnquiryTypeID INT =NULL,    
      @IsCorporate Nnvarchar(max) =NULL,    
      @EnquiryDesc Nnvarchar(max) =NULL,    
      @Title Nnvarchar(max) =NULL,    
      @FirstName Nnvarchar(max) ,    
      @MiddleName Nnvarchar(max) =NULL,    
      @LastName Nnvarchar(max) ,    
      @DtBirthDate DATETIME ,    
      @Age Nnvarchar(max) ,    
      @casteID INT =NULL,    
      @QualificationNameID INT =NULL,    
      @SkipTest CHAR(1) =NULL,    
      @StreamID INT =NULL,    
      @EmailID Nnvarchar(max) =NULL,    
      @PhoneNo Nnvarchar(max) =NULL,    
      @MobileNo Nnvarchar(max) =NULL,    
      @CurrCityID INT =NULL,    
      @CurrStateID INT =NULL,    
      @CurrCountryID INT =NULL,    
      @GuardianName Nnvarchar(max) =NULL,    
      @GuardianOccupationID INT =NULL,    
      @GuardianEmailID Nnvarchar(max) =NULL,    
      @GuardianPhoneNo Nnvarchar(max) =NULL,    
      @GuardianMobileNo Nnvarchar(max) =NULL,    
      @IncomeGroupID INT =NULL,    
      @CurrAddress1 Nnvarchar(max) =NULL,    
      @CurrAddress2 Nnvarchar(max) =NULL,    
      @CurrPincode Nnvarchar(max) =NULL,    
      @CurrArea Nnvarchar(max) =NULL,    
      @PermAddress1 Nnvarchar(max) =NULL,    
      @PermAddress2 Nnvarchar(max) =NULL,    
      @PermPincode Nnvarchar(max) =NULL,    
      @PermCityID INT =NULL,    
      @PermStateID INT =NULL,    
      @PermCountryID INT =NULL,    
      @PermArea Nnvarchar(max) =NULL,    
      @CrtdBy Nnvarchar(max) ,    
      @DtCrtdOn DATETIME ,    
      @sSelectedCourseID Nnvarchar(max) =NULL,    
      @dtFirstFollowUpDate DATETIME =NULL,    
      @iCorporateID INT =NULL,    
      @iCorporatePlanID INT =NULL,    
      @sStudentPhoto Nnvarchar(max) = NULL,    
      @iResidenceArea INT = NULL,    
      @sFatherName Nnvarchar(max) = NULL,    
      @sMotherName Nnvarchar(max) = NULL,    
      @iSex INT = NULL,    
      @iNativeLanguage INT = NULL,    
      @iNationality INT = NULL,    
      @iReligion INT = NULL,    
      @iMaritalStatus INT= NULL,    
      @iBloodGroup INT = NULL,    
      @iFatherQualification INT = NULL,    
      @iFatherOccupation INT = NULL,    
      @iFatherBusinessType INT = NULL,    
      @sFatherCompany Nnvarchar(max) = NULL,    
      @sFatherDesignation Nnvarchar(max) = NULL,    
      @sFatherOfficePhone Nnvarchar(max) = NULL,    
      @iFatherIncomeGroup INT = NULL,    
      @sFatherPhoto Nnvarchar(max) = NULL,    
      @sFatherOfficeAddress Nnvarchar(max) = NULL,    
      @iMotherQualification INT = NULL,    
      @iMotherOccupation INT = NULL,    
      @iMotherBusinessType INT = NULL,    
      @sMotherCompany Nnvarchar(max) = NULL,    
      @sMotherDesignation Nnvarchar(max) = NULL,    
      @sMotherOfficePhone Nnvarchar(max) = NULL,    
      @iMotherIncomeGroup INT = NULL,    
      @sMotherPhoto Nnvarchar(max) = NULL,    
      @sMotherOfficeAddress Nnvarchar(max) = NULL,    
      @sGuardianRelation Nnvarchar(max)  =NULL,    
      @sGuardianAddress Nnvarchar(max) = NULL,    
      @iMonthlyFamilyIncome INT = NULL,    
      @bCanSponsorEducation BIT = NULL,    
      @sSiblingID Nnvarchar(max) =NULL,    
      @bHasGivenOtherExam BIT = NULL,    
      @iNoOfAttempts INT = NULL,    
      @sOtherInstitute Nnvarchar(max) = NULL,    
      @nDuration DECIMAL(18,2) = NULL,    
      @iSeatType INT = NULL,    
      @iEnrolmentType INT = NULL,    
      @sEnrolmentNo Nnvarchar(max) = NULL,    
      @iRankObtained INT = NULL,    
      @sUniversityRegnNo Nnvarchar(max) = NULL,    
      @sUnivRollNo Nnvarchar(max) = NULL,    
      @iScholarType INT = NULL,    
      @sSecondLanguageOpted Nnvarchar(max) = NULL,    
      @sQualificationXML XML = NULL,    
      @sPhysicalAilment Nnvarchar(max)  =NULL,  
      @IsLateral BIT = NULL,
      @EducationCurrentStatus INT = NULL ,
      @EducationStream INT = NULL ,
      @EducationPostGrad INT = NULL ,
      @IndustryType INT = NULL ,
      @ITSkills INT = NULL ,
      @YrsofExp Nnvarchar(max) = NULL ,
      @JobRole Nnvarchar(max) = NULL ,
      @JobSalary Nnvarchar(max) = NULL ,
      @sSelectedAimID Nnvarchar(max) = NULL ,
      @sSelectedFocusID Nnvarchar(max) = NULL ,
      @sReferenceXML XML=NULL,
      @sFeedbackXML XML=NULL,
      @TestScore Nnvarchar(max)=NULL  
    )    
AS     
    BEGIN TRY                
        SET NOCOUNT OFF ;                
                
        DECLARE @iGetCourseIndex INT                
        DECLARE @iCourseListLength INT                
        DECLARE @iCourseID INT                
        DECLARE @sSelectedCourseIDs nvarchar(max)                
        --DECLARE @iEnquiryID INT                
        DECLARE @iCenterID INT                
        DECLARE @iEmployeeId INT           
                
        BEGIN TRANSACTION                
             
   IF ( SELECT  COUNT(*)    
         FROM    dbo.T_Enquiry_Regn_Detail    
         WHERE    I_Centre_Id=  @Centre AND S_Mobile_No = @MobileNo ) = 0   
         BEGIN    
              
    -- Insert the Enquiry Details                
                    
                INSERT INTO dbo.T_Enquiry_Regn_Detail    
                        ( I_Centre_Id ,    
                          I_Occupation_ID ,    
                          I_Pref_Career_ID ,    
                          I_Enquiry_Status_Code ,    
                          I_Info_Source_ID ,    
                          I_Enquiry_Type_ID ,    
                          S_Is_Corporate ,    
                          S_Enquiry_Desc ,    
                          S_Title ,    
                          S_First_Name ,    
                          S_Middle_Name ,    
                          S_Last_Name ,    
                          Dt_Birth_Date ,    
                          S_Age ,    
                          S_Student_Photo ,    
                          I_Qualification_Name_ID ,    
                          C_Skip_Test ,    
                          I_Stream_ID ,    
                          S_Email_ID ,    
                          S_Phone_No ,    
                          S_Mobile_No ,    
                          I_Curr_City_ID ,    
                          I_Curr_State_ID ,    
                          I_Curr_Country_ID ,    
                          S_Guardian_Name ,    
                          I_Guardian_Occupation_ID ,    
                          S_Guardian_Email_ID ,    
                          S_Guardian_Phone_No ,    
                          S_Guardian_Mobile_No ,    
                          I_Income_Group_ID ,    
                          S_Curr_Address1 ,    
                          S_Curr_Address2 ,    
                          S_Curr_Pincode ,    
                          S_Curr_Area ,    
                          S_Perm_Address1 ,    
                          S_Perm_Address2 ,    
                          S_Perm_Pincode ,    
                          I_Perm_City_ID ,    
                          I_Perm_State_ID ,    
                          I_Perm_Country_ID ,    
                          S_Perm_Area ,    
                          I_Residence_Area_ID ,    
                          S_Crtd_By ,    
                          Dt_Crtd_On ,    
                          I_Corporate_ID ,    
                          I_Corporate_Plan_ID ,    
                          I_Caste_ID ,    
                          S_Father_Name ,    
                          S_Mother_Name ,    
                          B_IsPreEnquiry ,    
                          I_Sex_ID ,    
                          I_Native_Language_ID ,    
                          I_Nationality_ID ,    
                          I_Religion_ID ,    
                          I_Marital_Status_ID ,    
                          I_Blood_Group_ID ,    
                          I_Father_Qualification_ID ,    
                          I_Father_Occupation_ID ,    
                          I_Father_Business_Type_ID ,    
                          S_Father_Company_Name ,    
                          S_Father_Designation ,    
                          S_Father_Office_Phone ,    
                          I_Father_Income_Group_ID ,    
                          S_Father_Photo ,    
                          S_Father_Office_Address ,    
                          I_Mother_Qualification_ID ,    
                          I_Mother_Occupation_ID ,    
                          I_Mother_Business_Type_ID ,    
                          S_Mother_Designation ,    
                          S_Mother_Company_Name ,    
  S_Mother_Office_Address ,    
                          S_Mother_Office_Phone ,    
                          I_Mother_Income_Group_ID ,    
                          S_Mother_Photo ,    
                          S_Guardian_Relationship ,    
                          S_Guardian_Address ,    
                          I_Monthly_Family_Income_ID ,    
                          B_Can_Sponsor_Education ,    
                          S_Sibling_ID ,    
                          B_Has_Given_Exam ,    
                          I_Attempts ,    
                          S_Other_Institute ,    
                          N_Duration ,    
                          I_Seat_Type_ID ,    
                          I_Enrolment_Type_ID ,    
                          S_Enrolment_No ,    
                          I_Rank_Obtained ,    
                          S_Univ_Registration_No ,    
                          S_Univ_Roll_No ,    
                          I_Scholar_Type_ID,    
                          S_Second_Language_Opted,    
                          S_Physical_Ailment,  
                          B_IsLateral,
                          N_Test_Score    
                        )    
                VALUES  ( @Centre , -- I_Centre_Id - int    
                          @OccupationID , -- I_Occupation_ID - int    
                          @PrefCareerID , -- I_Pref_Career_ID - int    
                          1 , -- I_Enquiry_Status_Code - int    
                          @InfoSourceID , -- I_Info_Source_ID - int    
                          @EnquiryTypeID , -- I_Enquiry_Type_ID - int    
                          @IsCorporate , -- S_Is_Corporate - nvarchar(max)    
                          @EnquiryDesc , -- S_Enquiry_Desc - nvarchar(max)    
                          @Title , -- S_Title - nvarchar(max)    
                          @FirstName , -- S_First_Name - nvarchar(max)    
                          @MiddleName , -- S_Middle_Name - nvarchar(max)    
                          @LastName , -- S_Last_Name - nvarchar(max)    
                          @DtBirthDate , -- Dt_Birth_Date - datetime    
                          @Age , -- S_Age - nvarchar(max)    
                          @sStudentPhoto  , -- S_Student_Photo - nvarchar(max)    
                          @QualificationNameID  , -- I_Qualification_Name_ID - int    
                          @SkipTest , -- C_Skip_Test - char(1)    
                          @StreamID , -- I_Stream_ID - int    
                          @EmailID  , -- S_Email_ID - nvarchar(max)    
                          @PhoneNo , -- S_Phone_No - nvarchar(max)    
                          @MobileNo , -- S_Mobile_No - nvarchar(max)    
                          @CurrCityID , -- I_Curr_City_ID - int    
                          @CurrStateID , -- I_Curr_State_ID - int    
                          @CurrCountryID , -- I_Curr_Country_ID - int    
                          @GuardianName , -- S_Guardian_Name - nvarchar(max)    
                          @GuardianOccupationID , -- I_Guardian_Occupation_ID - int    
                          @GuardianEmailID , -- S_Guardian_Email_ID - nvarchar(max)    
                          @GuardianPhoneNo , -- S_Guardian_Phone_No - nvarchar(max)    
                          @GuardianMobileNo , -- S_Guardian_Mobile_No - nvarchar(max)    
                          @IncomeGroupID , -- I_Income_Group_ID - int    
                          @CurrAddress1 , -- S_Curr_Address1 - nvarchar(max)    
                          @CurrAddress2 , -- S_Curr_Address2 - nvarchar(max)    
                          @CurrPincode , -- S_Curr_Pincode - nvarchar(max)    
                          @CurrArea , -- S_Curr_Area - nvarchar(max)    
                          @PermAddress1 , -- S_Perm_Address1 - nvarchar(max)    
                          @PermAddress2 , -- S_Perm_Address2 - nvarchar(max)    
                          @PermPincode , -- S_Perm_Pincode - nvarchar(max)    
                          @PermCityID , -- I_Perm_City_ID - int    
                          @PermStateID , -- I_Perm_State_ID - int    
                   @PermCountryID , -- I_Perm_Country_ID - int    
                          @PermArea , -- S_Perm_Area - nvarchar(max)    
                          @iResidenceArea  , -- I_Residence_Area_ID - int    
                          @CrtdBy  , -- S_Crtd_By - nvarchar(max)    
                    @DtCrtdOn , -- Dt_Crtd_On - datetime    
                          @iCorporateID , -- I_Corporate_ID - int    
                          @iCorporatePlanID , -- I_Corporate_Plan_ID - int    
                          @casteID  , -- I_Caste_ID - int    
                          @sFatherName , -- S_Father_Name - nvarchar(max)    
                          @sMotherName , -- S_Mother_Name - nvarchar(max)    
                          0 , -- B_IsPreEnquiry - bit    
                          @iSex , -- I_Sex_ID - int    
                          @iNativeLanguage  , -- I_Native_Language_ID - int    
                          @iNationality , -- I_Nationality_ID - int    
                          @iReligion , -- I_Religion_ID - int    
                          @iMaritalStatus , -- I_Marital_Status_ID - int    
                          @iBloodGroup , -- I_Blood_Group_ID - int    
                          @iFatherQualification , -- I_Father_Qualification_ID - int    
                          @iFatherOccupation , -- I_Father_Occupation_ID - int    
                          @iFatherBusinessType , -- I_Father_Business_Type_ID - int    
                          @sFatherCompany , -- S_Father_Company_Name - nvarchar(max)    
                          @sFatherDesignation , -- S_Father_Designation - nvarchar(max)    
                          @sFatherOfficePhone , -- S_Father_Office_Phone - nvarchar(max)    
                          @iFatherIncomeGroup , -- I_Father_Income_Group_ID - int    
                          @sFatherPhoto , -- S_Father_Photo - nvarchar(max)    
                          @sFatherOfficeAddress , -- S_Father_Office_Address - nvarchar(max)    
                          @iMotherQualification , -- I_Mother_Qualification_ID - int    
                          @iMotherOccupation , -- I_Mother_Occupation_ID - int    
                          @iMotherBusinessType , -- I_Mother_Business_Type_ID - int    
                          @sMotherDesignation , -- S_Mother_Designation - nvarchar(max)    
                          @sMotherCompany , -- S_Mother_Company_Name - nvarchar(max)    
                          @sMotherOfficeAddress , -- S_Mother_Office_Address - nvarchar(max)    
                          @sMotherOfficePhone , -- S_Mother_Office_Phone - nvarchar(max)    
                          @iMotherIncomeGroup , -- I_Mother_Income_Group_ID - int    
                          @sMotherPhoto , -- S_Mother_Photo - nvarchar(max)    
                          @sGuardianRelation , -- S_Guardian_Relationship - nvarchar(max)    
                          @sGuardianAddress , -- S_Guardian_Address - nvarchar(max)    
                          @iMonthlyFamilyIncome , -- I_Monthly_Family_Income_ID - int    
                          @bCanSponsorEducation , -- B_Can_Sponsor_Education - bit    
                          @sSiblingID , -- S_Sibling_ID - nvarchar(max)    
                          @bHasGivenOtherExam , -- B_Has_Given_Exam - bit    
                          @iNoOfAttempts , -- I_Attempts - int    
                          @sOtherInstitute , -- S_Other_Institute - nvarchar(max)    
                          @nDuration , -- N_Duration - decimal    
                          @iSeatType , -- I_Seat_Type_ID - int    
                          @iEnrolmentType , -- I_Enrolment_Type_ID - int    
                          @sEnrolmentNo , -- S_Enrolment_No - nvarchar(max)    
                          @iRankObtained , -- I_Rank_Obtained - int    
                          @sUniversityRegnNo , -- S_Univ_Registration_No - nvarchar(max)    
                          @sUnivRollNo , -- S_Univ_Roll_No - nvarchar(max)    
                          @iScholarType,  -- I_Scholar_Type_ID - int    
             @sSecondLanguageOpted,    
                          @sPhysicalAilment,  
                          @IsLateral,
                          CAST(@TestScore AS DECIMAL(14,1))    
                        )               
                
                SELECT  @iEnquiryID = SCOPE_IDENTITY()                 
                    
                UPDATE  dbo.T_Enquiry_Regn_Detail    
                SET     S_Enquiry_No = CAST(@iEnquiryID AS VARCHAR(20))    
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID                
           
    
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
    SELECT  @iEnquiryID,T.c.value('@S_Name_Of_Exam', 'nvarchar(max)') ,    
                        T.c.value('@S_University_Name', 'nvarchar(max)') ,    
                        T.c.value('@S_Year_From', 'nvarchar(max)') ,    
                        T.c.value('@S_Year_To', 'nvarchar(max)') ,    
                        T.c.value('@S_Subject_Name', 'nvarchar(max)') ,    
                        T.c.value('@N_Marks_Obtained', 'decimal(18,2)') ,    
                        T.c.value('@N_Percentage', 'decimal(18, 2)') ,    
                        T.c.value('@S_Division', 'nvarchar(max)') ,1,@CrtdBy,@DtCrtdOn    
                FROM    @sQualificationXML.nodes('/Root/Qualification') T ( c )
                
                
                --akash
                                INSERT  INTO dbo.T_Enquiry_Aim
                        ( I_Aim_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On ,
                          I_Enquiry_Regn_ID  
                          
                        )
                        SELECT  * , -- I_Aim_ID - int
                                @CrtdBy , -- S_Crtd_By - nvarchar(max)
                                @DtCrtdOn ,
                                @iEnquiryID
                        FROM    dbo.fnString2Rows(@sSelectedAimID, ',') FSR 
                        
                        INSERT  INTO dbo.T_Enquiry_Counseling_Focus
                        ( I_Counseling_Focus_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On ,
                          I_Enquiry_Regn_ID  
                          
                        )
                        SELECT  * , -- I_Counseling_Focus_ID - int
                                @CrtdBy , -- S_Crtd_By - nvarchar(max)
                                @DtCrtdOn ,
                                @iEnquiryID
                        FROM    dbo.fnString2Rows(@sSelectedFocusID, ',') FSR
                        
                        INSERT  INTO dbo.T_Enquiry_Education_CurrentStatus
                        ( I_Enquiry_Regn_ID ,
                          I_Education_CurrentStatus_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On 
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @EducationCurrentStatus , -- I_Education_CurrentStatus_ID - int
                          @CrtdBy , -- S_Crtd_By - nvarchar(max)
                          @DtCrtdOn -- Dt_Crtd_On - datetime
           
                        )
                        
                        INSERT  INTO dbo.T_Enquiry_Education_Stream
                        ( I_Enquiry_Regn_ID ,
                          I_Education_Stream_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @EducationStream , -- I_Education_Stream_ID - int
                          @CrtdBy , -- S_Crtd_By - nvarchar(max)
                          @DtCrtdOn  -- Dt_Crtd_On - datetime
            
                        )
                        
                        INSERT  INTO dbo.T_Enquiry_Education_Qualification
                        ( I_Enquiry_Regn_ID ,
                          I_Education_Qualification_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @EducationPostGrad , -- I_Education_Qualification_ID - int
                          @CrtdBy , -- S_Crtd_By - nvarchar(max)
                          @DtCrtdOn  -- Dt_Crtd_On - datetime
            
                        )
                        
                        INSERT  INTO dbo.T_Enquiry_Employment_Details
                        ( I_Enquiry_Regn_ID ,
                          I_Employment_Details_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @IndustryType , -- I_Employment_Details_ID - int
                          @CrtdBy , -- S_Crtd_By - nvarchar(max)
                          @DtCrtdOn  -- Dt_Crtd_On - datetime
            
                        )       
                        
                                        UPDATE  dbo.T_Enquiry_Employment_Details
                SET     S_Experience = @YrsofExp
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID
                UPDATE  dbo.T_Enquiry_Employment_Details
                SET     S_Role = @JobRole
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID
                UPDATE  dbo.T_Enquiry_Employment_Details
                SET     S_Salary = @JobSalary
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID
                
                INSERT  INTO dbo.T_Enquiry_IT_Skills
                        ( I_Enquiry_Regn_ID ,
                          I_IT_Skills_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @ITSkills , -- I_IT_Skills_ID - int
                          @CrtdBy , -- S_Crtd_By - nvarchar(max)
                          @DtCrtdOn -- Dt_Crtd_On - datetime
           
                        )
                        
                        INSERT  INTO dbo.T_Enquiry_Reference_Details
                        ( I_Enquiry_Regn_ID ,
                          S_Name ,
                          S_Contact_No ,
                          S_Address
                        )
                        SELECT  @iEnquiryID ,
                                T.c.value('@S_Name', 'nvarchar(max)') ,
                                T.c.value('@S_Contact_No', 'nvarchar(max)') ,
                                T.c.value('@S_Address', 'nvarchar(max)')
                        FROM    @sReferenceXML.nodes('/Root/Reference') T ( c )
                        
                        INSERT  INTO dbo.T_Enquiry_PostCounselling_Feedback_Details
                        ( I_Enquiry_Regn_ID ,
                          S_Question ,
                          I_Points
                        )
                        SELECT  @iEnquiryID ,
                                T.c.value('@S_Question', 'nvarchar(max)') ,
                                CAST(T.c.value('@S_Points', 'varchar(MAX)') AS INT)
                        FROM    @sFeedbackXML.nodes('/Root/Feedback') T ( c ) 
                        
                        
                --akash     
                    
                
    -- Update the Courses for the Enquiry                
                INSERT  INTO dbo.T_Enquiry_Course    
                        ( I_Course_ID ,    
                          I_Enquiry_Regn_ID    
                        )    
                        SELECT  * ,    
                                @iEnquiryID    
                        FROM    dbo.fnString2Rows(@sSelectedCourseID, ',')                
                
    -- Get the Employee Id of the Councellor                 
                SELECT  @iEmployeeId = I_Employee_ID    
                FROM    dbo.T_Employee_Dtls    
                WHERE   I_Employee_ID = ( SELECT    I_Reference_ID    
                                          FROM      dbo.T_User_Master    
                                          WHERE     S_Login_ID = @CrtdBy    
                                        )                
                   
    -- Update the first followup information for the enquiry                
                INSERT  INTO dbo.T_Enquiry_Regn_FollowUp    
                        ( I_Enquiry_Regn_ID ,    
                          I_Employee_ID ,    
                          Dt_Followup_Date ,    
                          Dt_Next_Followup_Date ,    
                          S_Followup_Remarks    
                        )    
                VALUES  ( @iEnquiryID ,    
                          @iEmployeeId ,    
                          @DtCrtdOn ,    
                          @dtFirstFollowUpDate ,    
                          'First FollowUp after Enquiry'                  
                        )                
                   
                SELECT  @iEnquiryID AS EnquiryNumber     
         END    
         ELSE     
         BEGIN    
             RAISERROR('Entry with the same mobile no. already exists',11,1)    
         END                
                            
        COMMIT TRANSACTION                
    END TRY                
    BEGIN CATCH                
 --Error occurred:                  
        ROLLBACK TRANSACTION                 
        DECLARE @ErrMsg Nnvarchar(max) ,    
            @ErrSeverity INT                
        SELECT  @ErrMsg = ERROR_MESSAGE() ,    
                @ErrSeverity = ERROR_SEVERITY()                
                
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                
    END CATCH


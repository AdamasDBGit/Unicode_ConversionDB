

CREATE PROCEDURE [dbo].[uspUpdateEnquiryDetails_BKP_BeforeRefer_Nov_2023]
    (
      @iEnquiryID INT ,
      @Centre INT ,
      @OccupationID INT ,
      @PrefCareerID INT ,
      @iEnquiryStatus INT = NULL ,
      @InfoSourceID INT ,
      @EnquiryTypeID INT ,
      @IsCorporate VARCHAR(20) ,
      @EnquiryDesc VARCHAR(500) ,
      @Title VARCHAR(10) ,
      @FirstName VARCHAR(50) ,
      @MiddleName VARCHAR(50) ,
      @LastName VARCHAR(50) ,
      @DtBirthDate DATETIME ,
      @Age VARCHAR(20) ,
      @casteID INT ,
      @QualificationNameID INT ,
      @SkipTest CHAR(1) ,
      @StreamID INT ,
      @EmailID VARCHAR(200) ,
      @PhoneNo VARCHAR(20) ,
      @MobileNo VARCHAR(20) ,
      @CurrCityID INT ,
      @CurrStateID INT ,
      @CurrCountryID INT ,
      @GuardianName VARCHAR(200) ,
      @GuardianOccupationID INT ,
      @GuardianEmailID VARCHAR(200) ,
      @GuardianPhoneNo VARCHAR(20) ,
      @GuardianMobileNo VARCHAR(20) ,
      @IncomeGroupID INT ,
      @CurrAddress1 VARCHAR(200) ,
      @CurrAddress2 VARCHAR(200) = NULL ,
      @CurrPincode VARCHAR(20) ,
      @CurrArea VARCHAR(20) ,
      @PermAddress1 VARCHAR(200) ,
      @PermAddress2 VARCHAR(200) = NULL ,
      @PermPincode VARCHAR(20) ,
      @PermCityID INT ,
      @PermStateID INT ,
      @PermCountryID INT ,
      @PermArea VARCHAR(20) ,
      @CrtdBy VARCHAR(20) ,
      @DtCrtdOn DATETIME ,
      @sSelectedCourseID VARCHAR(100) ,
      @dtFirstFollowUpDate DATETIME ,
      @iCorporateID INT ,
      @iCorporatePlanID INT ,
      @sStudentPhoto VARCHAR(500) ,
      @iResidenceArea INT ,
      @sFatherName VARCHAR(200) ,
      @sMotherName VARCHAR(200) ,    
      --@bIsPreEnquiry bit,    
      @iSex INT ,
      @iNativeLanguage INT ,
      @iNationality INT ,
      @iReligion INT ,
      @iMaritalStatus INT ,
      @iBloodGroup INT ,
      @iFatherQualification INT ,
      @iFatherOccupation INT ,
      @iFatherBusinessType INT ,
      @sFatherCompany VARCHAR(200) ,
      @sFatherDesignation VARCHAR(200) ,
      @sFatherOfficePhone VARCHAR(20) ,
      @iFatherIncomeGroup INT ,
      @sFatherPhoto VARCHAR(500) ,
      @sFatherOfficeAddress VARCHAR(2000) ,
      @iMotherQualification INT ,
      @iMotherOccupation INT ,
      @iMotherBusinessType INT ,
      @sMotherCompany VARCHAR(200) ,
      @sMotherDesignation VARCHAR(200) ,
      @sMotherOfficePhone VARCHAR(20) ,
      @iMotherIncomeGroup INT ,
      @sMotherPhoto VARCHAR(500) ,
      @sMotherOfficeAddress VARCHAR(2000) ,
      @sGuardianRelation VARCHAR(200) ,
      @sGuardianAddress VARCHAR(2000) ,
      @iMonthlyFamilyIncome INT ,
      @bCanSponsorEducation BIT ,
      @sSiblingID VARCHAR(500) ,
      @bHasGivenOtherExam BIT ,
      @iNoOfAttempts INT ,
      @sOtherInstitute VARCHAR(50) ,
      @nDuration DECIMAL(18, 2) ,
      @iSeatType INT ,
      @iEnrolmentType INT ,
      @sEnrolmentNo VARCHAR(50) ,
      @iRankObtained INT ,
      @sUniversityRegnNo VARCHAR(50) ,
      @sUnivRollNo VARCHAR(50) ,
      @iScholarType INT ,
      @sSecondLanguageOpted VARCHAR(100) ,
      @sPhysicalAilment VARCHAR(200) = NULL ,
      @sQualificationXML XML ,
      @iPreEnquiryUpdate INT = NULL ,
      @IsLateral BIT = NULL ,
      @EducationCurrentStatus INT = NULL ,
      @EducationStream INT = NULL ,
      @EducationPostGrad INT = NULL ,
      @IndustryType INT = NULL ,
      @ITSkills INT = NULL ,
      @YrsofExp VARCHAR(3) = NULL ,
      @JobRole VARCHAR(MAX) = NULL ,
      @JobSalary VARCHAR(10) = NULL ,
      @sSelectedAimID VARCHAR(100) = NULL ,
      @sSelectedFocusID VARCHAR(100) = NULL ,
      @sReferenceXML XML = NULL ,
      @sFeedbackXML XML = NULL ,
      @TestScore VARCHAR(10) = NULL
    )
AS
    BEGIN TRY            
        SET NOCOUNT OFF;            
            
        DECLARE @iGetCourseIndex INT            
        DECLARE @iCourseListLength INT            
        DECLARE @iCourseID INT            
        DECLARE @sSelectedCourseIDs VARCHAR(100)            
        DECLARE @iCenterID INT    
        DECLARE @iEmployeeId INT            
             
        BEGIN TRANSACTION     
        IF ( SELECT COUNT(*)
             FROM   dbo.T_Enquiry_Regn_Detail
             WHERE  S_Mobile_No = @MobileNo
                    AND I_Centre_Id = @Centre
                    AND I_Enquiry_Regn_ID NOT IN ( @iEnquiryID )
           ) = 0
            BEGIN           
 --SELECT @iCenterID = I_Center_Id FROM             
 --dbo.T_Center_Hierarchy_Details WHERE            
 --I_Hierarchy_Detail_ID = @Centre            
            
                UPDATE  dbo.T_Enquiry_Regn_Detail
                SET     --I_Centre_Id = @iCenterID,    
                        I_Centre_Id = @Centre ,
                        I_Occupation_ID = @OccupationID ,
                        I_Pref_Career_ID = @PrefCareerID ,
                        I_Enquiry_Status_Code = @iEnquiryStatus ,
                        I_Info_Source_ID = @InfoSourceID ,
                        I_Enquiry_Type_ID = @EnquiryTypeID ,
                        S_Is_Corporate = @IsCorporate ,
                        S_Enquiry_Desc = @EnquiryDesc ,
                        S_Title = @Title ,
                        S_First_Name = @FirstName ,
                        S_Middle_Name = @MiddleName ,
                        S_Last_Name = @LastName ,
                        Dt_Birth_Date = @DtBirthDate ,
                        S_Age = @Age ,
                        S_Student_Photo = @sStudentPhoto ,
                        I_Qualification_Name_ID = @QualificationNameID ,
                        C_Skip_Test = @SkipTest ,
                        I_Stream_ID = @StreamID ,
                        S_Email_ID = @EmailID ,
                        S_Phone_No = @PhoneNo ,
                        S_Mobile_No = @MobileNo ,
                        I_Curr_City_ID = @CurrCityID ,
                        I_Curr_State_ID = @CurrStateID ,
                        I_Curr_Country_ID = @CurrCountryID ,
                        S_Guardian_Name = @GuardianName ,
                        I_Guardian_Occupation_ID = @GuardianOccupationID ,
                        S_Guardian_Email_ID = @GuardianEmailID ,
                        S_Guardian_Phone_No = @GuardianPhoneNo ,
                        S_Guardian_Mobile_No = @GuardianMobileNo ,
                        I_Income_Group_ID = @IncomeGroupID ,
                        S_Curr_Address1 = @CurrAddress1 ,
                        S_Curr_Address2 = @CurrAddress2 ,
                        S_Curr_Pincode = @CurrPincode ,
                        S_Curr_Area = @CurrArea ,
                        S_Perm_Address1 = @PermAddress1 ,
                        S_Perm_Address2 = @PermAddress2 ,
                        S_Perm_Pincode = @PermPincode ,
                        I_Perm_City_ID = @PermCityID ,
                        I_Perm_State_ID = @PermStateID ,
                        I_Perm_Country_ID = @PermCountryID ,
                        S_Perm_Area = @PermArea ,
                        I_Residence_Area_ID = @iResidenceArea ,
                        --S_Crtd_By =ISNULL(@CrtdBy, S_Crtd_By) ,
                        --Dt_Crtd_On = @DtCrtdOn ,
                        Enquiry_Crtd_By = CASE WHEN @iEnquiryStatus = 1
                                                    AND ( SELECT
                                                              COUNT(*)
                                                          FROM
                                                              dbo.T_Enquiry_Regn_Detail
                                                          WHERE
                                                              S_Mobile_No = @MobileNo
                                                              AND I_Centre_Id = @Centre
                                                              AND I_Enquiry_Regn_ID = @iEnquiryID
                                                              AND I_Enquiry_Status_Code IS NULL
                                                        ) = 1
                                               THEN ISNULL(@CrtdBy, S_Crtd_By)
                                          END ,
                        Enquiry_Date = CASE WHEN @iEnquiryStatus = 1
                                                 AND ( SELECT COUNT(*)
                                                       FROM   dbo.T_Enquiry_Regn_Detail
                                                       WHERE  S_Mobile_No = @MobileNo
                                                              AND I_Centre_Id = @Centre
                                                              AND I_Enquiry_Regn_ID = @iEnquiryID
                                                              AND I_Enquiry_Status_Code IS NULL
                                                     ) = 1 THEN @DtCrtdOn
                                       END ,
                        S_Upd_By = CASE WHEN @iEnquiryStatus = 3
                                             OR @iEnquiryStatus IS NULL
                                             OR I_Enquiry_Status_Code = 1
                                        THEN ISNULL(@CrtdBy, S_Crtd_By)
                                   END ,
                        Dt_Upd_On = CASE WHEN @iEnquiryStatus = 3
                                              OR @iEnquiryStatus IS NULL
                                              OR I_Enquiry_Status_Code = 1
                                         THEN @DtCrtdOn
                                    END ,
                        I_Corporate_ID = @iCorporateID ,
                        I_Corporate_Plan_ID = @iCorporatePlanID ,
                        I_Caste_ID = @casteID ,
                        S_Father_Name = @sFatherName ,
                        S_Mother_Name = @sMotherName ,    
 --B_IsPreEnquiry =@bIsPreEnquiry,    
                        I_Sex_ID = @iSex ,
                        I_Native_Language_ID = @iNativeLanguage ,
                        I_Nationality_ID = @iNationality ,
                        I_Religion_ID = @iReligion ,
                        I_Marital_Status_ID = @iMaritalStatus ,
                        I_Blood_Group_ID = @iBloodGroup ,
                        I_Father_Qualification_ID = @iFatherQualification ,
                        I_Father_Occupation_ID = @iFatherOccupation ,
                        I_Father_Business_Type_ID = @iFatherBusinessType ,
                        S_Father_Company_Name = @sFatherCompany ,
                        S_Father_Designation = @sFatherDesignation ,
                        S_Father_Office_Phone = @sFatherOfficePhone ,
                        I_Father_Income_Group_ID = @iFatherIncomeGroup ,
                        S_Father_Photo = @sFatherPhoto ,
                        S_Father_Office_Address = @sFatherOfficeAddress ,
                        I_Mother_Qualification_ID = @iMotherQualification ,
                        I_Mother_Occupation_ID = @iMotherOccupation ,
                        I_Mother_Business_Type_ID = @iMotherBusinessType ,
                        S_Mother_Designation = @sMotherDesignation ,
                        S_Mother_Company_Name = @sMotherCompany ,
                        S_Mother_Office_Address = @sMotherOfficeAddress ,
                        S_Mother_Office_Phone = @sMotherOfficePhone ,
                        I_Mother_Income_Group_ID = @iMotherIncomeGroup ,
                        S_Mother_Photo = @sMotherPhoto ,
                        S_Guardian_Relationship = @sGuardianRelation ,
                        S_Guardian_Address = @sGuardianAddress ,
                        I_Monthly_Family_Income_ID = @iMonthlyFamilyIncome ,
                        B_Can_Sponsor_Education = @bCanSponsorEducation ,
                        S_Sibling_ID = @sSiblingID ,
                        B_Has_Given_Exam = @bHasGivenOtherExam ,
                        I_Attempts = @iNoOfAttempts ,
                        S_Other_Institute = @sOtherInstitute ,
                        N_Duration = @nDuration ,
                        I_Seat_Type_ID = @iSeatType ,
                        I_Enrolment_Type_ID = @iEnrolmentType ,
                        S_Enrolment_No = @sEnrolmentNo ,
                        I_Rank_Obtained = @iRankObtained ,
                        S_Univ_Registration_No = @sUniversityRegnNo ,
                        S_Univ_Roll_No = @sUnivRollNo ,
                        I_Scholar_Type_ID = @iScholarType ,
                        S_Second_Language_Opted = @sSecondLanguageOpted ,
                        S_Physical_Ailment = @sPhysicalAilment ,
                        B_IsLateral = @IsLateral ,
                        N_Test_Score = CAST(@TestScore AS DECIMAL(14, 1))
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID            
            
 --Delete Course Information           
                DELETE  FROM dbo.T_Enquiry_Course
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID     
     
            
 --Update Course Information           
                INSERT  INTO dbo.T_Enquiry_Course
                        ( I_Course_ID ,
                          I_Enquiry_Regn_ID  
                        )
                        SELECT  * ,
                                @iEnquiryID
                        FROM    dbo.fnString2Rows(@sSelectedCourseID, ',')
                        
 --akash
            
                DELETE  FROM dbo.T_Enquiry_Aim
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID     
     
            
            
                INSERT  INTO dbo.T_Enquiry_Aim
                        ( I_Aim_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On ,
                          I_Enquiry_Regn_ID  
                          
                        )
                        SELECT  * , -- I_Aim_ID - int
                                @CrtdBy , -- S_Crtd_By - varchar(max)
                                @DtCrtdOn ,
                                @iEnquiryID
                        FROM    dbo.fnString2Rows(@sSelectedAimID, ',') FSR  
                        --SELECT  * ,  
                        --        @iEnquiryID  
                        --FROM    dbo.fnString2Rows(@sSelectedCourseID, ',')
                        
                        
                DELETE  FROM dbo.T_Enquiry_Counseling_Focus
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID     
     
            
            
                INSERT  INTO dbo.T_Enquiry_Counseling_Focus
                        ( I_Counseling_Focus_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On ,
                          I_Enquiry_Regn_ID  
                          
                        )
                        SELECT  * , -- I_Counseling_Focus_ID - int
                                @CrtdBy , -- S_Crtd_By - varchar(max)
                                @DtCrtdOn ,
                                @iEnquiryID
                        FROM    dbo.fnString2Rows(@sSelectedFocusID, ',') FSR
 
 
                DELETE  FROM dbo.T_Enquiry_Education_CurrentStatus
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID
 
                INSERT  INTO dbo.T_Enquiry_Education_CurrentStatus
                        ( I_Enquiry_Regn_ID ,
                          I_Education_CurrentStatus_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On 
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @EducationCurrentStatus , -- I_Education_CurrentStatus_ID - int
                          @CrtdBy , -- S_Crtd_By - varchar(max)
                          @DtCrtdOn -- Dt_Crtd_On - datetime
           
                        )
         
                DELETE  FROM dbo.T_Enquiry_Education_Stream
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID 
  
                INSERT  INTO dbo.T_Enquiry_Education_Stream
                        ( I_Enquiry_Regn_ID ,
                          I_Education_Stream_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @EducationStream , -- I_Education_Stream_ID - int
                          @CrtdBy , -- S_Crtd_By - varchar(max)
                          @DtCrtdOn  -- Dt_Crtd_On - datetime
            
                        )
                DELETE  FROM dbo.T_Enquiry_Education_Qualification
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID
  
                INSERT  INTO dbo.T_Enquiry_Education_Qualification
                        ( I_Enquiry_Regn_ID ,
                          I_Education_Qualification_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @EducationPostGrad , -- I_Education_Qualification_ID - int
                          @CrtdBy , -- S_Crtd_By - varchar(max)
                          @DtCrtdOn  -- Dt_Crtd_On - datetime
            
                        )
          
                DELETE  FROM dbo.T_Enquiry_Employment_Details
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID
  
                INSERT  INTO dbo.T_Enquiry_Employment_Details
                        ( I_Enquiry_Regn_ID ,
                          I_Employment_Details_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @IndustryType , -- I_Employment_Details_ID - int
                          @CrtdBy , -- S_Crtd_By - varchar(max)
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
 
                DELETE  FROM dbo.T_Enquiry_IT_Skills
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID
 
                INSERT  INTO dbo.T_Enquiry_IT_Skills
                        ( I_Enquiry_Regn_ID ,
                          I_IT_Skills_ID ,
                          S_Crtd_By ,
                          Dt_Crtd_On
                        )
                VALUES  ( @iEnquiryID , -- I_Enquiry_Regn_ID - int
                          @ITSkills , -- I_IT_Skills_ID - int
                          @CrtdBy , -- S_Crtd_By - varchar(max)
                          @DtCrtdOn -- Dt_Crtd_On - datetime
           
                        )
                        
                         
                DELETE  FROM dbo.T_Enquiry_Reference_Details
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID 
                
                INSERT  INTO dbo.T_Enquiry_Reference_Details
                        ( I_Enquiry_Regn_ID ,
                          S_Name ,
                          S_Contact_No ,
                          S_Address
                        )
                        SELECT  @iEnquiryID ,
                                T.c.value('@S_Name', 'varchar(MAX)') ,
                                T.c.value('@S_Contact_No', 'varchar(MAX)') ,
                                T.c.value('@S_Address', 'varchar(MAX)')
                        FROM    @sReferenceXML.nodes('/Root/Reference') T ( c )
                        
                        
                DELETE  FROM dbo.T_Enquiry_PostCounselling_Feedback_Details
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID 
                
                INSERT  INTO dbo.T_Enquiry_PostCounselling_Feedback_Details
                        ( I_Enquiry_Regn_ID ,
                          S_Question ,
                          I_Points
                        )
                        SELECT  @iEnquiryID ,
                                T.c.value('@S_Question', 'varchar(MAX)') ,
                                CAST(T.c.value('@S_Points', 'varchar(MAX)') AS INT)
                        FROM    @sFeedbackXML.nodes('/Root/Feedback') T ( c )    
                   
      
        
                 
 
 --akash                           
     
     
 --Delete enquiry Qualification Information    
                DELETE  FROM dbo.T_Enquiry_Qualification_Details
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID    
      
 --Update enquiry Qualification Information       
                INSERT  INTO dbo.T_Enquiry_Qualification_Details
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
                          Dt_Crtd_On ,
                          S_Institution   
                        )
                        SELECT  @iEnquiryID ,
                                T.c.value('@S_Name_Of_Exam', 'varchar(200)') ,
                                T.c.value('@S_University_Name', 'varchar(200)') ,
                                T.c.value('@S_Year_From', 'varchar(4)') ,
                                T.c.value('@S_Year_To', 'varchar(4)') ,
                                T.c.value('@S_Subject_Name', 'varchar(200)') ,
                                T.c.value('@N_Marks_Obtained', 'decimal(18,2)') ,
                                T.c.value('@N_Percentage', 'decimal(18, 2)') ,
                                T.c.value('@S_Division', 'varchar(50)') ,
                                1 ,
                                @CrtdBy ,
                                @DtCrtdOn ,
                                T.c.value('@S_Institution', 'varchar(MAX)')
                        FROM    @sQualificationXML.nodes('/Root/Qualification') T ( c )     
                    
                IF @iPreEnquiryUpdate = 1
                    BEGIN                  
 -- Get the Employee Id of the Councellor                 
                        SELECT  @iEmployeeId = I_Employee_ID
                        FROM    dbo.T_Employee_Dtls
                        WHERE   I_Employee_ID = ( SELECT    I_Reference_ID
                                                  FROM      dbo.T_User_Master
                                                  WHERE     S_Login_ID = @CrtdBy
                                                )                
                   
 -- Update the first followup information for the enquiry                
                        INSERT  INTO dbo.T_Enquiry_Regn_Followup
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
                    END    
				
-- update language details in student language table : by susmita
			   
			   if exists(select * from T_Brand_Center_Details where I_Brand_ID=109 and I_Centre_Id in (@Centre))--only execute for 109
				BEGIN
					Exec uspUpdateEnquiryLanguageDetails @iEnquiryID,@iEnquiryStatus
				END

                SELECT  S_Enquiry_No
                FROM    T_Enquiry_Regn_Detail
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID     
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
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT            
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()            
            
        RAISERROR(@ErrMsg, @ErrSeverity, 1)            
    END CATCH  

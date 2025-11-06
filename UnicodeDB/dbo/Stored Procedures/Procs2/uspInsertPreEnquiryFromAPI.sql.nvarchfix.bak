
CREATE PROCEDURE [dbo].[uspInsertPreEnquiryFromAPI]
(
@ExtApplicationID Nnvarchar(max)=NULL,
@Centre Nnvarchar(max),
@FirstName Nnvarchar(max),
@MiddleName Nnvarchar(max)='',
@LastName Nnvarchar(max),
@DateofBirth Nnvarchar(max),
@Age INT,
@MobileNo Nnvarchar(max),
@PhoneNo Nnvarchar(max)='',
@EmailID Nnvarchar(max),
@SalesDisposition Nnvarchar(max),
@DateofMaturityCC DATETIME=NULL,
@DateofMaturitySales DATETIME=NULL,
@DateofMaturity DATETIME,
@Counsellor Nnvarchar(max),
@LeadCreatedBy Nnvarchar(max),
@LeadOrigin Nnvarchar(max),
@PrimaryTrafficChannel Nnvarchar(max),
@Publisher Nnvarchar(max),
@InfoSource Nnvarchar(max),
@Source Nnvarchar(max),
@Medium Nnvarchar(max),
@Campaign Nnvarchar(max),
@HighestEduQualification Nnvarchar(max),
@Country Nnvarchar(max),
@State Nnvarchar(max),
@District Nnvarchar(max)=NULL,
@City Nnvarchar(max),
@Address Nnvarchar(max),
@Pincode Nnvarchar(max),
@Course Nnvarchar(max),
@UserRegnDate DATETIME
)
AS
BEGIN

	

	DECLARE @CentreID INT=0
	DECLARE @HighestQualificationID INT=0
	DECLARE @CountryID INT=0
	DECLARE @StateID INT=0
	DECLARE @CityID INT=0
	DECLARE @CourseID INT=0
	DECLARE @InfoSourceID INT=0

	BEGIN TRY 
	BEGIN TRANSACTION


	SELECT @CentreID=TCHND.I_Center_ID FROM dbo.T_Center_Hierarchy_Name_Details AS TCHND WHERE TCHND.S_Center_Name=@Centre
	SELECT @CourseID=TCM.I_Course_ID FROM dbo.T_Course_Master AS TCM WHERE UPPER(TCM.S_Course_Name)=@Course AND TCM.I_Brand_ID=109 AND TCM.I_Status=1
	SELECT @InfoSourceID=TISM.I_Info_Source_ID FROM dbo.T_Information_Source_Master AS TISM WHERE TISM.S_Info_Source_Name=@InfoSource AND TISM.I_Status=1

	SELECT @HighestQualificationID=ISNULL(TECS.I_Education_CurrentStatus_ID ,0)
	FROM dbo.T_Education_CurrentStatus AS TECS WHERE UPPER(TECS.S_Education_CurrentStatus_Description)=UPPER(@HighestEduQualification)


	SELECT @CountryID=ISNULL(TCM.I_Country_ID ,0)
	FROM dbo.T_Country_Master AS TCM WHERE UPPER(TCM.S_Country_Name)=UPPER(@Country) AND TCM.I_Status=1

	SELECT @StateID=ISNULL(TSM.I_State_ID ,0)
	FROM dbo.T_State_Master AS TSM WHERE UPPER(TSM.S_State_Name)=UPPER(@State) AND TSM.I_Status=1

	SELECT @CityID=ISNULL(TCM.I_City_ID,0) FROM dbo.T_City_Master AS TCM WHERE UPPER(TCM.S_City_Name)=UPPER(@City) AND TCM.I_Status=1

	IF (@HighestQualificationID=0 AND @HighestEduQualification NOT LIKE '%NOT AVAILABLE%')
	BEGIN

		INSERT INTO dbo.T_Education_CurrentStatus
		(
		    S_Education_CurrentStatus_Description,
		    I_Status,
		    S_Crtd_By,
		    S_Upd_By,
		    Dt_Crtd_On,
		    Dt_Upd_On,
		    I_Brand_ID
		)
		VALUES
		(   @HighestEduQualification,        -- S_Education_CurrentStatus_Description - nvarchar(max)
		    1,         -- I_Status - int
		    'rice-group-admin',        -- S_Crtd_By - nvarchar(max)
		    NULL,        -- S_Upd_By - nvarchar(max)
		    GETDATE(), -- Dt_Crtd_On - datetime
		    NULL, -- Dt_Upd_On - datetime
		    109          -- I_Brand_ID - int
		    )

			SET @HighestQualificationID=SCOPE_IDENTITY()


	END


	IF (@CountryID=0 AND @Country NOT LIKE '%NOT AVAILABLE%')
	BEGIN

		SET @CountryID=1

	END

	IF (@StateID=0 AND @State NOT LIKE '%NOT AVAILABLE%')
	BEGIN

		SET @StateID=29

	END

	IF (@CityID=0 AND @City NOT LIKE '%NOT AVAILABLE%')
	BEGIN

		INSERT INTO dbo.T_City_Master
		(
		    S_City_Code,
		    S_City_Name,
		    I_Country_ID,
		    I_Status,
		    S_Crtd_By,
		    S_Upd_By,
		    Dt_Crtd_On,
		    Dt_Upd_On,
		    I_State_ID
		)
		VALUES
		(   SUBSTRING(@City,0,3),        -- S_City_Code - nvarchar(max)
		    @City,        -- S_City_Name - nvarchar(max)
		    @CountryID,         -- I_Country_ID - int
		    1,        -- I_Status - char(1)
		    'rice-group-admin',        -- S_Crtd_By - nvarchar(max)
		    NULL,        -- S_Upd_By - nvarchar(max)
		    GETDATE(), -- Dt_Crtd_On - datetime
		    NULL, -- Dt_Upd_On - datetime
		    @StateID          -- I_State_ID - int
		    )

			SET @CityID=SCOPE_IDENTITY()

	END

	IF (@CentreID>0 AND @CourseID>0 AND @CountryID>0 AND @StateID>0 AND @CityID>0 AND @HighestQualificationID>0)
	BEGIN

		DECLARE @sSelectedCourseID VARCHAR(MAX)=CAST(@CourseID AS VARCHAR)
		DECLARE @ExtID INT=0

		--IF (@ExtApplicationID IS NOT NULL AND EXISTS(SELECT * FROM dbo.T_Enquiry_External_Additional_Details AS TEEAD WHERE TEEAD.ExtApplicationID=@ExtApplicationID))
		--BEGIN

		--	RAISERROR('Entry with the same External Application ID already exists',11,1) 

		--END

		IF NOT EXISTS(SELECT * FROM dbo.T_Enquiry_Regn_Detail AS TERD WHERE TERD.I_Centre_Id=@CentreID AND TERD.S_Mobile_No=@MobileNo)
		BEGIN
		INSERT INTO dbo.T_Enquiry_External_Additional_Details
		(
		    PreEnquiryID,
		    ExtApplicationID,
		    FirstName,
		    MiddleName,
		    LastName,
		    Centre,
		    MobileNo,
		    EmailID,
		    AlternateMobileNo,
		    DateofBirth,
		    SalesDisposition,
		    DateofMaturityCC,
		    DateofMaturitySales,
		    Counsellor,
		    LeadCreatedBy,
		    Origin,
		    PrimaryTrafficChannel,
		    InfoSource,
		    InfoMedium,
		    InfoCampaign,
		    HighestQualification,
		    Country,
		    State,
		    District,
		    City,
		    Pincode,
		    UserRegistrationDate,
		    ExtSource,
		    CreatedBy,
		    CreatedOn
		)
		VALUES
		(   0,         -- PreEnquiryID - int
		    @ExtApplicationID,        -- ExtApplicationID - nvarchar(max)
		    @FirstName,        -- FirstName - nvarchar(max)
		    @MiddleName,        -- MiddleName - nvarchar(max)
		    @LastName,        -- LastName - nvarchar(max)
		    @Centre,        -- Centre - nvarchar(max)
		    @MobileNo,        -- MobileNo - nvarchar(max)
		    @EmailID,        -- EmailID - nvarchar(max)
		    @PhoneNo,        -- AlternateMobileNo - nvarchar(max)
		    @DateofBirth, -- DateofBirth - datetime
		    @SalesDisposition,        -- SalesDisposition - nvarchar(max)
		    @DateofMaturityCC, -- DateofMaturityCC - datetime
		    @DateofMaturitySales, -- DateofMaturitySales - datetime
		    @Counsellor,        -- Counsellor - nvarchar(max)
		    @LeadCreatedBy,        -- LeadCreatedBy - nvarchar(max)
		    @LeadOrigin,        -- Origin - nvarchar(max)
		    @PrimaryTrafficChannel,        -- PrimaryTrafficChannel - nvarchar(max)
		    @Source,        -- InfoSource - nvarchar(max)
		    @Medium,        -- InfoMedium - nvarchar(max)
		    @Campaign,        -- InfoCampaign - nvarchar(max)
		    @HighestEduQualification,        -- HighestQualification - nvarchar(max)
		    @Country,        -- Country - nvarchar(max)
		    @State,        -- State - nvarchar(max)
		    @District,        -- District - nvarchar(max)
		    @City,        -- City - nvarchar(max)
		    @Pincode,        -- Pincode - nvarchar(max)
		    @UserRegnDate, -- UserRegistrationDate - datetime
		    @InfoSource,        -- ExtSource - nvarchar(max)
		    'rice-group-admin',        -- CreatedBy - nvarchar(max)
		    GETDATE()  -- CreatedOn - datetime
		    )

		SET @ExtID=SCOPE_IDENTITY()

		DECLARE @dtDate DATETIME=GETDATE()

		DECLARE @xmldata XML='<Root>
									<Qualification S_Name_Of_Exam="Class X" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="" N_Marks_Obtained="0" N_Percentage="0" S_Division="" />
									<Qualification S_Name_Of_Exam="Class XII" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="" N_Marks_Obtained="0" N_Percentage="0" S_Division="" />
									<Qualification S_Name_Of_Exam="Graduation" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="" N_Marks_Obtained="0" N_Percentage="0" S_Division="" />
									<Qualification S_Name_Of_Exam="Post-Graduation" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="" N_Marks_Obtained="0" N_Percentage="0" S_Division="" />
								</Root>'


		EXEC dbo.uspInsertPreEnquiryDetailsFromAPI @Centre = @CentreID,                                  -- int
		                                    @IEnquiryStatusCode = NULL,                      -- int
		                                    @FirstName = @FirstName,                              -- nvarchar(max)
		                                    @MiddleName = @MiddleName,                             -- nvarchar(max)
		                                    @LastName = @LastName,                               -- nvarchar(max)
		                                    @DtBirthDate = @DateofBirth,         -- datetime
		                                    @Age = @Age,                                    -- nvarchar(max)
		                                    @casteID = NULL,                                 -- int
		                                    @MobileNo = @MobileNo,
											@EmailID=@EmailID,-- nvarchar(max)
											@PhoneNo=@PhoneNo,
		                                    @CurrCityID = @CityID,                              -- int
		                                    @CurrStateID = @StateID,                             -- int
		                                    @CurrCountryID = @CountryID,                           -- int
		                                    @CurrAddress1 = @Address,                           -- nvarchar(max)
		                                    @CurrAddress2 = '',                           -- nvarchar(max)
		                                    @CurrPincode = @Pincode,                            -- nvarchar(max)
		                                    @FatherName = '',                             -- nvarchar(max)
		                                    @MotherName = '',                             -- nvarchar(max)
		                                    @EnquiryDesc = '',                            -- nvarchar(max)
		                                    @IsPreEnquiry = 1,                         -- bit
		                                    @CrtdBy = 'rice-group-admin',                                 -- nvarchar(max)
		                                    @DtCrtdOn = @dtDate,            -- datetime
		                                    @sSelectedCourseID = @sSelectedCourseID,                      -- nvarchar(max)
		                                    @InfoSourceID = @InfoSourceID,                            -- int
		                                    @bHasGivenOtherExam = NULL,                   -- bit
		                                    @sQualificationXML = @xmldata,                    -- xml
		                                    @iSeatType = NULL,                               -- int
		                                    @iEnrolmentType = NULL,                          -- int
		                                    @sEnrolmentNo = NULL,                           -- nvarchar(max)
		                                    @iRankObtained = NULL,                           -- int
		                                    @dtFirstFollowUpDate = @dtDate, -- datetime
		                                    @IsLateral = NULL,                            -- bit
		                                    @IPreEnquiryFor = 1,                          -- int
		                                    @GuardianName = '',                           -- nvarchar(max)
		                                    @GuardianPhoneNo = '',                        -- nvarchar(max)
		                                    @iFatherIncomeGroup = 1,                      -- int
		                                    @EducationCurrentStatus = @HighestQualificationID ,                  -- int
											@ExtAdditionalDetailsID=@ExtID

											
		

		END
		ELSE
		BEGIN

			RAISERROR('Entry with the same mobile no. already exists',11,1) 

		END
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
	

	

END


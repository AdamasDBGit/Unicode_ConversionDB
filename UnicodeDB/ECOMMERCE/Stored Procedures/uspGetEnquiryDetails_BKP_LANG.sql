CREATE PROCEDURE [ECOMMERCE].[uspGetEnquiryDetails_BKP_LANG](@RegID INT, @CenterID INT, @BatchID INT, @ProspectusAmount DECIMAL(14,2)=0)
AS
BEGIN

	DECLARE @EnquiryNumber INT=0
	DECLARE @iReceiptHeader INT=0
	DECLARE @iBrandID INT
	DECLARE @dtDate DATETIME=GETDATE()
	DECLARE @FollowupDate DATETIME

	DECLARE @sCourseID VARCHAR(MAX)
	DECLARE @CountryID INT
	DECLARE @StateID INT
	DECLARE @CityID INT
	DECLARE @GenderID INT
	DECLARE @Address VARCHAR(MAX)
	DECLARE @Pincode VARCHAR(MAX)
	DECLARE @MobileNo VARCHAR(MAX)
	DECLARE @FirstName VARCHAR(MAX)
	DECLARE @MiddleName VARCHAR(MAX)
	DECLARE @LastName VARCHAR(MAX)
	DECLARE @EducationStatusID INT
	DECLARE @DateofBirth DATETIME
	DECLARE @EmailID VARCHAR(MAX)
	DECLARE @Age INT
	--61

	DECLARE @Gender VARCHAR(MAX),
			@HighestEducationQualification VARCHAR(MAX),
			@City VARCHAR(MAX)=NULL,
			@State VARCHAR(MAX) =NULL,
			@Country VARCHAR(MAX)=NULL


	select @iBrandID=I_Brand_ID from T_Center_Hierarchy_Name_Details where I_Center_ID=@CenterID


	select 
	@FirstName=FirstName,
	@MiddleName=ISNULL(MiddleName,NULL),
	@LastName=LastName,
	@MobileNo=MobileNo,
	@Address=ISNULL(Address,'NA'),
	@Pincode=ISNULL(Pincode,''),
	@DateofBirth=DateofBirth,
	@EmailID=EmailID,
	@HighestEducationQualification=HighestEducationQualification,
	@Gender=Gender,
	@City=City,
	@State=[State],
	@Country=Country
	from 
	ECOMMERCE.T_Registration where RegID=@RegID



	SELECT @EducationStatusID=ISNULL(TECS.I_Education_CurrentStatus_ID ,0)
	FROM dbo.T_Education_CurrentStatus AS TECS WHERE UPPER(TECS.S_Education_CurrentStatus_Description)=UPPER(@HighestEducationQualification)
	and TECS.I_Status=1 and TECS.I_Brand_ID=@iBrandID

	IF(@EducationStatusID=0)
	BEGIN

		insert into T_Education_CurrentStatus
		select @HighestEducationQualification,1,'rice-group-admin',NULL,GETDATE(),NULL,@iBrandID

		SET @EducationStatusID=SCOPE_IDENTITY()

	END

	SELECT @GenderID=ISNULL(TECS.I_Sex_ID ,0)
	FROM dbo.T_User_Sex AS TECS 
	WHERE UPPER(TECS.S_Sex_Name)=UPPER(@Gender)
	and TECS.I_Status=1

	IF(@GenderID=0)
	BEGIN

		RAISERROR('Invalid Gender',11,1)

	END


	SELECT @CountryID=ISNULL(TCM.I_Country_ID ,0)
	FROM dbo.T_Country_Master AS TCM WHERE UPPER(TCM.S_Country_Name)=UPPER(ISNULL(@Country,'')) AND TCM.I_Status=1

	SELECT @StateID=ISNULL(TSM.I_State_ID ,0)
	FROM dbo.T_State_Master AS TSM WHERE UPPER(TSM.S_State_Name)=UPPER(ISNULL(@State,'')) AND TSM.I_Status=1

	SELECT @CityID=ISNULL(TCM.I_City_ID,0) FROM dbo.T_City_Master AS TCM WHERE UPPER(TCM.S_City_Name)=UPPER(ISNULL(@City,'')) AND TCM.I_Status=1

	
	IF (ISNULL(@CountryID,0)=0 AND @Country NOT LIKE '%NOT AVAILABLE%')
	BEGIN

		SET @CountryID=1

	END

	IF (ISNULL(@StateID,0)=0 AND @State NOT LIKE '%NOT AVAILABLE%' AND @CountryID>0)
	BEGIN

		INSERT INTO T_State_Master
		SELECT SUBSTRING(@State,0,3),@State,@CountryID,1,'dba',NULL,GETDATE(),NULL

		SET @StateID=SCOPE_IDENTITY()

	END

	IF (ISNULL(@CityID,0)=0 AND @City NOT LIKE '%NOT AVAILABLE%' AND @StateID>0)
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
		(   SUBSTRING(@City,0,3),        -- S_City_Code - varchar(10)
			@City,        -- S_City_Name - varchar(50)
			@CountryID,         -- I_Country_ID - int
			1,        -- I_Status - char(1)
			'rice-group-admin',        -- S_Crtd_By - varchar(20)
			NULL,        -- S_Upd_By - varchar(20)
			GETDATE(), -- Dt_Crtd_On - datetime
			NULL, -- Dt_Upd_On - datetime
			@StateID          -- I_State_ID - int
			)

			SET @CityID=SCOPE_IDENTITY()

	END









	SET @FollowupDate=DATEADD(d,10,@dtDate)
	SET @Age=(CONVERT(int,CONVERT(char(8),@dtDate,112))-CONVERT(char(8),@DateofBirth,112))/10000
	SET @sCourseID=CAST((select I_Course_ID from T_Student_Batch_Master where I_Batch_ID=@BatchID) AS varchar(max))

	--select @Age



	IF NOT EXISTS
	(
		select * from ECOMMERCE.T_Registration_Enquiry_Map A
		inner join T_Enquiry_Regn_Detail B on A.EnquiryID=B.I_Enquiry_Regn_ID
		where
		A.RegID=@RegID and B.I_Centre_Id=@CenterID
	)
	BEGIN

	--CREATE Pre-Enquiry

	exec ECOMMERCE.uspInsertPreEnquiryDetailsFromRegistration 
		@Centre=@CenterID,
		@FirstName=@FirstName,
		@MiddleName=@MiddleName,
		@LastName=@LastName,
		@DtBirthDate=@DateofBirth,
		@Age=@Age,
		@MobileNo=@MobileNo,
		@CurrCityID=@CityID,
		@CurrStateID=@StateID,
		@CurrCountryID=@CountryID,
		@CurrAddress1=@Address,
		@CurrAddress2=N'',
		@CurrPincode=@Pincode,
		@FatherName=NULL,
		@MotherName=NULL,
		@EnquiryDesc=NULL,
		@IsPreEnquiry=1,
		@sQualificationXML=N'<Root><Qualification S_Name_Of_Exam="Class X" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="" N_Marks_Obtained="0" N_Percentage="0" S_Division="" /><Qualification S_Name_Of_Exam="Class XII" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="" N_Marks_Obtained="0" N_Percentage="0" S_Division="" /><Qualification S_Name_Of_Exam="Graduation" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="" N_Marks_Obtained="0" N_Percentage="0" S_Division="" /><Qualification S_Name_Of_Exam="Post-Graduation" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="" N_Marks_Obtained="0" N_Percentage="0" S_Division="" /></Root>',
		@bHasGivenOtherExam=0,
		@InfoSourceID=61,
		@CrtdBy=N'rice-group-admin',
		@DtCrtdOn=@dtDate,
		@iSeatType=NULL,
		@iEnrolmentType=NULL,
		@sEnrolmentNo=NULL,
		@iRankObtained=NULL,
		@dtFirstFollowUpDate=@FollowupDate,
		@sSelectedCourseID=@sCourseID,
		@casteID=NULL,
		@IEnquiryStatusCode=NULL,
		@IsLateral=NULL,
		@IPreEnquiryFor=1,
		@GuardianName=NULL,
		@GuardianPhoneNo=NULL,
		@iFatherIncomeGroup=1,
		@EducationCurrentStatus=@EducationStatusID,
		@EnquiryNumber=@EnquiryNumber OUTPUT


		EXEC [LMS].[uspInsertEnquiryDataForInterface] @EnquiryNumber,'ADD'

	END
	ELSE
	BEGIN

		select @EnquiryNumber=I_Enquiry_Regn_ID 
		from 
		ECOMMERCE.T_Registration_Enquiry_Map A
		inner join T_Enquiry_Regn_Detail B on A.EnquiryID=B.I_Enquiry_Regn_ID
		where
		A.RegID=@RegID and B.I_Centre_Id=@CenterID

	END

	--select @EnquiryNumber as No1

	IF(@EnquiryNumber>0)
	BEGIN

		Update T_Enquiry_Regn_Detail set RegID=@RegID where I_Enquiry_Regn_ID=@EnquiryNumber and RegID IS NULL

		IF NOT EXISTS(select * from ECOMMERCE.T_Registration_Enquiry_Map where RegID=@RegID and EnquiryID=@EnquiryNumber and StatusID=1)
		BEGIN

			insert into ECOMMERCE.T_Registration_Enquiry_Map
			select @RegID,@EnquiryNumber,1,GETDATE(),'rice-group-admin',NULL,NULL

		END

		IF NOT EXISTS
		(
			select * 
			from 
			T_Enquiry_Regn_Detail A
			where
			A.I_Enquiry_Status_Code in (1,3) and I_Enquiry_Regn_ID=@EnquiryNumber
		)
		BEGIN

			exec ECOMMERCE.uspUpdateEnquiryDetails 
					@iEnquiryID=@EnquiryNumber,
					@Centre=@CenterID,
					@OccupationID=NULL,
					@PrefCareerID=NULL,
					@InfoSourceID=61,
					@EnquiryTypeID=NULL,
					@IsCorporate=NULL,
					@EnquiryDesc=NULL,
					@Title=NULL,
					@FirstName=@FirstName,
					@MiddleName=@MiddleName,
					@LastName=@LastName,
					@DtBirthDate=@DateofBirth,
					@Age=@Age,
					@casteID=1,
					@QualificationNameID=NULL,
					@SkipTest=NULL,
					@StreamID=NULL,
					@EmailID=@EmailID,
					@PhoneNo=NULL,
					@MobileNo=@MobileNo,
					@CurrCityID=@CityID,
					@CurrStateID=@StateID,
					@CurrCountryID=@CountryID,
					@GuardianName=NULL,
					@GuardianOccupationID=NULL,
					@GuardianEmailID=NULL,
					@GuardianPhoneNo=@MobileNo,
					@GuardianMobileNo=NULL,
					@IncomeGroupID=NULL,
					@CurrAddress1=@Address,
					@CurrAddress2=NULL,
					@CurrPincode=@Pincode,
					@CurrArea=NULL,
					@PermAddress1=@Address,
					@PermAddress2=N'',
					@PermPincode=@Pincode,
					@PermCityID=@CityID,
					@PermStateID=@StateID,
					@PermCountryID=@CountryID,
					@PermArea=N'',
					@CrtdBy=N'rice-group-admin',
					@DtCrtdOn=@dtDate,
					@sSelectedCourseID=@sCourseID,
					@dtFirstFollowUpDate=@FollowupDate,
					@iCorporateID=NULL,
					@iCorporatePlanID=NULL,
					@sStudentPhoto=NULL,
					@iResidenceArea=NULL,
					@sFatherName=N'NA',
					@sMotherName=N'NA',
					@iSex=@GenderID,
					@iNativeLanguage=1,
					@iNationality=1,
					@iReligion=1,
					@iMaritalStatus=1,
					@iBloodGroup=1,
					@iFatherQualification=NULL,
					@iFatherOccupation=NULL,
					@iFatherBusinessType=NULL,
					@sFatherCompany=NULL,
					@sFatherDesignation=NULL,
					@sFatherOfficePhone=NULL,
					@sFatherOfficeAddress=NULL,
					@iFatherIncomeGroup=1,
					@sFatherPhoto=NULL,
					@iMotherQualification=NULL,
					@iMotherOccupation=NULL,
					@iMotherBusinessType=NULL,
					@sMotherCompany=NULL,
					@sMotherDesignation=NULL,
					@sMotherOfficePhone=NULL,
					@iMotherIncomeGroup=NULL,
					@sMotherPhoto=NULL,
					@sMotherOfficeAddress=NULL,
					@sGuardianRelation=NULL,
					@sGuardianAddress=NULL,
					@iMonthlyFamilyIncome=NULL,
					@bCanSponsorEducation=0,
					@sSiblingID=NULL,
					@bHasGivenOtherExam=0,
					@iNoOfAttempts=NULL,
					@sOtherInstitute=NULL,
					@nDuration=NULL,
					@iSeatType=NULL,
					@iEnrolmentType=NULL,
					@sEnrolmentNo=NULL,
					@iRankObtained=NULL,
					@sUniversityRegnNo=NULL,
					@sUnivRollNo=NULL,
					@iScholarType=NULL,
					@sSecondLanguageOpted=NULL,
					@sQualificationXML=N'<Root><Qualification 
					S_Name_Of_Exam="Class X" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="NA" N_Marks_Obtained="0" N_Percentage="0" S_Division="" /><Qualification S_Name_Of_Exam="Class XII" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="NA" N_Marks_Obtained="0" N_Percentage="0" S_Division="" /><Qualification S_Name_Of_Exam="Graduation" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="NA" N_Marks_Obtained="0" N_Percentage="0" S_Division="" /><Qualification S_Name_Of_Exam="Post-Graduation" S_University_Name="" S_Institution="" S_Year_From="" S_Year_To="" S_Subject_Name="NA" N_Marks_Obtained="0" N_Percentage="0" S_Division="" /></Root>',@sPhysicalAilment=NULL,@IsLateral=NULL,@EducationCurrentStatus=12,@EducationStream=NULL,@EducationPostGrad=NULL,@IndustryType=NULL,@ITSkills=NULL,@YrsofExp=NULL,@JobRole=NULL,@JobSalary=NULL,@sSelectedAimID=NULL,@sSelectedFocusID=NULL,@sReferenceXML=N'<Root><Reference S_Name="" S_Contact_No="" S_Address="" /><Reference S_Name="" S_Contact_No="" S_Address="" /></Root>',@sFeedbackXML=N'<Root><Feedback S_Question="Front office ambience" S_Points="0" /><Feedback S_Question="Relevant Information Brochures Availability" S_Points="0" /><Feedback S_Question="Queries were handled to my satisfaction" S_Points="0" /><Feedback S_Question="RICE can provide me with the product that I need and is best suited for my career" S_Points="0" /></Root>',
					@TestScore=NULL,
					@iEnquiryStatus=1,
					@iPreEnquiryUpdate=1,
					@EnquiryNumber=@EnquiryNumber OUTPUT


					--select @EnquiryNumber as No2

				END

				IF(@EnquiryNumber IS NOT NULL and @EnquiryNumber>0 and @ProspectusAmount=0)
				BEGIN

					IF NOT EXISTS(select * from T_Receipt_Header where I_Status=1 and I_Receipt_Type=32 and I_Enquiry_Regn_ID=@EnquiryNumber)
					BEGIN

					DECLARE @sFormNo VARCHAR(MAX)
					SET @sFormNo='CU'+CAST(@RegID as VARCHAR(MAX))+CAST(@CenterID as varchar(max))

						EXEC uspGenerateReceiptForOnAccountAPI @iCenterId = @CenterID,
															@iAmount = 0,
															@iStudentDetailId = NULL,
															@iReceiptDate = @dtDate,
															@iPaymentModeId = 27,
															@sChequeDDno = NULL,
															@dChequeDate = NULL,
															@sBankName = NULL,
															@sBranchName = NULL,
															@iCreditCardNo = NULL,
															@sCreditCardIssuer = NULL,
															@dCardExpiryDate = NULL,
															@sCrtdBy = 'rice-group-admin',
															@iReceiptType = 32,
															@dTaxAmount = 0,
															@TaxXML = '<ReceiptTax />',
															@iBrandID = @iBrandID,
															@iEnquiryID = @EnquiryNumber,
															@sFormNo = @sFormNo,
															@sNarration = '',
															@iReceiptHeader = @iReceiptHeader OUTPUT

					END
					ELSE
					BEGIN

						select @iReceiptHeader=I_Receipt_Header_ID 
						from T_Receipt_Header 
						where I_Status=1 and I_Receipt_Type=32 and I_Enquiry_Regn_ID=@EnquiryNumber

					END

				END

	END

	IF(@iReceiptHeader>0)
		select @EnquiryNumber as EnquiryID
	ELSE
		select 0 as EnquiryID

END

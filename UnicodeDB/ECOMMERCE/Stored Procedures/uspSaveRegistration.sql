
CREATE PROCEDURE [ECOMMERCE].[uspSaveRegistration]
(
@CustomerID VARCHAR(MAX),
@FirstName VARCHAR(MAX),
@MiddleName VARCHAR(MAX)=NULL,
@LastName VARCHAR(MAX),
@Gender VARCHAR(MAX),
@DoB Datetime,
@EmailID VARCHAR(MAX),
@MobileNo VARCHAR(16),
@HighestEducationQualification VARCHAR(MAX),
@RegSource VARCHAR(MAX),
@CoursesList VARCHAR(MAX),
@Address VARCHAR(MAX)=NULL,
@City VARCHAR(MAX)=NULL,
@State VARCHAR(MAX) =NULL,
@Country VARCHAR(MAX)=NULL,
@Pincode VARCHAR(20)=NULL,
@CreatedBy VARCHAR(MAX)='rice-group-admin',
@LanguageID INT=NULL,
@LanguageName VARCHAR(200)=NULL
)
AS
BEGIN

	DECLARE @RegID INT=0
	DECLARE @CountryID INT=0
	DECLARE @StateID INT=0
	DECLARE @CityID INT=0
	DECLARE @GenderID INT=0
	DECLARE @HighestEducationQualificationID INT=0


	BEGIN TRY

		BEGIN TRANSACTION


			--SELECT @HighestEducationQualificationID=ISNULL(TECS.I_Education_CurrentStatus_ID ,0)
			--FROM dbo.T_Education_CurrentStatus AS TECS WHERE UPPER(TECS.S_Education_CurrentStatus_Description)=UPPER(@HighestEducationQualification)
			--and TECS.I_Status=1

			--IF(@HighestEducationQualificationID=0)
			--BEGIN

			--	RAISERROR('Invalid Highest Education Qualification',11,1)

			--END

			--SELECT @GenderID=ISNULL(TECS.I_Sex_ID ,0)
			--FROM dbo.T_User_Sex AS TECS 
			--WHERE UPPER(TECS.S_Sex_Name)=UPPER(@Gender)
			--and TECS.I_Status=1

			--IF(@GenderID=0)
			--BEGIN

			--	RAISERROR('Invalid Gender',11,1)

			--END


			--SELECT @CountryID=ISNULL(TCM.I_Country_ID ,0)
			--FROM dbo.T_Country_Master AS TCM WHERE UPPER(TCM.S_Country_Name)=UPPER(ISNULL(@Country,'')) AND TCM.I_Status=1

			--SELECT @StateID=ISNULL(TSM.I_State_ID ,0)
			--FROM dbo.T_State_Master AS TSM WHERE UPPER(TSM.S_State_Name)=UPPER(ISNULL(@State,'')) AND TSM.I_Status=1

			--SELECT @CityID=ISNULL(TCM.I_City_ID,0) FROM dbo.T_City_Master AS TCM WHERE UPPER(TCM.S_City_Name)=UPPER(ISNULL(@City,'')) AND TCM.I_Status=1

	
			--IF (@CountryID=0 AND @Country NOT LIKE '%NOT AVAILABLE%')
			--BEGIN

			--	SET @CountryID=1

			--END

			--IF (@StateID=0 AND @State NOT LIKE '%NOT AVAILABLE%' AND @CountryID>0)
			--BEGIN

			--	INSERT INTO T_State_Master
			--	SELECT SUBSTRING(@State,0,3),@State,@CountryID,1,'dba',NULL,GETDATE(),NULL

			--	SET @StateID=SCOPE_IDENTITY()

			--END

			--IF (@CityID=0 AND @City NOT LIKE '%NOT AVAILABLE%' AND @StateID>0)
			--BEGIN

			--	INSERT INTO dbo.T_City_Master
			--	(
			--		S_City_Code,
			--		S_City_Name,
			--		I_Country_ID,
			--		I_Status,
			--		S_Crtd_By,
			--		S_Upd_By,
			--		Dt_Crtd_On,
			--		Dt_Upd_On,
			--		I_State_ID
			--	)
			--	VALUES
			--	(   SUBSTRING(@City,0,3),        -- S_City_Code - varchar(10)
			--		@City,        -- S_City_Name - varchar(50)
			--		@CountryID,         -- I_Country_ID - int
			--		1,        -- I_Status - char(1)
			--		'rice-group-admin',        -- S_Crtd_By - varchar(20)
			--		NULL,        -- S_Upd_By - varchar(20)
			--		GETDATE(), -- Dt_Crtd_On - datetime
			--		NULL, -- Dt_Upd_On - datetime
			--		@StateID          -- I_State_ID - int
			--		)

			--		SET @CityID=SCOPE_IDENTITY()

			--END

			



			IF NOT EXISTS(select * from ECOMMERCE.T_Registration where CustomerID=@CustomerID and StatusID=1)
			BEGIN

				IF EXISTS(select * from ECOMMERCE.T_Registration where MobileNo=@MobileNo and StatusID=1)
				BEGIN

					RAISERROR('Customer Registration with same mobile no already exists',11,1)

				END

				INSERT INTO ECOMMERCE.T_Registration
				(
					CustomerID,
					FirstName,
					MiddleName,
					LastName,
					EmailID,
					MobileNo,
					HighestEducationQualification,
					StatusID,
					RegistrationSource,
					CreatedOn,
					CreatedBy,
					Gender,
					DateofBirth,
					Address,
					City,
					State,
					Country,
					Pincode
				)
				VALUES
				(
					@CustomerID,
					@FirstName,
					@MiddleName,
					@LastName,
					@EmailID,
					@MobileNo,
					@HighestEducationQualification,
					1,
					@RegSource,
					GETDATE(),
					@CreatedBy,
					@Gender,
					CONVERT(DATE,@DoB),
					@Address,
					@City,
					@State,
					@Country,
					@Pincode
				)

				SET @RegID=SCOPE_IDENTITY()

				--added laguage details : susmita

				IF(@RegID > 0)
				BEGIN

					insert into ECOMMERCE.T_Registration_Language_Map
					(
						RegID,
						CustomerID,
						I_Language_ID,
						I_Language_Name
					)
					values
					(
						@RegID,
						@CustomerID,
						@LanguageID,
						@LanguageName
					)	

				END

				--added language details :susmita

				IF(@CoursesList IS NOT NULL and @CoursesList!='')
				BEGIN

					insert into ECOMMERCE.T_Registration_Courses
					select @RegID,Val,1 from fnString2Rows(@CoursesList,',')

				END


				--Migrate already created students, if any


				insert into ECOMMERCE.T_Registration_Enquiry_Map
				(
					RegID,
					EnquiryID,
					StatusID,
					CreatedOn,
					CreatedBy
				)
				select @RegID,T1.I_Enquiry_Regn_ID,1,GETDATE(),'rice-group-admin'
				from
				(
					select A.I_Enquiry_Regn_ID,B.RegID 
					from 
					T_Enquiry_Regn_Detail A
					inner join T_Center_Hierarchy_Name_Details C on A.I_Centre_Id=C.I_Center_ID
					left join ECOMMERCE.T_Registration_Enquiry_Map B on A.I_Enquiry_Regn_ID=B.EnquiryID and B.StatusID=1 and B.RegID=@RegID
					where 
					A.I_Enquiry_Status_Code is not null and A.I_Enquiry_Status_Code IN (1,3) and 
					C.I_Brand_ID in (109)
					and CASE WHEN LEN(ISNULL(A.S_Mobile_No,0))<=10 THEN ISNULL(A.S_Mobile_No,0) ELSE SUBSTRING(A.S_Mobile_No,LEN(A.S_Mobile_No)-10+1,10) END=@MobileNo
				) T1
				where T1.RegID IS NULL

			END
			ELSE
			BEGIN

				IF(ISNULL(@HighestEducationQualification,'')!='')
					update ECOMMERCE.T_Registration set HighestEducationQualification=@HighestEducationQualification where CustomerID=@CustomerID

				IF(ISNULL(@Gender,'')!='')
					update ECOMMERCE.T_Registration set Gender=@Gender where CustomerID=@CustomerID

				select @RegID=ISNULL(RegID,0) from ECOMMERCE.T_Registration where MobileNo=@MobileNo and StatusID=1 and CustomerID=@CustomerID

			END

			SELECT @RegID as RegID



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

END

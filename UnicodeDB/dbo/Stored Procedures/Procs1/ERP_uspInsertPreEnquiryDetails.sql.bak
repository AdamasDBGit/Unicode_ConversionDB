CREATE PROCEDURE [dbo].[ERP_uspInsertPreEnquiryDetails]      
    (  
      --@Centre INT , 

	  @sFirstName NVARCHAR(MAX) = NULL, --
	  @sMiddleName NVARCHAR(MAX) = NULL, --
	  @sLastName NVARCHAR(MAX) = NULL, --
	  @DtBirthDate DATETIME = NULL, --
	  @sMobileNo NVARCHAR(MAX) = NULL, --
	  @iEnquiryStatusCode int = NULL, --
	  @CreatedBy INT = NULL,      --

	  @iRelationId INT  = NULL, --
	  @FatherFirstName nvarchar(100) = NULL,  --
	  @FatherMiddleName nvarchar(100) = NULL, --
	  @FatherLastName nvarchar(100) = NULL,   --
	  @FatherEmailId nvarchar(100) = NULL,    --
	  @FatherMobileNo nvarchar(50) = NULL,    --

	  @MotherFirstName nvarchar(100) = NULL,  --
	  @MotherMiddleName nvarchar(100) = NULL, --
	  @MotherLastName nvarchar(100) = NULL,   --
	  @MotherEmailId nvarchar(100) = NULL,    --
	  @MotherMobileNo nvarchar(50) = NULL,    --
	  -- current address
	  @sAddressLine1 NVARCHAR(MAX) = NULL, --
	  @sAddressLine2 NVARCHAR(MAX) = NULL, --
	  @iCountryId int = NULL,  --
	  @iStateId int = NULL,   --
	  @iCityId int = NULL,  --
	  @sPinCode NVARCHAR(MAX) = NULL,  --

	  -- permanent address
	  @sPAddressLine1 NVARCHAR(MAX) = NULL, --
	  @sPAddressLine2 NVARCHAR(MAX) = NULL, --
	  @iPCountryId int = NULL,  --
	  @iPStateId int = NULL,   --
	  @iPCityId int = NULL,  --
	  @sPPinCode NVARCHAR(MAX) = NULL,  --

	  @iEnquiryType int = NULL,
	  @SchoolGroupID int = NULL,
	  @sClassID INT = NULL,  --
	  @Stream_ID int = NULL,
	  @SessionID int = NULL,
	  @iBrandID int = NULL,   --
	  @iInfoSourceID int = NULL,
	  --@I_Enquiry_Status_Code int = null,
    
      --@DtBirthDate DATETIME ,  
      --@Age NVARCHAR(MAX) ,  
      --@casteID INT = NULL ,  
      --@CurrCityID INT ,  
      --@CurrStateID INT ,  
      --@CurrCountryID INT ,  
      --@CurrAddress1 NVARCHAR(MAX) ,  
      --@CurrAddress2 NVARCHAR(MAX) ,  
      --@CurrPincode NVARCHAR(MAX)   

 --     @FatherName NVARCHAR(MAX) ,  
 --     @MotherName NVARCHAR(MAX) ,  
 --     @EnquiryDesc NVARCHAR(MAX) ,  
 --     @IsPreEnquiry BIT ,  
 --     --@CrtdBy NVARCHAR(MAX) ,  
 --     @DtCrtdOn DATETIME ,  
 --     @sSelectedCourseID NVARCHAR(MAX) = NULL ,  
        @InfoSourceID INT = NULL ,  
 --     @bHasGivenOtherExam BIT = NULL ,  
        @sQualificationXML XML = NULL ,  
 --     @iSeatType INT = NULL ,  
 --     @iEnrolmentType INT = NULL ,  
 --     @sEnrolmentNo NVARCHAR(MAX) = NULL ,  
 --     @iRankObtained INT = NULL ,  
        @dtFirstFollowUpDate DATETIME = NULL,  
 --     @IsLateral BIT = NULL ,  
 --     @IPreEnquiryFor INT = NULL,
 --     @GuardianName NVARCHAR(MAX)=NULL,
 --     @GuardianPhoneNo NVARCHAR(MAX)=NULL,
 --     @iFatherIncomeGroup INT=NULL,
 --     --@iMotherIncomeGroup INT=NULL,
        @EducationCurrentStatus INT=NULL,
	--  @EmailID NVARCHAR(MAX)=NULL,
	--  @GenderID INT=NULL
	  @sRefererName NVARCHAR(MAX) = null,
	  @sRefererMobileNo NVARCHAR(MAX) = null,
	  @EnqTypeSourceMappingID int=null,
	  @SReferal nvarchar(MAX)=null
    )  
AS   
    BEGIN TRY                    
        SET NOCOUNT OFF ;                    
           
        DECLARE @iEnquiryID INT                    
                           
        DECLARE @iEmployeeId INT       
        DECLARE @sSelectedCourseIDs VARCHAR(100)       
		
		DECLARE @Centre INT

		--DECLARE @FatherName VARCHAR(200) = NULL
		--DECLARE @FatherEmail VARCHAR(200) = NULL
		--DECLARE @FatherPhone VARCHAR(50) = NULL

		--DECLARE @MotherName VARCHAR(200) = NULL
		--DECLARE @MotherEmail VARCHAR(200) = NULL
		--DECLARE @MotherPhone VARCHAR(50) = NULL

		--IF(@iBrandID = 107 )
		--BEGIN
		--	SET @Centre = 1
		--END
		--ELSE IF(@iBrandID = 110)
		--BEGIN
		--	SET @Centre = 36
		--END

		SET @Centre=(
		Select Top 1 I_Centre_Id from T_Brand_Center_Details where I_Brand_ID=@iBrandID
		            )

		

		DECLARE @user_ID VARCHAR(100) = NULL
		SELECT @user_ID = S_Login_ID from T_User_Master where I_User_ID = @CreatedBy
		


		declare @FatherFullName varchar(300)
		declare @MotherFullName varchar(300)
		set @FatherFullName = CONCAT(COALESCE(LTRIM(RTRIM(@FatherFirstName))+' ', ''), COALESCE(LTRIM(RTRIM(@FatherMiddleName))+' ', ''), COALESCE(LTRIM(RTRIM(@FatherLastName)), ''));
		set @MotherFullName = CONCAT(COALESCE(LTRIM(RTRIM(@MotherFirstName))+' ', ''), COALESCE(LTRIM(RTRIM(@MotherMiddleName))+' ', ''), COALESCE(LTRIM(RTRIM(@MotherLastName)), ''));
		IF LEN(@FatherFullName) = 0
			set @FatherFullName = null;
		IF LEN(@MotherFullName) = 0
			set @MotherFullName = null;
		--IF(@iRelationId = 1)
		--BEGIN
		--	SET @FatherName = CONCAT(COALESCE(@ParentFirstName + ' ', ''), COALESCE(@ParentMiddleName + ' ', ''), COALESCE(@ParentLastName, ''))
		--	SET @FatherEmail = @ParentEmailId
		--	SET @FatherPhone = @ParentMobileNo
		--END
		--ELSE IF(@iRelationId = 2)
		--BEGIN
		--	SET @MotherName = CONCAT(COALESCE(@ParentFirstName+' ', ''), COALESCE(@ParentMiddleName+' ', ''), COALESCE(@ParentLastName, ''))
		--	SET @MotherEmail = @ParentEmailId
		--	SET @MotherPhone = @ParentMobileNo
		--END
           
        BEGIN TRANSACTION                    
                     
                  
        --IF ( SELECT COUNT(*)  
        --     FROM   dbo.T_Enquiry_Regn_Detail AS TERD  
        --     WHERE  I_Centre_Id=  @Centre AND S_Mobile_No = @sMobileNo  
        --   ) = 0   
        --    BEGIN        
                INSERT  INTO dbo.T_Enquiry_Regn_Detail  
                        ( 
                          S_First_Name ,  
                          S_Middle_Name ,  
                          S_Last_Name ,  
                          Dt_Birth_Date , 
                          S_Mobile_No ,
						  I_Enquiry_Status_Code , 
						  S_Crtd_By ,

						  S_Father_Name , 
                          S_Mother_Name ,
						  S_Father_Email,
						  S_Mother_Email,
						  S_Father_Mobile_No,
						  S_Mother_Mobile_No,
						  
						  S_Curr_Address1 ,  
                          S_Curr_Address2 , 
                          I_Curr_Country_ID ,  
						  I_Curr_State_ID ,
						  I_Curr_City_ID , 
                          S_Curr_Pincode , 

						  S_Perm_Address1 ,  
                          S_Perm_Address2 , 
                          I_Perm_Country_ID ,  
						  I_Perm_State_ID ,
						  I_Perm_City_ID , 
                          S_Perm_Pincode , 

						  I_Enquiry_Type_ID,
						  I_Centre_Id ,

						  I_School_Group_ID,
						  I_Class_ID,
						  I_Stream_ID,
						  R_I_School_Session_ID,

						  B_IsPreEnquiry ,
						  Dt_Crtd_On, 
						  I_ERP_Entry,
						  I_Info_Source_ID,
						  I_ERP_Crtd_By,
						  I_Is_Active,
						  R_I_AdmStgTypeID
            
                        )  
                VALUES  ( --@Centre ,  
                          --@iEnquiryStatusCode ,  
                          @sFirstName ,  
                          @sMiddleName ,  
                          @sLastName ,  
                          @DtBirthDate ,  
                          --@Age ,  
                          --@casteID , -- I_Caste_ID - int      
                          @sMobileNo ,
						  @iEnquiryStatusCode,
						  @user_ID,

						   --

						  @FatherFullName,
						  @MotherFullName,
						  @FatherEmailId,
						  @MotherEmailId,
						  @FatherMobileNo,
						  @MotherMobileNo,
						  --@ParentEmailId,
						  --@ParentMobileNo,

						  @sAddressLine1,
						  @sAddressLine2 , 
						  @iCountryId ,
						  @iStateId , 
                          @iCityId ,
						  @sPinCode , 

						  @sPAddressLine1,
						  @sPAddressLine2 , 
						  @iPCountryId ,
						  @iPStateId , 
                          @iPCityId ,
						  @sPPinCode , 

						  @iEnquiryType,
						  @Centre,

						  @SchoolGroupID,
						  --@SessionID,
						  @sClassID,
						  @Stream_ID,
						  @SessionID,

						  1,  -- Set B_IsPreEnquiry = 1 first time preEnquiry = ture
						  GETDATE(),
						  1,  -- from ERP entry
						  @iInfoSourceID,
						  @CreatedBy,
						  1, -- Active
						  1  --for Pre Enquiry
         
                        )                    
          
                SELECT  @iEnquiryID = @@IDENTITY   
				
                       
  -- Update the Enquiry No                     
                UPDATE  dbo.T_Enquiry_Regn_Detail  
                SET     S_Enquiry_No = CAST(@iEnquiryID AS VARCHAR(20))  
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID                    
                   
  -- Get the Employee Id of the Councellor                     
                --SELECT  @iEmployeeId = I_Employee_ID  
                --FROM    dbo.T_Employee_Dtls  
                --WHERE   I_Employee_ID = ( SELECT    I_Reference_ID  
                --                          FROM      dbo.T_User_Master  
                --                          WHERE     S_Login_ID = @CreatedBy  
                --                        )
  -- Update the Courses for the Enquiry  
				DECLARE @Course_ID INT
				SET @Course_ID = (Select top 1 I_Course_ID from T_Course_Group_Class_Mapping Where I_Brand_ID = @iBrandID and I_Class_ID = @sClassID and I_School_Session_ID = @SessionID and (I_Stream_ID = @Stream_ID OR I_Stream_ID IS NULL))

                INSERT  INTO dbo.T_Enquiry_Course  
                        ( I_Course_ID ,  
                          I_Enquiry_Regn_ID        
                        )  
						Values (
							@Course_ID,
							@iEnquiryID
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
                          GETDATE() ,  
                          @dtFirstFollowUpDate ,  
                          'First FollowUp after Enquiry'                      
                        )  
IF(@iInfoSourceID>0 or @EnqTypeSourceMappingID>0)
BEGIN
	INSERT into T_ERP_Enquiry_CRM_Details
						(
							I_EnqType_Source_Mapping_ID
							,I_Source_DetailsID
							,S_Referal
							,Is_Active
							,dt_create_dt
							,I_Enquiry_ID
						)
						values
						(
						 @EnqTypeSourceMappingID
						,@iInfoSourceID
						,@SReferal
						,1
						,GETDATE()
						,@iEnquiryID
						)
END
					
				
				Select 1 StatusFlag, 'Pre Enquiry Created Successfully' Message, @iEnquiryID AS EnquiryRegnID, CAST(@iEnquiryID AS VARCHAR(20)) AS EnquiryNo

    --        End        
    --    ELSE   
    --        BEGIN        
				--Select 0 StatusFlag, 'Entry with the same mobile no. already exists' Message  --, @iEnquiryID AS EnquiryRegnID, CAST(@iEnquiryID AS VARCHAR(20)) AS EnquiryNo
    --            --RAISERROR('Entry with the same mobile no. already exists',11,1)        
    --        END                  
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

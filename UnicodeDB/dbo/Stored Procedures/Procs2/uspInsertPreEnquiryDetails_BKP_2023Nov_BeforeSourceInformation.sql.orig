
CREATE PROCEDURE [dbo].[uspInsertPreEnquiryDetails_BKP_2023Nov_BeforeSourceInformation]  
    (  
      @Centre INT ,  
      @IEnquiryStatusCode INT = NULL ,  
      @FirstName VARCHAR(50) ,  
      @MiddleName VARCHAR(50) ,  
      @LastName VARCHAR(50) ,  
      @DtBirthDate DATETIME ,  
      @Age VARCHAR(20) ,  
      @casteID INT = NULL ,  
      @MobileNo VARCHAR(20) ,  
      @CurrCityID INT ,  
      @CurrStateID INT ,  
      @CurrCountryID INT ,  
      @CurrAddress1 VARCHAR(200) ,  
      @CurrAddress2 VARCHAR(200) ,  
      @CurrPincode VARCHAR(20) ,  
      @FatherName VARCHAR(200) ,  
      @MotherName VARCHAR(200) ,  
      @EnquiryDesc VARCHAR(500) ,  
      @IsPreEnquiry BIT ,  
      @CrtdBy VARCHAR(20) ,  
      @DtCrtdOn DATETIME ,  
      @sSelectedCourseID VARCHAR(100) = NULL ,  
      @InfoSourceID INT = NULL ,  
      @bHasGivenOtherExam BIT = NULL ,  
      @sQualificationXML XML = NULL ,  
      @iSeatType INT = NULL ,  
      @iEnrolmentType INT = NULL ,  
      @sEnrolmentNo VARCHAR(50) = NULL ,  
      @iRankObtained INT = NULL ,  
      @dtFirstFollowUpDate DATETIME,  
      @IsLateral BIT = NULL ,  
      @IPreEnquiryFor INT = NULL,
      @GuardianName VARCHAR(200)=NULL,
      @GuardianPhoneNo VARCHAR(20)=NULL,
      @iFatherIncomeGroup INT=NULL,
      --@iMotherIncomeGroup INT=NULL,
      @EducationCurrentStatus INT=NULL,
	  @EmailID VARCHAR(MAX)=NULL,
	  @GenderID INT=NULL
    )  
AS   
    BEGIN TRY                    
        SET NOCOUNT OFF ;                    
           
        DECLARE @iEnquiryID INT                    
                           
        DECLARE @iEmployeeId INT       
        DECLARE @sSelectedCourseIDs VARCHAR(100)                      
           
        BEGIN TRANSACTION                    
                     
                  
        IF ( SELECT COUNT(*)  
             FROM   dbo.T_Enquiry_Regn_Detail AS TERD  
             WHERE  I_Centre_Id=  @Centre AND S_Mobile_No = @MobileNo  
           ) = 0   
            BEGIN        
                INSERT  INTO dbo.T_Enquiry_Regn_Detail  
                        ( I_Centre_Id ,  
                          I_Enquiry_Status_Code ,  
                          S_First_Name ,  
                          S_Middle_Name ,  
                          S_Last_Name ,  
                          Dt_Birth_Date ,  
                          S_Age ,  
                          I_Caste_ID ,  
                          S_Mobile_No ,  
                          I_Curr_City_ID ,  
                          I_Curr_State_ID ,  
                          I_Curr_Country_ID ,  
                          S_Curr_Address1 ,  
                          S_Curr_Address2 ,  
                          S_Curr_Pincode ,  
                          S_Father_Name ,  
                          S_Mother_Name ,
                          S_Guardian_Name,
                          S_Guardian_Phone_No,  
                          S_Enquiry_Desc ,  
                          B_IsPreEnquiry ,  
                          I_Info_Source_ID ,  
                          B_Has_Given_Exam ,  
                          I_Seat_Type_ID ,  
                          I_Enrolment_Type_ID ,  
                          S_Enrolment_No ,  
                          I_Rank_Obtained ,  
                          S_Crtd_By ,  
                          Dt_Crtd_On,  
                          B_IsLateral,  
                          I_PreEnquiryFor,
                          I_Relevence_ID,
                          I_Monthly_Family_Income_ID,
                          PreEnquiryDate,
                          PreEnquiry_Crtd_By,
						  S_Email_ID,
						  I_Sex_ID
                          --I_Mother_Income_Group_ID               
                        )  
                VALUES  ( @Centre ,  
                          @IEnquiryStatusCode ,  
                          @FirstName ,  
                          @MiddleName ,  
                          @LastName ,  
                          @DtBirthDate ,  
                          @Age ,  
                          @casteID , -- I_Caste_ID - int      
                          @MobileNo ,  
                          @CurrCityID ,  
                          @CurrStateID ,  
                          @CurrCountryID ,  
       @CurrAddress1 ,  
                          @CurrAddress2 ,  
                          @CurrPincode ,  
                          @FatherName ,  
                          @MotherName ,
                          @GuardianName,
                          @GuardianPhoneNo,  
                          @EnquiryDesc ,  
                          @IsPreEnquiry ,  
                          @InfoSourceID , -- I_Info_Source_ID - int        
                          @bHasGivenOtherExam ,  
    @iSeatType ,  
                          @iEnrolmentType ,  
                          @sEnrolmentNo ,  
                          @iRankObtained ,  
                          @CrtdBy ,  
                          @DtCrtdOn,  
                          @IsLateral,  
                          @IPreEnquiryFor,
                          1,
                          @iFatherIncomeGroup,
                          @DtCrtdOn,
                          @CrtdBy,
						  @EmailID,
						  @GenderID
                          --@iMotherIncomeGroup          
                        )                    
          
                SELECT  @iEnquiryID = @@IDENTITY                     
                       
  -- Update the Enquiry No                     
                UPDATE  dbo.T_Enquiry_Regn_Detail  
                SET     S_Enquiry_No = CAST(@iEnquiryID AS VARCHAR(20))  
                WHERE   I_Enquiry_Regn_ID = @iEnquiryID                    
                   
  -- Get the Employee Id of the Councellor                     
                SELECT  @iEmployeeId = I_Employee_ID  
                FROM    dbo.T_Employee_Dtls  
                WHERE   I_Employee_ID = ( SELECT    I_Reference_ID  
                                          FROM      dbo.T_User_Master  
                                          WHERE     S_Login_ID = @CrtdBy  
                                        )        
  -- Update the Courses for the Enquiry                    
                INSERT  INTO dbo.T_Enquiry_Course  
                        ( I_Course_ID ,  
                          I_Enquiry_Regn_ID        
                        )  
                        SELECT  * ,  
                                @iEnquiryID  
                        FROM    dbo.fnString2Rows(@sSelectedCourseID, ',')                     
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
                          Dt_Crtd_On,
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
                                @DtCrtdOn,
                                T.c.value('@S_Institution','varchar(MAX)') 
                        FROM    @sQualificationXML.nodes('/Root/Qualification') T ( c )         
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
						
				EXEC [LMS].[uspInsertEnquiryDataForInterface] @iEnquiryID,'ADD'
                       
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
        DECLARE @ErrMsg NVARCHAR(4000) ,  
            @ErrSeverity INT                    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,  
                @ErrSeverity = ERROR_SEVERITY()                    
                    
        RAISERROR(@ErrMsg, @ErrSeverity, 1)                    
    END CATCH

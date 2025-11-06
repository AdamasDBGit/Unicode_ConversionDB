
CREATE PROCEDURE [dbo].[uspInsertStudentDetailsFromEnquiry_BKP_BeforeGaurdianJune2023]  
    (  
      @iEnquiryRegnID INT ,  
      @CrtdBy VARCHAR(20) ,  
      @DtCrtdOn DATETIME ,  
      @sConductCode VARCHAR(20),  
      @sStudentCode VARCHAR(500) = NULL,  
      @iRollNo INT = NULL,
      @sStudyMaterialNo varchar(500) = NULL  
    )  
AS   
    SET NOCOUNT ON    
    BEGIN TRY     
    
        DECLARE @sLoginID VARCHAR(500)     
        DECLARE @iStudentDetailId INT    
        DECLARE @iCenterID INT    
    
        BEGIN TRANSACTION    
        SELECT TOP 1  
                @iCenterID = I_Destination_Center_ID  
        FROM    dbo.T_Student_Registration_Details  
        WHERE   I_Enquiry_Regn_ID = @iEnquiryRegnID    
        IF ( @iCenterID IS NULL )   
            BEGIN    
                SELECT  @iCenterID = I_Centre_Id  
                FROM    dbo.T_Enquiry_Regn_Detail  
                WHERE   I_Enquiry_Regn_ID = @iEnquiryRegnID    
            END    
     
        IF EXISTS ( SELECT  1  
                    FROM    T_Student_Detail  
                    WHERE   I_Enquiry_Regn_Id = @iEnquiryRegnID  
                            AND I_Status <> 0 )   
            BEGIN    
                RAISERROR('Student Already Exists With This Enquiry', 16, 1)    
            END    
    
  IF(@sStudentCode IS NULL)  
  BEGIN  
   SELECT  @sLoginID = [dbo].fnGetStudentNo(@iCenterID)    
  END  
  ELSE  
   BEGIN  
    SET @sLoginID = @sStudentCode  
   END   
    
        INSERT  INTO T_Student_Detail  
                ( I_Enquiry_Regn_Id ,  
                  S_Student_Id ,  
                  I_Status ,  
                  S_Title ,  
                  S_First_Name ,  
                  S_Middle_Name ,  
                  S_Last_Name ,  
                  Dt_Birth_Date ,  
                  S_Age ,  
                  C_Skip_Test ,  
                  I_Occupation_ID ,  
                  I_Pref_Career_ID ,  
                  I_Qualification_Name_ID ,  
                  I_Stream_ID ,  
                  S_Guardian_Name ,  
                  I_Guardian_Occupation_ID ,  
                  S_Guardian_Email_ID ,  
                  S_Mobile_No ,  
                  S_Guardian_Phone_No ,  
                  I_Curr_City_ID ,  
                  I_Curr_State_ID ,  
                  S_Email_ID ,  
                  I_Curr_Country_ID ,  
                  S_Phone_No ,  
                  S_Curr_Address1 ,  
                  S_Curr_Address2 ,  
                  S_Curr_Pincode ,  
                  S_Perm_Address1 ,  
                  S_Guardian_Mobile_No ,  
                  S_Perm_Address2 ,  
                  I_Income_Group_ID ,  
                  S_Perm_Pincode ,  
                  S_Curr_Area ,  
                  I_Perm_City_ID ,  
                  I_Perm_State_ID ,  
                  I_Perm_Country_ID ,  
                  S_Perm_Area ,  
                  S_Is_Corporate ,  
                  I_Corporate_ID ,  
                  S_Conduct_Code ,  
                  S_Crtd_By ,  
                  Dt_Crtd_On,  
                  I_RollNo    
                )  
                SELECT  @iEnquiryRegnID ,  
                        @sLoginID ,  
                        1 ,  
                        S_Title ,  
                        S_First_Name ,  
                        S_Middle_Name ,  
                        S_Last_Name ,  
                        Dt_Birth_Date ,  
                        S_Age ,  
                        C_Skip_Test ,  
                        I_Occupation_ID ,  
                        I_Pref_Career_ID ,  
                        I_Qualification_Name_ID ,  
                        I_Stream_ID ,  
                        S_Guardian_Name ,  
                        I_Guardian_Occupation_ID ,  
                        S_Guardian_Email_ID ,  
                        S_Mobile_No ,  
                        S_Guardian_Phone_No ,  
                        I_Curr_City_ID ,  
                        I_Curr_State_ID ,  
                        S_Email_ID ,  
                        I_Curr_Country_ID ,  
                        S_Phone_No ,  
                        S_Curr_Address1 ,  
                        S_Curr_Address2 ,  
                        S_Curr_Pincode ,  
                        S_Perm_Address1 ,  
                        S_Guardian_Mobile_No ,  
                        S_Perm_Address2 ,  
                        I_Income_Group_ID ,  
                        S_Perm_Pincode ,  
                        S_Curr_Area ,  
                        I_Perm_City_ID ,  
                        I_Perm_State_ID ,  
                        I_Perm_Country_ID ,  
                        S_Perm_Area ,  
                        S_Is_Corporate ,  
                        I_Corporate_ID ,  
                        @sConductCode ,  
                        @CrtdBy ,  
                        @DtCrtdOn,  
                        @iRollNo  
                FROM    T_Enquiry_Regn_Detail  
                WHERE   I_Enquiry_Regn_ID = @iEnquiryRegnID    
     
        SET @iStudentDetailId = SCOPE_IDENTITY()   
    
 --close the enquiry/registration    
        UPDATE  T_Enquiry_Regn_Detail  
        SET     I_Enquiry_Status_Code = 3 ,  
                I_Centre_Id = @iCenterID  
        WHERE   I_Enquiry_Regn_ID = @iEnquiryRegnID    
     
        INSERT  INTO T_Student_Center_Detail  
                ( I_Student_Detail_ID ,  
                  I_Centre_ID ,  
                  I_Status ,  
                  Dt_Valid_From    
                )  
                SELECT  @iStudentDetailId ,  
                        @iCenterID ,  
                        1 ,  
                        GETDATE()    
		
		if(@sStudyMaterialNo is not null)
		BEGIN	
			insert into T_Student_StudyMaterial_Map
			select @iStudentDetailId,@sStudyMaterialNo
		END
		
        SELECT  @iStudentDetailId AS StudentID ,  
                @sLoginID AS StudentCode     
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

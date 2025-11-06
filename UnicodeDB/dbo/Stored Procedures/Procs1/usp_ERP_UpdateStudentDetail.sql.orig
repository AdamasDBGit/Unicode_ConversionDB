    
-- =============================================    
-- Author: <Parichoy Nandi>    
-- Create date: <14th jan 2024>    
-- Description: <to add or update the student detail>    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_ERP_UpdateStudentDetail]     
    @StudentDetailID INT,    
    @StudentID INT = NULL,    
    @EnquiryID INT,    
    @StudentPhoto VARCHAR(500) = NULL,    
    @StudentFirstName VARCHAR(255) = NULL,    
    @StudentMiddleName VARCHAR(255) = NULL,    
    @StudentLastName VARCHAR(255) = NULL,    
    @BirthDate DATETIME = NULL,    
    @Age VARCHAR(20) = NULL,    
    @EmailID VARCHAR(200) = NULL,    
    @MobileNo VARCHAR(500) = NULL,    
    @BloodGroupID INT = NULL,    
    @GenderID INT = NULL,    
    @NativeLanguageID INT = NULL,    
    @CasteID INT = NULL,    
    @NationalityID INT = NULL,    
    @ReligionID INT = NULL,    
    @Address1 VARCHAR(200) = NULL,    
    @Address2 VARCHAR(200) = NULL,    
    @Pincode INT = NULL,    
    @StudentStatus INT = NULL,    
    @CountryID INT = NULL,    
    @StateID INT = NULL,    
    @CityID INT = NULL,    
    @Sibling INT = NULL,    
    @PrevAcademy INT = NULL,    
    @PrevSchool VARCHAR(100) = NULL,    
    @PrevBoard VARCHAR(100) = NULL,    
    @PrevAddress VARCHAR(255) = NULL,    
    @SibID VARCHAR(100) = NULL,    
    @SibName VARCHAR(100) = NULL,    
    @SibRunning INT = NULL,    
    @SibPassYear VARCHAR(12) = NULL,    
    @UpdatedBy INT = NULL,    
    @UTStudentGuardian UT_StudentGuardian READONLY    
AS    
BEGIN TRANSACTION    
BEGIN TRY     
    BEGIN    
        SET NOCOUNT ON;    
    
        IF EXISTS (SELECT 1 FROM T_ERP_Student_Detail WHERE I_Student_Detail_ID = @StudentDetailID AND Is_Active = 1)    
        BEGIN    
            UPDATE [dbo].[T_ERP_Student_Detail]    
            SET     
                [S_First_Name] = ISNULL(@StudentFirstName, [S_First_Name]),    
                [S_Middle_Name] = ISNULL(@StudentMiddleName, [S_Middle_Name]),    
                [S_Last_Name] = ISNULL(@StudentLastName, [S_Last_Name]),    
                [Dt_Birth_Date] = ISNULL(@BirthDate, [Dt_Birth_Date]),    
                [S_Age] = ISNULL(@Age, [S_Age]),    
                [S_Email_ID] = ISNULL(@EmailID, [S_Email_ID]),    
                [S_Mobile_No] = ISNULL(@MobileNo, [S_Mobile_No]),    
                [S_Perm_Address1] = ISNULL(@Address1, [S_Perm_Address1]),    
                [S_Perm_Address2] = ISNULL(@Address2, [S_Perm_Address2]),    
                [I_Perm_Country_ID] = ISNULL(@CountryID, [I_Perm_Country_ID]),    
                [I_Perm_State_ID] = ISNULL(@StateID, [I_Perm_State_ID]),    
                [I_Perm_City_ID] = ISNULL(@CityID, [I_Perm_City_ID]),    
                [S_Perm_Pincode] = ISNULL(@Pincode, [S_Perm_Pincode]),    
                [I_UpdatedBy] = @UpdatedBy,    
                [Dtt_UpdatedAt] = GETDATE()    
            WHERE [I_Student_Detail_ID] = @StudentDetailID AND [S_Student_ID] = @StudentID;    
     
            UPDATE [dbo].[T_ERP_Enquiry_Regn_Detail]    
            SET     
                [S_First_Name] = ISNULL(@StudentFirstName, [S_First_Name]),    
                [S_Middle_Name] = ISNULL(@StudentMiddleName, [S_Middle_Name]),    
                [S_Last_Name] = ISNULL(@StudentLastName, [S_Last_Name]),    
                [Dt_Birth_Date] = ISNULL(@BirthDate, [Dt_Birth_Date]),    
                [S_Email_ID] = ISNULL(@EmailID, [S_Email_ID]),    
                [S_Mobile_No] = ISNULL(@MobileNo, [S_Mobile_No]),    
                [S_Upd_By] = @UpdatedBy,    
                [Dt_Upd_On] = GETDATE(),    
                [I_Caste_ID] = ISNULL(@CasteID, [I_Caste_ID]),    
                [S_Student_Photo] = ISNULL(@StudentPhoto, [S_Student_Photo]),    
                [I_Gender_ID] = ISNULL(@GenderID, [I_Gender_ID]),    
                [I_Native_Language_ID] = ISNULL(@NativeLanguageID, [I_Native_Language_ID]),    
                [I_Nationality_ID] = ISNULL(@NationalityID, [I_Nationality_ID]),    
                [I_Religion_ID] = ISNULL(@ReligionID, [I_Religion_ID]),    
                [I_Blood_Group_ID] = ISNULL(@BloodGroupID, [I_Blood_Group_ID]),    
                [Is_Sibling] = ISNULL(@Sibling, [Is_Sibling]),    
                [Is_Prev_Academy] = ISNULL(@PrevAcademy, [Is_Prev_Academy])    
            WHERE [I_Enquiry_Regn_ID] = @EnquiryID;    
        END    
    
        IF EXISTS (SELECT 1 FROM T_ERP_EnquiryReg_Prev_Details WHERE R_I_Enquiry_Regn_ID = @EnquiryID)    
        BEGIN    
            UPDATE [dbo].[T_ERP_EnquiryReg_Prev_Details]    
            SET     
                [S_School_Name] = ISNULL(@PrevSchool, [S_School_Name]),    
                [S_School_Board] = ISNULL(@PrevBoard, [S_School_Board]),    
                [S_Address] = ISNULL(@PrevAddress, [S_Address]),    
                [Dtt_Modified_At] = GETDATE(),    
                [I_Modified_By] = @UpdatedBy    
            WHERE [R_I_Enquiry_Regn_ID] = @EnquiryID;    
    
            UPDATE [dbo].[T_ERP_PreEnq_Siblings]    
            SET    
                [S_StudentID] = ISNULL(@SibID, [S_StudentID]),    
                [S_Stud_Name] = ISNULL(@SibName, [S_Stud_Name]),    
                [Is_Running_Stud] = ISNULL(@SibRunning, [Is_Running_Stud]),    
                [S_Passout_Year] = ISNULL(@SibPassYear, [S_Passout_Year]),    
                [Dtt_Modified_At] = GETDATE(),    
                [I_Modified_By] = @UpdatedBy    
            WHERE [R_I_Enquiry_Regn_ID] = @EnquiryID;    
        END    
    
        UPDATE [T_ERP_Enquiry_Regn_Guardian_Master]    
        SET    
            [S_Mobile_No] = u.[GuardianMobile],    
            [S_First_Name] = u.[GuardianFirstName],    
            [S_Middile_Name] = u.[GuardianMiddleName],    
            [S_Last_Name] = u.[GuardianLastName],    
            [S_Guardian_Email] = u.[GuardianEmail],    
            [I_Qualification_ID] = u.[GuardianQualification],    
            [I_Occupation_ID] = u.[Occupation],    
            [S_Company_Name] = u.[GuardianCompanyName],    
            [S_Designation] = u.[GuardianDesignation],    
            [I_Income_Group_ID] = u.[Income],    
            [S_Profile_Picture] = u.[GuardianPicture],    
            [Dt_UpdatedAt] = GETDATE()    
        FROM    
            [T_ERP_Enquiry_Regn_Guardian_Master] t    
        INNER JOIN    
            @UTStudentGuardian u ON t.[I_Enquiry_Regn_ID] = u.[EnquiryID] AND t.[I_Relation_ID] = u.RelationID;    
    
        SELECT 1 StatusFlag, 'Student Details updated' Message;    
    END    
END TRY    
BEGIN CATCH    
    ROLLBACK TRANSACTION;    
    DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT    
    SELECT @ErrMsg = ERROR_MESSAGE(),    
           @ErrSeverity = ERROR_SEVERITY()    
    SELECT 0 StatusFlag, @ErrMsg Message;    
END CATCH    
    
COMMIT TRANSACTION;

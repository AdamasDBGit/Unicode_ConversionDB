CREATE PROCEDURE [dbo].[ERP_uspBulkInsertPreEnquiryDetails]
    @BulkData [dbo].[PreEnquiryBulkUploadType] READONLY,
    @CreatedBy INT,
    @BrandID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
		declare @iCenterID int;
		set @iCenterID = (select top 1 I_Centre_Id from T_Brand_Center_Details  where I_Brand_ID=@BrandID)
        INSERT INTO dbo.T_Enquiry_Regn_Detail
        (
            S_First_Name,
            S_Middle_Name,
            S_Last_Name,
            Dt_Birth_Date,
            S_Mobile_No,
            S_Father_Name,
            S_Mother_Name,
            S_Father_Email,
            S_Mother_Email,
            S_Father_Mobile_No,
            S_Mother_Mobile_No,
            S_Curr_Address1,
            S_Curr_Address2,
            I_Curr_Country_ID,
            I_Curr_State_ID,
            I_Curr_City_ID,
            S_Curr_Pincode,
            S_Perm_Address1,
            S_Perm_Address2,
            I_Perm_Country_ID,
            I_Perm_State_ID,
            I_Perm_City_ID,
            S_Perm_Pincode,
            -- Add other columns as needed
            I_Enquiry_Type_ID,
            I_Class_ID,
            I_Stream_ID,
            R_I_School_Session_ID,
            I_Brand_ID,
            Dt_Crtd_On,
            S_Crtd_By,
            B_IsPreEnquiry,
            I_ERP_Entry,
            I_Is_Active,
            R_I_AdmStgTypeID,
			I_Centre_Id
        )
        SELECT
            FirstName,
            MiddleName,
            LastName,
            DateOfBirth,
            MobileNo,
            CONCAT(FatherFirstName, ' ', FatherMiddleName, ' ', FatherLastName),
            CONCAT(MotherFirstName, ' ', MotherMiddleName, ' ', MotherLastName),
            FatherEmailId,
            MotherEmailId,
            FatherMobileNo,
            MotherMobileNo,
            CurrAddress1,
            CurrAddress2,
            CurrCountryId,
            CurrStateId,
            CurrCityId,
            CurrPinCode,
            PermAddress1,
            PermAddress2,
            PermCountryId,
            PermStateId,
            PermCityId,
            PermPinCode,
            EnquiryTypeId,
            ClassId,
            StreamId,
            AcademicSessionId,
            @BrandID,
            GETDATE(),
            @CreatedBy,
            1, -- B_IsPreEnquiry
            1, -- I_ERP_Entry
            1, -- I_Is_Active
            1,  -- R_I_AdmStgTypeID (Pre Enquiry)
			@iCenterID
        FROM @BulkData

        COMMIT TRANSACTION
        SELECT 1 AS StatusFlag, 'Bulk upload successful' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SELECT 0 AS StatusFlag, ERROR_MESSAGE() AS Message
    END CATCH
END
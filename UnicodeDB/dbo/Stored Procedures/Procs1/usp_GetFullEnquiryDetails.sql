 --SELECT S_Father_Name     
 --       FROM [dbo].[T_Enquiry_Regn_Detail]     
 --       WHERE I_Enquiry_Regn_ID = 8551  
		--DIPANKAR  SARKAR
--EXEC [usp_GetFullEnquiryDetails_New] 8551
CREATE PROCEDURE [dbo].[usp_GetFullEnquiryDetails]      
(      
    @iEnquiryRegnID INT        
)      
AS      
BEGIN      
    SET NOCOUNT ON;      
    
    DECLARE @studentID INT;
    SET @studentID = (
        SELECT I_Student_Detail_ID 
        FROM T_Student_Detail 
        WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID
    );    

    -- ========== FATHER NAME SPLIT ==========
    DECLARE @FatherFullName NVARCHAR(300) = (
        SELECT S_Father_Name     
        FROM [dbo].[T_Enquiry_Regn_Detail]     
        WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID    
    );
    
    DECLARE @FatherFirstName NVARCHAR(100), @FatherMiddleName NVARCHAR(100), @FatherLastName NVARCHAR(100);

    IF @FatherFullName IS NOT NULL AND CHARINDEX(' ', @FatherFullName) > 0
    BEGIN
        DECLARE @FatherLastSpace INT = LEN(@FatherFullName) - CHARINDEX(' ', REVERSE(@FatherFullName)) + 1;
        SET @FatherLastName = LTRIM(RTRIM(SUBSTRING(@FatherFullName, @FatherLastSpace + 1, LEN(@FatherFullName))));
        SET @FatherFirstName = LTRIM(RTRIM(LEFT(@FatherFullName, @FatherLastSpace - 1)));

        IF CHARINDEX(' ', @FatherFirstName) > 0
        BEGIN
            SET @FatherMiddleName = LTRIM(RTRIM(SUBSTRING(@FatherFirstName, CHARINDEX(' ', @FatherFirstName) + 1, LEN(@FatherFirstName))));
            SET @FatherFirstName = LTRIM(RTRIM(LEFT(@FatherFirstName, CHARINDEX(' ', @FatherFirstName) - 1)));
        END
        ELSE
        BEGIN
            SET @FatherMiddleName = NULL;
        END
    END
    ELSE
    BEGIN
        SET @FatherFirstName = LTRIM(RTRIM(@FatherFullName));
        SET @FatherMiddleName = NULL;
        SET @FatherLastName = NULL;
    END

    -- ========== MOTHER NAME SPLIT ==========
    DECLARE @MotherFullName NVARCHAR(300) = (
        SELECT S_Mother_Name     
        FROM [dbo].[T_Enquiry_Regn_Detail]     
        WHERE I_Enquiry_Regn_ID = @iEnquiryRegnID    
    );

    DECLARE @MotherFirstName NVARCHAR(100), @MotherMiddleName NVARCHAR(100), @MotherLastName NVARCHAR(100);

    IF @MotherFullName IS NOT NULL AND CHARINDEX(' ', @MotherFullName) > 0
    BEGIN
        DECLARE @MotherLastSpace INT = LEN(@MotherFullName) - CHARINDEX(' ', REVERSE(@MotherFullName)) + 1;
        SET @MotherLastName = LTRIM(RTRIM(SUBSTRING(@MotherFullName, @MotherLastSpace + 1, LEN(@MotherFullName))));
        SET @MotherFirstName = LTRIM(RTRIM(LEFT(@MotherFullName, @MotherLastSpace - 1)));

        IF CHARINDEX(' ', @MotherFirstName) > 0
        BEGIN
            SET @MotherMiddleName = LTRIM(RTRIM(SUBSTRING(@MotherFirstName, CHARINDEX(' ', @MotherFirstName) + 1, LEN(@MotherFirstName))));
            SET @MotherFirstName = LTRIM(RTRIM(LEFT(@MotherFirstName, CHARINDEX(' ', @MotherFirstName) - 1)));
        END
        ELSE
        BEGIN
            SET @MotherMiddleName = NULL;
        END
    END
    ELSE
    BEGIN
        SET @MotherFirstName = LTRIM(RTRIM(@MotherFullName));
        SET @MotherMiddleName = NULL;
        SET @MotherLastName = NULL;
    END

    -- ========== MAIN QUERY 1 ==========
    SELECT DISTINCT
        TEERD.I_Enquiry_Regn_ID,        
        TEERD.I_Enquiry_Status_Code,        
        TEERD.I_Enquiry_Type_ID,        
        TEERD.S_Enquiry_No,        
        TEERD.S_First_Name,        
        TEERD.S_Middle_Name,        
        TEERD.S_Last_Name,        
        TEERD.I_Sex_ID,        
        TEERD.Dt_Birth_Date,        
        TEERD.S_Mobile_No,        
        TEERD.I_Blood_Group_ID,        
        TEERD.I_Native_Language_ID,        
        TEERD.I_Nationality_ID,        
        TEERD.I_Religion_ID,        
        TEERD.I_Caste_ID,        
        TEERD.S_Email_ID,        
        TEERD.S_Student_Photo AS CandidatePhotoPath,        
        TEERD.Enquiry_Date,        
        TEERD.PreEnquiryDate,        
        TEERD.S_Enquiry_No,      
        TESFSCM.R_I_Fee_Structure_ID AS FeeStructureID,      
        ISNULL(TEERD.I_Tab_No, 0) AS I_Tab_No,      
        SD.S_Student_ID AS StudentInfoID      
    FROM T_Enquiry_Regn_Detail TEERD
        LEFT JOIN T_Student_Detail SD ON SD.I_Enquiry_Regn_ID = TEERD.I_Enquiry_Regn_ID      
        LEFT JOIN T_ERP_Stud_Fee_Struct_Comp_Mapping TESFSCM ON TESFSCM.R_I_Enquiry_Regn_ID = TEERD.I_Enquiry_Regn_ID      
    WHERE TEERD.I_Enquiry_Regn_ID = @iEnquiryRegnID;

    -- ========== MAIN QUERY 2 ==========
    SELECT DISTINCT
        TEERD.I_Enquiry_Regn_ID,
        TEERD.S_Father_Mobile_No,
        @FatherFirstName AS S_Father_First_Name,
        @FatherMiddleName AS S_Father_Middile_Name,
        @FatherLastName AS S_Father_Last_Name,
        TEERD.S_Father_Email AS S_Father_Email_ID,
        TEERD.I_Father_Qualification_ID,
        TEERD.I_Father_Occupation_ID,
        TEERD.S_Father_Company_Name,
        TEERD.S_Father_Designation,
        TEERD.I_Father_Income_Group_ID,
        TEERD.S_Father_Photo AS S_Father_Photo_Path,
        TEERD.S_Mother_Mobile_No,
        @MotherFirstName AS S_Mother_First_Name,
        @MotherMiddleName AS S_Mother_Middile_Name,
        @MotherLastName AS S_Mother_Last_Name,
        TEERD.S_Mother_Email AS S_Mother_Email_ID,
        TEERD.I_Mother_Qualification_ID,
        TEERD.I_Mother_Occupation_ID,
        TEERD.S_Mother_Company_Name,
        TEERD.S_Mother_Designation,
        TEERD.I_Mother_Income_Group_ID,
        TEERD.S_Mother_Photo AS S_Mother_Photo_Path,
        TEERD.I_Curr_Country_ID AS S_Country_ID,
        TEERD.I_Curr_State_ID AS S_State_ID,
        TEERD.I_Curr_City_ID AS S_City_ID,
        TEERD.S_Curr_Address1 AS S_Address1,
        TEERD.S_Curr_Address2 AS S_Address2,
        TEERD.S_Curr_Pincode AS S_Pincode,
        TEERD.I_Perm_Country_ID AS I_P_Country_ID,
        TEERD.I_Perm_State_ID AS I_P_State_ID,
        TEERD.I_Perm_City_ID AS I_P_City_ID,
        TEERD.S_Perm_Address1 AS S_P_AddressLine_1,
        TEERD.S_Perm_Address2 AS S_P_AddressLine_2,
        TEERD.S_Perm_Pincode AS S_P_PinCode
    FROM T_Enquiry_Regn_Detail TEERD
    WHERE TEERD.I_Enquiry_Regn_ID = @iEnquiryRegnID;

    -- ========== MAIN QUERY 3 ==========
    SELECT DISTINCT
        TEERD.I_Enquiry_Regn_ID,
        TEERD.I_Enquiry_Type_ID,
        ISNULL(sgc.I_School_Group_ID, TEERD.I_School_Group_ID) AS I_School_Group_ID,
        ISNULL(sgc.I_Class_ID, TEERD.I_Class_ID) AS I_Course_Applied_For,
        scs.I_Stream_ID AS I_Stream_ID,
        TEECD.I_EnqType_Source_Mapping_ID AS I_Info_Source_ID,
        TEERD.R_I_School_Session_ID,
        TEERD.Is_Prev_Academy,
        TEERD.Is_Sibling,
        TEEPD.R_I_Prev_Class_ID,
        CASE WHEN TEEPD.Is_Marks_Input = 1 THEN 0 ELSE 1 END AS Is_Marks_Input,
        TEEPD.N_TotalMarks,
        TEEPD.N_Obtain_Marks,
        TEEPD.S_Grade,
        TEEPD.N_Percentage,
        TEEPD.S_School_Name,
        TEEPD.S_School_Board,
        TEEPD.S_Address,
        TEPS.S_StudentID,
        TEPS.S_Stud_Name,
        TEECD.I_Source_DetailsID AS I_Source_ID,
        TEECD.S_Referal AS S_Referal,
        CASE WHEN TEPS.Is_Running_Stud = 1 THEN 0 ELSE 1 END AS Is_Running_Stud,
        TEPS.S_Passout_Year
    FROM T_Enquiry_Regn_Detail TEERD
        LEFT JOIN T_ERP_EnquiryReg_Prev_Details TEEPD ON TEERD.I_Enquiry_Regn_ID = TEEPD.R_I_Enquiry_Regn_ID
        LEFT JOIN T_ERP_PreEnq_Siblings TEPS ON TEERD.I_Enquiry_Regn_ID = TEPS.R_I_Enquiry_Regn_ID
        LEFT JOIN T_ERP_Enquiry_CRM_Details TEECD ON TEECD.I_Enquiry_ID = TEERD.I_Enquiry_Regn_ID
        LEFT JOIN T_ERP_CRMSource_Details TECD ON TECD.I_Source_DetailsID = TEECD.I_Source_DetailsID
        LEFT JOIN T_ERP_EnqType_Source_Mapping TEESM ON TEESM.I_EnqType_Source_Mapping_ID = TECD.I_EnqType_Source_Mapping_ID
        LEFT JOIN T_Student_Class_Section scs ON scs.I_Student_Detail_ID = @studentID AND scs.I_Status = 1
        LEFT JOIN T_School_Group_Class sgc ON sgc.I_School_Group_Class_ID = scs.I_School_Group_Class_ID AND sgc.I_Status = 1
    WHERE TEERD.I_Enquiry_Regn_ID = @iEnquiryRegnID;

END

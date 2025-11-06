-- Dynamic-SQL version of the original stored procedure.
-- Uses sp_executesql with parameterization to build and execute the INSERT or UPDATE dynamically,
-- while preserving the duplicate-check logic and returning the same StatusFlag / Message (+ Id on insert).

CREATE   PROCEDURE [dbo].[ERP_Usp_InsertBank_Dynamic]      
    @ID                     INT = NULL,      
    @stBusinessName         NVARCHAR(100),      
    @stBusinessType         NVARCHAR(100),      
    @stBusinessTypeDesc     NVARCHAR(MAX),      
    @stBankName             NVARCHAR(200),      
    @stBranchName           NVARCHAR(200),      
    @stIFSCCode             NVARCHAR(20),      
    @stMICRCode             NVARCHAR(20),      
    @stSWIFTCode            NVARCHAR(20),      
    @inAccountType          INT,      
    @stAccountHolderName    NVARCHAR(150),      
    @stAccountNumber        NVARCHAR(50),      
    @stBankEmail            NVARCHAR(100),      
    @stBankPhone            NVARCHAR(20),      
    @stSupportingDocs       NVARCHAR(255),      
    @stKYCDocs              NVARCHAR(255),      
    @stEmail                NVARCHAR(100) = NULL,      
    @stPhone                NVARCHAR(20)  = NULL,      
    @stType                 NVARCHAR(20)  = NULL,      
    @stReferenceId          NVARCHAR(100) = NULL,      
    @stContactName          NVARCHAR(255) = NULL,      
    @stProfileFields        NVARCHAR(MAX) = NULL,      
    @stLegalInfo            NVARCHAR(MAX) = NULL,      
    @IsDashboardEnabled     BIT           = NULL,      
    @stNotes                NVARCHAR(MAX) = NULL,      
    @LinkedAccountId        NVARCHAR(100) = NULL,    
    @stPAN                  NVARCHAR(20) = NULL,    
    @stGST                  NVARCHAR(20) = NULL,    
    @stStreet1              NVARCHAR(255) = NULL,    
    @stStreet2              NVARCHAR(255) = NULL,    
    @stCity                 NVARCHAR(100) = NULL,    
    @stState                NVARCHAR(100) = NULL,    
    @stPostalCode           NVARCHAR(20) = NULL,    
    @stCountry              NVARCHAR(100) = NULL,    
    @stAccountType          NVARCHAR(100) = NULL,    
    @stBankType             NVARCHAR(100) = NULL,    
    @inBankType             INT,      
    @inStatus               INT,      
    @stRemarks              NVARCHAR(MAX),      
    @inBrandID              INT      
AS      
BEGIN      
    SET NOCOUNT ON;      

    -- Duplicate check (parameterized)
    IF EXISTS (
        SELECT 1
        FROM dbo.T_ERP_BankMaster
        WHERE stBankName   = @stBankName
          AND stBranchName = @stBranchName
          AND stBusinessName = @stBusinessName
          AND (@ID IS NULL OR ID <> @ID)
    )
    BEGIN
        SELECT 0 AS StatusFlag,
               'Duplicate bank entry exists for the same name, branch, and business.' AS Message;
        RETURN;
    END

    DECLARE @sql       NVARCHAR(MAX);
    DECLARE @params    NVARCHAR(MAX);
    DECLARE @lastID    INT;  -- will receive new ID for inserts

    IF @ID IS NULL
    BEGIN
        -- Build INSERT dynamic SQL (uses parameterized placeholders)
        SET @sql = N'
        INSERT INTO dbo.T_ERP_BankMaster
        (
            stBusinessName, stBusinessType, stBusinessTypeDesc,
            stBankName, stBranchName, stIFSCCode, stMICRCode, stSWIFTCode,
            inAccountType, stAccountHolderName, stAccountNumber,
            stBankEmail, stBankPhone, stSupportingDocs, stKYCDocs,
            stEmail, stPhone, stType, stReferenceId, stContactName,
            stProfileFields, stLegalInfo, IsDashboardEnabled, stNotes,
            inBankType, inStatus, stRemarks, inBrandID,
            LinkedAccountId, stPAN, stGST, stStreet1, stStreet2,
            stCity, stState, stPostalCode, stCountry,
            stAccountType, stBankType
        )
        VALUES
        (
            @stBusinessName, @stBusinessType, @stBusinessTypeDesc,
            @stBankName, @stBranchName, @stIFSCCode, @stMICRCode, @stSWIFTCode,
            @inAccountType, @stAccountHolderName, @stAccountNumber,
            @stBankEmail, @stBankPhone, @stSupportingDocs, @stKYCDocs,
            @stEmail, @stPhone, @stType, @stReferenceId, @stContactName,
            @stProfileFields, @stLegalInfo, @IsDashboardEnabled, @stNotes,
            @inBankType, @inStatus, @stRemarks, @inBrandID,
            @LinkedAccountId, @stPAN, @stGST, @stStreet1, @stStreet2,
            @stCity, @stState, @stPostalCode, @stCountry,
            @stAccountType, @stBankType
        );

        SET @NewId = SCOPE_IDENTITY();
        ';

        -- Parameter definitions for sp_executesql (include NewId as OUTPUT)
        SET @params = N'
            @stBusinessName NVARCHAR(100),
            @stBusinessType NVARCHAR(100),
            @stBusinessTypeDesc NVARCHAR(MAX),
            @stBankName NVARCHAR(200),
            @stBranchName NVARCHAR(200),
            @stIFSCCode NVARCHAR(20),
            @stMICRCode NVARCHAR(20),
            @stSWIFTCode NVARCHAR(20),
            @inAccountType INT,
            @stAccountHolderName NVARCHAR(150),
            @stAccountNumber NVARCHAR(50),
            @stBankEmail NVARCHAR(100),
            @stBankPhone NVARCHAR(20),
            @stSupportingDocs NVARCHAR(255),
            @stKYCDocs NVARCHAR(255),
            @stEmail NVARCHAR(100),
            @stPhone NVARCHAR(20),
            @stType NVARCHAR(20),
            @stReferenceId NVARCHAR(100),
            @stContactName NVARCHAR(255),
            @stProfileFields NVARCHAR(MAX),
            @stLegalInfo NVARCHAR(MAX),
            @IsDashboardEnabled BIT,
            @stNotes NVARCHAR(MAX),
            @LinkedAccountId NVARCHAR(100),
            @stPAN NVARCHAR(20),
            @stGST NVARCHAR(20),
            @stStreet1 NVARCHAR(255),
            @stStreet2 NVARCHAR(255),
            @stCity NVARCHAR(100),
            @stState NVARCHAR(100),
            @stPostalCode NVARCHAR(20),
            @stCountry NVARCHAR(100),
            @stAccountType NVARCHAR(100),
            @stBankType NVARCHAR(100),
            @inBankType INT,
            @inStatus INT,
            @stRemarks NVARCHAR(MAX),
            @inBrandID INT,
            @NewId INT OUTPUT
        ';

        -- Execute dynamic INSERT
        EXEC sp_executesql
            @sql,
            @params,
            @stBusinessName = @stBusinessName,
            @stBusinessType = @stBusinessType,
            @stBusinessTypeDesc = @stBusinessTypeDesc,
            @stBankName = @stBankName,
            @stBranchName = @stBranchName,
            @stIFSCCode = @stIFSCCode,
            @stMICRCode = @stMICRCode,
            @stSWIFTCode = @stSWIFTCode,
            @inAccountType = @inAccountType,
            @stAccountHolderName = @stAccountHolderName,
            @stAccountNumber = @stAccountNumber,
            @stBankEmail = @stBankEmail,
            @stBankPhone = @stBankPhone,
            @stSupportingDocs = @stSupportingDocs,
            @stKYCDocs = @stKYCDocs,
            @stEmail = @stEmail,
            @stPhone = @stPhone,
            @stType = @stType,
            @stReferenceId = @stReferenceId,
            @stContactName = @stContactName,
            @stProfileFields = @stProfileFields,
            @stLegalInfo = @stLegalInfo,
            @IsDashboardEnabled = @IsDashboardEnabled,
            @stNotes = @stNotes,
            @LinkedAccountId = @LinkedAccountId,
            @stPAN = @stPAN,
            @stGST = @stGST,
            @stStreet1 = @stStreet1,
            @stStreet2 = @stStreet2,
            @stCity = @stCity,
            @stState = @stState,
            @stPostalCode = @stPostalCode,
            @stCountry = @stCountry,
            @stAccountType = @stAccountType,
            @stBankType = @stBankType,
            @inBankType = @inBankType,
            @inStatus = @inStatus,
            @stRemarks = @stRemarks,
            @inBrandID = @inBrandID,
            @NewId = @lastID OUTPUT;

        SELECT 1 AS StatusFlag,
               'Bank details saved successfully!' AS Message,
               @lastID AS Id;
    END
    ELSE
    BEGIN
        -- Build UPDATE dynamic SQL (parameterized)
        SET @sql = N'
        UPDATE dbo.T_ERP_BankMaster
           SET stBusinessName      = @stBusinessName,
               stBusinessType      = @stBusinessType,
               stBusinessTypeDesc  = @stBusinessTypeDesc,
               stBankName          = @stBankName,
               stBranchName        = @stBranchName,
               stIFSCCode          = @stIFSCCode,
               stMICRCode          = @stMICRCode,
               stSWIFTCode         = @stSWIFTCode,
               inAccountType       = @inAccountType,
               stAccountHolderName = @stAccountHolderName,
               stAccountNumber     = @stAccountNumber,
               stBankEmail         = @stBankEmail,
               stBankPhone         = @stBankPhone,
               stSupportingDocs    = @stSupportingDocs,
               stKYCDocs           = @stKYCDocs,
               stEmail             = @stEmail,
               stPhone             = @stPhone,
               stType              = @stType,
               stReferenceId       = @stReferenceId,
               stContactName       = @stContactName,
               stProfileFields     = @stProfileFields,
               stLegalInfo         = @stLegalInfo,
               IsDashboardEnabled  = @IsDashboardEnabled,
               stNotes             = @stNotes,
               inBankType          = @inBankType,
               inStatus            = @inStatus,
               stRemarks           = @stRemarks,
               inBrandID           = @inBrandID,
               LinkedAccountId     = @LinkedAccountId,
               stPAN               = @stPAN,
               stGST               = @stGST,
               stStreet1           = @stStreet1,
               stStreet2           = @stStreet2,
               stCity              = @stCity,
               stState             = @stState,
               stPostalCode        = @stPostalCode,
               stCountry           = @stCountry,
               stAccountType       = @stAccountType,
               stBankType          = @stBankType
         WHERE ID = @ID;
        ';

        SET @params = N'
            @ID INT,
            @stBusinessName NVARCHAR(100),
            @stBusinessType NVARCHAR(100),
            @stBusinessTypeDesc NVARCHAR(MAX),
            @stBankName NVARCHAR(200),
            @stBranchName NVARCHAR(200),
            @stIFSCCode NVARCHAR(20),
            @stMICRCode NVARCHAR(20),
            @stSWIFTCode NVARCHAR(20),
            @inAccountType INT,
            @stAccountHolderName NVARCHAR(150),
            @stAccountNumber NVARCHAR(50),
            @stBankEmail NVARCHAR(100),
            @stBankPhone NVARCHAR(20),
            @stSupportingDocs NVARCHAR(255),
            @stKYCDocs NVARCHAR(255),
            @stEmail NVARCHAR(100),
            @stPhone NVARCHAR(20),
            @stType NVARCHAR(20),
            @stReferenceId NVARCHAR(100),
            @stContactName NVARCHAR(255),
            @stProfileFields NVARCHAR(MAX),
            @stLegalInfo NVARCHAR(MAX),
            @IsDashboardEnabled BIT,
            @stNotes NVARCHAR(MAX),
            @LinkedAccountId NVARCHAR(100),
            @stPAN NVARCHAR(20),
            @stGST NVARCHAR(20),
            @stStreet1 NVARCHAR(255),
            @stStreet2 NVARCHAR(255),
            @stCity NVARCHAR(100),
            @stState NVARCHAR(100),
            @stPostalCode NVARCHAR(20),
            @stCountry NVARCHAR(100),
            @stAccountType NVARCHAR(100),
            @stBankType NVARCHAR(100),
            @inBankType INT,
            @inStatus INT,
            @stRemarks NVARCHAR(MAX),
            @inBrandID INT
        ';

        EXEC sp_executesql
            @sql,
            @params,
            @ID = @ID,
            @stBusinessName = @stBusinessName,
            @stBusinessType = @stBusinessType,
            @stBusinessTypeDesc = @stBusinessTypeDesc,
            @stBankName = @stBankName,
            @stBranchName = @stBranchName,
            @stIFSCCode = @stIFSCCode,
            @stMICRCode = @stMICRCode,
            @stSWIFTCode = @stSWIFTCode,
            @inAccountType = @inAccountType,
            @stAccountHolderName = @stAccountHolderName,
            @stAccountNumber = @stAccountNumber,
            @stBankEmail = @stBankEmail,
            @stBankPhone = @stBankPhone,
            @stSupportingDocs = @stSupportingDocs,
            @stKYCDocs = @stKYCDocs,
            @stEmail = @stEmail,
            @stPhone = @stPhone,
            @stType = @stType,
            @stReferenceId = @stReferenceId,
            @stContactName = @stContactName,
            @stProfileFields = @stProfileFields,
            @stLegalInfo = @stLegalInfo,
            @IsDashboardEnabled = @IsDashboardEnabled,
            @stNotes = @stNotes,
            @LinkedAccountId = @LinkedAccountId,
            @stPAN = @stPAN,
            @stGST = @stGST,
            @stStreet1 = @stStreet1,
            @stStreet2 = @stStreet2,
            @stCity = @stCity,
            @stState = @stState,
            @stPostalCode = @stPostalCode,
            @stCountry = @stCountry,
            @stAccountType = @stAccountType,
            @stBankType = @stBankType,
            @inBankType = @inBankType,
            @inStatus = @inStatus,
            @stRemarks = @stRemarks,
            @inBrandID = @inBrandID;

        SELECT 1 AS StatusFlag,
               'Bank details updated successfully!' AS Message;
    END
END;
CREATE PROCEDURE [dbo].[ERP_Usp_InsertBank]      
    @ID                     INT = NULL,      
    @stBusinessName         NVARCHAR(max),      
    @stBusinessType         NVARCHAR(max),      
    @stBusinessTypeDesc     NVARCHAR(max),      
    @stBankName             NVARCHAR(max),      
    @stBranchName           NVARCHAR(max),      
    @stIFSCCode             NVARCHAR(max),      
    @stMICRCode             NVARCHAR(max),      
    @stSWIFTCode            NVARCHAR(max),      
    @inAccountType          INT,      
    @stAccountHolderName    NVARCHAR(max),      
    @stAccountNumber        NVARCHAR(max),      
    @stBankEmail            NVARCHAR(max),      
    @stBankPhone            NVARCHAR(max),      
    @stSupportingDocs       NVARCHAR(max),      
    @stKYCDocs              NVARCHAR(max),      
    @stEmail                NVARCHAR(max) = NULL,      
    @stPhone                NVARCHAR(max)  = NULL,      
    @stType                 NVARCHAR(max)  = NULL,      
    @stReferenceId          NVARCHAR(max) = NULL,      
    @stContactName          NVARCHAR(max) = NULL,      
    @stProfileFields        NVARCHAR(max) = NULL,      
    @stLegalInfo            NVARCHAR(max) = NULL,      
    @IsDashboardEnabled     BIT           = NULL,      
    @stNotes                NVARCHAR(max) = NULL,      
    @LinkedAccountId        NVARCHAR(max) = NULL,    
    @stPAN                  NVARCHAR(max) = NULL,    
    @stGST                  NVARCHAR(max) = NULL,    
    @stStreet1              NVARCHAR(max) = NULL,    
    @stStreet2              NVARCHAR(max) = NULL,    
    @stCity                 NVARCHAR(max) = NULL,    
    @stState                NVARCHAR(max) = NULL,    
    @stPostalCode           NVARCHAR(max) = NULL,    
    @stCountry              NVARCHAR(max) = NULL,    
    @stAccountType          NVARCHAR(max) = NULL,    
    @stBankType             NVARCHAR(max) = NULL,    
    @inBankType             INT,      
    @inStatus               INT,      
    @stRemarks              NVARCHAR(max),      
    @inBrandID              INT      
AS      
BEGIN      
    SET NOCOUNT ON;      
      
    -- Check for duplicate bank entry      
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
      
    IF @ID IS NULL      
    BEGIN      
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
    DECLARE @lastID int   
 SET @lastID = SCOPE_IDENTITY();  
        SELECT 1 AS StatusFlag,      
               'Bank details saved successfully!' AS Message,@lastID as Id;      
    END      
    ELSE      
    BEGIN      
        UPDATE dbo.T_ERP_BankMaster      
           SET stBusinessName      = N'@stBusinessName',      
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
      
        SELECT 1 AS StatusFlag,      
               'Bank details updated successfully!' AS Message;      
    END      
END; 

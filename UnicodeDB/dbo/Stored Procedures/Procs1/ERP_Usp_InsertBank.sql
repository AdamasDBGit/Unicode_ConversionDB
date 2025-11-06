CREATE PROCEDURE [dbo].[ERP_Usp_InsertBank]      
    @ID                     INT = NULL,      
    @stBusinessName         Nnvarchar(max),      
    @stBusinessType         Nnvarchar(max),      
    @stBusinessTypeDesc     Nnvarchar(max),      
    @stBankName             Nnvarchar(max),      
    @stBranchName           Nnvarchar(max),      
    @stIFSCCode             Nnvarchar(max),      
    @stMICRCode             Nnvarchar(max),      
    @stSWIFTCode            Nnvarchar(max),      
    @inAccountType          INT,      
    @stAccountHolderName    Nnvarchar(max),      
    @stAccountNumber        Nnvarchar(max),      
    @stBankEmail            Nnvarchar(max),      
    @stBankPhone            Nnvarchar(max),      
    @stSupportingDocs       Nnvarchar(max),      
    @stKYCDocs              Nnvarchar(max),      
    @stEmail                Nnvarchar(max) = NULL,      
    @stPhone                Nnvarchar(max)  = NULL,      
    @stType                 Nnvarchar(max)  = NULL,      
    @stReferenceId          Nnvarchar(max) = NULL,      
    @stContactName          Nnvarchar(max) = NULL,      
    @stProfileFields        Nnvarchar(max) = NULL,      
    @stLegalInfo            Nnvarchar(max) = NULL,      
    @IsDashboardEnabled     BIT           = NULL,      
    @stNotes                Nnvarchar(max) = NULL,      
    @LinkedAccountId        Nnvarchar(max) = NULL,    
    @stPAN                  Nnvarchar(max) = NULL,    
    @stGST                  Nnvarchar(max) = NULL,    
    @stStreet1              Nnvarchar(max) = NULL,    
    @stStreet2              Nnvarchar(max) = NULL,    
    @stCity                 Nnvarchar(max) = NULL,    
    @stState                Nnvarchar(max) = NULL,    
    @stPostalCode           Nnvarchar(max) = NULL,    
    @stCountry              Nnvarchar(max) = NULL,    
    @stAccountType          Nnvarchar(max) = NULL,    
    @stBankType             Nnvarchar(max) = NULL,    
    @inBankType             INT,      
    @inStatus               INT,      
    @stRemarks              Nnvarchar(max),      
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
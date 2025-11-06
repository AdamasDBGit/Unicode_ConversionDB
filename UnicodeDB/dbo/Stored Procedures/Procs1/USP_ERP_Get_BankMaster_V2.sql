CREATE PROCEDURE [dbo].[USP_ERP_Get_BankMaster_V2]    
(    
    @ID INT = NULL,    
    @BrandID INT    
)    
AS    
BEGIN    
    SET NOCOUNT ON;    
    
    SELECT    
        BM.ID,    
        BM.stBusinessName,    
        BM.stBusinessType,    
        BM.stBusinessTypeDesc,    
        BM.stBankName,    
        BM.stBranchName,    
        BM.stIFSCCode,    
        BM.stMICRCode,    
        BM.stSWIFTCode,   
        BM.stAccountHolderName,    
        BM.stAccountNumber,    
        BM.LinkedAccountId,    
        BM.stBankEmail,    
        BM.stBankPhone,    
        BM.stSupportingDocs,    
        BM.stKYCDocs,    
        BM.stPAN,    
        BM.stGST,    
        BM.stStreet1,    
        BM.stStreet2,    
        BM.stCity,    
        BM.stState,    
        BM.stPostalCode,    
        BM.stCountry,    
        BM.stEmail,    
        BM.stPhone,    
        BM.stType,    
        BM.stReferenceId,    
        BM.stContactName,    
        BM.stProfileFields,    
        BM.stLegalInfo,    
        BM.IsDashboardEnabled,    
        BM.stNotes,    
        TBT.Type AS stBankType,  
		TBA.Type AS stAccountType, 
		BM.inAccountType,
		BM.inBankType,
        BM.inStatus,    
        BM.stRemarks    
    FROM [dbo].[T_ERP_BankMaster] AS BM
	lEFT JOIN T_Bank_Account_Type TBA ON BM.inAccountType = TBA.ID
	LEFT JOIN T_Bank_Type TBT ON BM.inBankType = TBT.ID
    WHERE inBrandID = @BrandID    
      AND BM.ID = ISNULL(@ID, BM.ID);    
END 
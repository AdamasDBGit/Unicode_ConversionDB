CREATE PROCEDURE [dbo].[USP_GetReceiptDetailsByTransactionNo]
    @TransactionNo Nnvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        RH.[S_Receipt_No], 
        TM.[I_ERP_TransactionNo]
    FROM 
        [dbo].[T_Receipt_Header] RH
    INNER JOIN 
        [dbo].[T_ERP_Transaction_Invoice_Details] TID 
        ON RH.I_Receipt_Header_ID = TID.ReceiptHeaderID
    INNER JOIN 
        [dbo].[T_ERP_Transaction_Master] TM 
        ON TID.I_ERP_Transaction_Master_ID = TM.I_ERP_Transaction_Master_ID
    WHERE 
        TM.[I_ERP_TransactionNo] = @TransactionNo;
END

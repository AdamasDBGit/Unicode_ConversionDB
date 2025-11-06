
CREATE PROCEDURE [dbo].[usp_ERP_GetNextInstalmentDateForReceipt] ( @receiptid INT )
AS
    BEGIN
    
        DECLARE @InvHeaderID INT
        DECLARE @InstalmentDate DATETIME
        
        
		
		
        SELECT  @InvHeaderID = TRH.I_Invoice_Header_ID
        FROM    dbo.T_Receipt_Header AS TRH
        WHERE   TRH.I_Receipt_Header_ID = @receiptid
        
        SELECT TOP 1 @InstalmentDate=T1.Dt_Installment_Date FROM
		(
        SELECT  TIP.I_Invoice_Header_ID ,
                TICD.I_Invoice_Detail_ID ,
                TICD.I_Installment_No ,
                TICD.Dt_Installment_Date ,
                TICD.N_Amount_Due ,
                ISNULL(SUM(ISNULL(TRCD.N_Amount_Paid, 0.00)), 0.00) AS AmountPaid,
                TICD.N_Amount_Due-ISNULL(SUM(ISNULL(TRCD.N_Amount_Paid, 0.00)), 0.00) AS Diff
        FROM    dbo.T_Invoice_Parent AS TIP
                INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
                INNER JOIN dbo.T_Invoice_Child_Detail AS TICD ON TICD.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
                LEFT JOIN dbo.T_Receipt_Component_Detail AS TRCD ON TRCD.I_Invoice_Detail_ID = TICD.I_Invoice_Detail_ID
                                                              AND TRCD.I_Receipt_Detail_ID IN (
                                                              SELECT
                                                              TRH.I_Receipt_Header_ID
                                                              FROM
                                                              dbo.T_Receipt_Header
                                                              AS TRH
                                                              WHERE
                                                              TRH.I_Receipt_Header_ID <= @receiptid
                                                              AND TRH.I_Invoice_Header_ID = @InvHeaderID
                                                              AND TRH.I_Status = 1 )
        WHERE   TIP.I_Invoice_Header_ID = @InvHeaderID
                AND TICD.I_Installment_No<>0
        GROUP BY  TIP.I_Invoice_Header_ID ,
                TICD.I_Invoice_Detail_ID ,
                TICD.I_Installment_No ,
                TICD.Dt_Installment_Date ,
                TICD.N_Amount_Due
         ) T1 WHERE Diff>10       
        ORDER BY T1.Dt_Installment_Date,T1.I_Installment_No
        
        
        IF (@InstalmentDate IS NULL)
        BEGIN
        
        SET @InstalmentDate='1990-01-01'
        
        END
        
        SELECT @InstalmentDate AS NextInstalmentDate
                     


    END

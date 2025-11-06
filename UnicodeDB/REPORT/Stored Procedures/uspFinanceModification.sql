CREATE PROCEDURE [REPORT].[uspFinanceModification]
AS 
    BEGIN
        DECLARE @iStudentDetailID AS INT
        DECLARE @iInvoiceID AS INT
        DECLARE @iInvoiceChildID AS INT
        DECLARE @iInvoiceDetailID AS INT
        DECLARE @iReceiptHeaderID AS INT
        
        
        DECLARE Student CURSOR
        FOR
            SELECT  I_Student_Detail_ID
            FROM    dbo.T_Student_Detail TSD
            WHERE   I_Student_Detail_ID =17858


        OPEN Student
        FETCH NEXT FROM Student INTO @iStudentDetailID
        
        WHILE @@FETCH_STATUS = 0 
            BEGIN


                SET @iInvoiceID = ( SELECT  I_Invoice_Header_ID
                                    FROM    dbo.T_Invoice_Parent TIP
                                    WHERE   I_Student_Detail_ID = @iStudentDetailID
                                  )
                  
                SET @iInvoiceChildID = ( SELECT I_Invoice_Child_Header_ID
                                         FROM   dbo.T_Invoice_Child_Header
                                         WHERE  I_Invoice_Header_ID = @iInvoiceID
                                       )
                               
                DECLARE Inv_Detail CURSOR
                FOR
                    SELECT  I_Invoice_Detail_ID
                    FROM    dbo.T_Invoice_Child_Detail TICD
                    WHERE   I_Invoice_Child_Header_ID = @iInvoiceChildID
 
                OPEN Inv_Detail
                FETCH NEXT FROM Inv_Detail INTO @iInvoiceDetailID
                WHILE @@FETCH_STATUS = 0 
                    BEGIN
		
                        UPDATE  dbo.T_Invoice_Parent
                        SET     N_Invoice_Amount = 0 ,
                                N_Tax_Amount = 0
                        WHERE   I_Invoice_Header_ID = @iInvoiceID
                        UPDATE  dbo.T_Invoice_Child_Detail
                        SET     N_Amount_Due = 0
                        WHERE   I_Invoice_Detail_ID = @iInvoiceDetailID
                        UPDATE  dbo.T_Invoice_Child_Header
                        SET     N_Amount = 0 ,
                                N_Tax_Amount = 0
                        WHERE   I_Invoice_Child_Header_ID = @iInvoiceChildID
                        UPDATE  dbo.T_Invoice_Detail_Tax
                        SET     N_Tax_Value = 0
                        WHERE   I_Invoice_Detail_ID = @iInvoiceDetailID
                
                        SELECT  @iReceiptHeaderID = I_Receipt_Detail_ID
                        FROM    dbo.T_Receipt_Component_Detail TRCD
                        WHERE   I_Invoice_Detail_ID = @iInvoiceDetailID
                        UPDATE  dbo.T_Receipt_Component_Detail
                        SET     N_Amount_Paid = 0
                        WHERE   I_Invoice_Detail_ID = @iInvoiceDetailID
                        UPDATE  dbo.T_Receipt_Tax_Detail
                        SET     N_Tax_Paid = 0
                        WHERE   I_Invoice_Detail_ID = @iInvoiceDetailID
                        UPDATE  dbo.T_Receipt_Header
                        SET     N_Receipt_Amount = 0 ,
                                N_Tax_Amount = 0
                        WHERE   I_Receipt_Header_ID = @iReceiptHeaderID
                
     
                
                 
                        FETCH NEXT FROM Inv_Detail INTO @iInvoiceDetailID
                    END
                CLOSE Inv_Detail
                DEALLOCATE Inv_Detail
        
                IF ( ( SELECT   I_PaymentMode_ID
                       FROM     dbo.T_Receipt_Header
                       WHERE    I_Receipt_Header_ID = @iReceiptHeaderID
                     ) = 2
                     OR ( SELECT    I_PaymentMode_ID
                          FROM      dbo.T_Receipt_Header
                          WHERE     I_Receipt_Header_ID = @iReceiptHeaderID
                        ) = 3
                   ) 
                    BEGIN
                        UPDATE  dbo.T_Receipt_Header
                        SET     Dt_Deposit_Date = NULL ,
                                Bank_Account_Name = NULL
                        WHERE   I_Receipt_Header_ID = @iReceiptHeaderID
                    END

                UPDATE  dbo.T_Receipt_Header
                SET     S_Cancellation_Reason = 'CONCESSION'
                WHERE   I_Receipt_Header_ID = @iReceiptHeaderID

                FETCH NEXT FROM Student INTO @iStudentDetailID
            END
        CLOSE Student
        DEALLOCATE Student
                  
                     
    END

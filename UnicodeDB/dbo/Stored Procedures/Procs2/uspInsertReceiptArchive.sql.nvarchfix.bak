
CREATE PROCEDURE [dbo].[uspInsertReceiptArchive] 
(
	@iInvoiceId INT
)
AS 
    BEGIN TRY           
          
        DECLARE @iReceiptID INT          
        DECLARE @iReceiptComponentID INT          
           
        BEGIN TRANSACTION          

        DECLARE @I_Receipt_Header_ID INT          
        DECLARE @I_Receipt_Component_ID INT   
        DECLARE @iTaxId int  
		DECLARE @nTaxPaid numeric(18,2)            
        DECLARE @iInvoiceDetailId INT
        declare @nTaxRff NUMERIC(18,2)
        
 -- declare cursor for receipt header          
        DECLARE Receipt_Cursor CURSOR FOR           
        SELECT I_Receipt_Header_ID FROM dbo.T_Receipt_Header AS TRH WHERE I_Invoice_Header_ID=@iInvoiceId AND I_Status<>0        
          
        OPEN Receipt_Cursor           
        FETCH NEXT FROM Receipt_Cursor           
 INTO @I_Receipt_Header_ID          

              
        WHILE @@FETCH_STATUS = 0 
            BEGIN           
               
               INSERT  INTO T_Receipt_Header_archive          
                ( S_Receipt_No , 
				I_Invoice_Header_ID ,
				Dt_Receipt_Date,
				I_Student_Detail_ID ,
				I_PaymentMode_ID,
				I_Centre_Id,
				I_Enquiry_Regn_ID,
				N_Receipt_Amount,
				S_Fund_Transfer_Status,
				I_Status,
				Dt_CreditCard_Expiry,
				S_CreditCard_Issuer,
				S_Cancellation_Reason,
				N_CreditCard_No,
				S_ChequeDD_No,
				Dt_ChequeDD_Date,
				S_Bank_Name,
				S_Branch_Name,
				I_Receipt_Type,
				S_Crtd_By,
				S_Upd_By,
				Dt_Crtd_On,
				Dt_Upd_On,
				N_Tax_Amount,
				N_Amount_Rff,
				N_Receipt_Tax_Rff,
				S_AdjustmentRemarks,
				Bank_Account_Name,
				Dt_Deposit_Date,
				S_Narration 
                )          
        SELECT  S_Receipt_No, 
					I_Invoice_Header_ID ,
					Dt_Receipt_Date,
					I_Student_Detail_ID ,
					I_PaymentMode_ID,
					I_Centre_Id,
					I_Enquiry_Regn_ID,
					N_Receipt_Amount,
					S_Fund_Transfer_Status,
					I_Status,
					Dt_CreditCard_Expiry,
					S_CreditCard_Issuer,
					S_Cancellation_Reason,
					N_CreditCard_No,
					S_ChequeDD_No,
					Dt_ChequeDD_Date,
					S_Bank_Name,
					S_Branch_Name,
					I_Receipt_Type,
					S_Crtd_By,
					S_Upd_By,
					Dt_Crtd_On,
					Dt_Upd_On,
					N_Tax_Amount,
					N_Amount_Rff,
					N_Receipt_Tax_Rff,
					S_AdjustmentRemarks,
					Bank_Account_Name,
					Dt_Deposit_Date,
					S_Narration  
                 from dbo.T_Receipt_Header AS TRH WHERE I_Receipt_Header_ID=@I_Receipt_Header_ID
          
                SET @iReceiptID = SCOPE_IDENTITY()          
             
   -- open cursor for receipt component          
                DECLARE Receipt_Component_Cursor CURSOR FOR           
                SELECT I_Receipt_Comp_Detail_ID FROM dbo.T_Receipt_Component_Detail AS TRCD    
                WHERE I_Receipt_Detail_ID = @I_Receipt_Header_ID          
          
                OPEN Receipt_Component_Cursor           
                FETCH NEXT FROM Receipt_Component_Cursor           
				   INTO @I_Receipt_Component_ID          
            
                WHILE @@FETCH_STATUS = 0 
                    BEGIN           
                      
                     INSERT INTO T_Receipt_Component_Detail_Archive  
					 (  
					  I_Invoice_Detail_ID,  
					  I_Receipt_Detail_ID,  
					  N_Amount_Paid,  
					  N_Comp_Amount_Rff  
					 )  
					SELECT I_Invoice_Detail_ID,@iReceiptID,N_Amount_Paid,N_Comp_Amount_Rff
					FROM dbo.T_Receipt_Component_Detail AS TRCD WHERE I_Receipt_Comp_Detail_ID=@I_Receipt_Component_ID
                      
                        SET @iReceiptComponentID = SCOPE_IDENTITY()          
          
            
                        DECLARE Receipt_Tax_Cursor CURSOR FOR           
                        SELECT 	   I_Tax_ID,  
								   I_Invoice_Detail_ID,  
								   N_Tax_Paid,  
								   N_Tax_Rff  
								   FROM dbo.T_Receipt_Tax_Detail AS TRTD          
                        WHERE I_Receipt_Comp_Detail_ID = @I_Receipt_Component_ID          
          
                        OPEN Receipt_Tax_Cursor           
                        FETCH NEXT FROM Receipt_Tax_Cursor           
						INTO @iTaxId,          
						  @iInvoiceDetailId,          
						  @nTaxPaid,         
						  @nTaxRff          
                 
                        WHILE @@FETCH_STATUS = 0 
                            BEGIN           
                                INSERT INTO T_Receipt_Tax_Detail_Archive  
								  (  
								   I_Receipt_Comp_Detail_ID,  
								   I_Tax_ID,  
								   I_Invoice_Detail_ID,  
								   N_Tax_Paid,  
								   N_Tax_Rff  
								  )  
								  Values (@iReceiptComponentID, @iTaxId, @iInvoiceDetailId,@nTaxPaid,@nTaxRff)        
						          
                                FETCH NEXT FROM Receipt_Tax_Cursor           
							    INTO @iTaxId,   
								  @iInvoiceDetailId,          
								  @nTaxPaid,         
								  @nTaxRff           
                            END          
                        CLOSE Receipt_Tax_Cursor           
                        DEALLOCATE Receipt_Tax_Cursor           
          
     
                        FETCH NEXT FROM Receipt_Component_Cursor           
    INTO @I_Receipt_Component_ID      
                    END          
                CLOSE Receipt_Component_Cursor           
                DEALLOCATE Receipt_Component_Cursor           
          
     
                FETCH NEXT FROM Receipt_Cursor           
    INTO @I_Receipt_Header_ID          
           
            END          
          
        CLOSE Receipt_Cursor           
        DEALLOCATE Receipt_Cursor           
 
        COMMIT TRANSACTION          
    END TRY          
    BEGIN CATCH          

        ROLLBACK TRANSACTION          
        DECLARE @ErrMsg Nnvarchar(max) ,
            @ErrSeverity INT          
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()          
          
        RAISERROR(@ErrMsg, @ErrSeverity, 1)          
    END CATCH

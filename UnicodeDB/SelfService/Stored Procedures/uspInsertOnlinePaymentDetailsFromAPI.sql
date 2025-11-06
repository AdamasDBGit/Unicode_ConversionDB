CREATE PROCEDURE [SelfService].[uspInsertOnlinePaymentDetailsFromAPI]
(
@StudentID VARCHAR(MAX),
@BrandID INT,
@CenterID INT,
@TransactionNo VARCHAR(MAX),
@TransactionDate DATETIME,
@TransactionStatus VARCHAR(MAX),
@TransactionSource VARCHAR(MAX),
@TransactionMode VARCHAR(MAX),
@Amount DECIMAL(14,2),
@Tax DECIMAL(14,2),
@InvoiceHeaderID INT,
@sInvoiceNo varchar(MAX)
--@InvoiceChildDetailIDs varchar(MAX)

)
AS
BEGIN TRY
          DECLARE @AdjPosition SMALLINT ,
            @AdjCount SMALLINT 

		BEGIN TRANSACTION

			IF NOT EXISTS(select * from SelfService.T_Online_Payment_Master where TransactionNo=@TransactionNo 
																			and InvoiceHeaderID=@InvoiceHeaderID and StudentID=@StudentID and StatusID=1)
			begin
				insert into SelfService.T_Transaction_RawData
			 (
			 TransactionDate
			 ,TransactionNo
			 ,CreatedOn
			 )
			 VALUES
			 (
			 @TransactionDate
			 ,@TransactionNo
			 ,GETDATE()
			 )
	
				insert into SelfService.T_Online_Payment_Master
				(
					BrandID,
					CenterID,
					TransactionNo,
					TransactionDate,
					TransactionStatus,
					TransactionSource,
					TransactionMode,
					Amount,
					Tax,
					TotalAmount,
					InvoiceHeaderID,
					StatusID,
					StudentID
				)
				values
				(
					@BrandID,
					@CenterID,
					@TransactionNo,
					@TransactionDate,
					@TransactionStatus,
					@TransactionSource,
					@TransactionMode,
					@Amount,
					@Tax,
					@Amount+@Tax,
					@InvoiceHeaderID,
					1,
					@StudentID
				)

				 
							  INSERT  INTO [SelfService].[T_Invoice_Payment_Details]
							( OnlinePaymentID, 
							  InvoiceNo 
							  --InvoiceChildDetailIDs 
							 -- Amount

							)
							VALUES  
							( 
							 SCOPE_IDENTITY()
							 ,@sInvoiceNo
							 --,@InvoiceChildDetailIDs
							 --,@Amount
							)	

			end
			else
			begin

				RAISERROR('Duplicate Transaction ID',11,1) 

			end


			


			COMMIT TRANSACTION


	END TRY

    BEGIN CATCH

 --Error occurred:      
        ROLLBACK TRANSACTION    
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT    
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()    
    
        RAISERROR(@ErrMsg, @ErrSeverity, 1) 

    END CATCH

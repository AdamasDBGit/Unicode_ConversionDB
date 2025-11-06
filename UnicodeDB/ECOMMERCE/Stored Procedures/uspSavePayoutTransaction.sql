CREATE PROCEDURE [ECOMMERCE].[uspSavePayoutTransaction]
(
	@FeeScheduleID INT,
	@TransactionNo VARCHAR(MAX),
	@TransactionDate DATETIME,
	@TransactionSource VARCHAR(MAX),
	@TransactionMode VARCHAR(MAX),
	@TransactionStatus VARCHAR(MAX),
	@TransactionAmount DECIMAL(14,2),
	@TransactionTax DECIMAL(14,2),
	@CustomerID VARCHAR(MAX)=NULL
)
AS
BEGIN

	DECLARE @PayoutTransactionID INT=0

	IF NOT EXISTS(select * from [ECOMMERCE].[T_Payout_Transaction] where TransactionNo=@TransactionNo and FeeScheduleID=@FeeScheduleID)
	BEGIN

		insert into [ECOMMERCE].[T_Payout_Transaction]
		(
			[TransactionNo],
			[TransactionDate],
			[TransactionSource],
			[TransactionMode],
			[TransactionStatus],
			[TransactionAmount],
			[TransactionTax],
			[FeeScheduleID],
			[IsCompleted],
			[CreatedOn],
			[CreatedBy],
			[StatusID],
			[CustomerID]
		)
		select @TransactionNo,@TransactionDate,@TransactionSource,@TransactionMode,@TransactionStatus,@TransactionAmount,@TransactionTax,@FeeScheduleID,
				0,GETDATE(),'rice-group-admin',1,@CustomerID

		set @PayoutTransactionID=SCOPE_IDENTITY()

	END
	ELSE IF((select TransactionStatus from [ECOMMERCE].[T_Payout_Transaction] where TransactionNo=@TransactionNo and StatusID=1)!=@TransactionStatus)
	BEGIN

		Update [ECOMMERCE].[T_Payout_Transaction] set TransactionStatus=@TransactionStatus,UpdatedBy='rice-group-admin',UpdatedOn=GETDATE()
		where TransactionNo=@TransactionNo and [FeeScheduleID]=@FeeScheduleID

		select @PayoutTransactionID= [PayoutTransactionID] from [ECOMMERCE].[T_Payout_Transaction] where TransactionNo=@TransactionNo and StatusID=1 and [FeeScheduleID]=@FeeScheduleID

	END
	ELSE
	BEGIN

		select @PayoutTransactionID= [PayoutTransactionID] from [ECOMMERCE].[T_Payout_Transaction] where TransactionNo=@TransactionNo and StatusID=1 and [FeeScheduleID]=@FeeScheduleID

	END

	select ISNULL(@PayoutTransactionID,0) as PayoutTransactionID

END

CREATE PROCEDURE [ECOMMERCE].[uspSaveSubscriptionTransaction]
(
	@SubscriptionID INT,
	@TransactionNo VARCHAR(MAX),
	@TransactionDate DATETIME,
	@TransactionSource VARCHAR(MAX),
	@TransactionMode VARCHAR(MAX),
	@TransactionStatus VARCHAR(MAX),
	@TransactionAmount DECIMAL(14,2),
	@TransactionTax DECIMAL(14,2),
	@FeeScheduleID INT,
	@CustomerID VARCHAR(MAX)=NULL
)
AS
BEGIN

	DECLARE @SubscriptionTransactionID INT=0

	IF NOT EXISTS(select * from ECOMMERCE.T_Subscription_Transaction where TransactionNo=@TransactionNo and StatusID=1 and FeeScheduleID=@FeeScheduleID)
	BEGIN

		insert into ECOMMERCE.T_Subscription_Transaction
		(
			SubscriptionDetailID,
			TransactionNo,
			TransactionDate,
			TransactionSource,
			TransactionMode,
			TransactionStatus,
			TransactionAmount,
			TransactionTax,
			IsCompleted,
			CreatedOn,
			CreatedBy,
			StatusID,
			FeeScheduleID,
			CustomerID
		)
		select @SubscriptionID,@TransactionNo,@TransactionDate,@TransactionSource,@TransactionMode,@TransactionStatus,@TransactionAmount,@TransactionTax,
				0,GETDATE(),'rice-group-admin',1,@FeeScheduleID,@CustomerID

		set @SubscriptionTransactionID=SCOPE_IDENTITY()

	END
	ELSE IF((select TransactionStatus from ECOMMERCE.T_Subscription_Transaction where TransactionNo=@TransactionNo and StatusID=1 and FeeScheduleID=@FeeScheduleID)!=@TransactionStatus)
	BEGIN

		Update ECOMMERCE.T_Subscription_Transaction set TransactionStatus=@TransactionStatus,UpdatedBy='rice-group-admin',UpdatedOn=GETDATE()
		where TransactionNo=@TransactionNo and SubscriptionDetailID=@SubscriptionID and FeeScheduleID=@FeeScheduleID

		select @SubscriptionTransactionID= SubscriptionTransactionID from ECOMMERCE.T_Subscription_Transaction 
		where TransactionNo=@TransactionNo and StatusID=1 and FeeScheduleID=@FeeScheduleID

	END
	ELSE
	BEGIN

		select @SubscriptionTransactionID= SubscriptionTransactionID 
		from ECOMMERCE.T_Subscription_Transaction where TransactionNo=@TransactionNo and StatusID=1 and FeeScheduleID=@FeeScheduleID

	END

	select ISNULL(@SubscriptionTransactionID,0) as SubscriptionTransactionID

END

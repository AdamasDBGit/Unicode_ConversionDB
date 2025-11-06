CREATE PROCEDURE [ECOMMERCE].[uspSaveNewSubscriptionDetails]
(
@TransactionNo VARCHAR(MAX),
@PlanID INT,
@ProductID INT,
@SubscriptionPlanID VARCHAR(MAX)=NULL,
@AuthKey VARCHAR(MAX)=NULL,
@BillingPeriod INT=NULL,
@BillingStartDate DATETIME=NULL,
@BillingEndDate DATETIME=NULL,
@BillingAmount DECIMAL(14,2)=NULL,
@SubscriptionStatus VARCHAR(MAX),
@SubscriptionLink VARCHAR(MAX)=NULL
)
AS
BEGIN

	DECLARE @SubscriptionID INT=0
	DECLARE @TransactionProductDetailID INT=0
	DECLARE @TransactionStatus VARCHAR(MAX)=''
	DECLARE @CurrSubscriptionStatus VARCHAR(MAX)='NA'


	select @SubscriptionID=ISNULL(A.SubscriptionDetailID,0),@TransactionProductDetailID=B.TransactionProductDetailID,
			@TransactionStatus=D.TransactionStatus,@CurrSubscriptionStatus=ISNULL(A.SubscriptionStatus,'NA')
	from ECOMMERCE.T_Transaction_Product_Details B
	inner join ECOMMERCE.T_Transaction_Plan_Details C on B.TransactionPlanDetailID=C.TransactionPlanDetailID
	inner join ECOMMERCE.T_Transaction_Master D on C.TransactionID=D.TransactionID
	left join ECOMMERCE.T_Transaction_Product_Subscription_Details A on B.TransactionProductDetailID=A.TransactionProductDetailID and ISNULL(A.StatusID,0)=1
	where D.TransactionNo=@TransactionNo and C.PlanID=@PlanID and B.ProductID=@ProductID

	PRINT @SubscriptionID
	PRINT @TransactionProductDetailID
	PRINT @TransactionStatus
	PRINT @CurrSubscriptionStatus




	IF(@TransactionProductDetailID>0 and @TransactionStatus!='Failure')
	BEGIN

		IF(@SubscriptionID<=0 and @CurrSubscriptionStatus='NA')
		BEGIN

			insert into ECOMMERCE.T_Transaction_Product_Subscription_Details
			select @TransactionProductDetailID,@SubscriptionPlanID,@AuthKey,@BillingPeriod,@BillingStartDate,@BillingEndDate,
			@BillingAmount,1,@SubscriptionStatus,@SubscriptionLink

			SET @SubscriptionID=SCOPE_IDENTITY()

		END
		ELSE IF(@SubscriptionID>0 and @CurrSubscriptionStatus='Failure')
		BEGIN

			insert into ECOMMERCE.T_Transaction_Product_Subscription_Details
			select @TransactionProductDetailID,@SubscriptionPlanID,@AuthKey,@BillingPeriod,@BillingStartDate,@BillingEndDate,
			@BillingAmount,1,@SubscriptionStatus,@SubscriptionLink

			SET @SubscriptionID=SCOPE_IDENTITY()

		END
		ELSE IF(@SubscriptionID>0 and @CurrSubscriptionStatus='Skipped')
		BEGIN

			update ECOMMERCE.T_Transaction_Product_Subscription_Details
			set
			TransactionProductDetailID=@TransactionProductDetailID,
			SubscriptionPlanID=@SubscriptionPlanID,
			AuthKey=@AuthKey,
			BillingPeriod=@BillingPeriod,
			BillingStartDate=@BillingStartDate,
			BillingEndDate=@BillingEndDate,
			TotalBillingAmount=@BillingAmount,
			SubscriptionLink=@SubscriptionLink,
			SubscriptionStatus=@SubscriptionStatus
			where
			SubscriptionDetailID=@SubscriptionID

		END
		ELSE IF(@SubscriptionID>0 and @CurrSubscriptionStatus='Pending')
		BEGIN

			update ECOMMERCE.T_Transaction_Product_Subscription_Details
			set
			SubscriptionStatus=@SubscriptionStatus,
			SubscriptionLink=@SubscriptionLink
			where
			SubscriptionDetailID=@SubscriptionID

		END
	END
	ELSE IF(@TransactionProductDetailID>0 and @SubscriptionID>0 and @SubscriptionStatus='Failure')
	BEGIN

		update ECOMMERCE.T_Transaction_Product_Subscription_Details
		set
		SubscriptionStatus=@SubscriptionStatus
		where
		SubscriptionDetailID=@SubscriptionID

	END


	select @SubscriptionID as SubscriptionID


END

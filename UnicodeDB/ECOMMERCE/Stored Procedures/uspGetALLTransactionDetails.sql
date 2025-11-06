CREATE PROCEDURE [ECOMMERCE].[uspGetALLTransactionDetails](@CustomerID VARCHAR(MAX))
AS
BEGIN


	DECLARE @TD TABLE
	(
		ID INT IDENTITY(1,1),
		CustomerID VARCHAR(MAX),
		TransactionNo VARCHAR(MAX),
		PaymentType VARCHAR(MAX),
		PlanID INT,
		PlanName VARCHAR(MAX),
		PlanImage VARCHAR(MAX),
		FeeScheduleIDList VARCHAR(MAX) DEFAULT '',
		ReceiptIDList VARCHAR(MAX) DEFAULT ''
	)

	DECLARE @i INT=1
	DECLARE @c INT=0
	

	select * from
	(
		select CustomerID,TransactionNo,TransactionStatus,TransactionMode,TransactionDate,IsCompleted,'UpFrontPayment' as PaymentType,
		SUM(TransactionAmount+TransactionTax) as TransactionAmount
		from 
		ECOMMERCE.T_Transaction_Master where CustomerID=@CustomerID and StatusID=1
		group by CustomerID,TransactionNo,TransactionStatus,TransactionMode,TransactionDate,IsCompleted
		UNION ALL
		select CustomerID,TransactionNo,TransactionStatus,TransactionMode,TransactionDate,IsCompleted,'SubscriptionPayment' as PaymentType,
		SUM(TransactionAmount+TransactionTax) as TransactionAmount
		from ECOMMERCE.T_Subscription_Transaction where CustomerID=@CustomerID and StatusID=1
		group by CustomerID,TransactionNo,TransactionStatus,TransactionMode,TransactionDate,IsCompleted
		UNION ALL
		select CustomerID,TransactionNo,TransactionStatus,TransactionMode,TransactionDate,IsCompleted,'DuePayment' as PaymentType,
		SUM(TransactionAmount+TransactionTax) as TransactionAmount
		from ECOMMERCE.T_Payout_Transaction where CustomerID=@CustomerID and StatusID=1
		group by CustomerID,TransactionNo,TransactionStatus,TransactionMode,TransactionDate,IsCompleted
	) T1
	order by TransactionDate DESC


	


	insert into @TD
	(
		CustomerID,
		TransactionNo,
		PaymentType,
		PlanID,
		PlanName,
		PlanImage
	)
	select DISTINCT A.CustomerID,A.TransactionNo,'UpFrontPayment',B.PlanID,C.PlanName,D.ConfigValue as PlanImage
	from ECOMMERCE.T_Transaction_Master A
	inner join ECOMMERCE.T_Transaction_Plan_Details B on A.TransactionID=B.TransactionID
	inner join ECOMMERCE.T_Plan_Master C on B.PlanID=C.PlanID
	inner join ECOMMERCE.T_Plan_Config D on D.PlanID=C.PlanID and D.StatusID=1
	inner join ECOMMERCE.T_Cofiguration_Property_Master E on D.ConfigID=E.ConfigID and E.StatusID=1 and E.ConfigCode='LOGO'
	where
	A.CustomerID=@CustomerID and A.StatusID=1
	UNION ALL
	select DISTINCT A.CustomerID,A.TransactionNo,'DuePayment',ISNULL(D.PlanID,0) as PlanID,ISNULL(D.PlanName,'') as PlanName,ISNULL(T1.ConfigValue,'' ) as PlanImage
	from ECOMMERCE.T_Payout_Transaction A
	left join ECOMMERCE.T_Transaction_Product_Details B on A.FeeScheduleID=B.FeeScheduleID and B.IsCompleted=1
	left join ECOMMERCE.T_Transaction_Plan_Details C on B.TransactionPlanDetailID=C.TransactionPlanDetailID and C.IsCompleted=1
	left join ECOMMERCE.T_Plan_Master D on C.PlanID=D.PlanID
	left join 
	(
	select  E.PlanID,E.ConfigValue from ECOMMERCE.T_Plan_Config E 
	inner join ECOMMERCE.T_Cofiguration_Property_Master F on F.ConfigID=E.ConfigID and F.StatusID=1 and F.ConfigCode='LOGO'
	) T1 on T1.PlanID=D.PlanID and T1.PlanID=C.PlanID
	where A.CustomerID=@CustomerID and A.StatusID=1
	UNION ALL
	select DISTINCT A.CustomerID,A.TransactionNo,'SubscriptionPayment',D.PlanID,E.PlanName,ISNULL(F.ConfigValue,G.ConfigDefaultValue) as PlanImage 
	from ECOMMERCE.T_Subscription_Transaction A
	inner join ECOMMERCE.T_Transaction_Product_Subscription_Details B on A.SubscriptionDetailID=B.SubscriptionDetailID
	inner join ECOMMERCE.T_Transaction_Product_Details C on B.TransactionProductDetailID=C.TransactionProductDetailID
	inner join ECOMMERCE.T_Transaction_Plan_Details D on C.TransactionPlanDetailID=D.TransactionPlanDetailID
	inner join ECOMMERCE.T_Plan_Master E on D.PlanID=E.PlanID
	inner join ECOMMERCE.T_Plan_Config F on F.PlanID=E.PlanID and F.StatusID=1
	inner join ECOMMERCE.T_Cofiguration_Property_Master G on F.ConfigID=G.ConfigID and G.StatusID=1 and G.ConfigCode='LOGO'
	where
	A.CustomerID=@CustomerID and A.StatusID=1

	select @c=COUNT(*) from @TD


	WHILE(@i<=@c)
	BEGIN

		DECLARE @ReceiptIDList VARCHAR(MAX)=''
		DECLARE @FeeScheduleIDList VARCHAR(MAX)=''
		DECLARE @PaymentType VARCHAR(MAX)


		select @PaymentType=PaymentType from @TD where ID=@i

		IF(@PaymentType='UpFrontPayment')
		BEGIN

			select 
			@FeeScheduleIDList=COALESCE(@FeeScheduleIDList + ',', '') + CAST(ISNULL(A.FeeScheduleID,0) AS VARCHAR(MAX)),
			@ReceiptIDList=COALESCE(@ReceiptIDList + ',','') + CAST(ISNULL(A.ReceiptHeaderID,0) AS VARCHAR(MAX)) 
			from ECOMMERCE.T_Transaction_Product_Details A
			inner join ECOMMERCE.T_Transaction_Plan_Details B on A.TransactionPlanDetailID=B.TransactionPlanDetailID
			inner join ECOMMERCE.T_Transaction_Master C on B.TransactionID=C.TransactionID
			inner join @TD T on T.TransactionNo=C.TransactionNo and T.PlanID=B.PlanID
			where
			T.ID=@i and C.StatusID=1

			UPDATE @TD 
			SET 
			FeeScheduleIDList=SUBSTRING(LEFT(@FeeScheduleIDList,Len(@FeeScheduleIDList)),2,LEN(LEFT(@FeeScheduleIDList,Len(@FeeScheduleIDList)))),
			ReceiptIDList=SUBSTRING(LEFT(@ReceiptIDList,Len(@ReceiptIDList)),2,LEN(LEFT(@ReceiptIDList,Len(@ReceiptIDList))))
			where
			ID=@i

			

		

		END

		IF(@PaymentType='SubscriptionPayment')
		BEGIN

			select 
			@FeeScheduleIDList=COALESCE(@FeeScheduleIDList + ',', '') + CAST(ISNULL(A.FeeScheduleID,0) AS VARCHAR(MAX)),
			@ReceiptIDList=COALESCE(@ReceiptIDList + ',', '') + CAST(ISNULL(A.ReceiptHeaderID,0) AS VARCHAR(MAX))
			from 
			ECOMMERCE.T_Subscription_Transaction A
			inner join @TD T on T.TransactionNo=A.TransactionNo
			where
			T.ID=@i and A.StatusID=1

			UPDATE @TD 
			SET 
			FeeScheduleIDList=SUBSTRING(LEFT(@FeeScheduleIDList,Len(@FeeScheduleIDList)),2,LEN(LEFT(@FeeScheduleIDList,Len(@FeeScheduleIDList)))),
			ReceiptIDList=SUBSTRING(LEFT(@ReceiptIDList,Len(@ReceiptIDList)),2,LEN(LEFT(@ReceiptIDList,Len(@ReceiptIDList))))
			where
			ID=@i

		END

		IF(@PaymentType='DuePayment')
		BEGIN

			select 
			@FeeScheduleIDList=COALESCE(@FeeScheduleIDList + ',', '') + CAST(ISNULL(A.FeeScheduleID,0) AS VARCHAR(MAX)),
			@ReceiptIDList=COALESCE(@ReceiptIDList + ',', '') + CAST(ISNULL(A.ReceiptHeaderID,0) AS VARCHAR(MAX))
			from 
			ECOMMERCE.T_Payout_Transaction A
			inner join @TD T on T.TransactionNo=A.TransactionNo
			where
			T.ID=@i and A.StatusID=1

			UPDATE @TD 
			SET 
			FeeScheduleIDList=SUBSTRING(LEFT(@FeeScheduleIDList,Len(@FeeScheduleIDList)),2,LEN(LEFT(@FeeScheduleIDList,Len(@FeeScheduleIDList)))),
			ReceiptIDList=SUBSTRING(LEFT(@ReceiptIDList,Len(@ReceiptIDList)),2,LEN(LEFT(@ReceiptIDList,Len(@ReceiptIDList))))
			where
			ID=@i

		END

		SET @i=@i+1

	END

	




	select * from @TD


END

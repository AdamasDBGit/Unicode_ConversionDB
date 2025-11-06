CREATE PROCEDURE [ECOMMERCE].[uspValidateSubscriptionPayment](@SubscriptionID INT, @TransactionNo VARCHAR(MAX)=NULL,@DueDate DATETIME=NULL,@FeeSchID INT=0, 
																	@PaidAmount DECIMAL(14,2), @PaidTax DECIMAL(14,2))
AS
BEGIN
	
	DECLARE @ErrMessage NVARCHAR(MAX)

	DECLARE @BrandID INT=NULL
	DECLARE @BrandName VARCHAR(MAX)=''
	DECLARE @StudentID VARCHAR(MAX)=NULL
	DECLARE @CourseID INT
	DECLARE @FeeScheduleID INT=NULL

		CREATE TABLE #Due
		(
			S_Brand_Name VARCHAR(MAX) COLLATE DATABASE_DEFAULT,
			I_Center_ID INT,
			S_Center_Name VARCHAR(MAX) COLLATE DATABASE_DEFAULT,
			S_Course_Name VARCHAR(MAX) COLLATE DATABASE_DEFAULT,
			S_Batch_Name VARCHAR(MAX) COLLATE DATABASE_DEFAULT,
			S_Student_ID VARCHAR(MAX) COLLATE DATABASE_DEFAULT,
			S_Student_Name VARCHAR(MAX) COLLATE DATABASE_DEFAULT,
			I_Invoice_Header_ID INT,
			S_Invoice_No VARCHAR(MAX) COLLATE DATABASE_DEFAULT,
			I_Invoice_Child_Header_ID INT,
			I_Invoice_Detail_ID INT,
			Dt_Installment_Date DATETIME,
			I_Installment_No INT,
			I_Fee_Component_ID INT,
			S_Component_Name VARCHAR(MAX) COLLATE DATABASE_DEFAULT,
			BaseAmountDue DECIMAL(14,2),
			TaxDue DECIMAL(14,2),
			TotalAmtPayable DECIMAL(14,2),
			Amount_Paid DECIMAL(14,2),
			Tax_Paid DECIMAL(14,2),
			Total_Paid DECIMAL(14,2),
			CurrentDue DECIMAL(14,2)
		)

BEGIN TRY

	BEGIN TRANSACTION

		IF(@TransactionNo IS NULL)
		BEGIN

			select @BrandID=T1.I_Brand_ID,@StudentID=T1.StudentID,@CourseID=T1.I_Course_ID 
			from
			(
				select A.CustomerID,C.StudentID,F.I_Brand_ID,E.I_Course_ID,D.AuthKey,D.SubscriptionDetailID,D.TotalBillingAmount,
				ISNULL(ST.PrevPaidAmount,0) as PrevPaidAmount
				from ECOMMERCE.T_Transaction_Master A
				inner join ECOMMERCE.T_Transaction_Plan_Details B on A.TransactionID=B.TransactionID
				inner join ECOMMERCE.T_Transaction_Product_Details C on B.TransactionPlanDetailID=C.TransactionPlanDetailID
				inner join ECOMMERCE.T_Transaction_Product_Subscription_Details D on C.TransactionProductDetailID=D.TransactionProductDetailID
				inner join T_Student_Batch_Master E on C.BatchID=E.I_Batch_ID
				inner join T_Course_Master F on F.I_Course_ID=E.I_Course_ID
				left join
				(
					select SubscriptionDetailID,SUM(ISNULL(TransactionAmount,0)+ISNULL(TransactionTax,0)) as PrevPaidAmount 
					from ECOMMERCE.T_Subscription_Transaction TST
					where SubscriptionDetailID=@SubscriptionID and StatusID=1
					group by SubscriptionDetailID
				) ST on D.SubscriptionDetailID=ST.SubscriptionDetailID
				where
				A.StatusID=1 and (C.StudentID IS NOT NULL and C.StudentID!='') and ISNULL(D.AuthKey,'')!='' and D.StatusID=1 
				and D.SubscriptionDetailID=@SubscriptionID
			) T1
			where
			(T1.TotalBillingAmount-T1.PrevPaidAmount)>=(@PaidAmount+@PaidTax)

			--PRINT @BrandID
			--Print @StudentID
			--Print @CourseID
			--Print @DueDate

			IF(@BrandID IS NULL OR @StudentID IS NULL)
			BEGIN

				SELECT @ErrMessage='Invalid Subscription: '+CAST(@SubscriptionID AS VARCHAR(MAX))

				RAISERROR(@ErrMessage,11,1)

			END

			IF(@BrandID=109)
				set @BrandName='RICE'

			insert into #Due
			EXEC [ECOMMERCE].[uspGetIndividualStudentDueForSubscription] @BrandName,@StudentID,@DueDate,@FeeSchID

			--select * from #Due

			select TOP 1 @FeeScheduleID= INV.I_Invoice_Header_ID 
			from
			(
				select T1.I_Invoice_Header_ID,SUM(ISNULL(T1.CurrentDue,0)) as TotalDue 
				from #Due T1
				inner join T_Invoice_Batch_Map T2 on T1.I_Invoice_Child_Header_ID=T2.I_Invoice_Child_Header_ID
				inner join T_Student_Batch_Master T3 on T2.I_Batch_ID=T3.I_Batch_ID
				where
				T3.I_Course_ID=@CourseID
				and T1.I_Invoice_Header_ID=@FeeSchID
				group by T1.I_Invoice_Header_ID
				having SUM(T1.CurrentDue)>=(@PaidAmount+@PaidTax)
			) INV


			IF(@FeeScheduleID IS NULL)
			BEGIN

				SELECT @ErrMessage='Due Amount is less than Paid Amount. SubscriptionID: '+CAST(@SubscriptionID AS VARCHAR(MAX))

				RAISERROR(@ErrMessage,11,1)

			END

		

		END
		ELSE IF(ISNULL(@TransactionNo,'')!='')
		BEGIN

			select @BrandID=T1.I_Brand_ID,@StudentID=T1.StudentID,@CourseID=T1.I_Course_ID 
			from
			(
				select A.CustomerID,C.StudentID,F.I_Brand_ID,E.I_Course_ID,D.AuthKey,D.SubscriptionDetailID,D.TotalBillingAmount,
				ISNULL(ST.PrevPaidAmount,0) as PrevPaidAmount
				from ECOMMERCE.T_Transaction_Master A
				inner join ECOMMERCE.T_Transaction_Plan_Details B on A.TransactionID=B.TransactionID
				inner join ECOMMERCE.T_Transaction_Product_Details C on B.TransactionPlanDetailID=C.TransactionPlanDetailID
				inner join ECOMMERCE.T_Transaction_Product_Subscription_Details D on C.TransactionProductDetailID=D.TransactionProductDetailID
				inner join T_Student_Batch_Master E on C.BatchID=E.I_Batch_ID
				inner join T_Course_Master F on F.I_Course_ID=E.I_Course_ID
				left join
				(
					select SubscriptionDetailID,SUM(ISNULL(TransactionAmount,0)+ISNULL(TransactionTax,0)) as PrevPaidAmount 
					from ECOMMERCE.T_Subscription_Transaction TST
					where SubscriptionDetailID=@SubscriptionID and StatusID=1 and TST.TransactionNo NOT IN (@TransactionNo)
					group by SubscriptionDetailID
				) ST on D.SubscriptionDetailID=ST.SubscriptionDetailID
				where
				A.StatusID=1 and (C.StudentID IS NOT NULL and C.StudentID!='') and ISNULL(D.AuthKey,'')!='' and D.StatusID=1 
				and D.SubscriptionDetailID=@SubscriptionID
			) T1
			where
			(T1.TotalBillingAmount-T1.PrevPaidAmount)>=(@PaidAmount+@PaidTax)

			IF(@BrandID IS NULL OR @StudentID IS NULL)
			BEGIN

				SELECT @ErrMessage='Invalid Subscription'

				RAISERROR(@ErrMessage,11,1)

			END

			IF(@BrandID=109)
				set @BrandName='RICE'

			insert into #Due
			EXEC [ECOMMERCE].[uspGetIndividualStudentDueForSubscription] @BrandName,@StudentID,NULL,@FeeSchID

			select TOP 1 @FeeScheduleID=INV.I_Invoice_Header_ID 
			from
			(
				select T1.I_Invoice_Header_ID,SUM(ISNULL(T1.CurrentDue,0)) as TotalDue 
				from #Due T1
				inner join T_Invoice_Batch_Map T2 on T1.I_Invoice_Child_Header_ID=T2.I_Invoice_Child_Header_ID
				inner join T_Student_Batch_Master T3 on T2.I_Batch_ID=T3.I_Batch_ID
				where
				T3.I_Course_ID=@CourseID
				and T1.I_Invoice_Header_ID=@FeeSchID
				group by T1.I_Invoice_Header_ID
				having SUM(T1.CurrentDue)>=(@PaidAmount+@PaidTax)
			) INV


			IF(@FeeScheduleID IS NULL)
			BEGIN

				SELECT @ErrMessage='Due Amount is less than Paid Amount'

				RAISERROR(@ErrMessage,11,1)

			END

		

		END

		select ISNULL(@FeeScheduleID,0) as FeeScheduleID

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

END

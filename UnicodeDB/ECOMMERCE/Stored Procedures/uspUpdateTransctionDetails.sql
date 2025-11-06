CREATE PROCEDURE [ECOMMERCE].[uspUpdateTransctionDetails](@TransactionProductDetailID INT, @FeeScheduleID INT=NULL, @StudentDetailID INT=NULL, @ReceiptHeaderID INT=NULL)
AS
BEGIN

	DECLARE @TransactionPlanDetailID INT=0
	DECLARE @TransactionID INT=0
	DECLARE @StudentID VARCHAR(MAX)=NULL

	select @StudentID=ISNULL(S_Student_ID,NULL) from T_Student_Detail where I_Student_Detail_ID=ISNULL(@StudentDetailID,0)

	select @TransactionPlanDetailID=TransactionPlanDetailID 
	from ECOMMERCE.T_Transaction_Product_Details 
	where TransactionProductDetailID=@TransactionProductDetailID

	select @TransactionID=TransactionID 
	from ECOMMERCE.T_Transaction_Plan_Details 
	where TransactionPlanDetailID=@TransactionPlanDetailID


	IF(@ReceiptHeaderID IS NULL OR @ReceiptHeaderID=0)
	BEGIN
		
		select TOP 1 @ReceiptHeaderID=ISNULL(I_Receipt_Header_ID,0)
		from T_Receipt_Header 
		where I_Invoice_Header_ID=@FeeScheduleID and I_Status=1
		order by Dt_Crtd_On ASC

	END

	IF(@FeeScheduleID IS NOT NULL and @FeeScheduleID>0 and @StudentID IS NOT NULL and @StudentID!='' and @ReceiptHeaderID IS NOT NULL and @ReceiptHeaderID>0)
	BEGIN

		Update ECOMMERCE.T_Transaction_Product_Details 
		set 
		FeeScheduleID=@FeeScheduleID,StudentID=@StudentID,ReceiptHeaderID=@ReceiptHeaderID,IsCompleted=1,CompletedOn=GETDATE()
		where
		TransactionProductDetailID=@TransactionProductDetailID and ISNULL(IsCompleted,0)=0 and CanBeProcessed=1


		IF NOT EXISTS(select * from ECOMMERCE.T_Transaction_Product_Details where ISNULL(IsCompleted,0)=0 and TransactionPlanDetailID=@TransactionPlanDetailID)
		BEGIN

			Update ECOMMERCE.T_Transaction_Plan_Details
			set
			IsCompleted=1,CompletedOn=GETDATE()
			where
			TransactionPlanDetailID=@TransactionPlanDetailID and ISNULL(IsCompleted,0)=0 and CanBeProcessed=1

		END

		IF NOT EXISTS(select * from ECOMMERCE.T_Transaction_Plan_Details where ISNULL(IsCompleted,0)=0 and TransactionID=@TransactionID)
		BEGIN

			Update ECOMMERCE.T_Transaction_Master
			set
			IsCompleted=1,CompletedOn=GETDATE()
			where
			TransactionID=@TransactionID and ISNULL(IsCompleted,0)=0 and CanBeProcessed=1 and StatusID=1

		END

	END

END


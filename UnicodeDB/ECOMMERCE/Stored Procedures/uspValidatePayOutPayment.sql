CREATE PROCEDURE [ECOMMERCE].[uspValidatePayOutPayment](@FeeScheduleID INT,@PaidAmount DECIMAL(14,2), @PaidTax DECIMAL(14,2))
AS
BEGIN
	
	DECLARE @ErrMessage NVARCHAR(MAX)

	DECLARE @BrandID INT=NULL
	DECLARE @BrandName VARCHAR(MAX)=''
	DECLARE @StudentID VARCHAR(MAX)=NULL
	DECLARE @CourseID INT

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

		select @BrandID=C.I_Brand_ID,@StudentID=D.S_Student_ID,@CourseID=B.I_Course_ID 
		from
		T_Invoice_Parent A
		inner join T_Invoice_Child_Header B on A.I_Invoice_Header_ID=B.I_Invoice_Header_ID and B.I_Course_ID IS NOT NULL
		inner join T_Center_Hierarchy_Name_Details C on A.I_Centre_Id=C.I_Center_ID
		inner join T_Student_Detail D on A.I_Student_Detail_ID=D.I_Student_Detail_ID
		where
		A.I_Invoice_Header_ID=@FeeScheduleID and A.I_Status in (1,3)

		PRINT @BrandID
		PRINT @StudentID
		PRINT @CourseID

		IF(@BrandID IS NULL OR @StudentID IS NULL)
		BEGIN

			SELECT @ErrMessage='Invalid FeeScheduleID: '+CAST(@FeeScheduleID AS VARCHAR(MAX))

			RAISERROR(@ErrMessage,11,1)

		END

		IF(@BrandID=109)
			set @BrandName='RICE'

		insert into #Due
		EXEC [ECOMMERCE].[uspGetIndividualStudentDueForPayOut] @BrandName,@StudentID,@FeeScheduleID

		--select * from #Due

		IF NOT EXISTS
		(
			select TOP 1 INV.I_Invoice_Header_ID 
			from
			(
				select T1.I_Invoice_Header_ID,SUM(ISNULL(T1.CurrentDue,0)) as TotalDue 
				from #Due T1
				inner join T_Invoice_Batch_Map T2 on T1.I_Invoice_Child_Header_ID=T2.I_Invoice_Child_Header_ID
				inner join T_Student_Batch_Master T3 on T2.I_Batch_ID=T3.I_Batch_ID
				group by T1.I_Invoice_Header_ID
				having SUM(T1.CurrentDue)=(@PaidAmount+@PaidTax)
			) INV
		)
		BEGIN

			SELECT @ErrMessage='Due Amount does not match Paid Amount. FeeScheduleID: '+CAST(@FeeScheduleID AS VARCHAR(MAX))

			RAISERROR(@ErrMessage,11,1)

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

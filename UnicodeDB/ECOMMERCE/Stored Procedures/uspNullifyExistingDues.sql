CREATE PROCEDURE [ECOMMERCE].[uspNullifyExistingDues](@InvoiceHeaderID INT)
AS
BEGIN


	DECLARE @BatchID INT
	DECLARE @CourseID INT
	DECLARE @FeePlanID INT
	DECLARE @CentreID INT
	DECLARE @StudentDetID INT

	DECLARE @newInvoiceHeaderID INT
	DECLARE @iBrandID INT
	DECLARE @newInvoiceChildHeaderID INT

	SELECT  @CentreID = TIP.I_Centre_Id ,
			@BatchID = TIBM.I_Batch_ID ,
			@CourseID = TICH.I_Course_ID ,
			@FeePlanID = TICH.I_Course_FeePlan_ID ,
			@StudentDetID = TIP.I_Student_Detail_ID
	FROM    dbo.T_Invoice_Parent AS TIP
			INNER JOIN dbo.T_Invoice_Child_Header AS TICH ON TICH.I_Invoice_Header_ID = TIP.I_Invoice_Header_ID
			INNER JOIN dbo.T_Invoice_Batch_Map AS TIBM ON TIBM.I_Invoice_Child_Header_ID = TICH.I_Invoice_Child_Header_ID
	WHERE   TIP.I_Invoice_Header_ID = @InvoiceHeaderID --AND TIBM.I_Status=1

	SET @iBrandID = ( SELECT    I_Brand_ID
						FROM      dbo.T_Center_Hierarchy_Name_Details
						WHERE     I_Center_ID = @CentreID
					)




	INSERT  INTO dbo.T_Invoice_Parent
			( S_Invoice_No ,
				I_Student_Detail_ID ,
				I_Centre_Id ,
				N_Invoice_Amount ,
				N_Discount_Amount ,
				N_Tax_Amount ,
				Dt_Invoice_Date ,
				I_Status ,
				I_Discount_Scheme_ID ,
				I_Discount_Applied_At ,
				S_Crtd_By ,
				S_Upd_By ,
				Dt_Crtd_On ,
				Dt_Upd_On ,
				I_Coupon_Discount ,
				I_Parent_Invoice_ID ,
				S_Cancel_Type
			)
	VALUES  ( NULL , -- S_Invoice_No - varchar(50)
				@StudentDetID , -- I_Student_Detail_ID - int
				@CentreID , -- I_Centre_Id - int
				0.00 , -- N_Invoice_Amount - numeric
				0.00 , -- N_Discount_Amount - numeric
				0.00 , -- N_Tax_Amount - numeric
				GETDATE() , -- Dt_Invoice_Date - datetime
				1 , -- I_Status - int
				NULL , -- I_Discount_Scheme_ID - int
				NULL , -- I_Discount_Applied_At - int
				'rice-group-admin' , -- S_Crtd_By - varchar(20)
				NULL , -- S_Upd_By - varchar(20)
				GETDATE() , -- Dt_Crtd_On - datetime
				NULL , -- Dt_Upd_On - datetime
				NULL , -- I_Coupon_Discount - int
				@InvoiceHeaderID , -- I_Parent_Invoice_ID - int
				NULL  -- S_Cancel_Type - varchar(10)
			)
        
	SET @newInvoiceHeaderID = SCOPE_IDENTITY()        
        
	DECLARE @iInvoiceNo BIGINT          
            
	SELECT  @iInvoiceNo = MAX(CAST(S_Invoice_No AS BIGINT))
	FROM    T_Invoice_Parent TIP
	WHERE   I_Invoice_Header_ID NOT IN (
			SELECT  I_Invoice_Header_ID
			FROM    T_Invoice_Parent
			WHERE   @iInvoiceNo LIKE '%[A-Z]' )
			AND TIP.I_Centre_Id IN (
			SELECT  I_Centre_Id
			FROM    dbo.T_Brand_Center_Details AS TBCD
			WHERE   I_Brand_ID = @iBrandID
					AND I_Status = 1 )        
          
	SET @iInvoiceNo = ISNULL(@iInvoiceNo, 0) + 1          
          
	UPDATE  dbo.T_Invoice_Parent
	SET     S_Invoice_No = CAST(@iInvoiceNo AS VARCHAR(20))
	WHERE   I_Invoice_Header_ID = @newInvoiceHeaderID 
                
                
	INSERT  INTO dbo.T_Invoice_Child_Header
			( I_Invoice_Header_ID ,
				I_Course_ID ,
				I_Course_FeePlan_ID ,
				C_Is_LumpSum ,
				N_Amount ,
				N_Tax_Amount ,
				N_Discount_Amount ,
				I_Discount_Scheme_ID ,
				I_Discount_Applied_At
			)
	VALUES  ( @newInvoiceHeaderID , -- I_Invoice_Header_ID - int
				@CourseID , -- I_Course_ID - int
				@FeePlanID , -- I_Course_FeePlan_ID - int
				'N' , -- C_Is_LumpSum - char(1)
				0.00 , -- N_Amount - numeric
				0.00 , -- N_Tax_Amount - numeric
				NULL , -- N_Discount_Amount - numeric
				NULL , -- I_Discount_Scheme_ID - int
				NULL  -- I_Discount_Applied_At - int
			)
         
	SET @newInvoiceChildHeaderID = SCOPE_IDENTITY()
 
	INSERT  INTO dbo.T_Invoice_Batch_Map
			( I_Invoice_Child_Header_ID ,
				I_Batch_ID ,
				I_Status ,
				S_Crtd_By ,
				S_Updt_By ,
				Dt_Crtd_On ,
				Dt_Updt_On
			)
	VALUES  ( @newInvoiceChildHeaderID , -- I_Invoice_Child_Header_ID - int
				@BatchID , -- I_Batch_ID - int
				1 , -- I_Status - int
				'rice-group-admin' , -- S_Crtd_By - varchar(20)
				NULL , -- S_Updt_By - varchar(20)
				GETDATE() , -- Dt_Crtd_On - datetime
				NULL  -- Dt_Updt_On - datetime
			)
                
	UPDATE  dbo.T_Student_Course_Detail
	SET     I_Status = 0
	WHERE   I_Student_Detail_ID = @StudentDetID
			AND I_Course_ID = @CourseID        
         
	EXEC dbo.uspCancelInvoice @iInvoiceId = @InvoiceHeaderID, -- int
		@sUpdatedBy = 'rice-group-admin', -- varchar(20)
		@iCancellationReasonId = 2 -- int
               
	Update T_Student_Batch_Details set I_Status=0, Dt_Valid_To=GETDATE() where I_Batch_ID=@BatchID and I_Status=1

END

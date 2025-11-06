-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2024-July-17>
-- Description:	<SaveDiscountinInvoice>
-- =============================================
CREATE PROCEDURE  [dbo].[usp_ERP_Claim_Approve_Discount]
	-- Add the parameters for the stored procedure here
	@UserID INT,
	@iBrandID INT,
	@is_Claim bit=NULL,
	@is_reject bit=NULL,
	@is_Approved bit=NULL,
	@InvoiceHeaderID INT,
	@iDiscount_Claim_Request_ID int=NULL,
	@iCurrentDiscountApproverDetailID int=NULL,
	@Remarks NVARCHAR(MAX),
	@InvoiceDiscountDetails ERPInvoiceDiscountDetails READONLY
	

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		BEGIN TRANSACTION

	IF exists (
	select * from T_ERP_User as EU 
	inner join
	T_ERP_User_Brand as UB on EU.I_User_ID=UB.I_User_ID
	where EU.I_User_ID=@UserID and UB.I_Brand_ID=@iBrandID and EU.I_Status=1 and UB.Is_Active=1
	)
	BEGIN

		IF @iDiscount_Claim_Request_ID IS NULL AND @iCurrentDiscountApproverDetailID IS NULL  AND @is_Claim ='true'
		BEGIN --- BEGIN for New Request Claim


			IF exists(
			SELECT *
			FROM T_ERP_Discount_Claim_Request
			WHERE I_Invoice_Header_ID = @InvoiceHeaderID
			  AND I_Status = 1
			  AND (Is_Fully_Approved = 'false' OR Is_Fully_Approved IS NULL 
				   OR Is_Rejected = 'false' OR Is_Rejected IS NULL)
			)

			BEGIN
				RAISERROR('Request Rejected! There are previous claims still pending for Approval for this invoice',11,1)	
			END
			ELSE
			BEGIN

				DECLARE @NewClaimID INT=0;
				DECLARE @NewDiscountClaimRequestID INT=0;
				DECLARE @NoOfRows INT=0;
				
				insert into T_ERP_Discount_Claim_Request
					(
					I_Brand_ID,
					I_Invoice_Header_ID,
					I_User_Claim_By,
					S_Claim_Status,
					Dt_Claim_Date,
					S_Discount_Remarks
					)
					values
					(
					@iBrandID,
					@InvoiceHeaderID,
					@UserID,
					'Claimed',
					GETDATE(),
					@Remarks
					)

					set @NewClaimID=SCOPE_IDENTITY();

				insert into T_ERP_Discount_Claim_Approver_Details
				(
				I_ERP_Discount_Claim_Request_ID,
				I_Approver_Seq,
				S_Status,
				Dt_Created_At,
				I_Saas_Header_ID
				)
				SELECT
				@NewClaimID,
				CAST(SUBSTRING(PH.N_help, CHARINDEX('_', PH.N_help) + 1, LEN(PH.N_help)) AS INT) AS Sequence,
				'Claim',
				GETDATE(),
				PH.I_Pattern_HeaderID
				FROM 
					T_ERP_Saas_Pattern_Header AS PH
				INNER JOIN 
					T_ERP_Saas_Pattern_Child_Header AS PCH 
					ON PH.I_Pattern_HeaderID = PCH.I_Pattern_HeaderID
				WHERE 
					PH.I_Brand_ID = @iBrandID 
					AND PH.S_Property_Name = 'Discount Approver'
					AND PCH.Is_Active=1 and PH.Is_Active=1
					order by Sequence


				set @NewDiscountClaimRequestID=SCOPE_IDENTITY();


				insert into T_ERP_Discount_Claim_Breakup_Details
				(
				I_ERP_Discount_Claim_Request_ID,
				I_Invoice_Header_ID,
				I_Invoice_Detail_ID,
				S_Invoice_Number,
				S_Discount_Amount,
				S_Discount_Rate,
				S_Status,
				Dt_Created_At
				)
				select
				@NewClaimID,
				InvoiceHeaderID,
				InvoiceDetailID,
				S_invoice_No,
				Discount_Amount,
				Discount_Rate,
					'Claim',
					GETDATE()
				from 
				@InvoiceDiscountDetails

				SET @NoOfRows=@@ROWCOUNT;


				IF @NoOfRows > 0 AND @NewDiscountClaimRequestID > 0 AND @NewClaimID > 0
				BEGIN

					select 1 StatusFlag
					,'Discount Claim request has been registered. Please wait for approval.' Message

				END
				ELSE
				BEGIN

				RAISERROR('Something is Wrong!Please Try again Later',11,1)


				END

			

			END

		END -- END for New Request Claim


	END
	ELSE
	BEGIN

		RAISERROR('Invalid User!',11,1)

	END

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


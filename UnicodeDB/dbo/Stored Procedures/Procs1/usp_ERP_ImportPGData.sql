CREATE PROCEDURE [dbo].[usp_ERP_ImportPGData]
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@userID INT,
	@PGData UT_PG_Data readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   
   insert into PGPaymentdetails
   (
    Payid,
	amount,
	status,
	order_id,
	invoice_id,
	amount_refunded,
	amount_transferred,
	refund_status,
	captured,
	createdAt,
	BrandID,
	ExportAt,
	ExportBy,
	PGDataSourceType
   )
   select 
   PayID,
   amount,
   status,
   order_id,
   invoice_id,
   amount_refunded,
   amount_transferred,
   refund_status,
		captured,
		CreatedAt,
		@iBrandID,
		GETDATE(),
		@userID,
		
		PGDataSourceType
		
		from @PGData



		select 1 StatusFlag,'Success' Message



END

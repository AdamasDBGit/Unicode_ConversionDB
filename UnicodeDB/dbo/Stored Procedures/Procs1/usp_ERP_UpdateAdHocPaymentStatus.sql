CREATE PROCEDURE [dbo].[usp_ERP_UpdateAdHocPaymentStatus]
(
    @Id INT
	,@paymentStatus int=null,
	@InvoiceID int = null
    
)
AS
BEGIN
    SET NOCOUNT ON;
	
  update T_ERP_AdhocPaymentScheduleStudentDetail set inPaymentStatus=1 where inAdhocPaymentScheduleStudentDetailID=@Id
  if(@paymentStatus=1)

  UPDATE T_ERP_AdhocPaymentScheduleStudentDetail
SET sInvoiceNo = 'AIS' + RIGHT(sInvoiceNo, LEN(sInvoiceNo) - CHARINDEX('/', sInvoiceNo))
,I_Receipt_Header_ID=@InvoiceID
WHERE sInvoiceNo LIKE 'TEMP/%'
AND inAdhocPaymentScheduleStudentDetailID = @Id;

END;



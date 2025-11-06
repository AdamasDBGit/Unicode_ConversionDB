CREATE PROCEDURE [dbo].[uspGetReceiptList] 
(
	-- Add the parameters for the stored procedure here
	@iInvoiceID int = NULL,
	@iEnquiryID int = NULL,
	@iReceiptType SmallInt = NULL,
	@iStudentDetailID int = NULL
)

AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

   -- Table[0] Enquiry Course Details		
	SELECT *
	FROM 
		dbo.T_Receipt_Header A WITH (NOLOCK)
	WHERE
		ISNULL(A.I_Invoice_Header_ID,'') = ISNULL(ISNULL(@iInvoiceID, A.I_Invoice_Header_ID),'')
		AND ISNULL(A.I_Enquiry_Regn_ID,'') = ISNULL(ISNULL(@iEnquiryID, A.I_Enquiry_Regn_ID),'')
		AND ISNULL(A.I_Receipt_Type,'') = ISNULL(ISNULL(@iReceiptType, A.I_Receipt_Type),'')
		AND ISNULL(A.I_Student_Detail_ID,'') = ISNULL(ISNULL(@iStudentDetailID, A.I_Student_Detail_ID),'')
		AND A.I_Status = 1
		ORDER BY A.Dt_Crtd_On
	 
	
END

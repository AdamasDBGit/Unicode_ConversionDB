-- =============================================
-- Author:		Aritra Saha
-- Create date: 11/04/2007
-- Description:	Get the Invoice List by EnquiryID or StudentName
-- =============================================
CREATE PROCEDURE [dbo].[uspGetInvoiceListforSpecialDiscount] 
(
	-- Add the parameters for the stored procedure here
	@sFirstName varchar(50),
	@sMiddleName varchar(50),
	@sLastName varchar(50),
	@sInvoiceNo varchar(50),
	@iCenterId int
)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    -- Table[0]  Invoice Details
	
SELECT 
	I_Invoice_Header_ID,
	S_Invoice_No,
	N_Invoice_Amount,
	Dt_Invoice_Date
FROM 
	dbo.T_Invoice_Parent A
WHERE
	A.I_Student_Detail_ID 
	IN 
	(	
		SELECT I_Student_Detail_ID 
		FROM dbo.T_Student_Detail B
		WHERE  
		B.S_First_Name LIKE ISNULL(@sFirstName,B.S_First_Name)+'%'
		AND B.S_Middle_Name LIKE ISNULL(@sMiddleName,B.S_Middle_Name)+'%'
		AND B.S_Last_Name LIKE ISNULL(@sLastName,B.S_Last_Name)+'%'		
	)
	AND A.S_Invoice_No LIKE ISNULL(@sInvoiceNo,A.S_Invoice_No)+'%'
	AND A.I_Centre_Id = @iCenterId
	AND A.I_STATUS = '1' 
	
	
END

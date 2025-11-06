CREATE PROCEDURE [dbo].[uspUpdateCorpStudentInvoiceMap]
(
	@sInvHeaderId VARCHAR(50),
	@sCorpStudentInvMap VARCHAR(MAX)
)
AS
BEGIN  
DECLARE @command VARCHAR(MAX)
SET @command = 'UPDATE dbo.T_Corp_Student_Invoice_Map SET I_Invoice_Header_ID ='+ @sInvHeaderId+
' WHERE I_Corp_Student_Invoice_Map IN ('+@sCorpStudentInvMap+')'

EXEC (@command)
END

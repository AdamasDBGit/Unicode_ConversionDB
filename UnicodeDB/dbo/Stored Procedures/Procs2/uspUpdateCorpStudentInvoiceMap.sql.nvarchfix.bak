CREATE PROCEDURE [dbo].[uspUpdateCorpStudentInvoiceMap]
(
	@sInvHeaderId Nnvarchar(max),
	@sCorpStudentInvMap Nnvarchar(max)
)
AS
BEGIN  
DECLARE @command nvarchar(max)
SET @command = 'UPDATE dbo.T_Corp_Student_Invoice_Map SET I_Invoice_Header_ID ='+ @sInvHeaderId+
' WHERE I_Corp_Student_Invoice_Map IN ('+@sCorpStudentInvMap+')'

EXEC (@command)
END


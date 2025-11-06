CREATE PROCEDURE [dbo].[uspGetCorporateInvoices]
(
	@strCorpStudentId NVARCHAR(max)
)
AS
BEGIN  
DECLARE @command nvarchar(max)
SET @command = 'SELECT * FROM dbo.T_Invoice_Parent WHERE I_Student_Detail_ID IN ('+@strCorpStudentId+')'

EXEC (@command)
END



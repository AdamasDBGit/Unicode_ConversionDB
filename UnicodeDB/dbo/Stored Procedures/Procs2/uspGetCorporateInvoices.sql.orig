CREATE PROCEDURE [dbo].[uspGetCorporateInvoices]
(
	@strCorpStudentId VARCHAR(MAX)
)
AS
BEGIN  
DECLARE @command VARCHAR(MAX)
SET @command = 'SELECT * FROM dbo.T_Invoice_Parent WHERE I_Student_Detail_ID IN ('+@strCorpStudentId+')'

EXEC (@command)
END

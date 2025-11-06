CREATE PROCEDURE [dbo].[uspGetCertificateTemplate] 
	
AS
BEGIN

	SET NOCOUNT OFF;

	SELECT * FROM dbo.T_Template_Master WHERE I_Status = 1
		
END

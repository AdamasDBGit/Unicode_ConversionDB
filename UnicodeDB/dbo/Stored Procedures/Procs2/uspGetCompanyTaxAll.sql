-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the Stream Master table
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCompanyTaxAll] 

AS
BEGIN TRY

	SELECT I_Company_Tax_Master_ID,I_Brand_ID,I_Country_ID,
			S_Tax_Name,S_Tax_Desc
	FROM dbo.T_Company_Tax_Master
	WHERE I_Status <> 0

END TRY


BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

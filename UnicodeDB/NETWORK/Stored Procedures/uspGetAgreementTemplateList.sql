-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the List of all Agreement Templates
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetAgreementTemplateList]
	@iAgreementTempID INT= NULL,
	@iCountryID INT = NULL,
	@sCode varchar(20) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT I_Agreement_Template_ID,
		S_Agreement_Template_Code,
		I_Country_ID,
		I_Status
	FROM NETWORK.T_Agreement_Template_Master
	WHERE ISNULL(@iAgreementTempID,I_Agreement_Template_ID) = I_Agreement_Template_ID
	AND ISNULL(@iCountryID,I_Country_ID) = I_Country_ID
	AND ISNULL(@sCode,S_Agreement_Template_Code) = S_Agreement_Template_Code
	AND I_Status <> 0
	
END

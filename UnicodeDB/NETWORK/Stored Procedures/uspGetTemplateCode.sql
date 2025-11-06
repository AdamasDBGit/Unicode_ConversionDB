-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the details of a particular Agreement Template
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetTemplateCode]
	@iCountryID INT = NULL,
	@sTemplateCode varchar(20)=NULL,
	@iTemplateID INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT ATM.I_Agreement_Template_ID,ATM.S_Agreement_Template_Code,
		ATM.I_Country_ID,ATM.I_Document_ID,ATM.I_Status,
		UD.S_Document_Name,UD.S_Document_Type,UD.S_Document_Path,
		UD.S_Document_URL
	FROM NETWORK.T_Agreement_Template_Master ATM
	INNER JOIN dbo.T_Upload_Document UD
	ON UD.I_Document_ID = ATM.I_Document_ID
	WHERE ATM.S_Agreement_Template_Code = ISNULL(@sTemplateCode,ATM.S_Agreement_Template_Code)
		AND ATM.I_Country_ID = ISNULL(@iCountryID,ATM.I_Country_ID)
		AND ATM.I_Agreement_Template_ID = ISNULL(@iTemplateID,ATM.I_Agreement_Template_ID)
		AND ATM.I_Status = 1
		AND UD.I_Status = 1
	
END

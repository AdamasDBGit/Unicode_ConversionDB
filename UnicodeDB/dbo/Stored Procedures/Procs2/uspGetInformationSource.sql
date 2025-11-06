-- =============================================
-- Author:		Debarshi basu
-- Create date: 22/03/2006
-- Description:	Selects All the Information Source 
-- =============================================
CREATE PROCEDURE [dbo].[uspGetInformationSource] 

AS
BEGIN

	SELECT TOP 100 I_Info_Source_ID, S_Info_Source_Name, I_Status
	FROM dbo.T_Information_Source_Master
	WHERE I_Status = 1

END

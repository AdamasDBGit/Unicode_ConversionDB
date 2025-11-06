-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Gets all rows from Qualification Name master table
-- =============================================
CREATE PROCEDURE [dbo].[uspGetQualificationType] 

AS
BEGIN

	SET NOCOUNT OFF

	SELECT	I_Qualification_Type_ID,S_Qualification_Type,I_Status
	FROM dbo.T_Qualification_Type_Master
	WHERE I_Status = 1 ORDER BY S_Qualification_Type

END

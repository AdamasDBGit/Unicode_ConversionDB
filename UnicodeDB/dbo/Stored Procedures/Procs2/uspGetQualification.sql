-- =============================================
-- Author:		Debarshi Basu
-- Create date: <22-03-2007>
-- Description:	<To get all types of Qualification from table>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetQualification] 

AS
BEGIN

	SET NOCOUNT OFF

	SELECT	I_Qualification_Name_ID,S_Qualification_Name
	FROM dbo.T_Qualification_Name_Master
	WHERE I_Status = 1 ORDER BY S_Qualification_Name

END

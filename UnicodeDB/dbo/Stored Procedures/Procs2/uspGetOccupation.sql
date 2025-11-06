-- =============================================
-- Author:		Debarshi basu
-- Create date: 22-03-2007
-- Description:	<to load all occupation>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetOccupation] 
	
AS
BEGIN

	SET NOCOUNT ON;

	SELECT I_Occupation_ID,S_Occupation_Name,I_Status
	FROM dbo.T_Occupation_Master WHERE I_Status = 1 ORDER BY S_Occupation_Name
END

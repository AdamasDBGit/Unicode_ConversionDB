-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the Preferred Careers
-- =============================================


CREATE PROCEDURE [dbo].[uspGetPrefCareer] 

AS
BEGIN

	SELECT I_Pref_Career_ID,S_Pref_Career_Name,I_Status
	FROM T_Preferred_Career_Master
	WHERE I_Status = 1 ORDER BY S_Pref_Career_Name

END

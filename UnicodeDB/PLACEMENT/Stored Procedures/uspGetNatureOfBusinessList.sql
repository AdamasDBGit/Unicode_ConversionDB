-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description:Select list of Nature of business records from T_Business_Master table	
-- =================================================================

CREATE PROCEDURE [PLACEMENT].[uspGetNatureOfBusinessList]
AS
BEGIN

	SELECT 
		ISNULL(I_Nature_of_Business,0) AS I_Nature_of_Business ,
        ISNULL(S_Description_Business,' ') AS S_Description_Business
	FROM [PLACEMENT].T_Business_Master
		WHERE I_Status = 1
	ORDER BY S_Description_Business	

END

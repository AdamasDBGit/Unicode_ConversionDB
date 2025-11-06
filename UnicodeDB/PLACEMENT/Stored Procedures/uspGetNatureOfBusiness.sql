-- =================================================================
-- Author:Shankha Roy
-- Create date:12/05/2007 
-- Description:Select detail of Nature of business record from T_Business_Master table	
-- =================================================================

CREATE PROCEDURE [PLACEMENT].[uspGetNatureOfBusiness]
(
@INatureofBusiness int
) 
AS
BEGIN

	SELECT 
		ISNULL(I_Nature_of_Business,0) AS I_Nature_of_Business ,
        ISNULL(S_Description_Business,' ') AS S_Description_Business
	FROM [PLACEMENT].T_Business_Master
	WHERE I_Nature_of_Business =@INatureofBusiness
END

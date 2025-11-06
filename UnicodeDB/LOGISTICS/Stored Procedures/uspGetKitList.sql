/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:31/07/2007
-- Description:Get Kit Details From T_Kit_Master table
-- Parameter : 
-- =================================================================
*/

CREATE PROCEDURE [LOGISTICS].[uspGetKitList]
(
	@sKitCode VARCHAR(20) = NULL,
	@sKitDesc VARCHAR(200) = NULL
)
AS
BEGIN
	SELECT 
		ISNULL(I_Kit_ID, 0) AS I_Kit_ID,
  		ISNULL(S_Kit_Code, ' ') AS S_Kit_Code,
		ISNULL(S_Kit_Desc, ' ') AS S_Kit_Desc,
		ISNULL(I_Kit_Rate_INR, ' ') AS S_Kit_Rate_INR,
		ISNULL(I_Kit_Rate_USD, ' ') AS S_Kit_Rate_USD,
		ISNULL(I_Kit_Mode, 0) AS I_Kit_Mode
	FROM  LOGISTICS.T_Kit_Master
	WHERE 
        S_Kit_Code LIKE '%' + @sKitCode + '%'
		OR S_Kit_Desc LIKE '%' + @sKitDesc + '%'
END

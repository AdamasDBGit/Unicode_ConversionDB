/*
-- =================================================================
-- Author:Shankha Roy
-- Create date:12/07/2007
-- Description:Get Company name from T_Employer_Detail table
-- Returns : Dataset
-- ================================================================= 	   
*/

CREATE PROCEDURE [PLACEMENT].[uspGetCompanyName]
(
@iBrandId INT =null
)
AS
BEGIN 

	SELECT DISTINCT [ED].[I_Employer_ID] ,(ED.S_Company_Name) AS S_Company_Name
	FROM PLACEMENT.T_Employer_Detail ED
	INNER JOIN dbo.T_User_Master UM
	ON UM.I_Reference_ID = ED.I_Employer_ID
	AND UM.S_User_Type = 'EM'	
	WHERE  UM.I_User_ID IN (SELECT I_User_ID FROM [Placement].[fnGetUserIDFormBrand](@iBrandID))	
END

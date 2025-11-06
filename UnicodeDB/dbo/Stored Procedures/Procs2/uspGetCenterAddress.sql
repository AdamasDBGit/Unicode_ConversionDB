-- ============================================================================
-- Author:		Aritra Saha
-- Create date: 7/05/2007
-- Description:	Retrieve the Center Address for a Center
--Parameters:  CenterID
--Returns:     DatatSet
--Modified By:
--Comments   : Further details such as course details can be retrieved later
-- ============================================================================
CREATE PROCEDURE [dbo].[uspGetCenterAddress] 
(
	-- Add the parameters for the stored procedure here
	 @iCenterID int --Center ID
)

AS
BEGIN 
SELECT TCA.*,TCM.S_Center_Name,TCM.I_Is_OwnCenter,TCM.S_ServiceTax_Regd_Code,CM.I_Currency_ID
FROM [NETWORK].[T_Center_Address] TCA
INNER JOIN T_Centre_Master TCM
ON TCA.I_Centre_ID = TCM.I_Centre_ID
INNER JOIN dbo.T_Country_Master CM
ON TCM.I_Country_ID = CM.I_Country_ID
WHERE TCM.I_Centre_Id=@iCenterID  AND TCM.I_Centre_Id = TCA.I_Centre_Id


END

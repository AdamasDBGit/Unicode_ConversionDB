-- =============================================
-- Author:		Shankha Roy
-- Create date: '07/04/2008'
-- Description:	This Function return a table 
-- consisting of default product id of given brand ID
-- Return: Table
-- =============================================
CREATE FUNCTION [MBP].[fnGetDefaultProductIDFromBrandID]
(
	@iBrandID INT
	
)
RETURNS @rtnTable  TABLE
(
	iProductID INT
	
)

AS
BEGIN

INSERT INTO @rtnTable
SELECT I_Product_ID FROM MBP.T_Product_Master 
WHERE S_Product_Name ='MBP_DUMMY_PRODUCT_FOR_ENQUIRY' 
AND I_Brand_ID =@iBrandID   


RETURN;

END
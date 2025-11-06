/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 10/04/2007
Description: Select all Tax Master Data
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetTax]

AS
BEGIN

SELECT * FROM T_Tax_Master ORDER BY S_Tax_Desc	

END

/*****************************************************************************************************************
Created by: Debarshi Basu
Date: 10/04/2007
Description: Select all Tax Master Data
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetValidTax]

AS
BEGIN

SELECT * FROM T_Tax_Master where I_Status = 1	
	AND GETDATE() >= ISNULL(Dt_Valid_From,Getdate())
	AND GETDATE() <= ISNULL(Dt_Valid_To,Getdate())

END

/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 12/04/2007
Description: Deletes a receipt header and corresponding details
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetChequeDetails]
(
	@iCenterID int,
	@sChequeDDNumber varchar(20)
)

AS
BEGIN

	SELECT H.* 
	FROM T_Receipt_Header H WITH(NOLOCK)
	WHERE H.I_Centre_Id = ISNULL(@iCenterID,H.I_Centre_Id)
	AND S_ChequeDD_No = @sChequeDDNumber
	AND H.I_Status<>0

END

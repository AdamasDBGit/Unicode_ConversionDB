/**************************************************************************************************************
Created by  : Debarshi Basu
Date		: 30.05.2007
Description : This SP will retrieve all the BP Types
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/


CREATE PROCEDURE [NETWORK].[uspGetBPType] 
AS
BEGIN

	SELECT I_BP_ID,S_BP_Type,I_Status
	FROM NETWORK.T_BP_Master
	WHERE I_Status = 1 ORDER BY S_BP_Type

END

/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will retrieve the Lis of KRAs
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetKRAList]
AS
BEGIN
	SELECT  I_KRA_ID,
			I_KRA_Index_ID,
			S_KRA_Desc,
			I_KRA_Type,
			I_Status
	FROM EOS.T_KRA_Master WITH(NOLOCK)
	WHERE I_Status = 1
END

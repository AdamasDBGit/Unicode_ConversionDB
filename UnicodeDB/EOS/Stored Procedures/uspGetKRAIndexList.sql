/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will retrieve the List of KRA Indexes
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetKRAIndexList]
AS
BEGIN
	SELECT  I_KRA_Index_ID,
			S_KRA_Index_Desc,
			I_Status
	FROM EOS.T_KRA_Index_Master WITH(NOLOCK)
	WHERE I_Status = 1
END

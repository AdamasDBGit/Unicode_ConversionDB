/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will retrieve the Lis of KRAs
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetKRADetails]
(
	@iBrandID INT,
	@iRoleID INT,
	@iKRAID INT
)
AS
BEGIN
	SELECT  TRKS.I_Role_ID,
			TRKS.I_Brand_ID,
			TRKS.I_SubKRA_ID,
			TRKS.I_SubKRA_Index_ID,
			TKM.S_KRA_Desc AS S_SubKRA_Desc,
			TKM.I_Status
	FROM EOS.T_Role_KRA_SubKRA TRKS WITH(NOLOCK), EOS.T_KRA_Master TKM WITH(NOLOCK)		
	WHERE	TRKS.I_Status = 1
		AND	TRKS.I_Brand_ID = @iBrandID
		AND TRKS.I_Role_ID = @iRoleID
		AND TRKS.I_KRA_ID = @iKRAID
		AND TRKS.I_SubKRA_ID = TKM.I_KRA_ID
END

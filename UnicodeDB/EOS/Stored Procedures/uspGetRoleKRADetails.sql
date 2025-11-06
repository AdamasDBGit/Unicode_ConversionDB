/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will retrieve the KRAs for a particular Role
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [EOS].[uspGetRoleKRADetails]
(	
	@iBrandID INT,
	@iRoleID INT
)	
AS
BEGIN
	SELECT 
		TRKM.I_KRA_ID,
		TRKM.I_KRA_Index_ID,
		TKM.S_KRA_Desc		
	FROM
		EOS.T_Role_KRA_Map TRKM WITH(NOLOCK)
		INNER JOIN EOS.T_KRA_Master TKM WITH(NOLOCK)
			ON TRKM.I_KRA_ID = TKM.I_KRA_ID
	WHERE
			--TRKM.I_Brand_ID = @iBrandID AND
		TRKM.I_Role_ID = @iRoleID
END

-- =============================================
-- Author:		Santanu Maity
-- Create date: 31/07/2007
-- Description:	GETS center list for ownership transfer
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetCenterForOwnershipTranfer]
	@iStatus INT
	
AS
BEGIN
	SET NOCOUNT OFF;
	BEGIN
		SELECT CM.I_Centre_Id,CM.S_Center_Name,
			CM.I_Status,
			ISNULL(CM.S_CENTER_CODE,'') AS S_CENTER_CODE,
			ISNULL(CM.Dt_Upd_On,GETDATE()) as Dt_Upd_On
		FROM dbo.T_Centre_Master CM WITH(NOLOCK)
		INNER JOIN NETWORK.T_Ownership_Transfer_Request OTR
		ON CM.I_Centre_Id = OTR.I_Centre_Id
		AND OTR.I_Status = @iStatus

	END
END

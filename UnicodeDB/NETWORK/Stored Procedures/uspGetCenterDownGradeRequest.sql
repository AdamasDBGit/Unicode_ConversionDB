-- =============================================
-- Author:		Debarshi Basu
-- Create date: 04/07/2007
-- Description:	Get center Downgrade Request List
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCenterDownGradeRequest]
(
	@iStatus int=NULL
)
AS
BEGIN TRY
	IF @iStatus IS NOT NULL
	BEGIN
		SELECT A.I_Centre_Id,A.S_Reason,A.S_Remarks,A.I_Requested_Category,
			CM.S_Center_Code,CM.S_Center_Name,CM.S_Center_Short_Name,
			CM.I_Center_Category,A.I_Status,ISNULL(A.Dt_Upd_On,A.Dt_Crtd_On) AS Dt_Upd_On
		FROM NETWORK.T_Upgrade_Request A 
		INNER JOIN dbo.T_Centre_Master CM
		ON A.I_Centre_Id = CM.I_Centre_Id
		WHERE A.I_Is_Upgrade = 0
		AND A.I_Status = @iStatus
	END
	ELSE
	BEGIN
		SELECT A.I_Centre_Id,A.S_Reason,A.S_Remarks,A.I_Requested_Category,
			CM.S_Center_Code,CM.S_Center_Name,CM.S_Center_Short_Name,
			CM.I_Center_Category,A.I_Status,ISNULL(A.Dt_Upd_On,A.Dt_Crtd_On) AS Dt_Upd_On
		FROM NETWORK.T_Upgrade_Request A 
		INNER JOIN dbo.T_Centre_Master CM
		ON A.I_Centre_Id = CM.I_Centre_Id
		WHERE A.I_Is_Upgrade = 0
		AND A.I_Status <> 0
	END
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

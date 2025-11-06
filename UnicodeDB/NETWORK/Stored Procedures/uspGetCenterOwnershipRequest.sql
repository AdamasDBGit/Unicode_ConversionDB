-- =============================================
-- Author:		Santanu Maity
-- Create date: 01/08/2007
-- Description:	Get center ownership Request
-- =============================================

CREATE PROCEDURE [NETWORK].[uspGetCenterOwnershipRequest]
(
	@iStatus int=NULL
)
AS
BEGIN TRY
	

	IF @iStatus IS NOT NULL
	BEGIN
		SELECT 
			CM.I_Centre_Id,
			CM.S_Center_Code,
			CM.S_Center_Name,
			CM.I_Country_ID,
			OTR.I_Status,
			BCD.I_Brand_ID

		FROM dbo.T_Centre_Master CM
			INNER JOIN NETWORK.T_Ownership_Transfer_Request OTR
			ON OTR.I_Centre_Id = CM.I_Centre_Id
			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON BCD.I_Centre_Id = CM.I_Centre_Id
		WHERE OTR.I_Status = @iStatus
			AND BCD.I_Status = 1
	END
	ELSE
	BEGIN
		SELECT 
			CM.I_Centre_Id,
			CM.S_Center_Code,
			CM.S_Center_Name,
			CM.I_Country_ID,
			OTR.I_Status,
			BCD.I_Brand_ID

		FROM dbo.T_Centre_Master CM
			INNER JOIN NETWORK.T_Ownership_Transfer_Request OTR
			ON OTR.I_Centre_Id = CM.I_Centre_Id
			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON BCD.I_Centre_Id = CM.I_Centre_Id
		WHERE OTR.I_Status <> 0
			AND BCD.I_Status = 1
	END


END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

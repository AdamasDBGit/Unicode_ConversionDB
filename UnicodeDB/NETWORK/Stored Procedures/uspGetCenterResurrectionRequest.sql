-- =============================================
-- Author:		Santanu Maity
-- Create date: 04/07/2007
-- Description:	Get center Termination Request
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCenterResurrectionRequest]
	-- Add the parameters for the stored procedure here
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
			BCD.I_Brand_ID,
			RR.I_Status,
			RR.S_Reason,
			ISNULL(RR.Dt_Upd_On,RR.Dt_Crtd_On) as Dt_Upd_On
		FROM dbo.T_Centre_Master CM
			INNER JOIN NETWORK.T_Resurrection_Request RR
			ON CM.I_Centre_Id = RR.I_Centre_Id
			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON BCD.I_Centre_Id = CM.I_Centre_Id
		WHERE RR.I_Status = @iStatus
			AND BCD.I_Status = 1
	END
	ELSE
	BEGIN
		SELECT 
			CM.I_Centre_Id,
			CM.S_Center_Code,
			CM.S_Center_Name,
			CM.I_Country_ID,
			BCD.I_Brand_ID,
			RR.I_Status,
			RR.S_Reason,
			ISNULL(RR.Dt_Upd_On,RR.Dt_Crtd_On) as Dt_Upd_On
		FROM dbo.T_Centre_Master CM
			INNER JOIN NETWORK.T_Resurrection_Request RR
			ON CM.I_Centre_Id = RR.I_Centre_Id
			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON BCD.I_Centre_Id = CM.I_Centre_Id
		WHERE RR.I_Status <> 0
			AND BCD.I_Status = 1
	END


END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

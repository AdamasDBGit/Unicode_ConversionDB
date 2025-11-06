-- =============================================
-- Author:		Santanu Maity
-- Create date: 04/07/2007
-- Description:	Get center Termination Request
-- =============================================
CREATE PROCEDURE [NETWORK].[uspGetCenterTerminationRequest]
	-- Add the parameters for the stored procedure here
(
	@iStatus int=NULL
)
AS
BEGIN TRY

	IF (@iStatus IS NOT NULL)
	BEGIN
		SELECT 
			CM.I_Centre_Id,
			CM.S_Center_Code,
			CM.S_Center_Name,
			CM.I_Country_ID,
			BCD.I_Brand_ID,
			TR.I_Status,
			TR.S_Reason,
			ISNULL(TR.Dt_Upd_On,TR.Dt_Crtd_On) AS Dt_Upd_On,
			UD.I_Document_ID,
			UD.S_Document_Name,
			UD.S_Document_Path,
			UD.S_Document_Type,
			UD.S_Document_URL
		FROM dbo.T_Centre_Master CM
			INNER JOIN NETWORK.T_Termination_Request TR
			ON CM.I_Centre_Id = TR.I_Centre_Id
			INNER JOIN dbo.T_Upload_Document UD
			ON TR.I_Document_ID = UD.I_Document_ID
			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON BCD.I_Centre_Id = CM.I_Centre_Id
		WHERE TR.I_Status = @iStatus
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
			TR.I_Status,
			TR.S_Reason,
			ISNULL(TR.Dt_Upd_On,TR.Dt_Crtd_On) AS Dt_Upd_On,
			UD.I_Document_ID,
			UD.S_Document_Name,
			UD.S_Document_Path,
			UD.S_Document_Type,
			UD.S_Document_URL
		FROM dbo.T_Centre_Master CM
			INNER JOIN NETWORK.T_Termination_Request TR
			ON CM.I_Centre_Id = TR.I_Centre_Id
			INNER JOIN dbo.T_Upload_Document UD
			ON TR.I_Document_ID = UD.I_Document_ID
			INNER JOIN dbo.T_Brand_Center_Details BCD
			ON BCD.I_Centre_Id = CM.I_Centre_Id
		WHERE TR.I_Status <> 0
			AND BCD.I_Status = 1
	END


END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

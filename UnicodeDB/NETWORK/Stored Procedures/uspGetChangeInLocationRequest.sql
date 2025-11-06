-- ====================================================================
-- Author:		Santanu Maity
-- Create date: 06/08/2007
-- Description:	Get the Details of an Change In Location Request
-- ====================================================================

CREATE PROCEDURE [NETWORK].[uspGetChangeInLocationRequest]
(
	@iCenterID INT=NULL,
	@iStatus INT=NULL
)
AS
BEGIN TRY
	IF @iStatus IS NOT NULL AND @iCenterID IS NULL
	BEGIN
		SELECT * FROM NETWORK.T_AddressChange_Request
			WHERE I_Status = @iStatus
	END
	ELSE IF @iCenterID IS NOT NULL AND @iStatus IS NULL
	BEGIN
		SELECT * FROM NETWORK.T_AddressChange_Request
			WHERE I_Centre_Id = @iCenterID
			AND I_Status <> 0
	END
	ELSE IF @iCenterID IS NULL AND @iStatus IS NULL
	BEGIN
		SELECT * FROM NETWORK.T_AddressChange_Request
			WHERE I_Status <> 0
	END
	ELSE
	BEGIN
		SELECT  * FROM NETWORK.T_AddressChange_Request 
			WHERE I_Centre_Id = @iCenterID AND I_Status = @iStatus
	END

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

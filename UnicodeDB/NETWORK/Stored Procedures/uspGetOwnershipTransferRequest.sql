-- ====================================================================
-- Author:		Swagatam Sarkar
-- Create date: 05/07/2007
-- Description:	Get the Details of an Ownership Transfer Request
-- ====================================================================

CREATE PROCEDURE [NETWORK].[uspGetOwnershipTransferRequest]
	@iCenterID INT
AS
BEGIN

	--Table[0] for Ownership Transfer Request Details
	SELECT * FROM NETWORK.T_Ownership_Transfer_Request
		WHERE I_Centre_Id = @iCenterID
		AND I_Status <> 0
END

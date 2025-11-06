-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/06/2007
-- Description:	Get the fee sharing percentage
-- =============================================

CREATE PROCEDURE [dbo].[uspGetFeeSharing]
(
	@iCountryID INT = NULL,
	@iCenterID INT = NULL,
	@iCourseID INT = NULL,
	@iFeeComponentID INT = NULL
)

AS
BEGIN
	
	SELECT top 1 N_Company_Share,Dt_Period_Start,Dt_Period_End
	FROM dbo.T_Fee_Sharing_Master
	WHERE ISNULL(I_Country_ID,0) = ISNULL(@iCountryID,0)
		AND	ISNULL(I_Center_ID,0) = ISNULL(@iCenterID,0)
		AND ISNULL(I_Course_ID,0) = ISNULL(@iCourseID,0)
		AND	ISNULL(I_Fee_Component_ID,0) = ISNULL(@iFeeComponentID,0)
		AND	I_Status = 1
		AND GETDATE() >= ISNULL(Dt_Period_Start, GETDATE())
		AND GETDATE() <= ISNULL(Dt_Period_End, GETDATE())

 
	

END

/**************************************************************************************************************
Created by  : Aritra Saha
Date		: 29/06/2007
Description : This SP will retrieve Center Details for a Center Id
Parameters  : Center  ID
Returns     : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [dbo].[uspPopulateCenterDetails] 

(
	@iCenterID int
)
AS
BEGIN TRY
	
	SELECT TCM.*, TBCD.I_Brand_ID,TCHD.I_Hierarchy_Detail_ID
	FROM dbo.T_Centre_Master TCM
	INNER JOIN dbo.T_Brand_Center_Details TBCD
	ON TCM.I_Centre_Id = TBCD.I_Centre_Id
	INNER JOIN dbo.T_Center_Hierarchy_Details TCHD
	ON TCM.I_Centre_Id = TCHD.I_Center_Id
	WHERE TCM.I_Centre_Id = @iCenterID
	AND GETDATE() >= ISNULL(TCM.Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(TCM.Dt_Valid_To,GETDATE())
	AND TBCD.I_Status <> 0
	AND GETDATE() >= ISNULL(TBCD.Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(TBCD.Dt_Valid_To,GETDATE())
	AND TCHD.I_Status <> 0
	AND GETDATE() >= ISNULL(TCHD.Dt_Valid_From,GETDATE())
	AND GETDATE() <= ISNULL(TCHD.Dt_Valid_To,GETDATE())		
	
	
	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

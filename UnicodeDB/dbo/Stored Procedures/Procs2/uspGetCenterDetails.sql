/**************************************************************************************************************
Created by  : Swagata De
Date		: 02.04.2007
Description : This SP will retrieve Center Details for a given hierarchy detail Id
Parameters  : Center Hierarchy Details ID
Returns     : Dataset
**************************************************************************************************************/
CREATE PROCEDURE [dbo].[uspGetCenterDetails] 

(
	@iCenterHrchyDetID int
)

AS
BEGIN TRY
	
	SELECT TCM.I_Centre_Id,TCM.S_Center_Code,TCM.S_Center_Name
	FROM dbo.T_Centre_Master TCM,dbo.T_Center_Hierarchy_Details TCHD
	WHERE TCM.I_Centre_Id=TCHD.I_Center_Id
	AND TCHD.I_Hierarchy_Detail_ID=@iCenterHrchyDetID
	AND TCM.I_Status<>0
	
END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

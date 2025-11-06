-- =============================================
-- Author: Shankha Roy
-- Create date: 07/11/2007
-- Description: This sp return return list summary report for placment. 
--				
-- Parameter: @iBrandID ,@dtStartDate ,@dtEndDate , @sHierarchyList
-- =============================================


CREATE PROCEDURE [REPORT].[uspGetPlacementSummaryReport] 
(
-- Add the parameters for the stored procedure here
	@iBrandID INT = NULL,
	@sHierarchyList VARCHAR(MAX) = NULL,
	@dtStartDate DATETIME,
	@dtEndDate DATETIME
)
AS

BEGIN TRY
	BEGIN 

			
				SELECT
				ISNULL(FN1.CenterCode,'') AS CenterCode,
				ISNULL(FN1.CenterName,'') AS CenterName,
				ISNULL(FN2.InstanceChain,'') AS InstanceChain,
				COUNT(SS.I_Shortlisted_Student_ID) AS Placements
				FROM
				PLACEMENT.T_Shortlisted_Students SS
				INNER JOIN dbo.T_Student_Detail SD 
				ON SS.I_Student_Detail_ID = SD.I_Student_Detail_ID 
				INNER JOIN dbo.T_Student_Center_Detail SCD 
				ON SS.I_Student_Detail_ID = SCD.I_Student_Detail_ID 
				INNER JOIN dbo.T_Centre_Master CM 
				ON CM.I_Centre_Id = SCD.I_Centre_Id 
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON CM.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID

				WHERE 
				--SS.C_Interview_Status = 'S'
				 DATEDIFF(dd, ISNULL(@dtStartDate,SS.Dt_Crtd_On), SS.Dt_Crtd_On) >= 0
				AND DATEDIFF(dd, ISNULL(@dtEndDate,SS.Dt_Crtd_On), SS.Dt_Crtd_On) <= 0
				AND CM.I_Centre_Id IN 
				(
				SELECT centerID FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID)
				)
				AND SS.C_Interview_Status = 'S'
				GROUP BY SCD.I_Centre_Id,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain				


	END
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

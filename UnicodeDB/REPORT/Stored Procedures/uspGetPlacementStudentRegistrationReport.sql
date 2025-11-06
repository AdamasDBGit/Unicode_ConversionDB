-- =============================================
-- Author: Shankha Roy
-- Create date: 07/11/2007
-- Description: This sp return return list summary student registration report. 
--				
-- Parameter: @iBrandID ,@dtStartDate ,@dtEndDate , @sHierarchyList
-- =============================================


CREATE PROCEDURE [REPORT].[uspGetPlacementStudentRegistrationReport] 
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
				SD.S_Student_ID AS StudentID,
				ISNULL(SD.S_Title,'') + ' ' + SD.S_First_Name + ' ' + LTRIM(isnull(SD.S_Middle_Name,'') + ' ' + SD.S_Last_Name) as StudentName,
				CONVERT(VARCHAR(12),PR.Dt_Crtd_On,106) AS RegistrationDate,
				CONVERT(VARCHAR(12),ISNULL(STCD.Dt_Course_Actual_End_Date,STCD.Dt_Course_Expected_End_Date),106) AS Dt_Course_Actual_End_Date,
				CONVERT(VARCHAR(12),STCD.Dt_Course_Expected_End_Date,106) AS Dt_Course_Expected_End_Date,
				PR.I_Job_Type_ID AS I_Job_Type_ID,				
				TCM.S_Course_Name AS S_Course_Name,
				FN1.CenterCode,
				FN1.CenterName,
				FN2.InstanceChain
				FROM
				
				PLACEMENT.T_Placement_Registration PR				
				INNER JOIN dbo.T_Student_Detail SD 
				ON PR.I_Student_Detail_ID = SD.I_Student_Detail_ID 
				INNER JOIN dbo.T_Student_Center_Detail SCD 
				ON PR.I_Student_Detail_ID = SCD.I_Student_Detail_ID 
				INNER JOIN dbo.T_Centre_Master CM 
				ON CM.I_Centre_Id = SCD.I_Centre_Id 
				INNER JOIN dbo.T_Brand_Center_Details BCD 
				ON CM.I_Centre_Id = BCD.I_Centre_Id 
				INNER JOIN dbo.T_Brand_Master BM
				ON BM.I_Brand_ID = BCD.I_Brand_ID				
				INNER JOIN dbo.T_Student_Course_Detail STCD
				ON PR.I_Student_Detail_ID = STCD.I_Student_Detail_ID 
				INNER JOIN dbo.T_Course_Master TCM
				ON TCM.I_Course_ID =STCD.I_Course_ID
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
				ON CM.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
				WHERE 
				DATEDIFF(dd, ISNULL(@dtStartDate,PR.Dt_Crtd_On), PR.Dt_Crtd_On) >= 0
				AND DATEDIFF(dd, ISNULL(@dtEndDate,PR.Dt_Crtd_On), PR.Dt_Crtd_On) <= 0
				AND CM.I_Centre_Id IN 
				(
				SELECT centerID FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID)
				)
				


	END
END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

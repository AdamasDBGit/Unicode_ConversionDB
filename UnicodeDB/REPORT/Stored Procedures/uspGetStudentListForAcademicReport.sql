/*****************************************************************************************************************
Created by: Santanu Maity
Date: 25/06/2007
Description:Fetches the Student List for the selected center(s) and Course
Parameters: @sHierarchyList, @iBrandID, @iCourseID, @dtStartDate, @dtEndDate
******************************************************************************************************************/

CREATE PROCEDURE [REPORT].[uspGetStudentListForAcademicReport] 
(
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@iBatchID int	
)
AS

BEGIN TRY 

	SELECT 
		SD.I_Student_Detail_ID,
		SD.S_Title,
		SD.S_First_Name,
		SD.S_Middle_Name,
		SD.S_Last_Name
		
	FROM dbo.T_Student_Detail SD WITH (NOLOCK)
			INNER JOIN dbo.T_Student_Course_Detail SCD WITH (NOLOCK)
				ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
				AND SCD.I_Status = SD.I_Status
				AND SCD.[I_Batch_ID] = @iBatchID
				AND SCD.I_Is_Completed = 0
				AND SCD.I_Status = 1
			INNER JOIN dbo.T_Student_Center_Detail SC WITH (NOLOCK)
				ON SC.I_Student_Detail_ID = SD.I_Student_Detail_ID
				AND SC.I_Status = 1
			INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1 
				ON SC.I_Centre_Id=FN1.CenterID
			INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList, @iBrandID) FN2
				ON FN1.HierarchyDetailID=FN2.HierarchyDetailID


END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

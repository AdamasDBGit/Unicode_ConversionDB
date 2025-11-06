/*****************************************************************************************************************
Created by: Soumya Sikder
Date: 11/06/2007
Description:Fetches the Course List for the selected center(s)
Parameters: @sHierarchyList, @iBrandID
******************************************************************************************************************/
CREATE PROCEDURE [REPORT].[uspGetCourseListForReport]
(
	@sHierarchyList varchar(MAX),
	@iBrandID int
)
AS

BEGIN TRY 

	SELECT CM.I_Course_ID,
		   CM.S_Course_Code,
		   CM.S_Course_Name
	FROM dbo.T_Course_Master CM
    INNER JOIN dbo.T_Course_Center_Detail CCD
	ON CM.I_Course_ID = CCD.I_Course_ID
	WHERE CCD.I_Centre_Id IN 
	(
		SELECT centerID FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID))
--	AND GETDATE() > = ISNULL(CCD.Dt_Valid_From, GETDATE()) 
--	AND GETDATE() <= ISNULL(CCD.Dt_Valid_To, GETDATE())
	AND CCD.I_Status = 1
	AND CM.I_Status = 1
	ORDER BY CM.S_Course_Code

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

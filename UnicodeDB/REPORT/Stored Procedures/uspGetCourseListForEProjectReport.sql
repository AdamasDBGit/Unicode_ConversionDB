/*****************************************************************************************************************
Created by: Soumya Sikder
Date: 22/11/2007
Description:Fetches the Course List for the selected center(s) having E-Projects
Parameters: @sHierarchyList, @iBrandID
******************************************************************************************************************/
CREATE PROCEDURE [REPORT].[uspGetCourseListForEProjectReport]
(
	@sHierarchyList varchar(MAX),
	@iBrandID int
)
AS

BEGIN TRY 

	SELECT DISTINCT CM.I_Course_ID,
		   CM.S_Course_Code,
		   CM.S_Course_Name
	FROM dbo.T_Course_Master CM
    INNER JOIN dbo.T_Course_Center_Detail CCD
	ON CM.I_Course_ID = CCD.I_Course_ID
	INNER JOIN dbo.T_Term_Eval_Strategy TES
	ON CM.I_Course_ID = TES.I_Course_ID
	AND TES.I_Exam_Type_Master_ID = 1
	AND TES.I_Status = 1
	WHERE CCD.I_Centre_Id IN 
	(SELECT centerID FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID))
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

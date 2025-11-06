/*****************************************************************************************************************
Created by: Santanu Maity
Date: 18/07/2007
Description:Fetches the Student List for the selected center(s) and Courses
Parameters: @sHierarchyList, @iBrandID, @sCourseIDs
******************************************************************************************************************/

CREATE PROCEDURE [REPORT].[uspGetStudentListForMultiCourse] 
(
	@sHierarchyList varchar(MAX),
	@iBrandID int,
	@sCourseIDs varchar(100)	
)
AS

BEGIN TRY 
	IF @sCourseIDs = '%'
	BEGIN
		SELECT 
			SD.I_Student_Detail_ID,
			SD.S_Title,
			SD.S_First_Name,
			SD.S_Middle_Name,
			SD.S_Last_Name		
		FROM dbo.T_Student_Detail SD
				INNER JOIN dbo.T_Student_Course_Detail SCD
					ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
					AND SCD.I_Status = SD.I_Status
					AND SCD.I_Is_Completed = 'False'
					AND SCD.I_Status = 1
				INNER JOIN dbo.T_Student_Center_Detail SC
					ON SC.I_Student_Detail_ID = SD.I_Student_Detail_ID
					AND SC.I_Status = 1
				INNER JOIN dbo.T_Course_Master CM
					ON SCD.I_Course_ID = CM.I_Course_ID
					AND CM.I_Course_ID LIKE ('%') 
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
					ON SC.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,@iBrandID) FN2
					ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
	END
	ELSE
	BEGIN
		SELECT 
			SD.I_Student_Detail_ID,
			SD.S_Title,
			SD.S_First_Name,
			SD.S_Middle_Name,
			SD.S_Last_Name		
		FROM dbo.T_Student_Detail SD
				INNER JOIN dbo.T_Student_Course_Detail SCD
					ON SD.I_Student_Detail_ID = SCD.I_Student_Detail_ID
					AND SCD.I_Status = SD.I_Status
					AND SCD.I_Is_Completed = 'False'
					AND SCD.I_Status = 1
				INNER JOIN dbo.T_Student_Center_Detail SC
					ON SC.I_Student_Detail_ID = SD.I_Student_Detail_ID
					AND SC.I_Status = 1
				INNER JOIN dbo.T_Course_Master CM
					ON SCD.I_Course_ID = CM.I_Course_ID
					AND CM.I_Course_ID IN (select * from dbo.fnString2Rows(@sCourseIDs,',')) 
				INNER JOIN [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID) FN1
					ON SC.I_Centre_Id=FN1.CenterID
				INNER JOIN [dbo].[fnGetInstanceNameChainForReports](@sHierarchyList,@iBrandID) FN2
					ON FN1.HierarchyDetailID=FN2.HierarchyDetailID
	END
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

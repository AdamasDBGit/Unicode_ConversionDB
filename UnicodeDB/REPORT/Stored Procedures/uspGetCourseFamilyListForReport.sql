CREATE PROCEDURE [REPORT].[uspGetCourseFamilyListForReport]
(
	@sHierarchyList varchar(MAX),
	@iBrandID int
)
AS

BEGIN TRY 

	SELECT DISTINCT CFM.I_CourseFamily_ID,
					CFM.S_CourseFamily_Name
					FROM dbo.T_Course_Master CM
		 INNER JOIN dbo.T_Course_Center_Detail CCD
				 ON CM.I_Course_ID = CCD.I_Course_ID
		 INNER JOIN dbo.T_CourseFamily_Master CFM
				 ON CM.I_CourseFamily_ID=CFM.I_CourseFamily_ID
			  WHERE CCD.I_Centre_Id IN (SELECT centerID FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID))
				AND GETDATE() > = ISNULL(CCD.Dt_Valid_From, GETDATE()) 
				AND GETDATE() <= ISNULL(CCD.Dt_Valid_To, GETDATE())
				AND CCD.I_Status = 1
				AND CM.I_Status = 1
				ORDER BY CFM.S_CourseFamily_Name

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

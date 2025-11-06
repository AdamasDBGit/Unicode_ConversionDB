/***************************************************************
Description : Gets term list for a selected course family
Author	:     Swagatam Sarkar
Date	:	  13-Mar-2008
***************************************************************/

CREATE PROCEDURE [dbo].[uspGetTermListforCourseFamily]
(
	@iCourseFamilyID int
)
AS

BEGIN TRY 

	SELECT * FROM dbo.T_Term_Master
	WHERE I_Term_ID IN
	(SELECT I_Term_ID FROM dbo.T_Term_Course_Map
		WHERE I_Course_ID IN
		(SELECT I_Course_ID FROM dbo.T_Course_Master
			WHERE I_CourseFamily_ID = @iCourseFamilyID
			AND I_Status <> 0)
		 AND GETDATE() >= ISNULL(Dt_Valid_From, GETDATE())
		 AND GETDATE() <= ISNULL(Dt_Valid_To,GETDATE())
		 AND I_Status <> 0)

END TRY

BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

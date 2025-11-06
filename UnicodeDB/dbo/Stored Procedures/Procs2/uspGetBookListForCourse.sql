--******************************************
--Desc : This SP gets the book list for a course
--Date : 31/07/2007
--Written By : Debarshi Basu
--******************************************
CREATE PROCEDURE [dbo].[uspGetBookListForCourse] 
	@iCourseID INT

AS
BEGIN

	SELECT CAST(I_Book_ID AS VARCHAR(10)) + '|' + S_Book_Code + '|' + S_BOOK_NAME  AS S_BookList
	FROM T_BOOK_MASTER WHERE I_BOOK_ID IN
		(SELECT DISTINCT I_BOOK_ID FROM T_MODULE_BOOK_MAP MBM WHERE I_MODULE_ID IN 
			(SELECT I_MODULE_ID FROM T_MODULE_TERM_MAP MTM WHERE I_TERM_ID IN
				(SELECT I_TERM_ID FROM T_TERM_COURSE_MAP TCM 
				WHERE I_COURSE_ID = @iCourseId AND I_Status <> 0 AND 
				GETDATE() >= ISNULL(TCM.Dt_Valid_From,GETDATE())
				AND GETDATE() <= ISNULL(TCM.Dt_Valid_To,GETDATE())
				)
			AND GETDATE() >= ISNULL(MTM.Dt_Valid_From,GETDATE())
			AND GETDATE() <= ISNULL(MTM.Dt_Valid_To,GETDATE())
		)
		AND GETDATE() >= ISNULL(MBM.Dt_Valid_From,GETDATE())
		AND GETDATE() <= ISNULL(MBM.Dt_Valid_To,GETDATE())
		)

END

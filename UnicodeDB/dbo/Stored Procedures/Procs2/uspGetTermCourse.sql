-- =============================================
-- Author:		<Rabin Mukherjee>
-- Create date: <05-02-2007	>
-- Description:	<to load all Terms And Courses>
--exec uspGetTermCourse
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTermCourse]
@iCourseID INT,
@dtCurrentDate datetime = null
AS
BEGIN	
	Set @dtCurrentDate = CONVERT(DATE,ISNULL(@dtCurrentDate,GETDATE()))		

	SELECT T_Term_Course_Map.*, [T_Term_Master].[S_Term_Code], [T_Term_Master].[S_Term_Name] 
	FROM T_Term_Course_Map
	INNER JOIN [T_Term_Master] WITH(NOLOCK)
	ON [dbo].[T_Term_Course_Map].[I_Term_ID] = [dbo].[T_Term_Master].[I_Term_ID]
	WHERE T_Term_Course_Map.I_Course_ID=@iCourseID
	AND T_Term_Course_Map.[I_Status] = 1
	AND [T_Term_Master].[I_Status] = 1
	AND @dtCurrentDate >= ISNULL(CONVERT(DATE,T_Term_Course_Map.Dt_Valid_From),@dtCurrentDate)
	AND @dtCurrentDate <= ISNULL(CONVERT(DATE,T_Term_Course_Map.Dt_Valid_To),@dtCurrentDate)
END

select GETDATE()

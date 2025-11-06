-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetCourseNameList]
(
	-- Add the parameters for the function here
	@iCourseIdList INT
)
RETURNS VARCHAR(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @sCourseNameList VARCHAR(MAX)
	DECLARE @temp TABLE(I_Course_List_ID INT,S_Course_Name VARCHAR(250))
	
	INSERT INTO @temp
	SELECT A.I_Course_List_ID,B.S_Course_Name
	FROM [ASSESSMENT].[T_Assessment_CourseList_Course_Map] A
	INNER JOIN dbo.T_Course_Master B
	ON A.I_Course_ID = B.I_Course_ID
	WHERE A.I_Course_List_ID  = @iCourseIdList
	
	SELECT @sCourseNameList =
	stuff((select ','+S_Course_Name
		   from @temp b
		   where b.I_Course_List_ID=a.I_Course_List_ID
		   for xml path(''),type).value('.[1]','nvarchar(max)'),1,1,'')
		   FROM @temp a
	
		   
	-- Return the result of the function
	RETURN @sCourseNameList

END
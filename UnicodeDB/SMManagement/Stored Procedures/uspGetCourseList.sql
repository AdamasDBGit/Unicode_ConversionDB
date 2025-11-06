CREATE PROCEDURE [SMManagement].[uspGetCourseList]
AS

BEGIN

SELECT DISTINCT TCM.I_Course_ID,TCM.S_Course_Name FROM dbo.T_Course_Master AS TCM
INNER JOIN SMManagement.T_Item_Course_Mapping AS TICM ON TCM.I_Course_ID=TICM.CourseID
WHERE
TCM.I_Status=1 AND TICM.StatusID=1


END

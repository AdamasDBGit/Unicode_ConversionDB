/*
-- =================================================================
-- Author:Chandan Dey
-- Create date:26/08/2007
-- Description:Get Module List For Selected Course
-- Parameter : iCourseID
-- =================================================================
*/
CREATE PROCEDURE [PSCERTIFICATE].[uspGetModuleListForSelectedCourse]
(
	@iCourseId INT
)


AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT DISTINCT ISNULL(MM.I_Module_ID,0) AS I_Module_ID
			,ISNULL(MM.S_Module_Code,'') AS S_Module_Code
			,ISNULL(MM.S_Module_Name,'') AS S_Module_Name
	FROM	dbo.T_Module_Master MM
			INNER JOIN dbo.T_Module_Term_Map MTM
			ON MTM.I_Module_ID = MM.I_Module_ID
			INNER JOIN dbo.T_Term_Course_Map TCM
			ON TCM.I_Term_ID = MTM.I_Term_ID
			WHERE	TCM.I_Course_ID = @iCourseId
	
END

-- =============================================
-- Author:		Soumya Sikder	
-- Create date: 12/03/2007
-- Description:	Gets all course list master details defined in the system
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCourseList] 

AS
BEGIN

	SET NOCOUNT OFF;

	SELECT I_CourseList_ID,
		   S_CourseList_Name, 
		   I_Brand_ID,
		   I_Status, 
		   S_Crtd_By, 
		   S_Upd_By, 
		   Dt_Crtd_On, 
		   Dt_Upd_On
	FROM  dbo.T_CourseList_Master
	WHERE I_Status=1
	ORDER BY S_CourseList_Name	
	
END

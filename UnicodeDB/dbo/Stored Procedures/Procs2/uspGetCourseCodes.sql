-- =============================================
-- Author:		Debarshi Basu	
-- Create date: 11/03/2007
-- Description:	Gets all course codes defined in the system
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCourseCodes] 

AS
BEGIN

	SET NOCOUNT OFF;

	Select	I_Course_ID,
			I_CourseFamily_ID,
			I_Brand_ID,
			S_Course_Code,
			S_Course_Name,
			S_Course_Desc 
	From dbo.T_Course_Master 
	Where I_Status = 1	
	
END

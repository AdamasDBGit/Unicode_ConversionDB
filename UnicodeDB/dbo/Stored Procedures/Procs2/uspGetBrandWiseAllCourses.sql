-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 July 12>
-- Description:	<Get All Course Master Brand Or CourseFamily Wise>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBrandWiseAllCourses] 
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@iCourseFamilyID INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
	   BM.I_Brand_ID BrandID,	
	   CFM.I_CourseFamily_ID  CourseFamilyID,
	   CM.I_Course_ID CourseID,
	   CM.S_Course_Code CourseCode,
	   CM.S_Course_Name CourseName
	   from 
	   T_CourseFamily_Master as CFM
	   inner join
	   T_Course_Master as CM on CFM.I_CourseFamily_ID=CM.I_CourseFamily_ID and CM.I_Status=1
	   inner join
	   T_Brand_Master as BM on BM.I_Brand_ID=CFM.I_Brand_ID and BM.I_Brand_ID=CM.I_Brand_ID and BM.I_Status=1
	   where CFM.I_Status=1
	   AND CFM.I_CourseFamily_ID = ISNULL(@iCourseFamilyID,CFM.I_CourseFamily_ID)
	   AND BM.I_Brand_ID= @iBrandID
   


END

-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 July 12>
-- Description:	<Get Course Family Master>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBrandWiseCourseFamily] 
	-- Add the parameters for the stored procedure here
	@iBrandID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 SELECT  
	 A.I_CourseFamily_ID CourseFamilyID,   
   A.I_Brand_ID BrandID,      
   A.S_CourseFamily_Name CourseFamilyName
 FROM dbo.T_CourseFamily_Master A
 inner join
 dbo.T_Brand_Master B  on B.I_Brand_ID=A.I_Brand_ID
 WHERE A.I_Status = 1  AND B.I_Status=1
 AND A.I_Brand_ID = ISNULL(@iBrandID,B.I_Brand_ID)
 ORDER BY A.S_CourseFamily_Name

END

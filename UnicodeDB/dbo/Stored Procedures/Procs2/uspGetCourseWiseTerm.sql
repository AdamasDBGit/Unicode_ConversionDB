-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 July 13>
-- Description:	<Get Course Wise Term List>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCourseWiseTerm] 
	-- Add the parameters for the stored procedure here
	@iBrandID INT,
	@iCourseID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select CM2.I_Course_ID CourseID,
   TM.I_Term_ID TermID,
   TM.S_Term_Code TermCode,
   TM.S_Term_Name TermName from 
   T_CourseFamily_Master as CM 
   inner join
   T_Course_Master as CM2 on CM2.I_CourseFamily_ID=CM.I_CourseFamily_ID
   inner join
   T_Term_Course_Map as TCM on CM2.I_Course_ID=TCM.I_Course_ID
   inner join
   T_Term_Master as TM on TM.I_Term_ID=TCM.I_Term_ID
   where 
   CM.I_Status=1 and CM2.I_Status=1 and TCM.I_Status=1 and TM.I_Status=1
   and CM2.I_Course_ID = ISNULL(@iCourseID,CM2.I_Course_ID) 
   and CM.I_Brand_ID= ISNULL(@iBrandID,CM.I_Brand_ID)


END

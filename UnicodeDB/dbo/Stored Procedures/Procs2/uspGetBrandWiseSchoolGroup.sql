-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 July 12>
-- Description:	<Get School Group Master : Brand Wise>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBrandWiseSchoolGroup]
	-- Add the parameters for the stored procedure here
	(
	@iBrandID INT 
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   select 
   I_Brand_Id BrandID,
   I_School_Group_ID GroupID,
   S_School_Group_Code SchoolGroupCode,
   S_School_Group_Name SchoolGroupName
   from T_School_Group
   where I_Brand_Id=@iBrandID AND I_Status=1


END

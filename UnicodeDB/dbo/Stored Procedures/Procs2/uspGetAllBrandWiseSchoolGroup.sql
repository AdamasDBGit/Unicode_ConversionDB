-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 July 12>
-- Description:	<Get Brand Wise School Group >
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllBrandWiseSchoolGroup] 
	-- Add the parameters for the stored procedure here
	(
	@iBrandID INT=NULL
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select 
	SG.I_School_Group_ID SchoolGroupId,
	SG.S_School_Group_Code SchoolGroupCode,
	SG.S_School_Group_Name SchoolGroupName,
	SG.I_Brand_Id BrandId
	 from T_School_Group as SG 
	 where SG.I_Brand_Id = ISNULL(@iBrandID,SG.I_Brand_Id)
	 and SG.I_Brand_Id=1


	
END

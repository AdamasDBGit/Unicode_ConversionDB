-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023 May 22>
-- Description:	<Fetch Calender_Title_Category>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCalenderTitleCategory] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
	CalenderTitleCategoryID as CalenderTitleCategoryID,
	CalenderTitleCategoryDesc as CalenderTitleCategoryDesc
	from 
	Calender_Title_Category where I_Status=1
    
END


-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Feb-27>
-- Description:	<Update PlanSequence  >
-- =============================================
CREATE PROCEDURE [ECOMMERCE].[uspUpdatePlanIDListsSequence]
	-- Add the parameters for the stored procedure here
	@PlanIDLists VARCHAR(MAX),
	@BrandID INT
AS
BEGIN

	CREATE TABLE #PlanID
	(
	PlanID int,
	IndexNo int IDENTITY(1,1)
	)

	insert into #PlanID
	select CAST(FSR.Val as INT) as PlanID from fnString2Rows(@PlanIDLists,',') AS FSR

	select * from #PlanID

   
END

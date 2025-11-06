-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <29th August 2023>
-- Description:	<to get the event catagory>
-- =============================================
CREATE PROCEDURE [Academic].[uspGetEventsCatagory]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
    TEC.[I_Event_Category_ID] as CatagoryID,
    TEC.[S_Event_Category] as Catagory
FROM
    [dbo].[T_Event_Category] as TEC
WHERE
    TEC.[I_Status] = 1;


END

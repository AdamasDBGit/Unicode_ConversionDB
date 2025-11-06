-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <31st aug 2023>
-- Description:	<to >
-- =============================================
CREATE PROCEDURE [Academic].[uspDeleteEvent] 
	-- Add the parameters for the stored procedure here
	@iEventID int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	 Delete from T_Event where I_Event_ID = @iEventID;

	 select 1 statusFlag,'Event deleted succesfully.' message 
END

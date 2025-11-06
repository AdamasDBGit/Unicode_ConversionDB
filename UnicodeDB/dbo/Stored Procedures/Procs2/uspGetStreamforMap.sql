-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <20th sept 2023>
-- Description:	<to get section>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetStreamforMap]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	    select TS.I_Stream_ID as StreamID,
  TS.S_Stream as StreamName from [dbo].[T_Stream] as TS
END

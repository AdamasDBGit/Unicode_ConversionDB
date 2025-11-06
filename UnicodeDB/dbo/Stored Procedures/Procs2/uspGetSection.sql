-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <20th sept 2023>
-- Description:	<to get section>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSection]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	    select TS.I_Section_ID as SectionID,
  TS.S_Section_Name as SectionName from [dbo].[T_Section] as TS
END

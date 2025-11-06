
-- =============================================
-- Author:		<Swadesh Bhattacharya>
-- Create date: <08-10-2023>
-- Description:	<Get All Stream Name>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllStream] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [I_Stream_ID] StreamId
      ,[S_Stream] StreamName
      ,[I_Status]
  FROM [dbo].[T_Stream]
  WHERE [I_Status]=1
END

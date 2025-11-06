
-- =============================================
-- Author:		<Swadesh Bhattacharya>
-- Create date: <08-10-2023>
-- Description:	<Get All Stream Name>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllSection] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  [I_Section_ID] SectionId
      ,[S_Section_Name]  SectionName
  FROM [dbo].[T_Section]
END

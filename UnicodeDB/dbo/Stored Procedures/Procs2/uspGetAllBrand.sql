
-- =============================================
-- Author:		<Swadesh Bhattacharya>
-- Create date: <08-10-2023>
-- Description:	<Get All Brand Name>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetAllBrand] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  [I_Brand_ID] BrandId
      ,[S_Brand_Code]
      ,[S_Brand_Name] BrandName    
      ,[I_Status]
      ,[S_Short_Code]
  FROM [dbo].[T_Brand_Master]
  WHERE [I_Status]=1
END

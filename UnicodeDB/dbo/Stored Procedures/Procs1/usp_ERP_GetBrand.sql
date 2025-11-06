-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <22-09-2023>
-- Description:	<to get brand details>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetBrand] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT I_Brand_ID as BrandId
	,S_Brand_Name as BrandName
	FROM dbo.T_Brand_Master
	WHERE I_Status <> 0
END

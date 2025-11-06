-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetAllCitiesByState]
(
	@iStateID int = NULL
)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	I_City_ID,
	S_City_Code,
	S_City_Name
	FROM T_City_Master
	WHERE (I_State_ID = @iStateID OR @iStateID IS NULL)
END

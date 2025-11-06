CREATE PROCEDURE [dbo].[uspGetActivity] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    -- Insert statements for procedure here
	SELECT	I_Activity_ID,S_Activity_Name,I_Brand_ID
	FROM dbo.T_Activity_Master 
	WHERE I_Status <> 0
	
END

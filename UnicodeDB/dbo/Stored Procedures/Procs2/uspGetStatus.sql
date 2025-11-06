CREATE PROCEDURE [dbo].[uspGetStatus]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * FROM DBO.T_STATUS_MASTER

END

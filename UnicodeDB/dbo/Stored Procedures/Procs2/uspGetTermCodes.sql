-- =============================================
-- Author:		Debarshi Basu
-- Create date: 12/03/2007
-- Description:	It gets term codes from Term Master Table
-- =============================================
CREATE PROCEDURE [dbo].[uspGetTermCodes]  
	
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;

    -- Insert statements for procedure here
	
	SELECT I_Term_ID,S_Term_Name,S_Term_Code FROM dbo.T_Term_Master WHERE I_Status=1
END

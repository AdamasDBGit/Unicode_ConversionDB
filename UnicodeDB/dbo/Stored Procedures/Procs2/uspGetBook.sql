-- =============================================
-- Author:		<Rajesh>
-- Create date: <11-01-2007>
-- Description:	<To get all books from BookMaster>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetBook] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF

    -- Insert statements for procedure here
	SELECT	A.I_Book_ID,
			A.S_Book_Name,
			A.S_Book_Code,
			A.I_Brand_ID,
			A.I_Status,
			A.S_Book_Desc,
			B.S_Brand_Code,
			B.S_Brand_Name 
	FROM dbo.T_Book_Master A, dbo.T_Brand_Master B 
	WHERE A.I_Status <> 0
	AND B.I_Brand_ID = A.I_Brand_ID
END

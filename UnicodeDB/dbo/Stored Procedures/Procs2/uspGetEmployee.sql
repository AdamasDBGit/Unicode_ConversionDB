-- =============================================
-- Author:		<ANIRBAN PAHARI>
-- Create date: <08/03/2007>
-- Description:	<TO GET ALL Employee  uspGetEmployee>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetEmployee] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT I_Employee_ID,S_First_Name,S_Middle_Name,S_Last_Name
			 FROM T_Employee_Dtls
END

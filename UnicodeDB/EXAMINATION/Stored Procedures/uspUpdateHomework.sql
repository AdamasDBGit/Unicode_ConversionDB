-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspUpdateHomework]
	-- Add the parameters for the stored procedure here
	
	@I_Batch_ID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

      Update EXAMINATION.T_Homework_Master set I_Status=0
	   where I_Batch_ID=@I_Batch_ID

END

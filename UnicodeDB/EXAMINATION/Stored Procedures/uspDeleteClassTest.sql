
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [EXAMINATION].[uspDeleteClassTest]
	(
	@iClassTestID INT, 
	@sUpdatedBy VARCHAR(50)= NULL,
	@dUpdatedOn datetime = NULL,
	@iStatus INT
	
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	UPDATE EXAMINATION.T_ClassTest_Master SET I_Status=@iStatus,S_Updt_On=@sUpdatedBy,Dt_Updt_On=@dUpdatedOn WHERE I_ClassTest_ID=@iClassTestID
	END

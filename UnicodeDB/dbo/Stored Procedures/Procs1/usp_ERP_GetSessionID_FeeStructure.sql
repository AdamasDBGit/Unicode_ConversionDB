-- =============================================
-- Author:		<Parichoy Nandi>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_GetSessionID_FeeStructure]
	@iBrandID int,
	@iFeeStructure int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select FEAP.I_School_Session_ID from [T_ERP_Fee_Structure_AcademicSession_Map] FEAP
where FEAP.I_Fee_Structure_ID =@iFeeStructure AND FEAP.I_Brand_ID=@iBrandID AND FEAP.Is_Active=1
END

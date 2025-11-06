-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_DeleteRoutineHeaderAndDetails 13
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_DeleteRoutineHeaderAndDetails] 
(
	@RoutineStructureHeaderID INT = NULL
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DELETE FROM T_ERP_Routine_Structure_Header WHERE T_ERP_Routine_Structure_Header.I_Routine_Structure_Header_ID = @RoutineStructureHeaderID;
	DELETE FROM T_ERP_Routine_Structure_Detail WHERE T_ERP_Routine_Structure_Detail.I_Routine_Structure_Header_ID = @RoutineStructureHeaderID;
	select 1 StatusFlag,'Routine deleted successfully' Message;
END

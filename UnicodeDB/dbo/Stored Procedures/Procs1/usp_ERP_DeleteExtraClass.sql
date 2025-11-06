-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec usp_ERP_DeleteExtraClass null
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_DeleteExtraClass]
(
	@ClassRoutineExtraClassID int
)
AS
begin transaction
BEGIN TRY 
	SET NOCOUNT ON;
		UPDATE T_ERP_Student_Class_Routine_ExtraClass 
		SET				
			Is_Active = 0
		WHERE I_ClassRoutine_ExtraClass_ID = @ClassRoutineExtraClassID

		IF @@ROWCOUNT > 0
		BEGIN
			SELECT 1 StatusFlag,'Extra class deleted successfully' Message						
		END
		ELSE
		BEGIN
			SELECT 0 StatusFlag,'Failed to delete this extra class' Message	
		END
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
	--RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_ERP_InsertTeacherUnavailability]
(
	@FacultyMasterID INT = NULL,
    @DtFrom DATETIME = NULL,
    @DtTo DATETIME = NULL,
    @RequestReason NVARCHAR(MAX) = NULL,
	@CreatedBy INT = NULL,
	@Status INT = NULL
)
AS
begin transaction
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		BEGIN
		-- Insert statements for procedure here
		INSERT INTO [dbo].[T_ERP_Teacher_Unavailability_Header] 
		(
			I_Faculty_Master_ID,
			Dt_From,
			Dt_To,
			Dt_CreatedAt,
			S_Reason,
			I_CreatedBy,
			I_Status
		)
		VALUES 
		(
			@FacultyMasterID, 
			@DtFrom,
			@DtTo,
			GETDATE(),
			@RequestReason,
			@CreatedBy,
			@Status
		);
		select 1 StatusFlag,'Unavailability request added succesfully' Message;
	END
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
	select 0 StatusFlag,@ErrMsg Message
END CATCH
commit transaction
END

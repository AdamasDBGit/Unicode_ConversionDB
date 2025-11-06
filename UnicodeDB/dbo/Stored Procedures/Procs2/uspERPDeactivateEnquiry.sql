-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspERPDeactivateEnquiry]
	-- Add the parameters for the stored procedure here
	(
		@I_Enquiry_Regn_ID int = NULL,
		@Status int = NULL
	)
AS
begin transaction
BEGIN TRY 
UPDATE [T_Enquiry_Regn_Detail] set I_Is_Active = @Status where I_Enquiry_Regn_ID = @I_Enquiry_Regn_ID

SELECT 1 StatusFlag,'Status Updated succesfully' Message

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

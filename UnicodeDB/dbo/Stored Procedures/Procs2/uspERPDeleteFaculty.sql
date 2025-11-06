/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspERPDeleteFaculty] 
(
	@iFacultyMasterID int 
)
AS
begin transaction
BEGIN TRY 
UPDATE T_Faculty_Master set I_Status = 0 where I_Faculty_Master_ID = @iFacultyMasterID

SELECT 1 StatusFlag,'Faculty deleted succesfully' Message

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

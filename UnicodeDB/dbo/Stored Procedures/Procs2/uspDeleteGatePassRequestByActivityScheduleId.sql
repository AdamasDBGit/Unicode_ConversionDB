/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/
--exec [dbo].[uspInsertMultipleGatePassRequest] 2314,'Pick','test','19-0462,20-0462','2023-06-17','2023-06-20','13:05:20'


CREATE PROCEDURE [dbo].[uspDeleteGatePassRequestByActivityScheduleId] 
(
	@iScheduleActivityID int = null
	--@dtRequestTime datetime=null
	
)
AS
begin transaction
BEGIN TRY 

DELETE FROM T_Gate_Pass_Request where I_ScheduleActivityID = @iScheduleActivityID

select 1 StatusFlag,'Gate pass request deleted succesfully' Message

END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction

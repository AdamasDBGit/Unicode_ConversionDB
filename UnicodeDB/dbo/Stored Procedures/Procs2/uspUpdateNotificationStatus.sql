/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspUpdateNotificationStatus] 
(
	@Recepients UT_Recipient readonly
)
AS
begin transaction
BEGIN TRY 
UPDATE T_NotificationRecipient
set I_Sent =1 
from @Recepients r
where T_NotificationRecipient.I_NotificationRecepient_ID = r.Recipient

select 1 StatusFlag,'Notification update saved succesfully' Message
--if(@sClasses!=null)
--BEGIN
---- save for students for classes
--while len(@sClasses) > 0
----(left(@sStudents, charindex(',', @sStudents+',')-1)
--set @sTeachers = stuff(@sClasses, 1, charindex(',', @sClasses+','), '')
--end
--END

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

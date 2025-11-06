
/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspInsertUpdateNotificationSchedule_BeforeAddschoolGroup] 
(
	@iNotificationTemplateID int = null,
	@iType int = null,
	@sBody nvarchar(MAX),
	@iAllStudents bit,
	@iAllTeachers bit,
	@iGroupType int = null,
	@sBatches nvarchar(MAX)=null,
	@sStudents nvarchar(MAX)=null,
	@sTeachers nvarchar(MAX)=null,
	@sClasses  nvarchar(MAX)=null,
	@ScheduleDateTime datetime = null
   ,@SCreatedBy nvarchar(50) = null
   ,@sTitle nvarchar(50) = null
)
AS
begin transaction
BEGIN TRY 


INSERT INTO T_NotificationSchedule
(
 S_MessageBody
,I_NotificationGroupType_ID
,Dt_ScheduleDateTime
,Dt_CreatedAt
,S_CreatedBy
,S_Title
,I_NotificationTemplate_ID
)
VALUES
(
 @sBody
,@iGroupType
,@ScheduleDateTime
,GETDATE()
,@SCreatedBy
,@sTitle
,@iNotificationTemplateID
)
DECLARE @iLastNotificationScheduleID int;
SET @iLastNotificationScheduleID = SCOPE_IDENTITY();
--if(@iAllStudents=1)
--BEGIN
----save for all active students

--END
--if(@iAllTeachers=1)	
--BEGIN
---- save for all active teachers
--END
--if(@sBatches!=null)
--BEGIN
---- save students for batches
--END
if(@sStudents is not null)
BEGIN
while len(@sStudents) > 0
BEGIN
INSERT INTO T_NotificationRecipient
(
 I_NotificationSchedule_ID
,I_Recepient_ID
,I_Type
,S_CreatedBy
,Dt_CreatedOn
,S_MobileNumber
,S_FireBase_Token
,S_Email
)
--VALUES
--(
--@iLastNotificationScheduleID
--,left(@sStudents, charindex(',', @sStudents+',')-1)
--,1
--,@SCreatedBy
--,GETDATE()
--)
select 
@iLastNotificationScheduleID
,t2.I_Student_Detail_ID
,1
,@SCreatedBy
,GETDATE()
,t1.S_Mobile_No
,t1.S_Firebase_Token
,t1.S_Guardian_Email 
from T_Parent_Master t1 right join T_Student_Detail t2
on t2.S_Guardian_Mobile_No = t1.S_Mobile_No 
where t2.I_Student_Detail_ID = left(@sStudents, charindex(',', @sStudents+',')-1) 
and t1.I_IsPrimary = 1
SET @sStudents = stuff(@sStudents, 1, charindex(',', @sStudents+','), '')
END
END
if(@sTeachers is not null)
BEGIN
-- save for teachers
while len(@sTeachers) > 0
BEGIN
INSERT INTO T_NotificationRecipient
(
 I_NotificationSchedule_ID
,I_Recepient_ID
,I_Type
,S_CreatedBy
,Dt_CreatedOn
)
VALUES
(
@iLastNotificationScheduleID
,left(@sTeachers, charindex(',', @sTeachers+',')-1)
,2
,@SCreatedBy
,GETDATE()
)
SET @sTeachers = stuff(@sTeachers, 1, charindex(',', @sTeachers+','), '')
END
END
select 
NR.I_NotificationRecepient_ID NotificationRecepientID 
,NR.S_MobileNumber MobileNo
,NR.S_FireBase_Token FirebaseToken
,NR.S_Email GuardianEmail
 from T_NotificationRecipient NR
where NR.I_NotificationSchedule_ID = @iLastNotificationScheduleID
--select 1 StatusFlag,'Notification saved succesfully' Message,@iLastNotificationScheduleID LastNotificationId
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

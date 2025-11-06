/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspInsertUpdateDeleteGatePassRequest] 
(
	@sGuardianName int = null,
	@sRequestType nvarchar(200)=null,
	@sRequestReason nvarchar(200)=null,
	@sStudents nvarchar(200)=null  ,
	@dtRequestDate datetime=null ,
	@iGatePassRequestID int =null,
	@iStatus int = null,
	@iOperation int = null ,--1=insert,2=update,3=delete
	@sCancelReason nvarchar(MAX) = null
	
)
AS
begin transaction
BEGIN TRY 
if(@iOperation = 1)
BEGIN
while len(@sStudents) > 0
begin
  --print left(@S, charindex(',', @S+',')-1)
  select left(@sStudents, charindex(',', @sStudents+',')-1)
  INSERT INTO T_Gate_Pass_Request 
(S_Student_ID
,I_Parent_Master_ID
,S_Request_Type
,S_Request_Reason
,S_CreatedBy
,Dt_CreatedOn
,Dt_Request_Date
)
VALUES
(left(@sStudents, charindex(',', @sStudents+',')-1)
,@sGuardianName
,@sRequestType
,@sRequestReason
,@sGuardianName
,GETDATE()
,@dtRequestDate
)
 set @sStudents = stuff(@sStudents, 1, charindex(',', @sStudents+','), '')
  --select @S
end

select 1 StatusFlag,'Gate pass request created succesfully' Message
END
if(@iOperation = 2)
BEGIN
update T_Gate_Pass_Request
SET
I_Parent_Master_ID = @sGuardianName,
S_Request_Type = @sRequestType,
S_Request_Reason = @sRequestReason,
Dt_Request_Date = @dtRequestDate
where I_Gate_Pass_Request_ID = @iGatePassRequestID
select 1 StatusFlag,'Gate pass request updated succesfully' Message
END
if(@iOperation = 3)
BEGIN
update T_Gate_Pass_Request
set 
I_Status = 3,
S_CancelReason = @sCancelReason,
Dt_CanceledOn = GETDATE()
where I_Gate_Pass_Request_ID = @iGatePassRequestID 
select 1 StatusFlag,'Gate pass deleted succesfully' Message
END
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction

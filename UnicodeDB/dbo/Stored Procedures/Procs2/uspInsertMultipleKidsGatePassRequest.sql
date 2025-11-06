/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/
--exec [dbo].[uspInsertMultipleGatePassRequest] 2314,'Pick','test','19-0462,20-0462','2023-06-17','2023-06-20','13:05:20'


CREATE PROCEDURE [dbo].[uspInsertMultipleKidsGatePassRequest] 
(
	@sGuardianName int,
	@sRequestType nvarchar(200)=null,
	@sRequestReason nvarchar(200)=null,
	@Students UT_GatePassMultipleStudents readonly  ,
	@dtRequestStartDate datetime=null ,
	@dtRequestEndDate datetime=null,
	@iScheduleActivityID int = null
	--@dtRequestTime datetime=null
	
)
AS
begin transaction
BEGIN TRY 
DECLARE @delete int
SET @delete = case when @sRequestType ='Pickup & Drop Off' then 0
			       when @sRequestType ='Drop Off' then 0
				   else 1
				   end
DELETE FROM T_Gate_Pass_Request where I_ScheduleActivityID = @iScheduleActivityID
IF(@delete=0)
BEGIN
WHILE (@dtRequestStartDate <= @dtRequestEndDate)

BEGIN

  INSERT INTO T_Gate_Pass_Request 
(S_Student_ID
,I_Parent_Master_ID
,S_Request_Type
,S_Request_Reason
,S_CreatedBy
,Dt_CreatedOn
,Dt_Request_Date
,I_IsScheduleActivity
,I_ScheduleActivityID
)
--VALUES
--(left(@sStudents, charindex(',', @sStudents+',')-1)
--,@sGuardianName
--,@sRequestType
--,@sRequestReason
--,@sGuardianName
--,GETDATE()
--,CAST(@dtRequestStartDate AS DATETIME) + CAST(@dtRequestTime AS DATETIME)
--,1
--)
select 
 StudentID 
,@sGuardianName
,@sRequestType
,@sRequestReason
,@sGuardianName
,GETDATE()
,CAST(@dtRequestStartDate AS DATETIME) + CAST(Time AS DATETIME)
,1
,@iScheduleActivityID
from @Students

set @dtRequestStartDate = DATEADD(day, 1, @dtRequestStartDate);
END;
select 1 StatusFlag,'Gate pass request created succesfully' Message
END
ELSE
BEGIN
select 1 StatusFlag,'Gate pass request deleted succesfully' Message
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

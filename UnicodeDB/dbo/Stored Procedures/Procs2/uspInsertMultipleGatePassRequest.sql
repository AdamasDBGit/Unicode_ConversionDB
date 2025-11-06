/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/
--exec [dbo].[uspInsertMultipleGatePassRequest] 2314,'Pick','test','19-0462,20-0462','2023-06-17','2023-06-20','13:05:20'


CREATE PROCEDURE [dbo].[uspInsertMultipleGatePassRequest] 
(
	@sGuardianName int,
	@sRequestType nvarchar(200)=null,
	@sRequestReason nvarchar(200)=null,
	@sStudents nvarchar(200)=null  ,
	@dtRequestStartDate datetime=null ,
	@dtRequestEndDate datetime=null,
	@dtRequestTime datetime=null
	
)
AS
begin transaction
BEGIN TRY 
WHILE (@dtRequestStartDate <= @dtRequestEndDate)

BEGIN
DECLARE @students nvarchar(60)
SET @students = @sStudents
while len(@students) > 0

begin
  INSERT INTO T_Gate_Pass_Request 
(S_Student_ID
,I_Parent_Master_ID
,S_Request_Type
,S_Request_Reason
,S_CreatedBy
,Dt_CreatedOn
,Dt_Request_Date
,I_IsScheduleActivity
)
VALUES
(left(@sStudents, charindex(',', @sStudents+',')-1)
,@sGuardianName
,@sRequestType
,@sRequestReason
,@sGuardianName
,GETDATE()
,CAST(@dtRequestStartDate AS DATETIME) + CAST(@dtRequestTime AS DATETIME)
,1
)
set @students = stuff(@students, 1, charindex(',', @students+','), '')
end
set @dtRequestStartDate = DATEADD(day, 1, @dtRequestStartDate);
END;
select 1 StatusFlag,'Gate pass request created succesfully' Message
END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction

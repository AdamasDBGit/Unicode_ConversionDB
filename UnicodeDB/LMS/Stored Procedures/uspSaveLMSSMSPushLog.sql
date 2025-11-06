
-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023-Feb-02>
-- Description:	<Use for Populate SMS-LMS Push Log>
-- =============================================
CREATE PROCEDURE [LMS].[uspSaveLMSSMSPushLog]
    @ExecutedService VARCHAR(MAX),
	@PushJson VARCHAR(MAX),
	@PushResult VARCHAR(MAX),
	@Remarks VARCHAR(MAX)=NULL,
	@IssueStudentID VARCHAR(MAX)=NULL

AS
BEGIN
--start of DefaulterStudentStatusService
	DECLARE @rownumber INT
	select @rownumber=count(*) from LMS.LMS_Push_Log where ExecutedService='DefaulterStudentStatusService'

		if (@rownumber >= 20)
		begin
		delete from LMS.LMS_Push_Log where 
		LMSPushID in (
		select TOP (@rownumber-20) LMSPushID from LMS.LMS_Push_Log where ExecutedService='DefaulterStudentStatusService' order by LMSPushID 
		)
		end

	insert into LMS.LMS_Push_Log
	select @ExecutedService,@PushJson,@PushResult,@Remarks,GETDATE(),@IssueStudentID

-- End of DefaulterStudentStatusService 
END

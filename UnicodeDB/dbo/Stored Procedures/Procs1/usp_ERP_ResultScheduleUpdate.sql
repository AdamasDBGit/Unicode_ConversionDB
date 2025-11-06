CREATE PROCEDURE [dbo].[usp_ERP_ResultScheduleUpdate] 
	-- Add the parameters for the stored procedure here
	@ID int ,
	@Status int
AS
BEGIN
	Update T_Result_Exam_Schedule set I_Result_Publish_Status = @Status where I_Result_Exam_Schedule_ID = 1
	if(@Status=0)
	BEGIN
	select 1 StatusFlag,'Result unpublished' Message
	END
	ELSE
	BEGIN
	select 1 StatusFlag,'Result published' Message
	END
END

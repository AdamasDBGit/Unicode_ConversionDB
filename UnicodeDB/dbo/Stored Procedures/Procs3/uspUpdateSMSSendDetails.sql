CREATE PROCEDURE [dbo].[uspUpdateSMSSendDetails](@SMSDetailsID INT, @IsCompleted INT, @ConfigNoofAttempts INT, @ResponseText Nnvarchar(max))
AS
BEGIN

	DECLARE @NoofAttempts INT
	DECLARE @Status INT=1
	DECLARE @SendDate DATETIME=NULL

	select @NoofAttempts=I_NO_OF_ATTEMPT from T_SMS_SEND_DETAILS where I_SMS_SEND_DETAILS_ID=@SMSDetailsID and I_Status=1

	if((@NoofAttempts+1)>=@ConfigNoofAttempts)
		set @Status=0

	if(@IsCompleted=1)
	BEGIN

		set @Status=0
		set @SendDate=GETDATE()

	END

	update T_SMS_SEND_DETAILS 
	set 
	I_IS_SUCCESS=@IsCompleted,
	I_NO_OF_ATTEMPT=@NoofAttempts+1,
	S_RETURN_CODE_FROM_PROVIDER=@ResponseText,
	Dt_SMS_SEND_ON=@SendDate,
	S_Upd_By='rice-group-admin',
	Dt_Upd_On=GETDATE(),
	I_Status=@Status
	where
	I_SMS_SEND_DETAILS_ID=@SMSDetailsID and I_Status=1
	


END


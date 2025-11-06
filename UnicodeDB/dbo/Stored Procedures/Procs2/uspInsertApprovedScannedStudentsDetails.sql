-- =============================================
-- Author:		<Susmita Paul>
-- Create date: <2023July02>
-- Description:	<Insert the Approved and Scanned Student Details >
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertApprovedScannedStudentsDetails] 
	@sTokenID nvarchar(max),
	@iGatePassRequestID INT
AS
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrMessage NVARCHAR(4000)

	DECLARE @GaurdID INT=NULL,@ScanID INT=0,@BufferTime INT = 60

	

		IF EXISTS (select I_gate_Pass_Guard_ID from T_Gate_Pass_Guard where S_Token=@sTokenID)
	
			BEGIN
				IF EXISTS (
				select * from [dbo].[T_Gate_Pass_Request] as TGPR where  TGPR.I_Gate_Pass_Request_ID=@iGatePassRequestID
				)
					BEGIN

					---- Check For Completed Requested
						if EXISTS(select *
								from 
								[dbo].[T_Gate_Pass_Request] as TGPR 
								inner join
								dbo.[T_Gate_Pass_Scanned_Details] as GPSD on GPSD.I_Gate_Pass_Request_ID=TGPR.I_Gate_Pass_Request_ID
								inner join
								dbo.T_Gate_Pass_Guard as GPG on GPSD.I_Gate_Pass_Guard_ID=GPG.I_Gate_Pass_Guard_ID
								where TGPR.I_Gate_Pass_Request_ID=@iGatePassRequestID and TGPR.I_Is_Completed=1
						)

						BEGIN

							SELECT @ErrMessage='Student Scanned Already Completed '

							RAISERROR(@ErrMessage,11,1)

						END
						---- Check For Completed Requested

						---- Check For Expired Requested

						ELSE IF EXISTS
						(
						select *
								from 
								[dbo].[T_Gate_Pass_Request] as TGPR 
								left join
								(
								select GPSD.I_Gate_Pass_Scanned_ID,GPSD.I_Gate_Pass_Guard_ID,GPSD.I_Gate_Pass_Request_ID 
								from dbo.[T_Gate_Pass_Scanned_Details] as GPSD
								inner join
								dbo.T_Gate_Pass_Guard as GPG on GPSD.I_Gate_Pass_Guard_ID=GPG.I_Gate_Pass_Guard_ID
								) as GP on GP.I_Gate_Pass_Request_ID=TGPR.I_Gate_Pass_Request_ID
								where GP.I_Gate_Pass_Scanned_ID IS NULL --AND CONVERT(DATE,TGPR.Dt_Request_Date) < CONVERT(DATE,GETDATE())
								AND TGPR.Dt_Request_Date < (select DATEADD(MINUTE,-@BufferTime,GETDATE()))
								AND TGPR.I_Gate_Pass_Request_ID=@iGatePassRequestID
			
						)
	
						BEGIN

							SELECT @ErrMessage='Student PickUp Request Date is Already Over'

							RAISERROR(@ErrMessage,11,1)

						END
						---- Check For Expired Requested
						---- Check For Future Requested
						ELSE IF EXISTS
						(
						select *
								from 
								[dbo].[T_Gate_Pass_Request] as TGPR 
								left join
								(
								select GPSD.I_Gate_Pass_Scanned_ID,GPSD.I_Gate_Pass_Guard_ID,GPSD.I_Gate_Pass_Request_ID 
								from dbo.[T_Gate_Pass_Scanned_Details] as GPSD
								inner join
								dbo.T_Gate_Pass_Guard as GPG on GPSD.I_Gate_Pass_Guard_ID=GPG.I_Gate_Pass_Guard_ID
								) as GP on GP.I_Gate_Pass_Request_ID=TGPR.I_Gate_Pass_Request_ID
								where GP.I_Gate_Pass_Scanned_ID IS NULL --AND CONVERT(DATE,TGPR.Dt_Request_Date) > CONVERT(DATE,GETDATE())
								AND (select DATEADD(MINUTE,@BufferTime,GETDATE())) < TGPR.Dt_Request_Date
								and TGPR.I_Gate_Pass_Request_ID=@iGatePassRequestID
						)
		
						BEGIN

							SELECT @ErrMessage='Student PickUp Request Time is Not Come Yet'

							RAISERROR(@ErrMessage,11,1)

						END
						---- Check For Future Requested
						---- Check For Current Requested
						ELSE IF EXISTS
						(
						select *
								from 
								[dbo].[T_Gate_Pass_Request] as TGPR 
								left join
								(
								select GPSD.I_Gate_Pass_Scanned_ID,GPSD.I_Gate_Pass_Guard_ID,GPSD.I_Gate_Pass_Request_ID 
								from dbo.[T_Gate_Pass_Scanned_Details] as GPSD
								inner join
								dbo.T_Gate_Pass_Guard as GPG on GPSD.I_Gate_Pass_Guard_ID=GPG.I_Gate_Pass_Guard_ID
								) as GP on GP.I_Gate_Pass_Request_ID=TGPR.I_Gate_Pass_Request_ID
								where GP.I_Gate_Pass_Scanned_ID IS NULL --AND CONVERT(DATE,TGPR.Dt_Request_Date) = CONVERT(DATE,GETDATE())
								AND TGPR.Dt_Request_Date BETWEEN (select DATEADD(MINUTE,-@BufferTime,GETDATE())) AND (select DATEADD(MINUTE,@BufferTime,GETDATE()))
								and TGPR.I_Gate_Pass_Request_ID=@iGatePassRequestID
						)
		
						BEGIN

							select @GaurdID=I_gate_Pass_Guard_ID from T_Gate_Pass_Guard where S_Token=@sTokenID

							insert into T_Gate_Pass_Scanned_Details
							(
							I_Gate_Pass_Guard_ID,
							I_Gate_Pass_Request_ID,
							S_CreatedBy,
							Dt_CreatedOn
							)
							values
							(
							@GaurdID,
							@iGatePassRequestID,
							@GaurdID,
							GETDATE()
							)

							set @ScanID=SCOPE_IDENTITY() 
							
							update T_Gate_Pass_Request set I_Is_Completed=1 where I_Gate_Pass_Request_ID=@iGatePassRequestID

						END

						---- Check For Current Requested

					END

				ELSE
					BEGIN
						SELECT @ErrMessage='Invalid Request'

						RAISERROR(@ErrMessage,11,1)
					END

			END


			ELSE

			BEGIN

					SELECT @ErrMessage='Invalid Guard Token'

					RAISERROR(@ErrMessage,11,1)

			END




	PRINT @ErrMessage

		IF(@ErrMessage IS NULL)
			select @ScanID as StudentScanID
		ELSE
			select 0 StudentScanID

    
END TRY
BEGIN CATCH
	--Error occurred:  
        --ROLLBACK TRANSACTION
        DECLARE @ErrMsg NVARCHAR(4000) ,
            @ErrSeverity INT
        SELECT  @ErrMsg = ERROR_MESSAGE() ,
                @ErrSeverity = ERROR_SEVERITY()

        RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

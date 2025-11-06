CREATE PROCEDURE [dbo].[usp_ERP_Reset_Transaction] 
	-- Add the parameters for the stored procedure here
	@sTransactionNo NVARCHAR(MAX),
	@iuserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;

	BEGIN TRY
        -- Your existing code...
   BEGIN TRANSACTION;	

	

    -- Insert statements for procedure here

	DECLARE @iTransactionMasterID int=null

	select @iTransactionMasterID=I_ERP_Transaction_Master_ID from T_ERP_Transaction_Master 
	where I_ERP_TransactionNo=@sTransactionNo and S_TransactionStatus='Failure'
	
	update T_ERP_Transaction_Master set S_TransactionStatus='Initiated',Dt_UpdatedOn=GETDATE(),I_UpdatedBy=@iuserID
	where I_ERP_TransactionNo=@sTransactionNo and S_TransactionStatus='Failure'



	update ICD set ICD.is_Freezed='true' from 
	T_ERP_Transaction_Master as TM
	inner join
	T_ERP_Transaction_Invoice_Details as TID on TM.I_ERP_Transaction_Master_ID=TID.I_ERP_Transaction_Master_ID
	inner join
	T_Invoice_Child_Detail as ICD on TID.S_Installment_invoice_NO=ICD.S_Invoice_Number 
	and CONVERT(DATE,TID.Dt_Installment_Date)=CONVERT(DATE,ICD.Dt_Installment_Date)
	inner join
	T_Invoice_Child_Header as ICH on ICH.I_Invoice_Child_Header_ID=ICD.I_Invoice_Child_Header_ID
	and ICH.I_Invoice_Header_ID=TID.I_Invoice_Header_ID
	where TM.I_ERP_TransactionNo=@sTransactionNo --and TM.S_TransactionStatus='Failure'



	update TRC set TRC.S_Transaction_No='-1/'+TRC.S_Transaction_No,TRC.I_Transaction_Master_ID=(-1)*TRC.I_Transaction_Master_ID
	from
	T_ERP_Transaction_Requery_Cron_Job  as TRC
	inner join
	T_ERP_Transaction_Master as TM on TM.I_ERP_Transaction_Master_ID=TRC.I_Transaction_Master_ID	
	where TM.I_ERP_TransactionNo=@sTransactionNo --and TM.S_TransactionStatus='Failure'



	exec [dbo].[usp_ERP_SaveTransactionCronJob]
	@sTransactionNo,--@S_Transaction_No varchar(max),
	@iTransactionMasterID,--@I_Transaction_Master_ID INT,
	'Initiated',--@currentStatus varchar(max)=NULL,
	NULL,--@CompleteStatus bit=NULL,
	NULL,--@CronCanBeProcess bit=NULL,
	NULL,--@NoOfAttempt int=NULL,
	'true',--@StatusID bit = NULL,
	NULL,--@Is_PG_Success bit=NULL,
	NULL,--@Is_PG_Failure bit=NULL,
	NULL,--@Is_Failed_User bit =NULL,
	NULL,--@Requery_PG_LogID int=NULL,
	NULL,--@Requery_Request_LogID int=NULL,
	NULL,--@PG_Response varchar(max)=NULL,
	NULL,--@ERP_Response varchar(max)=NULL,
	NULL,--@PG_Remarks varchar(max)=NULL,
	NULL,--@ERP_Remarks varchar(max)=NULL,
	NULL,--@PG_Error varchar(max)=NULL,
	NULL,--@ERP_Error varchar(max)=NULL,
	NULL,--@CanbeProcessForERPSattlement BIT=NULL,
	'false'--@IsFromCron bit


	select 1 StatusFlag,'Trnsaction has been Reset' Message
	

		COMMIT;
	END TRY
    BEGIN CATCH
        -- Handle errors
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

	-- Rollback the transaction
		ROLLBACK;
        -- Raise the error
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH

END


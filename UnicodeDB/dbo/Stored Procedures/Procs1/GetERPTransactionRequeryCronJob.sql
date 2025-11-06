CREATE PROCEDURE [dbo].[GetERPTransactionRequeryCronJob]
AS
BEGIN
    SELECT 
        S_Transaction_No AS TransactionNumber, 
        S_Current_Status AS CurrentStatus, 
        CompleteStatus AS CompletionStatus, 
        CronCanBeProcess AS CronProcessable, 
        PG_NoOfAttempt AS PaymentGatewayAttempts, 
        ERP_NoOfAttempt AS ERPAttempts, 
        StatusID AS StatusIdentifier, 
        Is_PG_Sucess AS PaymentGatewaySuccess, 
        Is_Failed_User AS FailedUser, 
        PG_Response AS PaymentGatewayResponse, 
        S_PG_Remarks AS PaymentGatewayRemarks, 
        S_PG_Error AS PaymentGatewayError 
    FROM T_ERP_Transaction_Requery_Cron_Job;
END;

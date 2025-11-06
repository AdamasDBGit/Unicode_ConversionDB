CREATE PROCEDURE [dbo].[uspUpdateBatchProcessesData]
(
@I_Batch_Process_ID int,
@S_Batch_Process_Name varchar(100)=null,
@S_Batch_Process_Desc varchar(500)=null,
@I_Interval_Days int=null,
@Dt_Last_Run_Date datetime =null,
@S_Last_Run_Status varchar(50) =null
)

AS
BEGIN
SET XACT_ABORT ON
SET NOCOUNT ON
BEGIN TRY
BEGIN TRANSACTION
SET NOCOUNT ON;

UPDATE dbo.T_Batch_Master
SET
S_Batch_Process_Desc = ISNULL(@S_Batch_Process_Desc,S_Batch_Process_Desc),
I_Interval_Days = ISNULL(@I_Interval_Days,I_Interval_Days),
Dt_Last_Run_Date = ISNULL(@Dt_Last_Run_Date,Dt_Last_Run_Date),
S_Last_Run_Status = ISNULL(@S_Last_Run_Status,S_Last_Run_Status)
WHERE I_Batch_Process_ID=@I_Batch_Process_ID

COMMIT TRANSACTION
END TRY
BEGIN CATCH
PRINT ERROR_MESSAGE()
ROLLBACK TRANSACTION
END CATCH

END

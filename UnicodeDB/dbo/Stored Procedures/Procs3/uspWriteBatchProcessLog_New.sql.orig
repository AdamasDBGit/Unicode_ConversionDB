CREATE PROCEDURE [dbo].[uspWriteBatchProcessLog_New]
(
	@I_Process_ID_Max Int,
	@S_Batch_Process_Name Varchar(500),
	@S_Comments Varchar(2000),
	@S_Status Varchar(20),
	@I_Batch_Process_ID Int
)
 
AS

Begin
	Set NoCount On;

	Insert Into dbo.T_Batch_Log
	(I_Process_ID, I_Batch_Process_ID,S_Batch_Process_Name,S_Comments,Dt_Run_Date_Time,S_Status) 
	Select @I_Process_ID_Max, @I_Batch_Process_ID, @S_Batch_Process_Name, @S_Comments, Getdate(), @S_Status
End

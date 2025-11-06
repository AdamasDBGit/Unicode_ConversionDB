CREATE PROCEDURE [dbo].[uspGetBatchMasterList] 
	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT	I_Batch_Process_ID,
			S_Batch_Process_Name,
			S_Batch_Process_Desc,
			I_Interval_Days,
			I_Sequence_Number,
			Dt_Last_Run_Date,
			S_Last_Run_Status
	FROM dbo.T_Batch_Master WITH(NOLOCK)
	WHERE I_Status <> 0
	ORDER BY I_Sequence_Number

END

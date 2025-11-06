CREATE PROCEDURE [dbo].[uspGetTaskList] 
(
	@iTaskMasterId int

)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TTD.*, TTM.I_Type, TTM.S_URL
	FROM T_Task_Details TTD
	INNER JOIN dbo.T_Task_Master TTM
	ON TTM.I_Task_Master_Id = TTD.I_Task_Master_Id
	WHERE TTD.I_Task_Master_Id = @iTaskMasterId
	AND I_Status <> 4 AND I_Status <> 5 -- Not completed and not rejected
	AND DATEDIFF(dd, TTD.Dt_Created_Date, GETDATE()) < 10

	SELECT * FROM T_Task_Mapping
	WHERE I_Task_Details_Id 
		IN 
			(SELECT I_Task_Details_Id FROM T_Task_Details 
			WHERE I_Task_Master_Id = @iTaskMasterId
			AND I_Status <> 4 AND I_Status <> 5 AND DATEDIFF(dd, Dt_Created_Date, GETDATE()) < 10)

END

CREATE PROCEDURE [dbo].[uspGetBatchLogData]

As
Begin

	SELECT 'Batch Process Name' = S_Batch_Process_Name , 'Comments'=S_Comments, 'Date'= cast(Dt_Run_Date_Time as varchar(50))
	FROM dbo.T_Batch_Log 
	Where CAST(SUBSTRING(CAST(Dt_Run_Date_Time AS VARCHAR),1,11) as datetime)
	between 
(select CAST(SUBSTRING(CAST(max(Dt_Run_Date_Time)-2 AS VARCHAR),1,11) as datetime) from T_Batch_Log) 
and (select CAST(SUBSTRING(CAST(max(Dt_Run_Date_Time) AS VARCHAR),1,11) as datetime) from T_Batch_Log)

ORDER BY s_comments	

End

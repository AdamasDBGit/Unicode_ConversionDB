
CREATE VIEW [dbo].[MappingDataView]
AS

SELECT Centre+'_'+Batch as CentreBatch,Centre,Batch,IsExamBatch,IsFocusedBatch,IsMergedBatch 
FROM T_AttendanceDataMapping_Manual
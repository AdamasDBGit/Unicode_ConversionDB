
CREATE VIEW [dbo].[MissingMappingDataView]
AS

select TX.S_Center_Name as Centre,TX.S_Batch_Name as Batch 
from
(
	select T1.S_Center_Name,T1.S_Batch_Name,T2.Batch from
	(
		select TCHND.S_Center_Name+'_'+TSBM.S_Batch_Name as CentreBatch,TCHND.S_Center_Name,TSBM.S_Batch_Name 
		from T_Student_Batch_Master TSBM
		inner join T_Center_Batch_Details TCBD on TSBM.I_Batch_ID=TCBD.I_Batch_ID
		inner join T_Center_Hierarchy_Name_Details TCHND on TCBD.I_Centre_Id=TCHND.I_Center_ID
		where
		TCHND.I_Brand_ID=109
		and Dt_BatchStartDate>=DATEADD(d,-365,GETDATE())
	) T1
	LEFT JOIN
	(
		SELECT Centre+'_'+Batch as CentreBatch,Centre,Batch,IsExamBatch,IsFocusedBatch,IsMergedBatch 
		FROM T_AttendanceDataMapping_Manual
	) T2 on T1.CentreBatch=T2.CentreBatch
) TX 
where TX.Batch is null
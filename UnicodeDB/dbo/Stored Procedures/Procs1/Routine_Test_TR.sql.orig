-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Routine_Test_TR]
@BranchName varchar(50)=null,
@BatchName varchar(50)=null,
@FD date,
@TD date

AS
BEGIN
	SET NOCOUNT ON;
	
select
TSBM.S_Batch_Name AS Batch,

TSBM.S_Batch_Code as Batch_Code,
TCM.S_Center_Name as Branch,
TMM.S_Module_Name as Module,

TSM.S_Session_Name as Session,
TSM.S_Session_Topic as Topic,
convert(date,TTM.Dt_Schedule_Date) as Schedule_Date, 


convert(date,isnull(TTM.Dt_Actual_Date,'1900-01-01')) as Actual_Date,
(case when TTM.Dt_Actual_Date IS null then 'Incomplete' else 'Complete' end) As Class_Status,


TTM.S_Crtd_By As CreatedBy, 
convert(date,TTM.Dt_Crtd_On) as CreatedOn,
TTM.S_Updt_By as UpdatedBy,
convert(date,TTM.Dt_Updt_On) as UpdateOn 

from T_TimeTable_Master TTM 
inner join T_Centre_Master TCM on TCM.I_Centre_Id=TTM.I_Center_ID
inner join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=TTM.I_Batch_ID
inner join T_Module_Master TMM on TMM.I_Module_ID=TTM.I_Module_ID
left join T_Session_Master TSM on TSM.I_Session_ID=TTM.I_Session_ID
left join T_TimeSlot_Master TTSM on TTSM.I_TimeSlot_ID=TTM.I_TimeSlot_ID
where 

convert (date,TTM.Dt_Schedule_Date) between @FD
and @TD 
and (TSBM.S_Batch_Name=@BatchName or @BatchName is null)
and (TCM.S_Center_Name=@BranchName or @BranchName is null)
and TTM.I_Status=1   
order by TTM.Dt_Schedule_Date


END

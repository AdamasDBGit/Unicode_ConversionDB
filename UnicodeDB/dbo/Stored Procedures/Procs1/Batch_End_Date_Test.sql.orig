-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Batch_End_Date_Test]
@BranchName varchar(50),
@BatchName  varchar(50)=null

AS
BEGIN
select
TCM.S_Center_Name As Branch,
TSBM.S_Batch_Name AS Batch,
convert (date,TSBM.Dt_BatchStartDate) AS Start_Date,
convert(date,TSBM.Dt_Course_Expected_End_Date) As End_Date
,DateDiff (DAY,TSBM.Dt_BatchStartDate,TSBM.Dt_Course_Expected_End_Date) as Running_Days

from T_TimeTable_Master TTM 
inner join T_Centre_Master TCM on TCM.I_Centre_Id=TTM.I_Center_ID
inner join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=TTM.I_Batch_ID
inner join T_Module_Master TMM on TMM.I_Module_ID=TTM.I_Module_ID
left join T_Session_Master TSM on TSM.I_Session_ID=TTM.I_Session_ID
left join T_TimeSlot_Master TTSM on TTSM.I_TimeSlot_ID=TTM.I_TimeSlot_ID
where 
TCM.S_Center_Name=@BranchName
and (TSBM.S_Batch_Name=@BatchName or @BatchName is null)

and TTM.I_Status=1   
group by TSBM.S_Batch_Name,
TSBM.Dt_BatchStartDate,
TSBM.Dt_Course_Expected_End_Date,
TCM.S_Center_Name


END

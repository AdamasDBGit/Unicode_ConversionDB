-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Routine_Test_TR_Batch] 
@BranchName NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
select

TSBM.S_Batch_Name AS Batch

from T_TimeTable_Master TTM 
inner join T_Centre_Master TCM on TCM.I_Centre_Id=TTM.I_Center_ID
inner join T_Student_Batch_Master TSBM on TSBM.I_Batch_ID=TTM.I_Batch_ID
inner join T_Module_Master TMM on TMM.I_Module_ID=TTM.I_Module_ID
left join T_Session_Master TSM on TSM.I_Session_ID=TTM.I_Session_ID
left join T_TimeSlot_Master TTSM on TTSM.I_TimeSlot_ID=TTM.I_TimeSlot_ID
where 
TCM.S_Center_Name=@BranchName
and TTM.I_Status=1   
group by TSBM.S_Batch_Name


END


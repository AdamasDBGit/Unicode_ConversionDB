
-- =============================================
-- Author:		<susmita Paul>
-- Create date: <2023-Feb-02>
-- Description:	<Fetch all the defaulter students List>
-- =============================================
CREATE PROCEDURE [LMS].[uspGetDefaulterStudentsList_BKPBeforeBatchAddMarch2023]
	
AS
BEGIN
	
	select DISTINCT SD.S_Student_ID from 
	T_Student_Detail as SD
	inner join
	T_Student_Batch_Details as SBD on SD.I_Student_Detail_ID=SBD.I_Student_ID
	inner join
	T_Student_Batch_Master as SBM on SBM.I_Batch_ID=SBD.I_Batch_ID
	inner join
	T_Center_Batch_Details as CBD on CBD.I_Batch_ID=SBM.I_Batch_ID
	where SD.IsDiscontinued=0 and SD.IsDefaulter=1 and SD.I_Status=1
	and CBD.I_Centre_Id in (132)
	--and SBM.I_Status = 4 and SBD.I_Status=1 and CBD.I_Centre_Id in (132)
END

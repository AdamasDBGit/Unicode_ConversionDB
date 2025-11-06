/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [dbo].[uspInsertUpdateSubjectModuleSetup] 
(
	@ResultSubjectRule UT_ResultSubjectRule readonly,
	@GroupName UT_GroupName readonly,
	@ModuleGroupList UT_ModuleGroup readonly
	
)
AS
begin transaction
BEGIN TRY 
DECLARE @iResultSubjectRuleID int;
INSERT INTO T_Result_Subject_Rule
(
 I_Result_Exam_Schedule_ID
,I_Exam_Component_ID
)
SELECT ExamScheduleID,ComponentID from @ResultSubjectRule
INSERT INTO T_Result_Subject_Group_Rule
(
I_Result_Subject_Rule_ID
,S_Group_Name
)
SELECT TRSR.I_Result_Subject_Rule_ID,GroupName 
from @GroupName GM inner join T_Result_Subject_Rule TRSR 
ON TRSR.I_Exam_Component_ID = GM.ComponentID and TRSR.I_Result_Exam_Schedule_ID = GM.ExamScheduleID
INSERT INTO T_Result_Subject_Module 
(
 I_Result_Subject_Rule_ID
,I_Result_Subject_Group_Rule_ID
,I_Module_ID
)
SELECT 
--(SELECT I_Result_Subject_Rule_ID from T_Result_Subject_Rule where I_Exam_Component_ID=MGL.ComponentID and I_Result_Exam_Schedule_ID=MGL.ExamScheduleID)
 TRSR.I_Result_Subject_Rule_ID
,TRSGR.I_Result_Subject_Group_Rule_ID
,MGL.ModuleID
from @ModuleGroupList MGL 
inner join T_Result_Subject_Rule TRSR 
ON TRSR.I_Exam_Component_ID=MGL.ComponentID
and TRSR.I_Result_Exam_Schedule_ID = MGL.ExamScheduleID
inner join T_Result_Subject_Group_Rule TRSGR ON TRSGR.I_Result_Subject_Rule_ID = TRSR.I_Result_Subject_Rule_ID and TRSGR.S_Group_Name = MGL.GroupName

SELECT 1 StatusFlag,'Setup saved succesfully' Message

END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()
select 0 StatusFlag,@ErrMsg Message
	--RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction

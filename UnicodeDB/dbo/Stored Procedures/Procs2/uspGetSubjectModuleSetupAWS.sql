/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/
--exec [uspGetSubjectModuleSetupAWS] 3
CREATE PROCEDURE [dbo].[uspGetSubjectModuleSetupAWS] 
(
	@iResultExamScheduleID int = null
	
)
AS
begin transaction
BEGIN TRY 


select  TMM.S_Module_Name ComponentName
--,TTM.S_Term_Name TermName
,TTM.I_Term_ID TermID
--,TMM.S_Module_Name
,TRES.I_School_Session_ID SessionID
,TRES.I_Course_ID CourseID
,TMES.I_Module_ID ExamComponentID
,TRES.I_Result_Exam_Schedule_ID ResultExamScheduleID
,TRSR.S_Subject_Name
from T_Result_Exam_Schedule TRES inner join T_Module_Eval_Strategy TMES 
ON TRES.I_Term_ID = TMES.I_Term_ID
inner join T_Exam_Component_Master TECM ON TECM.I_Exam_Component_ID = TMES.I_Exam_Component_ID
inner join T_Term_Master TTM on TTM.I_Term_ID = TRES.I_Term_ID
inner join T_Module_Master TMM ON TMM.I_Module_ID = TMES.I_Module_ID
left join T_Result_Subject_Rule TRSR ON TRSR.I_Result_Exam_Schedule_ID = TRES.I_Result_Exam_Schedule_ID AND TRSR.I_Module_ID = TMM.I_Module_ID
where TRES.I_Result_Exam_Schedule_ID = @iResultExamScheduleID

group by TMM.S_Module_Name,TTM.I_Term_ID,TRES.I_School_Session_ID,TRES.I_Course_ID,TMES.I_Module_ID,TRES.I_Result_Exam_Schedule_ID,TRSR.S_Subject_Name

select  TMM.S_Module_Name ComponentName
,TTM.S_Term_Name TermName
,TTM.I_Term_ID TermID
,TECM.S_Component_Name  ModuleName
,TECM.I_Exam_Component_ID ModuleID
,TRES.I_School_Session_ID SessionID
,TRES.I_Course_ID CourseID
,TMES.I_Module_ID ExamComponentID
from T_Result_Exam_Schedule TRES inner join T_Module_Eval_Strategy TMES 
ON TRES.I_Term_ID = TMES.I_Term_ID
inner join T_Exam_Component_Master TECM ON TECM.I_Exam_Component_ID = TMES.I_Exam_Component_ID
inner join T_Term_Master TTM on TTM.I_Term_ID = TRES.I_Term_ID
inner join T_Module_Master TMM ON TMM.I_Module_ID = TMES.I_Module_ID
where TRES.I_Result_Exam_Schedule_ID = @iResultExamScheduleID

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

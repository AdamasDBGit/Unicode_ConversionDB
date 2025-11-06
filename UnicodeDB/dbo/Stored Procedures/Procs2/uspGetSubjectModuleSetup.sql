/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/
--exec [uspGetSubjectModuleSetup] 60
CREATE PROCEDURE [dbo].[uspGetSubjectModuleSetup] 
(
	@iResultExamScheduleID int = null
	
)
AS
begin transaction
BEGIN TRY 


select distinct TECM.S_Component_Name ComponentName
--,TTM.S_Term_Name TermName
,TTM.I_Term_ID TermID
--,TMM.S_Module_Name
,TRES.I_School_Session_ID SessionID
,TRES.I_Course_ID CourseID
,TMES.I_Exam_Component_ID ExamComponentID
,TRES.I_Result_Exam_Schedule_ID ResultExamScheduleID
from T_Result_Exam_Schedule TRES inner join T_Module_Eval_Strategy TMES 
ON TRES.I_Term_ID = TMES.I_Term_ID
inner join T_Exam_Component_Master TECM ON TECM.I_Exam_Component_ID = TMES.I_Exam_Component_ID
inner join T_Term_Master TTM on TTM.I_Term_ID = TRES.I_Term_ID
inner join T_Module_Master TMM ON TMM.I_Module_ID = TMES.I_Module_ID
where TRES.I_Result_Exam_Schedule_ID = @iResultExamScheduleID
--group by TMES.I_Exam_Component_ID 

select  TECM.S_Component_Name ComponentName
,TTM.S_Term_Name TermName
,TTM.I_Term_ID TermID
,TMM.S_Module_Name  ModuleName
,TMM.I_Module_ID ModuleID
,TRES.I_School_Session_ID SessionID
,TRES.I_Course_ID CourseID
,TMES.I_Exam_Component_ID ExamComponentID
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

CREATE PROCEDURE [dbo].[uspGetGradeDetails] 
(
	@iExamGradeMasterHeaderID int = null
)
AS
begin transaction
BEGIN TRY 
SELECT 
 TEGMH.I_Exam_Grade_Master_Header_ID ID
,TEGMH.I_Exam_Grade_Master_Header_ID ExamGradeMasterHeaderID
,TSG.S_School_Group_Name SchoolGroupName
,TSG.I_School_Group_ID SchoolGroupID
,TSAM.S_Label Session
,TSAM.I_School_Session_ID SessionID
,TC.S_Class_Name ClassName 
,TC.I_Class_ID ClassID
FROM 
T_Exam_Grade_Master_Header TEGMH 
inner join T_School_Group TSG on TSG.I_School_Group_ID=TEGMH.I_School_Group_ID
inner join T_School_Academic_Session_Master TSAM on  TSAM.I_School_Session_ID = TEGMH.I_School_Session_ID
left join T_Class TC ON TC.I_Class_ID = TEGMH.I_Class_ID
where TEGMH.I_Exam_Grade_Master_Header_ID = ISNULL(@iExamGradeMasterHeaderID,TEGMH.I_Exam_Grade_Master_Header_ID)

select 
S_Symbol Symbol
,ISNULL(S_Name,'') Name
,ISNULL(I_Lower_Limit,'') LowerLimit
,ISNULL(I_Upper_Limit,'') UpperLimit
from T_Exam_Grade_Master where  I_Exam_Grade_Master_Header_ID = @iExamGradeMasterHeaderID

END TRY
BEGIN CATCH
	rollback transaction
	DECLARE @ErrMsg NVARCHAR(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
commit transaction



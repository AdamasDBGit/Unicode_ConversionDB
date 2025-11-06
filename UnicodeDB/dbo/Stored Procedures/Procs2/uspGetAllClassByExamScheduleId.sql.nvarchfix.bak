CREATE PROCEDURE [dbo].[uspGetAllClassByExamScheduleId]
(
	@iExamScheduleID int = null
)
AS

BEGIN TRY 
select TSD.S_First_Name+' '+TSD.S_Middle_Name+' '+TSD.S_Last_Name+' ('+TSD.S_Student_ID+')' AS Name
,TSD.I_Student_Detail_ID  StudentDetailID
from T_Result_Exam_Schedule TRES 
inner join T_Student_Class_Section TSCS ON TSCS.I_School_Group_Class_ID = TRES.I_School_Group_Class_ID
inner join T_Student_Detail TSD ON TSCS.I_Student_Detail_ID = TSD.I_Student_Detail_ID
where TRES.I_Result_Exam_Schedule_ID = @iExamScheduleID
  
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg Nnvarchar(max), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

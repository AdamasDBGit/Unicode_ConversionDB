
CREATE PROCEDURE [dbo].[uspGetTrainingDetails]
(
	@iExamScheduleID int = null
)
AS

BEGIN TRY 

 SELECT 
 TSD.S_First_Name+' '+ TSD.S_Middle_Name+' '+TSD.S_Last_Name Name
,TC.S_Class_Name
 FROM 
T_Student_Result TSR inner join T_Student_Detail TSD ON TSD.I_Student_Detail_ID = TSR.I_Student_Detail_ID
inner join T_Result_Exam_Schedule TRES ON TRES.I_Result_Exam_Schedule_ID = TSR.I_Result_Exam_Schedule_ID
inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TRES.I_School_Group_Class_ID
inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID
WHERE TSR.I_Result_Exam_Schedule_ID = @iExamScheduleID
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

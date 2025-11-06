--exec uspGetAllStudentForExamSchedule_BKP 3,'482045'
CREATE PROCEDURE [dbo].[uspGetAllStudentForExamSchedule_BKP]
(
	@iExamScheduleID int = null,
	@sUserID nvarchar(50) = null
)
AS

BEGIN TRY 
DECLARE @recordExist int=0

	SET @recordExist = (SELECT top 1 count(I_School_Group_Class_ID)  
	from T_School_Class_Teacher where sms_user_id = ISNULL(@sUserID,sms_user_id)
	group by I_School_Group_Class_ID,I_Stream_ID,sms_user_id,I_Section_ID)
  SELECT 
  TSR.I_Result_Exam_Schedule_ID ExamScheduleID
 ,TSR.I_Student_Result_ID  StudentResultID
 ,TSD.S_First_Name+' '+ TSD.S_Middle_Name+' '+TSD.S_Last_Name Name
 ,TSD.I_Student_Detail_ID  StudentDetailID
 ,TC.S_Class_Name ClassName
 ,TC.I_Class_ID ClassID
 ,TSD.S_Student_ID StudentID
 ,TSR.I_IsHold Hold
 FROM 
T_Student_Result TSR inner join T_Student_Detail TSD ON TSD.I_Student_Detail_ID = TSR.I_Student_Detail_ID
inner join T_Result_Exam_Schedule TRES ON TRES.I_Result_Exam_Schedule_ID = TSR.I_Result_Exam_Schedule_ID
inner join T_School_Group_Class TSGC ON TSGC.I_School_Group_Class_ID = TRES.I_School_Group_Class_ID
inner join T_Class TC ON TC.I_Class_ID = TSGC.I_Class_ID
left join 
	(
		SELECT I_School_Group_Class_ID,I_Stream_ID,I_Section_ID,sms_user_id from T_School_Class_Teacher where sms_user_id = ISNULL(@sUserID,sms_user_id)
		group by I_School_Group_Class_ID,I_Stream_ID,I_Section_ID,sms_user_id
	) TSCM 
	 ON TSCM.I_School_Group_Class_ID = TRES.I_School_Group_Class_ID AND (ISNULL(TSCM.I_Stream_ID,0)=ISNULL(TSR.I_Stream_ID,0))
WHERE TSR.I_Result_Exam_Schedule_ID = @iExamScheduleID
and TRES.I_School_Group_Class_ID = CASE 
			WHEN @recordExist=1
				THEN TSCM.I_School_Group_Class_ID
				ELSE TRES.I_School_Group_Class_ID
			END
	and ISNULL(TRES.I_Stream_ID,0) = CASE 
			WHEN @recordExist=1
				THEN ISNULL(TSCM.I_Stream_ID,0)
				ELSE ISNULL(TRES.I_Stream_ID,0)
			END
	and ISNULL(TSR.I_Section_ID,0) = CASE 
			WHEN @recordExist=1
				THEN ISNULL(TSCM.I_Section_ID,0)
				ELSE ISNULL(TSR.I_Section_ID,0)
			END
		
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

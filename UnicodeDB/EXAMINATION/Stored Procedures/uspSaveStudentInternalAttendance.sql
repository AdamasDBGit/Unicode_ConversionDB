CREATE PROCEDURE [EXAMINATION].[uspSaveStudentInternalAttendance]
(
@CourseID INT,
@TermID INT,
@ExamComponentID INT=NULL,
@ModuleID INT=NULL,
@StudentDetailID INT,
@Attendance DECIMAL(14,2),
@LoginID VARCHAR(MAX),
@Noofdays INT=NULL
)
AS
BEGIN

	IF(@ExamComponentID=0)
			SET @ExamComponentID=NULL

	IF NOT EXISTS(SELECT * FROM EXAMINATION.T_Student_Internal_Attendance AS TSIA
					WHERE TSIA.I_Course_ID=@CourseID AND TSIA.I_Term_ID=@TermID AND ISNULL(TSIA.I_Exam_Component_ID,0)=ISNULL(@ExamComponentID,0)
					AND ISNULL(TSIA.I_Module_ID,0)=ISNULL(@ModuleID,0) AND TSIA.I_Student_Detail_ID=@StudentDetailID and TSIA.I_Status=1)
	BEGIN

		
		
		IF (@Attendance>=0)
		BEGIN

		

		INSERT INTO EXAMINATION.T_Student_Internal_Attendance
		(
		    I_Course_ID,
		    I_Term_ID,
		    I_Module_ID,
		    I_Exam_Component_ID,
		    I_Student_Detail_ID,
		    N_Attendance,
			S_Crtd_By,
			Dt_Crtd_On,
			N_AllottedClass,
			I_Status
		)
		VALUES
		(   @CourseID,   -- I_Course_ID - int
		    @TermID,   -- I_Term_ID - int
		    @ModuleID,   -- I_Module_ID - int
		    @ExamComponentID,   -- I_Exam_Component_ID - int
		    @StudentDetailID,   -- I_Student_Detail_ID - int
		    @Attendance, -- N_Attendance - decimal(14, 2)
			@LoginID,
			GETDATE(),
			@Noofdays,
			1
		    )

		END

	END
	ELSE
	BEGIN

		UPDATE EXAMINATION.T_Student_Internal_Attendance SET N_Attendance=@Attendance,S_Updt_By=@LoginID,Dt_Updt_On=GETDATE(),N_AllottedClass=@Noofdays 
		WHERE I_Course_ID=@CourseID
		AND I_Term_ID=@TermID AND ISNULL(I_Module_ID,0)=ISNULL(@ModuleID,0) AND ISNULL(I_Exam_Component_ID,0)=ISNULL(@ExamComponentID,0) 
		AND I_Student_Detail_ID=@StudentDetailID and I_Status=1

	END

END

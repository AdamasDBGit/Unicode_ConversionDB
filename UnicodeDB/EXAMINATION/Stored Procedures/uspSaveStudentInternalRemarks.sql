CREATE PROCEDURE [EXAMINATION].[uspSaveStudentInternalRemarks]
(
@CourseID INT,
@TermID INT,
@ModuleID INT=NULL,
@StudentDetailID INT,
@Remarks VARCHAR(MAX)=NULL,
@LoginID VARCHAR(MAX)
)
AS
BEGIN

	IF NOT EXISTS(SELECT * FROM EXAMINATION.T_Student_Internal_Remarks AS TSIA
					WHERE TSIA.I_Course_ID=@CourseID AND TSIA.I_Term_ID=@TermID --AND ISNULL(TSIA.I_Exam_Component_ID,0)=ISNULL(@ExamComponentID,0)
					AND ISNULL(TSIA.I_Module_ID,0)=ISNULL(@ModuleID,0) AND TSIA.I_Student_Detail_ID=@StudentDetailID)
	BEGIN

		
		
		IF (@Remarks is not null AND @Remarks!='')
		BEGIN

		

		INSERT INTO EXAMINATION.T_Student_Internal_Remarks
		(
		    I_Course_ID,
		    I_Term_ID,
		    I_Module_ID,
		    I_Student_Detail_ID,
		    S_Remarks,
			S_Crtd_By,
			Dt_Crtd_On
		)
		VALUES
		(   @CourseID,   -- I_Course_ID - int
		    @TermID,   -- I_Term_ID - int
		    @ModuleID,   -- I_Module_ID - int
		    --@ExamComponentID,   -- I_Exam_Component_ID - int
		    @StudentDetailID,   -- I_Student_Detail_ID - int
		    @Remarks, -- N_Attendance - decimal(14, 2)
			@LoginID,
			GETDATE()
		    )

		END

	END
	ELSE
	BEGIN

		UPDATE EXAMINATION.T_Student_Internal_Remarks SET S_Remarks=@Remarks,S_Updt_By=@LoginID,Dt_Updt_On=GETDATE() 
		WHERE I_Course_ID=@CourseID
		AND I_Term_ID=@TermID AND ISNULL(I_Module_ID,0)=ISNULL(@ModuleID,0) --AND ISNULL(I_Exam_Component_ID,0)=ISNULL(@ExamComponentID,0) 
		AND I_Student_Detail_ID=@StudentDetailID

	END

END

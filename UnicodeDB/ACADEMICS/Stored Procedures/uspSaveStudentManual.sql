/*******************************************************
Description : Save Manual Number for the Students eligible for e-projects
Author	:     Soumya Sikder
Date	:	  05/21/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspSaveStudentManual] 
(
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iCenterID int,
	@iEProjectManualNumber int,
	@iStudentDetailID int,
	@iStatus int,
	@sUser varchar(20),
	@dDate datetime
)
AS

BEGIN TRY 

DECLARE @iCenterEprojID int

SET @iCenterEprojID = 0

	SELECT @iCenterEprojID = I_Center_E_Proj_ID 
	FROM ACADEMICS.T_Center_E_Project_Manual
	WHERE I_Student_Detail_ID = @iStudentDetailID
	AND I_Center_ID = @iCenterID
	AND I_Course_ID = @iCourseID
	AND I_Term_ID = @iTermID
	AND I_Module_ID = @iModuleID
	AND I_Status NOT IN (2,3)


	IF @iCenterEprojID > 0
	BEGIN
		UPDATE ACADEMICS.T_Center_E_Project_Manual
		SET I_E_Proj_Manual_Number = @iEProjectManualNumber
		WHERE I_Center_ID = @iCenterID
		AND I_Course_ID = @iCourseID
		AND I_Term_ID = @iTermID
		AND I_Module_ID = @iModuleID
		AND I_Student_Detail_ID = @iStudentDetailID
		AND I_Status NOT IN (2,3)
	END
	ELSE
	BEGIN

	BEGIN TRAN TI

		INSERT INTO ACADEMICS.T_Center_E_Project_Manual
		(
			I_Center_ID,
			I_Course_ID,
			I_Term_ID,
			I_Module_ID,
			I_Student_Detail_ID,
			I_E_Proj_Manual_Number,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On
		)
		VALUES
		(
			@iCenterID,
			@iCourseID,
			@iTermID,
			@iModuleID,
			@iStudentDetailID,
			@iEProjectManualNumber,
			@iStatus,
			@sUser,
			@dDate
		)

		SET @iCenterEprojID = SCOPE_IDENTITY()

		COMMIT TRAN T1

	END

SELECT @iCenterEprojID CenterEprojID 

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

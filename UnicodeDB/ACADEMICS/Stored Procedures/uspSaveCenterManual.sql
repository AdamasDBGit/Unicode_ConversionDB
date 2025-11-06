/*******************************************************
Description : Save E-Project Manual
Author	:     Arindam Roy
Date	:	  05/22/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspSaveCenterManual] 
(
	@iCenterID int,
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iFromNumber int,
	@iToNumber int,
	@sUser varchar(20),
	@dDate datetime,
	@iManualID int = null,
	@iManNoCompulsory int
)
AS

BEGIN TRY 

	--BEGIN TRAN T1

	IF EXISTS(SELECT I_E_Proj_Manual_ID FROM ACADEMICS.T_E_Project_Manual_Master WHERE I_Center_ID = @iCenterID AND I_Course_ID = @iCourseID  AND I_Term_ID= @iTermID AND I_Module_ID = @iModuleID)

	BEGIN
		SELECT TOP 1 @iManualID = I_E_Proj_Manual_ID FROM ACADEMICS.T_E_Project_Manual_Master WHERE I_Center_ID = @iCenterID AND I_Course_ID = @iCourseID  AND I_Term_ID= @iTermID AND I_Module_ID = @iModuleID

		UPDATE ACADEMICS.T_E_Project_Manual_Master
		SET I_Is_Manual_No_Compulsory = @iManNoCompulsory,
			S_Crtd_By = @sUser,
			Dt_Upd_On = @dDate
		WHERE I_E_Proj_Manual_ID = @iManualID
	END 

	ELSE
	BEGIN

		INSERT INTO ACADEMICS.T_E_Project_Manual_Master
		(
			I_Center_ID,
			I_Course_ID,
			I_Term_ID,
			I_Module_ID,		
			S_Crtd_By,
			Dt_Crtd_On,
			S_Upd_By,
			Dt_Upd_On,
			I_Is_Manual_No_Compulsory)
		VALUES
		(
			@iCenterID,
			@iCourseID,
			@iTermID,
			@iModuleID,		
			@sUser,
			@dDate,
			NULL,
			NULL,
			@iManNoCompulsory
		)

		SET @iManualID = SCOPE_IDENTITY()
	END

	IF(@iFromNumber IS NOT NULL AND @iToNumber IS NOT NULL)

	INSERT INTO ACADEMICS.T_E_Project_Manual_Detail
	(
		I_E_Proj_Manual_ID,
		I_From_Number,
		I_To_Number
	)
	VALUES
	(
		@iManualID,
		@iFromNumber,
		@iToNumber
	)
	
	
	--COMMIT TRAN T1
	
	SELECT @iManualID ManualID

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

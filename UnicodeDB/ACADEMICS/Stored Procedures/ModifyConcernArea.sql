/*******************************************************
Description : Saves the student ids and thus enrolls them for examination
Author	:     Soumya Sikder
Date	:	  05/03/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[ModifyConcernArea] 
(
	@iVisitID int,
	@iConcernAreaID int = null,
	@sDescription varchar(2000) = null,
	@iAssignedEmpID int,
	@dTargetDate datetime = null,
	@dActualDate datetime = null,
	@sUser varchar(20),
	@dDate datetime,
	@iFlag int
)

AS

BEGIN TRY 
	-- Inserting New Records in the table
	if(@iFlag = 1)
	BEGIN
		
		BEGIN TRAN T1

		INSERT INTO ACADEMICS.T_Concern_Areas
		(
			I_Academics_Visit_ID,
			S_Description,
			I_Assigned_EmpID,
			Dt_Target_Date,
			S_Crtd_By,
			Dt_Crtd_On
		)
		VALUES
		(
			@iVisitID,
			@sDescription,
			@iAssignedEmpID,
			@dTargetDate,
			@sUser,
			@dDate
		)

		SET @iConcernAreaID = SCOPE_IDENTITY()

		COMMIT TRAN T1

	END

	-- Updating Records in the Table
	if(@iFlag = 2)
	BEGIN

		BEGIN TRAN T2

		UPDATE ACADEMICS.T_Concern_Areas
		SET
			Dt_Actual_Date = ISNULL(@dActualDate,Dt_Actual_Date),
			S_Upd_By = @sUser,
			Dt_Upd_On = @dDate 
		WHERE I_Concern_Areas_ID = @iConcernAreaID

		COMMIT TRAN T2

	END

	SELECT @iConcernAreaID ConcernAreaID

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

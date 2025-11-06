/*******************************************************
Description : Saves the student ids and thus enrolls them for examination
Author	:     Soumya Sikder
Date	:	  05/03/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspModifyCenterVisit] 
(
	@iCenterID int,
	@iVisitID int = null,
	@iUserID int,
	@dPlannedFromDate datetime = null,
	@dPlannedToDate datetime = null,
	@dActualFromDate datetime = null,
	@dActualToDate datetime = null,
	@sPurpose varchar(2000)= null,
	@sRemarks varchar(2000) = null,
	@iStatus int,
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

		INSERT INTO ACADEMICS.T_Academics_Visit
		(
			I_Center_Id,
			I_User_ID,
			Dt_Planned_Visit_From_Date,
			Dt_Planned_Visit_To_Date,
			S_Purpose,
			I_Status,
			S_Crtd_By,
			Dt_Crtd_On
		)
		VALUES
		(
			@iCenterID,
			@iUserID,
			@dPlannedFromDate,
			@dPlannedToDate,
			@sPurpose,
			@iStatus,
			@sUser,
			@dDate
		)
		
		SET @iVisitID = SCOPE_IDENTITY()

		COMMIT TRAN T1

		SELECT @iVisitID VisitID

	END

	-- Updating Records in the Table
	if(@iFlag = 2)
	BEGIN
		BEGIN TRAN T2
		-- Inserting Records in Audit table
		IF EXISTS( SELECT I_Academics_Visit_ID FROM ACADEMICS.T_Academics_Visit
					WHERE I_Academics_Visit_ID = @iVisitID
					AND I_Status <> 2 )
		BEGIN
			INSERT INTO ACADEMICS.T_Academics_Visit_Audit
			( 
				I_Academics_Visit_ID,
				I_User_ID,
				I_Center_ID,
				Dt_Planned_Visit_From_Date,	
				Dt_Planned_Visit_To_Date,
				Dt_Actual_Visit_From_Date,
				Dt_Actual_Visit_To_Date,
				S_Purpose,
				S_Remarks,
				C_Academic_Parameter,
				C_Faculty_Approval,
				C_Faculty_Certification,
				C_Infrastructure,
				I_Status,
				S_Crtd_By,
				Dt_Crtd_On
			)
			SELECT  I_Academics_Visit_ID,
					I_User_ID,
					I_Center_ID,
					Dt_Planned_Visit_From_Date,	
					Dt_Planned_Visit_To_Date,
					Dt_Actual_Visit_From_Date,
					Dt_Actual_Visit_To_Date,
					S_Purpose,
					S_Remarks,
					C_Academic_Parameter,
					C_Faculty_Approval,
					C_Faculty_Certification,
					C_Infrastructure,
					I_Status,
					S_Crtd_By,
					Dt_Crtd_On
			FROM ACADEMICS.T_Academics_Visit
			WHERE I_Academics_Visit_ID = @iVisitID
			AND I_Status <> 2
		END
		--Updating Records in Academics Visit Table
		UPDATE ACADEMICS.T_Academics_Visit 
		SET
			Dt_Planned_Visit_From_Date = ISNULL(@dPlannedFromDate,Dt_Planned_Visit_From_Date),
			Dt_Actual_Visit_From_Date = ISNULL(@dActualFromDate,Dt_Actual_Visit_From_Date),
			Dt_Planned_Visit_To_Date = ISNULL(@dPlannedToDate,Dt_Planned_Visit_To_Date),
			Dt_Actual_Visit_To_Date = ISNULL(@dActualToDate,Dt_Actual_Visit_To_Date),
			S_Purpose = ISNULL(@sPurpose,S_Purpose),
			I_Status = @iStatus,
			S_Upd_By = @sUser,
			Dt_Upd_On = @dDate
		WHERE I_Academics_Visit_ID = @iVisitID

		SET @iVisitID = SCOPE_IDENTITY()

		COMMIT TRAN T2

		SELECT @iVisitID VisitID 
	END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

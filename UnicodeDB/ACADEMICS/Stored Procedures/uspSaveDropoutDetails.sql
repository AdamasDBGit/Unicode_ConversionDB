/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 02/05/2007
Description:Saves the dropout details for a student in case of manual dropout and also for reactivating the student
Parameters: StudentDetailID,CenterID, DropoutStatusID, DropoutDate, Reason ,CreatedBy , CreatedOn
Returns:	
Modified By: Debman Mukherjee
******************************************************************************************************************/

CREATE PROCEDURE [ACADEMICS].[uspSaveDropoutDetails]
(
	@iStudentDetailID int,
	@iCenterID int,
	@iDropoutTypeID int=null,
	@dDropoutDate datetime,
	@sReason varchar(2000),
	@sUser varchar(20),
	@dDate datetime,
	@iStatus int
)
AS

BEGIN TRY 
	DECLARE @iDropoutCount int
	DECLARE @iStudentStatus int
	
	IF EXISTS (SELECT I_Dropout_ID FROM T_Dropout_Details
			   WHERE I_Student_Detail_ID = @iStudentDetailID
			   AND I_Center_Id = @iCenterID
			   AND I_Dropout_Status <> 0)	
	BEGIN
		-- inserting in the dropout audit table
		INSERT INTO T_Dropout_Dtls_Audit
		(
			I_Dropout_ID,
			I_Student_ID,
			I_Center_Id,
			I_Dropout_Status,
			I_Dropout_Type_ID,
			Dt_Dropout_Date,
			S_Reason,
			S_Crtd_By,
			Dt_Crtd_On
		)
		SELECT
			I_Dropout_ID,
			I_Student_Detail_ID,
			I_Center_Id,
			I_Dropout_Status,
			I_Dropout_Type_ID,
			Dt_Dropout_Date,
			S_Reason,
			S_Crtd_By,
			Dt_Crtd_On
		FROM T_Dropout_Details WITH(NOLOCK)
		WHERE I_Student_Detail_ID = @iStudentDetailID
		AND I_Center_Id = @iCenterID
		AND I_Dropout_Status <> 0
		
		-- upadte records druing reactivation

		UPDATE T_Dropout_Details
		SET
			I_Dropout_Status = @iStatus,
			S_Reason = @sReason,
			S_Upd_By = @sUser,
			Dt_Upd_On = @dDate
	   WHERE
			I_Student_Detail_ID = @iStudentDetailID
		AND I_Center_Id = @iCenterID
		AND I_Dropout_Status <> 0
		AND I_Dropout_Type_ID = @iDropoutTypeID
	
	END
	ELSE
	BEGIN
		-- insert in dropout details table during dropout
		INSERT INTO T_Dropout_Details
		(
			I_Student_Detail_ID,
			I_Center_Id,
			I_Dropout_Type_ID,
			I_Dropout_Status,
			Dt_Dropout_Date,
			S_Reason,
			S_Crtd_By,
			Dt_Crtd_On
		)
		Values
		(
			@iStudentDetailID ,
			@iCenterID ,
			@iDropoutTypeID,
			@iStatus,
			@dDropoutDate ,
			@sReason ,
			@sUser ,
			@dDate
		)
	
	END
	
	SET @iStudentStatus = 1
	IF @iStatus = 1 SET @iStudentStatus = 0 
	
	-- ACTIVATE THE STUDENT IN STUDENT DETAILS TABLE
	UPDATE dbo.T_Student_Detail
	SET I_Status = @iStudentStatus,
	S_Upd_By = @sUser,
	Dt_Upd_On = @dDate
	WHERE I_Student_Detail_ID = @iStudentDetailID

END TRY

BEGIN CATCH
	--Error occurred:  

	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int
	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

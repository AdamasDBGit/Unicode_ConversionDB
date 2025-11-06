/*******************************************************
Description : Saves the student ids and thus enrolls them for examination
Author	:     Soumya Sikder
Date	:	  05/03/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[SaveCenterVisitDetails] 
(
	@iVisitID int,
	@iUserID int,
	@iCenterID int,
	@dPlannedFromDate datetime = null,
	@dPlannedToDate datetime = null,
--	@dtActualFromDate datetime = null,
--	@dtActualToDate datetime = null,
	@sPurpose varchar(2000) = null,
	@sRemarks varchar(2000) = null,
	@sAcademicParameter char(1) = null,
	@sFacultyApprovalParameter char(1) = null,
	@sFacultyCertificationParameter char(1) = null,
	@sInfrastructureParameter char(1) = null,
	@iStatus int,
	@sUser varchar(20),
	@dDate datetime
)

AS

BEGIN TRY 
	BEGIN TRAN T1
	
	-- inserting records in Academics Audit table.
	IF EXISTS( SELECT COUNT(*) FROM ACADEMICS.T_Academics_Visit
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
		S_Crtd_By,
		Dt_Crtd_On,
		C_Academic_Parameter,
		C_Faculty_Approval,
		C_Faculty_Certification,
		C_Infrastructure,
		I_Status
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
			S_Crtd_By,
			Dt_Crtd_On,
			C_Academic_Parameter,
			C_Faculty_Approval,
			C_Faculty_Certification,
			C_Infrastructure,
			I_Status
	FROM ACADEMICS.T_Academics_Visit
	WHERE I_Academics_Visit_ID = @iVisitID
	AND I_Status <> 2

	-- updating in the Academics Visit table.
	UPDATE ACADEMICS.T_Academics_Visit 
	SET
		Dt_Planned_Visit_From_Date = ISNULL(@dPlannedFromDate,Dt_Planned_Visit_From_Date),
	--	Dt_Actual_Visit_From_Date = ISNULL(@dtActualFromDate,Dt_Actual_Visit_From_Date),
		Dt_Planned_Visit_To_Date = ISNULL(@dPlannedToDate,Dt_Planned_Visit_To_Date),
	--	Dt_Actual_Visit_To_Date = ISNULL(@dtActualToDate,Dt_Actual_Visit_To_Date),
		S_Purpose = ISNULL(@sPurpose,S_Purpose),
		S_Remarks = ISNULL(@sRemarks,S_Remarks),
		I_Status = @iStatus,
		C_Academic_Parameter = @sAcademicParameter,
		C_Faculty_Approval = @sFacultyApprovalParameter,
		C_Faculty_Certification = @sFacultyCertificationParameter,
		C_Infrastructure = @sInfrastructureParameter,
		S_Upd_By = @sUser,
		Dt_Upd_On = @dDate
	WHERE I_Academics_Visit_ID = @iVisitID

	END
	
	COMMIT TRAN T1
END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

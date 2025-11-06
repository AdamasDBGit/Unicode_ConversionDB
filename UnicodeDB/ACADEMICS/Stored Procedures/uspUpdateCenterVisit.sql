/*******************************************************
Description : Saves the student ids and thus enrolls them for examination
Author	:     Soumya Sikder
Date	:	  05/03/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspUpdateCenterVisit] 
(
	@iUserID int,
	@iCenterID int,
	@dtPlannedFromDate datetime = null,
	@dtPlannedToDate datetime = null,
	@dtActualFromDate datetime = null,
	@dtActualToDate datetime = null,
	@sPurpose varchar(2000) = null,
	@sRemarks varchar(2000) = null,
	@sAcademicParameter char(1) = null,
	@sFacultyApprovalParameter char(1) = null,
	@sFacultyCertificationParameter char(1) = null,
	@sInfrastructureParameter char(1) = null,
	@sUser varchar(20),
	@dDate datetime,
	@iFlag int
)
AS

BEGIN TRY 
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
	S_Upd_By,
	Dt_Crtd_On,
	Dt_Upd_On,
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
		S_Upd_By,
		Dt_Crtd_On,
		Dt_Upd_On,
		C_Academic_Parameter,
		C_Faculty_Approval,
		C_Faculty_Certification,
		C_Infrastructure,
		I_Status
FROM ACADEMICS.T_Academics_Visit
WHERE I_Center_Id = @iCenterID
AND I_User_ID = @iUserID

UPDATE ACADEMICS.T_Academics_Visit 
SET
	Dt_Planned_Visit_From_Date = ISNULL(@dtPlannedFromDate,Dt_Planned_Visit_From_Date),
	Dt_Actual_Visit_From_Date = ISNULL(@dtActualFromDate,Dt_Actual_Visit_From_Date),
	Dt_Planned_Visit_To_Date = ISNULL(@dtPlannedToDate,Dt_Planned_Visit_To_Date),
	Dt_Actual_Visit_To_Date = ISNULL(@dtActualToDate,Dt_Actual_Visit_To_Date),
	S_Upd_By = @sUser,
	Dt_Upd_On = @dDate
WHERE I_Center_Id = @iCenterID
AND I_User_ID = @iUserID

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

/*******************************************************
Description : Saves the student ids and thus enrolls them for examination
Author	:     Soumya Sikder
Date	:	  05/03/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspSaveVisitSchedule] 
(
	@iUserID int,
	@iCenterID int,
	@dtFromDate datetime,
	@dtToDate datetime,
	@sPurpose varchar(2000),
	@sCreatedBy varchar(20),
	@dtCreatedOn datetime
)
AS

BEGIN TRY 
INSERT INTO ACADEMICS.T_Academics_Visit
(
	I_Center_Id,
	I_User_ID,
	Dt_Planned_Visit_From_Date,
	Dt_Actual_Visit_From_Date,
	Dt_Planned_Visit_To_Date,
	Dt_Actual_Visit_To_Date,
	S_Remarks,
	S_Purpose,
	I_Status,
	C_Academic_Parameter,
	C_Faculty_Approval,
	C_Faculty_Certification,
	C_Infrastructure,
	S_Crtd_By,
	Dt_Crtd_On,
	S_Upd_By,
	Dt_Upd_On )
VALUES
(
	@iCenterID,
	@iUserID,
	@dtFromDate,
	@dtToDate,
	NULL,
	NULL,
	NULL,
	@sPurpose,
	1,
	NULL,
	NULL,
	NULL,
	NULL,
	@sCreatedBy,
	@dtCreatedOn,
	NULL,
	NULL
)

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

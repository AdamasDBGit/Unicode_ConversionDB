/*******************************************************
Description : Approve E-Project Extension Request
Author	:     Arindam Roy
Date	:	  05/25/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspApproveEProjectExtensionRequest] 
(
	@iEProjectGroupID int,
	@sExtensionReason varchar(500),
	@dExtentedDate datetime,
	@iStatus int,
	@sUser varchar(20),
	@dDate datetime
)

AS

BEGIN TRY 

		UPDATE ACADEMICS.T_E_Project_Extension
		   SET I_E_Project_Group_ID=@iEProjectGroupID,
			   S_Reason=@sExtensionReason,
			   Dt_New_End_Date=@dExtentedDate,
			   I_Status=0,
			   Dt_Upd_On=@dDate,
			   S_Upd_By=@sUser
		 WHERE I_E_Project_Group_ID=@iEProjectGroupID
		   AND I_Status=1
	

	INSERT INTO ACADEMICS.T_E_Project_Group_Audit
	(
			I_E_Project_Group_ID,
			S_Group_Desc,
			I_E_Project_Spec_ID,
			I_Center_ID,
			I_Course_ID,
			I_Term_ID,
			I_Module_ID,
			Dt_Project_Start_Date,
			Dt_Project_End_Date,
			Dt_Cancellation_Date,
			S_Cancellation_Reason,
			I_E_Project_File_ID,
			I_Report_File_ID,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On,
			I_Status
	)
	SELECT  I_E_Project_Group_ID,
			S_Group_Desc,
			I_E_Project_Spec_ID,
			I_Center_ID,
			I_Course_ID,
			I_Term_ID,
			I_Module_ID,
			Dt_Project_Start_Date,
			Dt_Project_End_Date,
			Dt_Cancellation_Date,
			S_Cancellation_Reason,
			I_E_Project_File_ID,
			I_Report_File_ID,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On,
			I_Status
	   FROM ACADEMICS.T_E_Project_Group
	  WHERE I_E_Project_Group_ID=@iEProjectGroupID
	
	IF @iStatus = 5   -- ProjectExtended
	BEGIN
		UPDATE ACADEMICS.T_E_Project_Group
		   SET I_Status=@iStatus,
			   Dt_Project_End_Date=@dExtentedDate,
			   S_Upd_By=@sUser,
			   Dt_Upd_On=@dDate
		 WHERE I_E_Project_Group_ID=@iEProjectGroupID
	END
	ELSE             -- (@iStatus = 8) ProjectExtensionCancelled
	BEGIN
		UPDATE ACADEMICS.T_E_Project_Group
		   SET I_Status=@iStatus,
			   S_Upd_By=@sUser,
			   Dt_Upd_On=@dDate
		 WHERE I_E_Project_Group_ID=@iEProjectGroupID
	END

	UPDATE ACADEMICS.T_Center_E_Project_Manual
	   SET I_Status=@iStatus,
		   S_Upd_By=@sUser,
		   Dt_Upd_On=@dDate
	 WHERE I_E_Project_Group_ID=@iEProjectGroupID
	   AND I_Status NOT IN (2,3)

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

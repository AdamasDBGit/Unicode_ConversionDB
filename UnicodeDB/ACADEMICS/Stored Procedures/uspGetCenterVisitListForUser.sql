/*******************************************************
Description : Gets the list of Visitors visiting the Center
Author	:     Soumya Sikder
Date	:	  03/05/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspGetCenterVisitListForUser] 
(
	@iCenterID int,
	@sUserType varchar(20),
	@iUserID int,
	@iFlag int = null
)
AS
BEGIN TRY 
	
	--- Selecting Complete Center Visit Details
	IF(@iFlag = 1)
	BEGIN

		IF @sUserType <> 'AE'
		BEGIN

			SELECT A.I_Center_Id,
				A.I_User_ID,
				A.I_Academics_Visit_ID, 
				A.Dt_Planned_Visit_From_Date, 
				A.Dt_Planned_Visit_To_Date,
				A.Dt_Actual_Visit_From_Date,
				A.Dt_Actual_Visit_To_Date,
				A.S_Remarks,
				A.S_Purpose,
				A.I_Status,
				A.C_Academic_Parameter,
				A.C_Faculty_Approval,
				A.C_Infrastructure,
				A.S_Crtd_By,
				A.Dt_Crtd_On,
				U.S_User_Type,
				U.S_Login_ID,
				U.S_Title,
				U.S_First_Name,
				U.S_Middle_Name,
				U.S_Last_Name,
				U.S_Email_ID,
				U.S_Forget_Pwd_Answer,
				U.Dt_Crtd_On
		FROM ACADEMICS.T_Academics_Visit A
		INNER JOIN dbo.T_User_Master U
		ON A.I_User_ID = U.I_User_ID
		WHERE A.I_Center_Id = @iCenterID
		AND A.I_Status = 2
		AND U.I_Status = 1
		ORDER BY A.Dt_Actual_Visit_From_Date DESC 

		END
		ELSE
		BEGIN
		SELECT A.I_Center_Id,
				A.I_User_ID,
				A.I_Academics_Visit_ID, 
				A.Dt_Planned_Visit_From_Date, 
				A.Dt_Planned_Visit_To_Date,
				A.Dt_Actual_Visit_From_Date,
				A.Dt_Actual_Visit_To_Date,
				A.S_Remarks,
				A.S_Purpose,
				A.I_Status,
				A.C_Academic_Parameter,
				A.C_Faculty_Approval,
				A.C_Infrastructure,
				A.S_Crtd_By,
				A.Dt_Crtd_On,
				U.S_User_Type,
				U.S_Login_ID,
				U.S_Title,
				U.S_First_Name,
				U.S_Middle_Name,
				U.S_Last_Name,
				U.S_Email_ID,
				U.S_Forget_Pwd_Answer,
				U.Dt_Crtd_On
		FROM ACADEMICS.T_Academics_Visit A
		INNER JOIN dbo.T_User_Master U
		ON A.I_User_ID = U.I_User_ID
		WHERE A.I_Center_Id = @iCenterID
		AND A.I_Status = 2
		AND A.I_User_ID = @iUserID
		AND U.I_Status = 1
		ORDER BY A.Dt_Actual_Visit_From_Date DESC 
		
		END
	END
	--- Selecting All Center Visit Details
	ELSE
	BEGIN
		
		IF @sUserType <> 'AE'
		BEGIN

		 SELECT A.I_Center_Id,
				A.I_User_ID,
				A.I_Academics_Visit_ID, 
				A.Dt_Planned_Visit_From_Date, 
				A.Dt_Planned_Visit_To_Date,
				A.Dt_Actual_Visit_From_Date,
				A.Dt_Actual_Visit_To_Date,
				A.S_Remarks,
				A.S_Purpose,
				A.I_Status,
				A.C_Academic_Parameter,
				A.C_Faculty_Approval,
				A.C_Infrastructure,
				A.S_Crtd_By,
				A.Dt_Crtd_On,
				U.S_User_Type,
				U.S_Login_ID,
				U.S_Title,
				U.S_First_Name,
				U.S_Middle_Name,
				U.S_Last_Name,
				U.S_Email_ID,
				U.S_Forget_Pwd_Answer,
				U.Dt_Crtd_On
		FROM ACADEMICS.T_Academics_Visit A
		INNER JOIN dbo.T_User_Master U
		ON A.I_User_ID = U.I_User_ID
		WHERE A.I_Center_Id = @iCenterID
		AND A.I_User_ID = @iUserID
		AND U.I_Status = 1
		ORDER BY A.Dt_Planned_Visit_From_Date DESC 
		
		END
		ELSE
		BEGIN
		
		SELECT A.I_Center_Id,
				A.I_User_ID,
				A.I_Academics_Visit_ID, 
				A.Dt_Planned_Visit_From_Date, 
				A.Dt_Planned_Visit_To_Date,
				A.Dt_Actual_Visit_From_Date,
				A.Dt_Actual_Visit_To_Date,
				A.S_Remarks,
				A.S_Purpose,
				A.I_Status,
				A.C_Academic_Parameter,
				A.C_Faculty_Approval,
				A.C_Infrastructure,
				A.S_Crtd_By,
				A.Dt_Crtd_On,
				U.S_User_Type,
				U.S_Login_ID,
				U.S_Title,
				U.S_First_Name,
				U.S_Middle_Name,
				U.S_Last_Name,
				U.S_Email_ID,
				U.S_Forget_Pwd_Answer,
				U.Dt_Crtd_On
		FROM ACADEMICS.T_Academics_Visit A
		INNER JOIN dbo.T_User_Master U
		ON A.I_User_ID = U.I_User_ID
		WHERE A.I_Center_Id = @iCenterID
		AND U.I_Status = 1
		ORDER BY A.Dt_Planned_Visit_From_Date DESC 

		END

	END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

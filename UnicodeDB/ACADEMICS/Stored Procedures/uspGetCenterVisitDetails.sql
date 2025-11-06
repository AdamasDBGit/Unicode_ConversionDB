/*******************************************************
Description : Gets the list of Visitors visiting the Center
Author	:     Soumya Sikder
Date	:	  03/05/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspGetCenterVisitDetails] 
(
	@iCenterVisitID int
)
AS
BEGIN TRY 
	-- getting records for Table [1]
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
			A.C_Faculty_Certification,
			A.C_Infrastructure,
			A.S_Crtd_By,
			A.Dt_Crtd_On,
			C.S_Center_Code,
			C.S_Center_Name,
			U.S_User_Type,
			U.S_Login_ID,
			U.S_Title,
			U.S_First_Name,
			U.S_Middle_Name,
			U.S_Last_Name,
			U.S_Email_ID,
			U.S_Forget_Pwd_Answer
	FROM ACADEMICS.T_Academics_Visit A
	INNER JOIN dbo.T_Centre_Master C
	ON A.I_Center_Id = C.I_Centre_Id
	INNER JOIN dbo.T_User_Master U
	ON A.I_User_ID = U.I_User_ID
	WHERE A.I_Academics_Visit_ID = @iCenterVisitID
	AND C.I_Status = 1
	AND U.I_Status = 1 

	-- getting records for Table[1]
	SELECT	DISTINCT C.I_Concern_Areas_ID,
			C.I_Academics_Visit_ID,
			C.S_Description,
			C.I_Assigned_EmpID,
			C.Dt_Target_Date,
			C.Dt_Actual_Date,
			C.I_Is_Notified,
			C.S_Crtd_By,
			C.Dt_Crtd_On,
			U.I_User_ID,
			U.S_User_Type,
			U.S_Login_ID,
			U.S_Title,
			U.S_First_Name,
			U.S_Middle_Name,
			U.S_Last_Name,
			U.S_Email_ID,
			U.S_Forget_Pwd_Answer
	FROM ACADEMICS.T_Concern_Areas C
	INNER JOIN dbo.T_User_Master U
	ON C.I_Assigned_EmpID = U.I_Reference_ID
	WHERE C.I_Academics_Visit_ID = @iCenterVisitID
	AND U.I_Status = 1

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

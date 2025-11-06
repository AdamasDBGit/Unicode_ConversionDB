CREATE PROCEDURE [REPORT].[uspGetCounselorListForReport]
(
	@sHierarchyList varchar(MAX),
	@iBrandID int
)
AS

BEGIN TRY 
	
	 SELECT ED.I_Employee_ID,
			ED.S_Emp_ID,
			ED.S_Title,
			ED.S_First_Name,
			ED.S_Middle_Name,
			ED.S_Last_Name,
			ED.S_Email_ID,
			UM.S_Login_ID
	   FROM dbo.T_Employee_Dtls ED
			INNER JOIN dbo.T_User_Master UM
			ON UM.I_Reference_ID = ED.I_Employee_ID 
			AND S_User_Type IN('CE','TE')
			INNER JOIN EOS.T_Employee_Role_Map ERM
			ON ERM.I_Employee_ID = ED.I_Employee_ID
			INNER JOIN dbo.T_Role_Master RM
			ON RM.I_Role_ID = ERM.I_Role_ID
	 WHERE  ED.I_Status in (3,6)	--Activated and AdditionalRolesAssigned
		AND ED.I_Centre_Id IN (SELECT centerID FROM [dbo].[fnGetCentersForReports](@sHierarchyList, @iBrandID))
		AND GETDATE() > = ISNULL(ED.Dt_Start_Date, GETDATE()) 
		AND GETDATE() <= ISNULL(ED.Dt_End_Date, GETDATE())
		AND ERM.I_Status_ID <> 0
		AND RM.I_Status <> 0
		AND RM.S_Role_Code = 'CON'	--Counsellor

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

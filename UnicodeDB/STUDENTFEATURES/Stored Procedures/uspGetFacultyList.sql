CREATE PROCEDURE [STUDENTFEATURES].[uspGetFacultyList]
(
	@iCenterID int,
	@iCourseID int=null, 
	@iTermID int=null, 
	@iModuleID int
)

AS
BEGIN TRY 
	
	SELECT E.I_Employee_ID,
		   E.S_First_Name,
		   E.S_Middle_Name,
		   E.S_Last_Name		   
	FROM dbo.T_Employee_Dtls E
	INNER JOIN EOS.T_Employee_Skill_Map S
	ON S.I_Employee_ID = E.I_Employee_ID
	INNER JOIN dbo.T_Module_Master M
	ON S.I_Skill_ID = M.I_Skill_ID
	WHERE E.I_Centre_Id = @iCenterID
	AND M.I_Module_ID = @iModuleID
	AND M.I_Status = 1
	AND S.I_Status = 1
	AND E.I_Status = 3

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

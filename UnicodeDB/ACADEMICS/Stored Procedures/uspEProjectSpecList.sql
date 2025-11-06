/*******************************************************
Description : Get E-Project Information with document details
Author	:     Sudipta Das
Date	:	  05/21/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspEProjectSpecList] 
(
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iStudentDetailID int = null
	
)

AS

BEGIN TRY 

	IF @iStudentDetailID IS NULL
	BEGIN
		SELECT 	DISTINCT EPS.I_E_Project_Spec_ID, 
			EPS.S_Description, 
			EPS.I_File_ID, 
			EPS.Dt_Valid_To,
			UD.S_Document_Name, 
			UD.S_Document_Path,
			UD.S_Document_Type, 
			UD.S_Document_URL, 
			UD.I_Status
		FROM ACADEMICS.T_E_Project_Spec EPS 
		LEFT OUTER JOIN dbo.T_Upload_Document UD
		ON EPS.I_File_ID=UD.I_Document_ID
		WHERE EPS.I_Course_ID=@iCourseID
		AND EPS.I_Term_ID=@iTermID
		AND EPS.I_Module_ID=@iModuleID
		AND EPS.I_Status=1 --Active
	END
	ELSE
	BEGIN
		SELECT 	DISTINCT EPS.I_E_Project_Spec_ID, 
			EPS.S_Description, 
			EPS.I_File_ID,
			EPS.Dt_Valid_To, 
			UD.S_Document_Name, 
			UD.S_Document_Path,
			UD.S_Document_Type, 
			UD.S_Document_URL, 
			UD.I_Status
		FROM ACADEMICS.T_E_Project_Spec EPS
		INNER JOIN ACADEMICS.T_E_Project_Group EPG
		ON EPS.I_E_Project_Spec_ID = EPG.I_E_Project_Spec_ID
		AND GETDATE() <= ISNULL(EPG.Dt_Project_End_Date,GETDATE())
		AND GETDATE() <= ISNULL(EPS.Dt_Valid_To,GETDATE())
		AND EPG.I_Status NOT IN (2,3)
		INNER JOIN ACADEMICS.T_Center_E_Project_Manual CEM
		ON EPG.I_E_Project_Group_ID = CEM.I_E_Project_Group_ID
		AND CEM.I_Course_ID=@iCourseID
		AND CEM.I_Term_ID=@iTermID
		AND CEM.I_Module_ID=@iModuleID
		AND CEM.I_Student_Detail_ID = @iStudentDetailID
		AND CEM.I_Status <> 3
		LEFT OUTER JOIN dbo.T_Upload_Document UD
		ON EPS.I_File_ID=UD.I_Document_ID
		WHERE  EPS.I_Status=1
	END


END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

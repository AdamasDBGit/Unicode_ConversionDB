/*******************************************************
Description : Get Count of records having the specified Manual No.
Author	:     Soumya Sikder
Date	:	  05/21/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspValidateStudentManualNumber] 
(
	@iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iCenterID int,
	@iManualNumber int
	
)
AS

BEGIN TRY 

SELECT COUNT(I_Center_E_Proj_ID) 
FROM ACADEMICS.T_Center_E_Project_Manual
WHERE I_Center_ID = @iCenterID
AND I_Course_ID = @iCourseID
AND I_Term_ID = @iTermID
AND I_Module_ID = @iModuleID
AND I_E_Proj_Manual_Number = @iManualNumber
AND I_Status <> 3

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

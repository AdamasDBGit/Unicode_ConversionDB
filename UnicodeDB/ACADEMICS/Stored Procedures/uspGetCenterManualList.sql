/*******************************************************
Description : Get E-Project Manual Master Details for a center
Author	:     Sudipta Das
Date	:	  05/21/2007
*********************************************************/

CREATE PROCEDURE [ACADEMICS].[uspGetCenterManualList] 
(
	@iCenterID int ,
	@iCourseID int = null,
	@iTermID int = null,
	@iModuleID int = null ,
	@iCompulsoryCheckReqd int = null
)
AS

BEGIN TRY 
IF (@iCompulsoryCheckReqd IS NULL)
BEGIN 
SELECT TED.I_From_Number, TED.I_To_Number
FROM  ACADEMICS.T_E_Project_Manual_Detail TED
INNER JOIN ACADEMICS.T_E_Project_Manual_Master TEM
ON TED.I_E_Proj_Manual_ID = TEM.I_E_Proj_Manual_ID
WHERE TEM.I_Center_ID=@iCenterID
AND TEM.I_Course_ID = ISNULL(@iCourseID,TEM.I_Course_ID)
AND TEM.I_Term_ID = ISNULL(@iTermID,TEM.I_Term_ID)
AND TEM.I_Module_ID = ISNULL(@iModuleID,TEM.I_Module_ID)
END
ELSE
BEGIN
	DECLARE @iManualNoCompulsory INT
	SET @iManualNoCompulsory = (SELECT I_Is_Manual_No_Compulsory FROM ACADEMICS.T_E_Project_Manual_Master WHERE 
	I_Center_ID = @iCenterID AND I_Course_ID = @iCourseID AND  I_Term_ID = @iTermID AND I_Module_ID = @iModuleID )
	IF @iManualNoCompulsory = 0
		SELECT NULL
	ELSE
		BEGIN 
			SELECT TED.I_From_Number, TED.I_To_Number
			FROM  ACADEMICS.T_E_Project_Manual_Detail TED
			INNER JOIN ACADEMICS.T_E_Project_Manual_Master TEM
			ON TED.I_E_Proj_Manual_ID = TEM.I_E_Proj_Manual_ID
			WHERE TEM.I_Center_ID=@iCenterID
			AND TEM.I_Course_ID = ISNULL(@iCourseID,TEM.I_Course_ID)
			AND TEM.I_Term_ID = ISNULL(@iTermID,TEM.I_Term_ID)
			AND TEM.I_Module_ID = ISNULL(@iModuleID,TEM.I_Module_ID)
		END
		
END

END TRY
BEGIN CATCH
	
	DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity int

	SELECT	@ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH

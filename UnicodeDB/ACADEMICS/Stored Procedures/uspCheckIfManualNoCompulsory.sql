/*****************************************************************************************************************
Created by:		Swagata De
Date:			11/9/07
Description:	This Stored procedure is used to check if manual no is compulsory for a given course/term/module
Parameters:		
				
Returns:	
******************************************************************************************************************/

CREATE PROCEDURE [ACADEMICS].[uspCheckIfManualNoCompulsory] 
(   @iCourseID int,
	@iTermID int,
	@iModuleID int,
	@iCenterID int
	
)

AS
BEGIN 

	DECLARE @iManualNoCompulsory INT
	SET @iManualNoCompulsory = (SELECT TOP 1 I_Is_Manual_No_Compulsory FROM ACADEMICS.T_E_Project_Manual_Master WHERE 
	I_Center_ID = @iCenterID AND I_Course_ID = @iCourseID AND  I_Term_ID = @iTermID AND I_Module_ID = @iModuleID )

	IF @iManualNoCompulsory IS NULL
		BEGIN
		SET @iManualNoCompulsory = 1
		SELECT @iManualNoCompulsory
		END
	ELSE
		SELECT @iManualNoCompulsory
	
END

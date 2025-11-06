/**************************************************************************************************************
Created by  : Sandeep Acharyya
Date		: 11.06.2007
Description : This SP will retrieve the Lis of Trainings
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetTrainingList]
AS
BEGIN
	SELECT  I_Training_ID,
			S_Training_Desc,
			S_Document_Name,
			S_Feedback_Form_Name,	
			I_Status
	FROM EOS.T_Employee_Training_Master WITH(NOLOCK)
	WHERE I_Status = 1
END

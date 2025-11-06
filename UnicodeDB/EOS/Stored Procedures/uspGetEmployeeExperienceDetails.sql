/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will retrieve all the Work Experience Details for a particualar employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetEmployeeExperienceDetails]
	(
		@iEmployeeID INT
	)
AS
BEGIN
	SELECT 
	Dt_From_Date,
	Dt_To_Date,
	S_Company,
	S_Industry,
	S_Job_Description	
	FROM EOS.T_Employee_WorkExp  WITH (NOLOCK)	
	WHERE I_Employee_ID=@iEmployeeID
			
END

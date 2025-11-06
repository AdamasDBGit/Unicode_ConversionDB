/**************************************************************************************************************
Created by  : Swagata De
Date		: 01.05.2007
Description : This SP will retrieve all the Qualification Details for a particualar employee
Parameters  : 
Returns     : Dataset
**************************************************************************************************************/

CREATE PROCEDURE [EOS].[uspGetEmployeeQualificationDetails]
	(
		@iEmployeeID INT
	)
AS
BEGIN
	SELECT TEQ.I_Employee_Qual_ID,
		   TEQ.I_Qualification_Name_ID,
           TEQ.I_Qualification_Type_ID,
		   TQNM.S_Qualification_Name,
			TQTM.S_Qualification_Type,
			TEQ.I_Passing_Year,
			TEQ.N_Percentage,
			TEQ.I_Status
	FROM EOS.T_Employee_Qualification TEQ WITH (NOLOCK)
	INNER JOIN dbo.T_Qualification_Type_Master TQTM WITH (NOLOCK)
	ON TEQ.I_Qualification_Type_ID=TQTM.I_Qualification_Type_ID
	INNER JOIN dbo.T_Qualification_Name_Master TQNM WITH (NOLOCK)
	ON TEQ.I_Qualification_Name_ID=TQNM.I_Qualification_Name_ID
	WHERE TEQ.I_Employee_ID=@iEmployeeID	
			
END

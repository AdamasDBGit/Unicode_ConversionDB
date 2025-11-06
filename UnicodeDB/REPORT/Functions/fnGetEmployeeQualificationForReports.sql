-- =============================================
-- Author:		Arindam Roy
-- Create date: '07/23/2007'
-- Description:	This Function return the Employee Qualification
-- =============================================
CREATE FUNCTION [REPORT].[fnGetEmployeeQualificationForReports]
(
	@iEmployeeID INT
)

RETURNS VARCHAR(100)

AS 

BEGIN

	DECLARE @Year INT
	DECLARE @QualificationType VARCHAR(45)
	DECLARE @QualificationName VARCHAR(45)

	 SELECT TOP(1)
			@Year=EQ.I_Passing_Year,
			@QualificationName=S_Qualification_Name,
			@QualificationType=S_Qualification_Type
	   FROM EOS.T_Employee_Qualification EQ
			INNER JOIN dbo.T_Qualification_Name_Master QNM
			ON EQ.I_Qualification_Name_ID=QNM.I_Qualification_Name_ID
			INNER JOIN dbo.T_Qualification_Type_Master QTM
			ON EQ.I_Qualification_Type_ID=QTM.I_Qualification_Type_ID
	  WHERE I_Employee_ID=@iEmployeeID
   ORDER BY EQ.I_Passing_Year DESC

	
	RETURN @QualificationType + ' (' + @QualificationName + ')'
END
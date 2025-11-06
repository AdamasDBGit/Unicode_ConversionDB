-- =====================================================================
-- Author:		Swagatam Sarkar
-- Create date: 10/12/2007'
-- Description:	This Function return a Numeric Value of Avg Salary KRA 
-- =====================================================================
CREATE FUNCTION [EOS].[fnGetKRAStudentsAvgSalary]
(
	@iEmployeeID INT,
	@iCurrentMonth INT,
	@iCurrentYear INT
)

RETURNS  NUMERIC(18,2)


AS 

BEGIN

	DECLARE @Salary NUMERIC(18,2)
	DECLARE @StudentNo NUMERIC(18,2)
	DECLARE @AvgSalary NUMERIC(18,2)

	 SELECT @Salary=ISNULL(SUM(TSS.N_Annual_Salary),0.00)
	   FROM PLACEMENT.T_Shortlisted_Students TSS
			INNER JOIN dbo.T_User_Master UM
				ON TSS.S_Crtd_By=UM.S_Login_ID
				AND UM.I_Reference_ID=@iEmployeeID
				AND UM.S_User_Type='CE'
	  WHERE TSS.I_Status<>0
		AND UM.I_Status<>0
		AND MONTH(TSS.Dt_Crtd_On)=@iCurrentMonth
		AND YEAR(TSS.Dt_Crtd_On)=@iCurrentYear

	SELECT @StudentNo=COUNT(*)
	   FROM PLACEMENT.T_Shortlisted_Students TSS
			INNER JOIN dbo.T_User_Master UM
				ON TSS.S_Crtd_By=UM.S_Login_ID
				AND UM.I_Reference_ID=@iEmployeeID
				AND UM.S_User_Type='CE'
	  WHERE TSS.I_Status<>0
		AND UM.I_Status<>0
		AND MONTH(TSS.Dt_Crtd_On)=@iCurrentMonth
		AND YEAR(TSS.Dt_Crtd_On)=@iCurrentYear

	IF @StudentNo > 0
	BEGIN
		SET @AvgSalary = ((@Salary / @StudentNo) / 1000.00)
	END

	RETURN @AvgSalary

END
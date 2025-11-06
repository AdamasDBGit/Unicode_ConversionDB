-- ==========================================================================
-- Author:		Swagatam Sarkar
-- Create date: 10/12/2007'
-- Description:	This Function return a Numeric Value of Students Placed KRA 
-- ==========================================================================
CREATE FUNCTION [EOS].[fnGetKRAStudentsPlaced]
(
	@iEmployeeID INT,
	@iCurrentMonth INT,
	@iCurrentYear INT
)

RETURNS  NUMERIC(18,2)

AS 

BEGIN

	DECLARE @StudentRegd NUMERIC(18,2)
	DECLARE @StudentPlaced NUMERIC(18,2)
	DECLARE @Ratio NUMERIC(18,2)

	 SELECT @StudentPlaced = COUNT(*)
	   FROM PLACEMENT.T_Shortlisted_Students TSS
			INNER JOIN dbo.T_User_Master UM
				ON TSS.S_Crtd_By=UM.S_Login_ID
				AND UM.I_Reference_ID=@iEmployeeID
				AND UM.S_User_Type='CE'
	  WHERE TSS.I_Status<>0
		AND UM.I_Status<>0
		AND MONTH(TSS.Dt_Crtd_On)=@iCurrentMonth
		AND YEAR(TSS.Dt_Crtd_On)=@iCurrentYear

	SELECT @StudentRegd = COUNT(*)
	   FROM PLACEMENT.T_Placement_Registration TPR
			INNER JOIN dbo.T_User_Master UM
				ON TPR.S_Crtd_By=UM.S_Login_ID
				AND UM.I_Reference_ID=@iEmployeeID
				AND UM.S_User_Type='CE'
	  WHERE TPR.I_Status<>0
		AND UM.I_Status<>0
		AND MONTH(TPR.Dt_Crtd_On)=@iCurrentMonth
		AND YEAR(TPR.Dt_Crtd_On)=@iCurrentYear

	IF @StudentRegd > 0
	BEGIN
		SET @Ratio = ((@StudentPlaced / @StudentRegd) * 100.00)
	END

	RETURN @Ratio

END
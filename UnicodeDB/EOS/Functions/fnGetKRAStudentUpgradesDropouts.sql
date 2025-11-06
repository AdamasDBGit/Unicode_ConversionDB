-- =============================================
-- Author:		Arindam Roy
-- Create date: '07/30/2007'
-- Description:	This Function return a Numeric Value of Student Upgrades & Dropouts KRA 
-- =============================================
CREATE FUNCTION [EOS].[fnGetKRAStudentUpgradesDropouts]
(
	@iEmployeeID INT,
	@iCurtrentMonth INT,
	@iCurtrentYear INT
)

RETURNS  NUMERIC(18,2)

AS 

BEGIN

	DECLARE @CenterID INT
	DECLARE @DroppedStudent NUMERIC(18,2)

	SELECT @CenterID=I_Centre_Id FROM dbo.T_Employee_Dtls WHERE I_Employee_ID=@iEmployeeID

	 SELECT @DroppedStudent=COUNT(DISTINCT I_Student_Detail_ID)
	   FROM ACADEMICS.T_Dropout_Details 
	  WHERE MONTH(Dt_Dropout_Date)=@iCurtrentMonth
		AND YEAR(Dt_Dropout_Date)=@iCurtrentYear
		AND I_Center_Id=@CenterID
		AND I_Dropout_Status=1

	RETURN @DroppedStudent

END
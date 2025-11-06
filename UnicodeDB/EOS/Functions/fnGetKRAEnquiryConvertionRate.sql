-- =======================================================================
-- Author:		Swagatam Sarkar
-- Create date: 10/12/2007
-- Description:	This Function return a % Value of Enquiry Convertion KRA 
-- =======================================================================
CREATE FUNCTION [EOS].[fnGetKRAEnquiryConvertionRate]
(
	@iEmployeeID INT,
	@iCurrentMonth INT,
	@iCurrentYear INT
)

RETURNS  NUMERIC(18,2)

AS 

BEGIN

	DECLARE @EnquiryConvRate NUMERIC(18,2)
	DECLARE @EnquiryGen NUMERIC(18,2)
	DECLARE @EnrollmentGen NUMERIC(18,2)

	 SELECT @EnquiryGen=COUNT(*)
	   FROM dbo.T_Enquiry_Regn_Detail ERD
			INNER JOIN dbo.T_User_Master UM
				ON ERD.S_Crtd_By=UM.S_Login_ID
				AND UM.I_Reference_ID=@iEmployeeID
				AND UM.S_User_Type='CE'
	  WHERE UM.I_Status<>0
		AND MONTH(ERD.Dt_Crtd_On)=@iCurrentMonth
		AND YEAR(ERD.Dt_Crtd_On)=@iCurrentYear

	SELECT @EnrollmentGen=COUNT(*)
	   FROM dbo.T_Student_Detail SD
			INNER JOIN dbo.T_User_Master UM
				ON SD.S_Crtd_By=UM.S_Login_ID
				AND UM.I_Reference_ID=@iEmployeeID
				AND UM.S_User_Type='CE'
	  WHERE UM.I_Status<>0
		AND MONTH(SD.Dt_Crtd_On)=@iCurrentMonth
		AND YEAR(SD.Dt_Crtd_On)=@iCurrentYear
	
	IF @EnquiryGen > 0
	BEGIN
		SET @EnquiryConvRate = ((@EnrollmentGen / @EnquiryGen) * 100)
	END
	ELSE
	BEGIN
		SET @EnquiryConvRate = 0
	END

	RETURN @EnquiryConvRate

END
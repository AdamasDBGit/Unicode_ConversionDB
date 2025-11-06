-- =====================================================================
-- Author:		Swagatam Sarkar
-- Create date: 10/12/2007'
-- Description:	This Function return a Numeric Value of Enquiry KRA 
-- =====================================================================
CREATE FUNCTION [EOS].[fnGetKRAEnquiryGeneration]
(
	@iEmployeeID INT,
	@iCurrentMonth INT,
	@iCurrentYear INT
)

RETURNS INT

AS 

BEGIN

	DECLARE @EnquiryGen INT

	 SELECT @EnquiryGen=COUNT(*)
	   FROM dbo.T_Enquiry_Regn_Detail ERD
			INNER JOIN dbo.T_User_Master UM
				ON ERD.S_Crtd_By=UM.S_Login_ID
				AND UM.I_Reference_ID=@iEmployeeID
				AND UM.S_User_Type='CE'
	  WHERE UM.I_Status<>0
		AND MONTH(ERD.Dt_Crtd_On)=@iCurrentMonth
		AND YEAR(ERD.Dt_Crtd_On)=@iCurrentYear

	RETURN @EnquiryGen

END
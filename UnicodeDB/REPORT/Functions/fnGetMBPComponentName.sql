/*******************************************************************************************************
* Author		: BabinSaha
* Create date	: 16/08/2007
* Description	: GET MBP component Name ddepenad upon type id
* Return		: Value Integer
*******************************************************************************************************/
CREATE FUNCTION [REPORT].[fnGetMBPComponentName]
(
	@iType		INT
)
RETURNS VARCHAR(255)

AS
BEGIN
	DECLARE @S_Component_Name VARCHAR(255) 
	IF @iType =1
	BEGIN
		SET @S_Component_Name ='Enquiry'
	END
	IF @iType =2
	BEGIN
		SET @S_Component_Name ='Admission'
	END
	IF @iType =3
	BEGIN
		SET @S_Component_Name ='Booking'
	END
	IF @iType =4
	BEGIN
		SET @S_Component_Name ='Billing'
	END
--add sanju
	IF @iType =5
	BEGIN
		SET @S_Component_Name ='CompanyShare'
	END
--end add
Return @S_Component_Name
END
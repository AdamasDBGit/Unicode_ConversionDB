CREATE PROCEDURE [dbo].[uspGetServiceTax] 

AS
BEGIN

	SELECT  A.I_Country_ServiceTax_Id,A.I_Country_Id,
	A.N_ServiceTax_Percent,B.S_Country_Name	,A.I_Status
	FROM dbo.T_Service_Tax_Master A,dbo.T_Country_Master B
	WHERE A.I_Country_Id = B.I_Country_ID 
	AND A.I_Status = 1

END

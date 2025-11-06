CREATE PROCEDURE [dbo].[uspGetCountry] 

AS
BEGIN

	SELECT I_Country_ID, S_Country_Code,S_Country_Name,I_Currency_ID,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On,I_Status
	FROM dbo.T_Country_Master
	WHERE I_Status <> 0
	ORDER BY S_Country_Name

END

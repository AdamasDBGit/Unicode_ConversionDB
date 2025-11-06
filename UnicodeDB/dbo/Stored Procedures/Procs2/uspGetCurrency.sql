CREATE PROCEDURE [dbo].[uspGetCurrency] 

AS
BEGIN

	SELECT  I_Currency_ID,S_Currency_Code, S_Currency_Name, I_Status, S_Crtd_By,  S_Upd_By, Dt_Crtd_On, Dt_Upd_On
	FROM dbo.T_Currency_Master
	WHERE I_Status <> 0

END

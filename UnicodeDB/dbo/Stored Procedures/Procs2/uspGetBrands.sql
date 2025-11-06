--*********************
--Modified By: Debarshi Basu 20/2/2007
--**********************

CREATE PROCEDURE [dbo].[uspGetBrands] 

AS
BEGIN

	SELECT I_Brand_ID,S_Brand_Code,S_Brand_Name,I_Status,S_Crtd_By,S_Upd_By,Dt_Crtd_On,Dt_Upd_On
	FROM dbo.T_Brand_Master
	WHERE I_Status <> 0

END

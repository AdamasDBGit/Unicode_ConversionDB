-- =============================================
-- Author:		Soumya Sikder
-- Create date: 17/01/2007
-- Description:	Fetches all the Certificate Master Table Details
-- =============================================


CREATE PROCEDURE [dbo].[uspGetCertificate] 

AS
BEGIN

	SELECT C.I_Certificate_ID,
		   C.I_Brand_ID,
		   C.S_Certificate_Name,
		   C.S_Certificate_Description,
		   C.S_Certificate_Type,
		   C.I_Template_ID,
		   B.S_Brand_Name,
		   B.S_Brand_Code,
		   C.I_Status,
		   C.S_Crtd_By,
		   C.S_Upd_By,
		   C.Dt_Crtd_On,
		   C.Dt_Upd_On
	FROM T_Certificate_Master C,T_Brand_Master B
	WHERE C.I_Brand_ID=B.I_Brand_ID
		  AND C.I_Status <> 0
		  ORDER BY C.S_Certificate_Name
		  
END

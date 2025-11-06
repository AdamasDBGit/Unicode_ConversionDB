CREATE PROCEDURE [dbo].[uspGetSessionType] 
AS
BEGIN

	SELECT	I_Session_Type_ID,
			S_Session_Type_Name,
			I_Status,
			S_Crtd_By,
			S_Upd_By,
			Dt_Crtd_On,
			Dt_Upd_On
	FROM dbo.T_Session_Type_Master
	WHERE I_Status <> 0

END

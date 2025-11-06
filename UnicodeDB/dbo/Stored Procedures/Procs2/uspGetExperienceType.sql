-- =============================================
-- Author:		Arunava Mitra
-- Create date: 22/12/2006
-- Description:	Selects All the Experience Type 
-- =============================================
CREATE PROCEDURE [dbo].[uspGetExperienceType] 

AS
BEGIN

	SELECT I_ETM_Experience_Type_ID,S_ETM_Experience_Type,S_ETM_Crtd_By,S_ETM_Upd_By,Dt_ETM_Crtd_On,Dt_ETM_Upd_On
	FROM dbo.T_Experience_Type_Master
	WHERE C_ETM_Status = 'D'

END

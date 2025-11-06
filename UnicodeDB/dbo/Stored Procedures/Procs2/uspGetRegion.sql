-- =============================================
-- Author:		Arunava Mitra
-- Create date: 22/12/2006
-- Description:	Selects All the Regions 
-- =============================================
CREATE PROCEDURE [dbo].[uspGetRegion] 

AS
BEGIN

	SELECT I_RGM_Rgn_ID,S_RGM_Rgn_Code,S_RGM_Rgn_Name,S_RGM_Crtd_By,S_RGM_Upd_By,Dt_RGM_Crtd_On,Dt_RGM_Upd_On,C_RGM_Status
	FROM dbo.T_Region_Master
	WHERE C_RGM_Status <> 'D'

END

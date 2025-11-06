-- =============================================
-- Author:		<Rajesh>
-- Create date: <29-12-2006>
-- Description:	<To load all Zone>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetZone]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT I_ZNM_Zone_Id,S_ZNM_Zone_Code,S_ZNM_Zone_Name,C_ZNM_Status,S_ZNM_Crtd_By,S_ZNM_Upd_By,Dt_ZNM_Crtd_On,Dt_ZNM_Upd_On
	FROM dbo.T_Zone_Master
	WHERE C_ZNM_Status <> 'D'

END

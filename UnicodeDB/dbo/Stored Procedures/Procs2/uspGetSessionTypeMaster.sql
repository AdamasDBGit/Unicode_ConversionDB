-- =============================================
-- Author:		<ANIRBAN PAHARI>
-- Create date: <08/03/2007>
-- Description:	<TO GET ALL SESSION TYPE.EXEC uspGetSessionTypeMaster>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSessionTypeMaster] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT I_Session_Type_ID,S_Session_Type_Name,I_Status,
			S_Crtd_By,S_Upd_By,Dt_Crtd_On,
			Dt_Upd_On FROM T_Session_Type_Master WHERE  I_Status <>0
END

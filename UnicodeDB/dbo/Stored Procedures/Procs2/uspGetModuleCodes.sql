-- =============================================
-- Author:		Debarshi Basu
-- Create date: 12/03/2007
-- Description:	Gets the Module List
-- =============================================
CREATE PROCEDURE [dbo].[uspGetModuleCodes] 	

AS
BEGIN
	
	SET NOCOUNT OFF

	SELECT	I_Module_ID,
			S_Module_Code,
			S_Module_Name			
	FROM dbo.T_Module_Master 
	WHERE I_Status <> 0
	
END

-- =============================================
-- Author:		Debarshi Basu
-- Create date: 26/03/2006
-- Description:	Modifies the FollowUp Closure master table
-- =============================================
CREATE PROCEDURE [dbo].[uspGetFollowupClosure] 

AS
BEGIN

	SELECT I_Followup_Closure_ID, S_Followup_Closure_Desc, I_Status
	FROM dbo.T_Followup_Closure_Master
	WHERE I_Status = 1

END

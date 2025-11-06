-- =============================================
-- Author:		Debarshi Basu
-- Create date: 22/03/2007
-- Description:	Get the Preferred Income Groups
-- =============================================

CREATE PROCEDURE [dbo].[uspGetIncomeGroup] 

AS
BEGIN

	SELECT I_Income_Group_ID,S_Income_Group_Name,I_Status
	FROM T_Income_Group_Master
	WHERE I_Status = 1

END

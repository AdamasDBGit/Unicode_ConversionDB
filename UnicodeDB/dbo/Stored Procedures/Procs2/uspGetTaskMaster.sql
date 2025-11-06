-- =============================================
-- Author:		Debhman Mukherjee
-- Create date: 23/03/2007
-- Description:	Selects All the Task Master Data
-- =============================================

CREATE PROCEDURE [dbo].[uspGetTaskMaster] 
AS
BEGIN
	SELECT * FROM T_Task_Master
	WHERE  I_IsActive=1
END

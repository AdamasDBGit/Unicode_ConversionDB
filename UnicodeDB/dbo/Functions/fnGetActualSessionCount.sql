-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fnGetActualSessionCount]
(
	@iBatchID INT,
	@iCenterID INT,
	@EndDate DateTime=Null
)
RETURNS INT
AS
BEGIN
	DECLARE @iCount INT

	SELECT @iCount = COUNT(*) FROM [dbo].[T_Student_Batch_Schedule] AS TSBS
	WHERE [TSBS].[I_Batch_ID] = @iBatchID
	AND [TSBS].[I_Centre_ID] = @iCenterID
	AND DATEDIFF(dd,[TSBS].Dt_Actual_Date,ISNULL(@EndDate,[TSBS].Dt_Actual_Date)) >= 0
	
	RETURN @iCount
END
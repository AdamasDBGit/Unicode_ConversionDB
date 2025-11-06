CREATE FUNCTION [dbo].[fnGetCenterIDForStudent]
(
	@iStudentDetailID INT
)
RETURNS INT
AS
BEGIN

DECLARE @iCenterID INT

SELECT @iCenterID = [tscd].[I_Centre_Id] 
FROM [dbo].[T_Student_Center_Detail] AS TSCD
WHERE [TSCD].[I_Student_Detail_ID] = @iStudentDetailID

RETURN @iCenterID

END
-- =============================================
-- Author:		Shankha Roy
-- Create date: '08/17/2007'
-- Description:	This Function calculate the obtain marks
-- Return: INT
-- =============================================
CREATE FUNCTION [dbo].[fnCalculateObtainMarks]
(
	@iMarks NUMERIC(18,2),
	@iTotMarks NUMERIC(18,2)	
)
RETURNS NUMERIC(18,2)

AS
BEGIN

DECLARE @rtnObtainMark NUMERIC(18,2)

IF((@iMarks IS NOT NULL ) AND (@iTotMarks IS NOT NULL)
	AND (@iMarks <> 0 ) AND (@iTotMarks <> 0)) 
BEGIN
--percentage = Total marks obtained / Total marks *100
  SET @rtnObtainMark = CAST((@iMarks * 100 / @iTotMarks)AS NUMERIC(18,2)) 
END
ELSE
  BEGIN
  	SET @rtnObtainMark = 0
  END

RETURN @rtnObtainMark;
END
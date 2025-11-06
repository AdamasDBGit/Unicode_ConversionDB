-- =============================================
-- Author:		Shankha Roy
-- Create date: '08/17/2007'
-- Description:	This Function calculate the exam type marks
-- Return: INT
-- =============================================
CREATE FUNCTION [dbo].[fnCalculateExamTypeMarks]
(
	@iMarks NUMERIC(18,2),
	@iTotMarks NUMERIC(18,2),
	@iWTGMark NUMERIC(18,2)	
)
RETURNS NUMERIC(18,2)

AS
BEGIN

DECLARE @rtnMark NUMERIC(18,2)

IF((@iMarks IS NOT NULL ) AND (@iTotMarks IS NOT NULL) AND (@iWTGMark IS NOT NULL)
	AND (@iMarks <> 0 ) AND (@iTotMarks <> 0) AND (@iWTGMark <> 0) ) 
BEGIN
--marks = (marks*100/totalmarks)* (weightage(%))
-- that means marks = (marks*100/totalmarks)* (weightage/100)
  SET @rtnMark = CAST(((@iMarks*@iWTGMark)/(@iTotMarks)) AS NUMERIC(18,2))
END
ELSE
  BEGIN
  	SET @rtnMark = 0
  END

RETURN @rtnMark;
END
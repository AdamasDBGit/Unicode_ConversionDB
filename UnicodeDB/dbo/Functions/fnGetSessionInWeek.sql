CREATE FUNCTION [dbo].[fnGetSessionInWeek]
(
	@iNoOfSessions INT,
	@SDaysOfWeek VARCHAR(50)
)  
RETURNS  INT

AS
BEGIN 
	DECLARE @iNoOfSessionInWeek INT
	SELECT @iNoOfSessionInWeek = COUNT(*)*@iNoOfSessions FROM dbo.fnString2Rows(@SDaysOfWeek,',')
	RETURN @iNoOfSessionInWeek
END
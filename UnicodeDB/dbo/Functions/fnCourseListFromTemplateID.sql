-- =============================================
-- Author:		Shankha Roy
-- Create date: '07/26/2007'
-- Description:	This Function return a table 
-- constains course id of given template id for print PS
-- Return: Table
-- =============================================
CREATE FUNCTION [dbo].[fnCourseListFromTemplateID]
(
	@iTemplate INT,
	@iFlag INT  -- This for track the template type like PS =1, Certificate =0 or TermCertificate=2
	
)
RETURNS @rtnTable TABLE
(
I_Course_ID INT
)

AS 
BEGIN

IF(@iFlag = 0)
	BEGIN
		-- for Certificate
		INSERT INTO @rtnTable
		SELECT I_Course_ID FROM dbo.T_Course_Master
		WHERE I_Certificate_ID IN (SELECT I_Certificate_ID FROM dbo.T_Certificate_Master
		WHERE I_Template_ID = @iTemplate)
	END
	-- for PS 
ELSE IF(@iFlag = 1)
	BEGIN
		INSERT INTO @rtnTable
		SELECT I_Course_ID FROM dbo.T_Term_Eval_Strategy
		WHERE I_Template_ID =@iTemplate
	END
	-- For Course term Certificate
ELSE
	BEGIN
		INSERT INTO @rtnTable
		SELECT I_Course_ID FROM dbo.T_Term_Course_Map
		WHERE I_Certificate_ID IN (
		SELECT I_Certificate_ID FROM dbo.T_Certificate_Master 
		WHERE S_Certificate_Type = 'Term'
		AND I_Template_ID = @iTemplate)
	END

	RETURN;
END
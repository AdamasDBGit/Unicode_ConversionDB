-- =============================================
-- Author:		Shankha Roy
-- Create date: '08/17/2007'
-- Description:	This Function return a table 
-- constains Exam Module name List
-- Return: Table
-- =============================================
CREATE FUNCTION [dbo].[fnGetExamModuleList]
(
	@iCourse INT ,
	@iTermID INT
)
RETURNS  @rtnTable TABLE
(
	S_Component_Name VARCHAR(2000)
)

AS 
-- Return the Table containing the student course details.
BEGIN
		DECLARE @tmpSub TABLE
		(
		sSubject VARCHAR(100)
		)
		DECLARE @getSubjects VARCHAR(2000)

		SET @getSubjects = ''

		INSERT INTO @tmpSub
		SELECT DISTINCT S_Module_Name FROM dbo.T_Module_Master MM
INNER JOIN dbo.T_Module_Term_Map MTM
ON MM.I_Module_ID=MTM.I_Module_ID
INNER JOIN dbo.T_Term_Course_Map TCM
ON TCM.I_Term_ID = MTM.I_Term_ID
WHERE TCM.I_Course_ID =COALESCE(@iCourse,TCM.I_Course_ID)
AND MTM.I_Term_ID = COALESCE(@iTermID,MTM.I_Term_ID)				

		

		SELECT @getSubjects = @getSubjects + CAST(sSubject AS VARCHAR(100))+ ' ,'
		FROM @tmpSub

		IF(@getSubjects <>'')
					BEGIN
					SET @getSubjects = SUBSTRING(@getSubjects,0,LEN(@getSubjects)-1)
					END
		
-- Insert Record in return table
		INSERT INTO @rtnTable (S_Component_Name)
		VALUES (@getSubjects)

	RETURN;

END
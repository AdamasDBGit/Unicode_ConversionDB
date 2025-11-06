CREATE PROCEDURE [dbo].[uspGetExamTypeMaster]
		
AS

BEGIN
	SET NOCOUNT ON

	SELECT	I_Exam_Type_Master_ID,
			S_Exam_Type_Name
	FROM dbo.T_Exam_Type_Master
	
END

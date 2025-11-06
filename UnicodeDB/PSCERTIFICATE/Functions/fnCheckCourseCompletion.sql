/*******************************************************************************************************
* Author		:	Abhisek Bhattacharya
* Create date	:	27/06/2007
* Description	:	This Function checks whether the course
					for a student is completed
					This is determined based on the whether all the terms under the course
					is completed for the student 
* Return		:	Integer
*******************************************************************************************************/
CREATE FUNCTION [PSCERTIFICATE].[fnCheckCourseCompletion]
(
	@iStudentID INT,
	@iCourseID INT
)
RETURNS INT

AS
BEGIN
	DECLARE @iTemp INT
	
	IF EXISTS ( SELECT STD.I_Student_Term_Detail_ID
		FROM dbo.T_Student_Term_Detail STD
		INNER JOIN dbo.T_Term_Course_Map TCM
		ON STD.I_Course_ID = TCM.I_Course_ID
		AND STD.I_Term_ID = TCM.I_Term_ID
		AND TCM.I_Status = 1
		AND STD.I_Student_Detail_ID = @iStudentID
		AND STD.I_Course_ID = @iCourseID
		AND STD.I_Is_Completed = 0 )
	BEGIN
		SET @iTemp = 0
	END
	ELSE
	BEGIN
		SET @iTemp = 1
	END

	RETURN @iTemp
END
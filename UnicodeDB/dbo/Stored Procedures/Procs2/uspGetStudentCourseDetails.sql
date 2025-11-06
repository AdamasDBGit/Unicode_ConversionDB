/*****************************************************************************************************************
Created by: Debman Mukherjee
Date: 19/04/2007
Description: Select List of courses for the student
Parameters: 
Returns:	
Modified By: 
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[uspGetStudentCourseDetails]
(
	@iStudentDetailId int,
	@iCourseId int
)
AS
BEGIN

	SELECT 
		TM.I_Term_ID,
		TM.S_Term_Name,
		TCM.I_Sequence,
		STD.I_Is_Completed 
	FROM 
		T_Student_Term_Detail STD
		INNER JOIN T_Term_Master TM
		ON STD.I_Term_ID = TM.I_Term_ID
		INNER JOIN T_Term_Course_Map TCM
		ON TM.I_Term_ID = TCM.I_Term_ID
		WHERE TCM.I_Course_ID = @iCourseId
		AND STD.I_Student_Detail_ID = @iStudentDetailId
		AND STD.I_Course_ID=@iCourseId
		AND TM.I_Status<>0
		AND TCM.I_Status<>0
END
